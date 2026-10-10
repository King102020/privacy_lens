package app.privacylens.vpn

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.SystemClock
import java.net.InetAddress

/** The phone's own DNS servers on the underlying (non-VPN) network. */
class UpstreamDns(private val connectivityManager: ConnectivityManager) {
    data class Target(val network: Network, val server: InetAddress)

    @Volatile
    private var cached: Target? = null

    @Volatile
    private var cachedAtMs = 0L

    fun current(): Target? {
        val now = SystemClock.elapsedRealtime()
        cached?.let { if (now - cachedAtMs < CACHE_MS) return it }
        val target = resolve()
        cached = target
        cachedAtMs = now
        return target
    }

    fun invalidate() {
        cached = null
    }

    @Suppress("DEPRECATION") // allNetworks is the simplest way to see non-default networks.
    private fun resolve(): Target? {
        for (network in connectivityManager.allNetworks) {
            val capabilities = connectivityManager.getNetworkCapabilities(network) ?: continue
            if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) continue
            if (!capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) continue
            val server = connectivityManager.getLinkProperties(network)?.dnsServers?.firstOrNull()
                ?: continue
            return Target(network, server)
        }
        return null
    }

    private companion object {
        const val CACHE_MS = 10_000L
    }
}
