package app.privacylens.vpn

import android.content.Context

enum class TrackerCategory {
    advertising,
    analytics,
    attribution,
    profiling,
    ;

    companion object {
        fun fromName(raw: String): TrackerCategory? =
            entries.find { it.name.equals(raw.trim(), ignoreCase = true) }
    }
}

/**
 * Tracker domains shipped with the app. A domain is blocked when it, or any
 * parent domain, is on an enabled category or the extra-block list. The
 * allow-list always wins.
 */
class Blocklist private constructor(
    val version: String,
    private val byCategory: Map<TrackerCategory, Set<String>>,
) {
    @Volatile
    private var enabledCategories: Set<TrackerCategory> = TrackerCategory.entries.toSet()

    @Volatile
    private var extraBlocked: Set<String> = emptySet()

    @Volatile
    private var allowed: Set<String> = emptySet()

    val size: Int get() = byCategory.values.sumOf { it.size }

    fun applyPolicy(
        enabledCategories: Collection<String>,
        extraBlocked: Collection<String>,
        allowed: Collection<String>,
    ) {
        this.enabledCategories = enabledCategories.mapNotNull(TrackerCategory::fromName).toSet()
        this.extraBlocked = extraBlocked.map(::normalize).filter { it.isNotEmpty() }.toSet()
        this.allowed = allowed.map(::normalize).filter { it.isNotEmpty() }.toSet()
    }

    fun isBlocked(domain: String): Boolean {
        if (matches(domain, allowed)) return false
        if (matches(domain, extraBlocked)) return true
        var candidate = normalize(domain)
        while (candidate.isNotEmpty()) {
            for (category in enabledCategories) {
                if (candidate in (byCategory[category] ?: emptySet())) return true
            }
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
            val byCategory = TrackerCategory.entries.associateWith { HashSet<String>() }
            for (raw in lines) {
                val line = raw.trim()
                if (line.isEmpty()) continue
                if (line.startsWith(VERSION_PREFIX)) {
                    version = line.removePrefix(VERSION_PREFIX).trim()
                    continue
                }
                if (line.startsWith("#")) continue
                val domain = line.substringBefore(' ').lowercase()
                val categoryName = line.substringAfter(' ', missingDelimiterValue = "").trim()
                val category = TrackerCategory.fromName(categoryName) ?: continue
                if (domain.isNotEmpty()) byCategory.getValue(category) += domain
            }
            return Blocklist(version, byCategory)
        }

        private fun normalize(domain: String): String = domain.trimEnd('.').lowercase()

        private fun matches(domain: String, set: Set<String>): Boolean {
            var candidate = normalize(domain)
            while (candidate.isNotEmpty()) {
                if (candidate in set) return true
                val dot = candidate.indexOf('.')
                if (dot < 0) return false
                candidate = candidate.substring(dot + 1)
            }
            return false
        }
    }
}
