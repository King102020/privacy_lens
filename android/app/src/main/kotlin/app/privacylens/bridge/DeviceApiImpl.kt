package app.privacylens.bridge

import android.app.Activity
import android.content.Intent
import android.os.Build
import app.privacylens.collectors.IconCache
import app.privacylens.collectors.InstalledAppsCollector
import app.privacylens.collectors.SettingsIntents
import app.privacylens.collectors.SpecialAccessCollector
import app.privacylens.collectors.TrackerSdkScanner
import app.privacylens.collectors.UsageStatsCollector
import app.privacylens.vpn.DnsEventStore
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class DeviceApiImpl(
    private val activity: Activity,
    messenger: BinaryMessenger,
    private val scope: CoroutineScope,
    private val activityResults: ActivityResults,
) : DeviceHostApi {
    private val iconCache = IconCache(activity)
    private val installedApps = InstalledAppsCollector(activity, iconCache)
    private val specialAccess = SpecialAccessCollector(activity)
    private val usageStats = UsageStatsCollector(activity)
    private val trackerScanner = TrackerSdkScanner(activity)
    private val settingsIntents = SettingsIntents(activity)
    private val progressApi = ScanProgressFlutterApi(messenger)

    override fun getAccessStatus(): AccessStatusDto = AccessStatusDto(
        hasUsageAccess = usageStats.hasUsageAccess(),
        isRestrictedSettingsLikely = isRestrictedSettingsLikely(),
        sdkInt = Build.VERSION.SDK_INT.toLong(),
    )

    override fun getInstalledApps(
        includeSystemApps: Boolean,
        callback: (Result<List<InstalledAppDto>>) -> Unit,
    ) = runInBackground(callback) { installedApps.collect(includeSystemApps) }

    override fun getSpecialAccess(callback: (Result<List<SpecialAccessDto>>) -> Unit) =
        runInBackground(callback) { specialAccess.collect() }

    override fun getUsageStats(
        sinceMs: Long,
        untilMs: Long,
        callback: (Result<List<UsageStatDto>>) -> Unit,
    ) {
        if (!usageStats.hasUsageAccess()) {
            callback(Result.failure(FlutterError(ERROR_USAGE_ACCESS_MISSING, "Usage Access is not granted")))
            return
        }
        runInBackground(callback) { usageStats.collect(sinceMs, untilMs) }
    }

    override fun scanTrackerSdks(
        packageNames: List<String>,
        signatures: List<TrackerSignatureDto>,
        callback: (Result<List<TrackerMatchDto>>) -> Unit,
    ) = runInBackground(callback) {
        trackerScanner.scan(packageNames, signatures) { scanned, total ->
            scope.launch {
                progressApi.onTrackerScanProgress(scanned.toLong(), total.toLong()) {}
            }
        }
    }

    override fun openAppDetailsSettings(packageName: String): Boolean =
        settingsIntents.openAppDetails(packageName)

    override fun openUsageAccessSettings(): Boolean = settingsIntents.openUsageAccess()

    override fun openOwnAppDetailsSettings(): Boolean =
        settingsIntents.openAppDetails(activity.packageName)

    override fun saveDocument(
        suggestedName: String,
        mimeType: String,
        bytes: ByteArray,
        callback: (Result<Boolean>) -> Unit,
    ) {
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
            .addCategory(Intent.CATEGORY_OPENABLE)
            .setType(mimeType)
            .putExtra(Intent.EXTRA_TITLE, suggestedName)
        activityResults.launch(intent) { resultCode, data ->
            val uri = data?.data
            if (resultCode != Activity.RESULT_OK || uri == null) {
                callback(Result.success(false))
                return@launch
            }
            runInBackground(callback) {
                val stream = activity.contentResolver.openOutputStream(uri)
                    ?: throw FlutterError(ERROR_IO, "Could not open the chosen file")
                stream.use { it.write(bytes) }
                true
            }
        }
    }

    override fun clearNativeData() {
        iconCache.clear()
        DnsEventStore.get(activity).clear()
    }

    /**
     * Android 13+ blocks special access ("restricted settings") for apps installed
     * from a file rather than an app store, until the user allows it in App info.
     */
    private fun isRestrictedSettingsLikely(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return false
        val installer = try {
            activity.packageManager.getInstallSourceInfo(activity.packageName).installingPackageName
        } catch (error: Exception) {
            null
        }
        return installer == null || installer in SYSTEM_PACKAGE_INSTALLERS
    }

    private fun <T> runInBackground(callback: (Result<T>) -> Unit, block: () -> T) {
        scope.launch {
            val result = withContext(Dispatchers.IO) {
                try {
                    Result.success(block())
                } catch (error: FlutterError) {
                    Result.failure(error)
                } catch (error: SecurityException) {
                    Result.failure(FlutterError(ERROR_SECURITY, error.message))
                } catch (error: Exception) {
                    Result.failure(FlutterError(ERROR_IO, error.message))
                }
            }
            callback(result)
        }
    }

    private companion object {
        const val ERROR_USAGE_ACCESS_MISSING = "usage_access_missing"
        const val ERROR_SECURITY = "security"
        const val ERROR_IO = "io"
        val SYSTEM_PACKAGE_INSTALLERS = setOf(
            "com.google.android.packageinstaller",
            "com.android.packageinstaller",
        )
    }
}
