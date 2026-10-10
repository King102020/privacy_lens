package app.privacylens.collectors

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import app.privacylens.bridge.InstalledAppDto

/**
 * Lists installed apps with their requested and granted permissions.
 *
 * Without [includeSystemApps], preinstalled apps are kept only when they have a
 * launcher entry, so people see the apps they actually use but not hundreds of
 * hidden system components.
 */
class InstalledAppsCollector(
    private val context: Context,
    private val iconCache: IconCache,
) {
    private val packageManager = context.packageManager

    fun collect(includeSystemApps: Boolean): List<InstalledAppDto> =
        packageManager.installedPackagesWithPermissions()
            .asSequence()
            .filter { it.packageName != context.packageName }
            .mapNotNull { toDto(it, includeSystemApps) }
            .toList()

    private fun toDto(info: PackageInfo, includeSystemApps: Boolean): InstalledAppDto? {
        val appInfo = info.applicationInfo ?: return null
        val isSystem = appInfo.isSystemApp
        if (isSystem && !includeSystemApps &&
            packageManager.getLaunchIntentForPackage(info.packageName) == null
        ) {
            return null
        }

        val requested = info.requestedPermissions?.toList().orEmpty()
        val flags = info.requestedPermissionsFlags
        val granted = requested.filterIndexed { index, _ ->
            flags != null && index < flags.size &&
                flags[index] and PackageInfo.REQUESTED_PERMISSION_GRANTED != 0
        }
        val versionCode = info.longVersionCode

        return InstalledAppDto(
            packageName = info.packageName,
            label = appInfo.loadLabel(packageManager).toString(),
            versionName = info.versionName,
            versionCode = versionCode,
            isSystemApp = isSystem,
            installerPackage = installerOf(info.packageName),
            firstInstallTimeMs = info.firstInstallTime,
            lastUpdateTimeMs = info.lastUpdateTime,
            iconPath = iconCache.iconPathFor(appInfo, versionCode),
            requestedPermissions = requested,
            grantedPermissions = granted,
        )
    }

    private fun installerOf(packageName: String): String? =
        try {
            packageManager.getInstallSourceInfo(packageName).installingPackageName
        } catch (error: PackageManager.NameNotFoundException) {
            null
        }
}
