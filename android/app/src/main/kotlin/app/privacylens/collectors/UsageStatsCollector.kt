package app.privacylens.collectors

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Process
import app.privacylens.bridge.UsageStatDto

class UsageStatsCollector(private val context: Context) {
    private val usageStatsManager = context.getSystemService(UsageStatsManager::class.java)

    fun hasUsageAccess(): Boolean {
        val appOps = context.getSystemService(AppOpsManager::class.java) ?: return false
        val mode = appOps.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName,
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    /**
     * Foreground time is summed from resume/pause events inside the window,
     * which Android keeps for only a few days. Last-used time comes from the
     * aggregated history, which covers months.
     */
    fun collect(sinceMs: Long, untilMs: Long): List<UsageStatDto> {
        val manager = usageStatsManager ?: return emptyList()
        val foreground = foregroundFromEvents(manager, sinceMs, untilMs)
        val lastUsed = manager.queryAndAggregateUsageStats(sinceMs, untilMs)
            .mapValues { (_, stats) -> stats.lastTimeUsed }

        return (foreground.keys + lastUsed.keys)
            .filter { it != context.packageName }
            .map { packageName ->
                UsageStatDto(
                    packageName = packageName,
                    foregroundMs = foreground[packageName] ?: 0L,
                    lastUsedMs = lastUsed[packageName] ?: 0L,
                )
            }
    }

    private fun foregroundFromEvents(
        manager: UsageStatsManager,
        sinceMs: Long,
        untilMs: Long,
    ): Map<String, Long> {
        val totals = HashMap<String, Long>()
        val resumedAt = HashMap<String, Long>()
        val events = manager.queryEvents(sinceMs, untilMs) ?: return totals
        val event = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val packageName = event.packageName ?: continue
            when (event.eventType) {
                UsageEvents.Event.ACTIVITY_RESUMED ->
                    resumedAt.putIfAbsent(packageName, event.timeStamp)
                UsageEvents.Event.ACTIVITY_PAUSED,
                UsageEvents.Event.ACTIVITY_STOPPED -> {
                    val start = resumedAt.remove(packageName) ?: continue
                    totals[packageName] = (totals[packageName] ?: 0L) + (event.timeStamp - start)
                }
            }
        }
        resumedAt.forEach { (packageName, start) ->
            totals[packageName] = (totals[packageName] ?: 0L) + (untilMs - start)
        }
        return totals
    }
}
