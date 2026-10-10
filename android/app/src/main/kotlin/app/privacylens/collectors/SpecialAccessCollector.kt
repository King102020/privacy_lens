package app.privacylens.collectors

import android.Manifest
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.Context
import android.content.pm.PackageManager
import android.view.accessibility.AccessibilityManager
import androidx.core.app.NotificationManagerCompat
import app.privacylens.bridge.SpecialAccessDto
import app.privacylens.bridge.SpecialAccessKindDto

/** Reads system-level access that sits outside normal runtime permissions. */
class SpecialAccessCollector(private val context: Context) {
    private val packageManager = context.packageManager

    fun collect(): List<SpecialAccessDto> = buildList {
        accessibilityServicePackages().forEach {
            add(SpecialAccessDto(it, SpecialAccessKindDto.ACCESSIBILITY_SERVICE))
        }
        NotificationManagerCompat.getEnabledListenerPackages(context).forEach {
            add(SpecialAccessDto(it, SpecialAccessKindDto.NOTIFICATION_LISTENER))
        }
        deviceAdminPackages().forEach {
            add(SpecialAccessDto(it, SpecialAccessKindDto.DEVICE_ADMIN))
        }
        overlayPackages().forEach {
            add(SpecialAccessDto(it, SpecialAccessKindDto.OVERLAY))
        }
    }.filter { it.packageName != context.packageName }

    private fun accessibilityServicePackages(): Set<String> {
        val manager = context.getSystemService(AccessibilityManager::class.java) ?: return emptySet()
        return manager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
            .mapNotNull { it.resolveInfo?.serviceInfo?.packageName }
            .toSet()
    }

    private fun deviceAdminPackages(): Set<String> {
        val manager = context.getSystemService(DevicePolicyManager::class.java) ?: return emptySet()
        return manager.activeAdmins?.map { it.packageName }?.toSet().orEmpty()
    }

    /**
     * Overlay ("display over other apps") is an app-op permission. Only an
     * explicit allow, or a granted permission when the op is at its default, counts.
     */
    private fun overlayPackages(): Set<String> {
        val appOps = context.getSystemService(AppOpsManager::class.java) ?: return emptySet()
        return packageManager.installedPackagesWithPermissions()
            .filter { info ->
                info.requestedPermissions?.contains(Manifest.permission.SYSTEM_ALERT_WINDOW) == true
            }
            .filter { info ->
                val uid = info.applicationInfo?.uid ?: return@filter false
                val mode = try {
                    appOps.unsafeCheckOpNoThrow(
                        AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW,
                        uid,
                        info.packageName,
                    )
                } catch (error: SecurityException) {
                    return@filter false
                }
                when (mode) {
                    AppOpsManager.MODE_ALLOWED -> true
                    AppOpsManager.MODE_DEFAULT -> packageManager.checkPermission(
                        Manifest.permission.SYSTEM_ALERT_WINDOW,
                        info.packageName,
                    ) == PackageManager.PERMISSION_GRANTED
                    else -> false
                }
            }
            .map { it.packageName }
            .toSet()
    }
}
