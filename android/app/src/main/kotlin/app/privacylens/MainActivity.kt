package app.privacylens

import android.content.Intent
import app.privacylens.bridge.ActivityResults
import app.privacylens.bridge.DeviceApiImpl
import app.privacylens.bridge.DeviceHostApi
import app.privacylens.bridge.TrackerShieldApiImpl
import app.privacylens.bridge.TrackerShieldHostApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel

class MainActivity : FlutterActivity() {
    private val activityResults = ActivityResults(this)
    private var bridgeScope: CoroutineScope? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
        bridgeScope = scope
        DeviceHostApi.setUp(messenger, DeviceApiImpl(this, messenger, scope, activityResults))
        TrackerShieldHostApi.setUp(messenger, TrackerShieldApiImpl(this, activityResults))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        DeviceHostApi.setUp(messenger, null)
        TrackerShieldHostApi.setUp(messenger, null)
        bridgeScope?.cancel()
        bridgeScope = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    @Deprecated("FlutterActivity is a plain Activity, so results arrive here.")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (!activityResults.dispatch(requestCode, resultCode, data)) {
            @Suppress("DEPRECATION")
            super.onActivityResult(requestCode, resultCode, data)
        }
    }
}
