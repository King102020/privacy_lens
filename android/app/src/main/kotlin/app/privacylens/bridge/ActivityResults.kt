package app.privacylens.bridge

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent

/** Routes `startActivityForResult` replies back to the caller that asked. */
class ActivityResults(private val activity: Activity) {
    private val pending = mutableMapOf<Int, (resultCode: Int, data: Intent?) -> Unit>()
    private var nextRequestCode = FIRST_REQUEST_CODE

    fun launch(intent: Intent, onResult: (resultCode: Int, data: Intent?) -> Unit) {
        val requestCode = nextRequestCode++
        pending[requestCode] = onResult
        try {
            @Suppress("DEPRECATION")
            activity.startActivityForResult(intent, requestCode)
        } catch (error: ActivityNotFoundException) {
            pending.remove(requestCode)
            onResult(Activity.RESULT_CANCELED, null)
        }
    }

    fun dispatch(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val callback = pending.remove(requestCode) ?: return false
        callback(resultCode, data)
        return true
    }

    private companion object {
        const val FIRST_REQUEST_CODE = 4100
    }
}
