package app.privacylens.vpn

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.net.ConnectivityManager
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.os.Process
import android.system.OsConstants
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import app.privacylens.MainActivity
import app.privacylens.R
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.SocketTimeoutException

/**
 * DNS-only VPN. Only the fake resolver address is routed into the tunnel, so
 * regular traffic never passes through this service. Lookups for known tracker
 * domains get NXDOMAIN; every other lookup is forwarded to the phone's own DNS.
 */
class TrackerShieldVpnService : VpnService() {
    private var tunnel: ParcelFileDescriptor? = null
    private var scope: CoroutineScope? = null
    private lateinit var blocklist: Blocklist
    private lateinit var eventStore: DnsEventStore
    private lateinit var connectivityManager: ConnectivityManager
    private lateinit var upstreamDns: UpstreamDns

    override fun onCreate() {
        super.onCreate()
        blocklist = Blocklist.get(this)
        eventStore = DnsEventStore.get(this)
        connectivityManager = getSystemService(ConnectivityManager::class.java)
        upstreamDns = UpstreamDns(connectivityManager)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopShield()
            return START_NOT_STICKY
        }
        startShield()
        return START_STICKY
    }

    override fun onRevoke() {
        stopShield()
        super.onRevoke()
    }

    override fun onDestroy() {
        stopShield()
        super.onDestroy()
    }

    private fun startShield() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                buildNotification(),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, buildNotification())
        }
        if (tunnel != null) return

        val established = Builder()
            .setSession(getString(R.string.tracker_shield_session))
            .addAddress(TUNNEL_ADDRESS, 32)
            .addDnsServer(FAKE_DNS_ADDRESS)
            .addRoute(FAKE_DNS_ADDRESS, 32)
            .setBlocking(true)
            .setMtu(MTU)
            .establish()
        if (established == null) {
            stopShield()
            return
        }
        tunnel = established
        isRunning = true

        val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
        scope = serviceScope
        serviceScope.launch { readLoop(established, serviceScope) }
    }

    private fun stopShield() {
        isRunning = false
        scope?.cancel()
        scope = null
        try {
            tunnel?.close()
        } catch (error: IOException) {
            // Already closed.
        }
        tunnel = null
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun readLoop(fd: ParcelFileDescriptor, serviceScope: CoroutineScope) {
        val input = FileInputStream(fd.fileDescriptor)
        val output = FileOutputStream(fd.fileDescriptor)
        val buffer = ByteArray(MTU)
        while (serviceScope.isActive) {
            val length = try {
                input.read(buffer)
            } catch (error: IOException) {
                break // Tunnel closed.
            }
            if (length <= 0) continue
            val query = DnsPacket.parse(buffer, length) ?: continue
            serviceScope.launch { handle(query, output) }
        }
    }

    private fun handle(query: DnsQuery, output: FileOutputStream) {
        if (blocklist.isBlocked(query.domain)) {
            eventStore.insertBlocked(System.currentTimeMillis(), query.domain, ownerPackage(query))
            write(output, DnsPacket.wrapReply(query, DnsPacket.nxDomain(query)))
            return
        }
        forward(query, output)
    }

    private fun forward(query: DnsQuery, output: FileOutputStream) {
        val target = upstreamDns.current() ?: return
        try {
            DatagramSocket().use { socket ->
                protect(socket)
                target.network.bindSocket(socket)
                socket.soTimeout = UPSTREAM_TIMEOUT_MS
                socket.send(
                    DatagramPacket(query.message, query.message.size, InetSocketAddress(target.server, DNS_PORT)),
                )
                val reply = ByteArray(MAX_DNS_REPLY)
                val packet = DatagramPacket(reply, reply.size)
                socket.receive(packet)
                write(output, DnsPacket.wrapReply(query, reply, packet.length))
            }
        } catch (error: SocketTimeoutException) {
            // The client retries on its own.
        } catch (error: IOException) {
            upstreamDns.invalidate()
        }
    }

    private fun write(output: FileOutputStream, packet: ByteArray) {
        synchronized(output) {
            try {
                output.write(packet)
            } catch (error: IOException) {
                // Tunnel closed while the reply was in flight.
            }
        }
    }

    /** Null when Android cannot attribute the lookup to an app. */
    private fun ownerPackage(query: DnsQuery): String? {
        val uid = try {
            connectivityManager.getConnectionOwnerUid(
                OsConstants.IPPROTO_UDP,
                InetSocketAddress(InetAddress.getByAddress(query.sourceAddress), query.sourcePort),
                InetSocketAddress(InetAddress.getByAddress(query.destinationAddress), query.destinationPort),
            )
        } catch (error: Exception) {
            return null
        }
        if (uid == Process.INVALID_UID) return null
        return packageManager.getPackagesForUid(uid)?.firstOrNull()
    }

    private fun buildNotification(): Notification {
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                getString(R.string.tracker_shield_channel),
                NotificationManager.IMPORTANCE_LOW,
            ),
        )
        val openApp = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE,
        )
        val stop = PendingIntent.getService(
            this,
            1,
            Intent(this, TrackerShieldVpnService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_shield)
            .setContentTitle(getString(R.string.tracker_shield_notification_title))
            .setContentText(getString(R.string.tracker_shield_notification_text))
            .setContentIntent(openApp)
            .addAction(0, getString(R.string.tracker_shield_notification_stop), stop)
            .setOngoing(true)
            .build()
    }

    companion object {
        const val ACTION_START = "app.privacylens.vpn.START"
        const val ACTION_STOP = "app.privacylens.vpn.STOP"

        @Volatile
        var isRunning: Boolean = false
            private set

        private const val CHANNEL_ID = "tracker_shield"
        private const val NOTIFICATION_ID = 7301
        private const val TUNNEL_ADDRESS = "10.111.222.1"
        private const val FAKE_DNS_ADDRESS = "10.111.222.2"
        private const val MTU = 1500
        private const val DNS_PORT = 53
        private const val MAX_DNS_REPLY = 4096
        private const val UPSTREAM_TIMEOUT_MS = 5_000

        fun start(context: Context) {
            context.startForegroundService(
                Intent(context, TrackerShieldVpnService::class.java).setAction(ACTION_START),
            )
        }

        fun stop(context: Context) {
            context.startService(
                Intent(context, TrackerShieldVpnService::class.java).setAction(ACTION_STOP),
            )
        }
    }
}
