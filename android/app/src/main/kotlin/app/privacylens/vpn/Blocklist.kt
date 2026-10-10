package app.privacylens.vpn

import android.content.Context

/**
 * Tracker domains shipped with the app. A domain is blocked when it, or any
 * parent domain, is on the list.
 */
class Blocklist private constructor(
    val version: String,
    private val domains: Set<String>,
) {
    val size: Int get() = domains.size

    fun isBlocked(domain: String): Boolean {
        var candidate = domain.trimEnd('.').lowercase()
        while (candidate.isNotEmpty()) {
            if (candidate in domains) return true
            val dot = candidate.indexOf('.')
            if (dot < 0) return false
            candidate = candidate.substring(dot + 1)
        }
        return false
    }

    companion object {
        /** Flutter packages app assets under this prefix inside the APK. */
        private const val ASSET_PATH = "flutter_assets/assets/rules/tracker_domains.txt"
        private const val VERSION_PREFIX = "# version:"

        @Volatile
        private var instance: Blocklist? = null

        fun get(context: Context): Blocklist =
            instance ?: synchronized(this) {
                instance ?: load(context).also { instance = it }
            }

        private fun load(context: Context): Blocklist =
            context.applicationContext.assets.open(ASSET_PATH).bufferedReader().useLines(::parse)

        /** Format: `# version: <v>` header, then `domain category` per line. */
        fun parse(lines: Sequence<String>): Blocklist {
            var version = "unknown"
            val domains = HashSet<String>()
            for (raw in lines) {
                val line = raw.trim()
                if (line.isEmpty()) continue
                if (line.startsWith(VERSION_PREFIX)) {
                    version = line.removePrefix(VERSION_PREFIX).trim()
                    continue
                }
                if (line.startsWith("#")) continue
                domains += line.substringBefore(' ').lowercase()
            }
            return Blocklist(version, domains)
        }
    }
}
