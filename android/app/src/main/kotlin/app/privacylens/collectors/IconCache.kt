package app.privacylens.collectors

import android.content.Context
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import androidx.core.graphics.drawable.toBitmap
import java.io.File

/** Renders app icons once per app version into the private cache directory. */
class IconCache(context: Context) {
    private val packageManager = context.packageManager
    private val directory = File(context.cacheDir, DIRECTORY_NAME)

    fun iconPathFor(appInfo: ApplicationInfo, versionCode: Long): String? {
        val file = File(directory, "${appInfo.packageName}-$versionCode.png")
        if (file.exists()) return file.absolutePath
        return try {
            directory.mkdirs()
            directory.listFiles { candidate ->
                candidate.name.startsWith("${appInfo.packageName}-")
            }?.forEach(File::delete)
            val bitmap = appInfo.loadIcon(packageManager).toBitmap(ICON_SIZE_PX, ICON_SIZE_PX)
            file.outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
            file.absolutePath
        } catch (error: Exception) {
            null
        }
    }

    fun clear() {
        directory.deleteRecursively()
    }

    private companion object {
        const val DIRECTORY_NAME = "app_icons"
        const val ICON_SIZE_PX = 128
    }
}
