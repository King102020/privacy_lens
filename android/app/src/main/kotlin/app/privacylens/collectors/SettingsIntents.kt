package app.privacylens.collectors

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.provider.Settings

/** Opens the system screens where the user changes access. */
class SettingsIntents(private val activity: Activity) {

    fun openAppDetails(packageName: String): Boolean = launch(
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.fromParts("package", packageName, null)),
    )

    /** Deep-links to this app's row when the device supports it. */
    fun openUsageAccess(): Boolean =
        launch(
            Intent(
                Settings.ACTION_USAGE_ACCESS_SETTINGS,
                Uri.fromParts("package", activity.packageName, null),
            ),
        ) || launch(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))

    private fun launch(intent: Intent): Boolean =
        try {
            activity.startActivity(intent)
            true
        } catch (error: ActivityNotFoundException) {
            false
        }
}
