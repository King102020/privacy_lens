package app.privacylens.collectors

import android.content.Context
import app.privacylens.bridge.TrackerMatchDto
import app.privacylens.bridge.TrackerSignatureDto
import java.io.File
import java.util.zip.ZipFile

/**
 * Finds known tracker SDKs by matching class names inside each app's DEX files
 * against package-prefix signatures supplied by the Dart rule pack.
 */
class TrackerSdkScanner(context: Context) {
    private val packageManager = context.packageManager

    /**
     * Returns one entry per package that could be read, including packages with
     * no matches. Unreadable packages are omitted so they are retried next scan.
     */
    fun scan(
        packageNames: List<String>,
        signatures: List<TrackerSignatureDto>,
        onProgress: (scanned: Int, total: Int) -> Unit,
    ): List<TrackerMatchDto> {
        val matcher = SignatureMatcher(signatures)
        val results = ArrayList<TrackerMatchDto>(packageNames.size)
        packageNames.forEachIndexed { index, packageName ->
            val appInfo = packageManager.applicationInfoOrNull(packageName)
            if (appInfo != null) {
                val apkPaths = listOfNotNull(appInfo.sourceDir) + appInfo.splitSourceDirs.orEmpty()
                val matches = scanApks(apkPaths, matcher)
                if (matches != null) results += TrackerMatchDto(packageName, matches.sorted())
            }
            onProgress(index + 1, packageNames.size)
        }
        return results
    }

    private fun scanApks(paths: List<String>, matcher: SignatureMatcher): Set<String>? {
        val found = HashSet<String>()
        var readAny = false
        for (path in paths) {
            val file = File(path)
            if (!file.canRead()) continue
            try {
                ZipFile(file).use { zip ->
                    for (entry in zip.entries()) {
                        if (!DEX_ENTRY.matches(entry.name)) continue
                        val bytes = zip.getInputStream(entry).use { it.readBytes() }
                        readAny = true
                        matcher.collectMatches(DexClassReader.classDescriptors(bytes), found)
                        if (found.size == matcher.signatureCount) return found
                    }
                }
            } catch (error: Exception) {
                continue
            }
        }
        return if (readAny) found else null
    }

    private companion object {
        val DEX_ENTRY = Regex("""classes\d*\.dex""")
    }
}

/** Matches DEX class descriptors against Java package prefixes. */
class SignatureMatcher(signatures: List<TrackerSignatureDto>) {
    private val descriptorPrefixes: List<Pair<String, String>> = signatures.flatMap { signature ->
        signature.classPrefixes.map { prefix ->
            "L${prefix.trim('.').replace('.', '/')}/" to signature.trackerId
        }
    }

    val signatureCount: Int = signatures.map { it.trackerId }.distinct().size

    fun collectMatches(descriptors: List<String>, into: MutableSet<String>) {
        for (descriptor in descriptors) {
            for ((prefix, trackerId) in descriptorPrefixes) {
                if (trackerId !in into && descriptor.startsWith(prefix)) into += trackerId
            }
        }
    }
}
