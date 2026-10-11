package app.privacylens.bridge

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.Build
import app.privacylens.vpn.Blocklist
import app.privacylens.vpn.DnsEventStore
import app.privacylens.vpn.TrackerShieldVpnService

class TrackerShieldApiImpl(
    private val activity: Activity,
    private val activityResults: ActivityResults,
) : TrackerShieldHostApi {
    private val eventStore = DnsEventStore.get(activity)

    override fun getStatus(): ShieldStatusDto {
        val blocklist = Blocklist.get(activity)
        return ShieldStatusDto(
            isRunning = TrackerShieldVpnService.isRunning,
            blocklistVersion = blocklist.version,
            blocklistSize = blocklist.size.toLong(),
        )
    }

    override fun start(callback: (Result<Boolean>) -> Unit) {
        requestNotificationPermissionIfNeeded()
        val consent = VpnService.prepare(activity)
        if (consent == null) {
            TrackerShieldVpnService.start(activity)
            callback(Result.success(true))
            return
        }
        activityResults.launch(consent) { resultCode, _ ->
            val granted = resultCode == Activity.RESULT_OK
            if (granted) TrackerShieldVpnService.start(activity)
            callback(Result.success(granted))
        }
    }

    override fun stop() {
        TrackerShieldVpnService.stop(activity)
    }

    override fun fetchBlockedEvents(afterId: Long, limit: Long): List<DnsEventDto> =
        eventStore.fetchAfter(afterId, limit)

    override fun deleteBlockedEventsUpTo(id: Long) {
        eventStore.deleteUpTo(id)
    }

    override fun applyPolicy(
        enabledCategories: List<String>,
        extraBlocked: List<String>,
        allowed: List<String>,
    ) {
        Blocklist.get(activity).applyPolicy(enabledCategories, extraBlocked, allowed)
    }

    /** The shield works without it; the permission only makes its notification visible. */
    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        val permission = Manifest.permission.POST_NOTIFICATIONS
        if (activity.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED) return
        activity.requestPermissions(arrayOf(permission), NOTIFICATION_REQUEST_CODE)
    }

    private companion object {
        const val NOTIFICATION_REQUEST_CODE = 4090
    }
}
