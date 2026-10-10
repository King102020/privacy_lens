package app.privacylens.collectors

import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build

internal fun PackageManager.installedPackagesWithPermissions(): List<PackageInfo> =
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        getInstalledPackages(
            PackageManager.PackageInfoFlags.of(PackageManager.GET_PERMISSIONS.toLong()),
        )
    } else {
        @Suppress("DEPRECATION")
        getInstalledPackages(PackageManager.GET_PERMISSIONS)
    }

internal fun PackageManager.applicationInfoOrNull(packageName: String): ApplicationInfo? =
    try {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getApplicationInfo(packageName, PackageManager.ApplicationInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            getApplicationInfo(packageName, 0)
        }
    } catch (error: PackageManager.NameNotFoundException) {
        null
    }

internal val ApplicationInfo.isSystemApp: Boolean
    get() = flags and ApplicationInfo.FLAG_SYSTEM != 0
