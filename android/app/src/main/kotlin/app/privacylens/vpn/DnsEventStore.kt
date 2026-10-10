package app.privacylens.vpn

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import app.privacylens.bridge.DnsEventDto

/**
 * Staging store for blocked lookups, written by the VPN service even when the
 * Flutter UI is not running. Dart imports and deletes rows on each app resume.
 * Allowed lookups are never recorded.
 */
class DnsEventStore private constructor(context: Context) :
    SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    private var insertsSincePrune = 0

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            "CREATE TABLE $TABLE (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "timestamp_ms INTEGER NOT NULL, " +
                "domain TEXT NOT NULL, " +
                "package_name TEXT)",
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) = Unit

    @Synchronized
    fun insertBlocked(timestampMs: Long, domain: String, packageName: String?) {
        val values = ContentValues().apply {
            put("timestamp_ms", timestampMs)
            put("domain", domain)
            put("package_name", packageName)
        }
        writableDatabase.insert(TABLE, null, values)
        if (++insertsSincePrune >= PRUNE_EVERY_INSERTS) {
            insertsSincePrune = 0
            writableDatabase.execSQL(
                "DELETE FROM $TABLE WHERE id NOT IN " +
                    "(SELECT id FROM $TABLE ORDER BY id DESC LIMIT $MAX_ROWS)",
            )
        }
    }

    fun fetchAfter(afterId: Long, limit: Long): List<DnsEventDto> {
        val events = ArrayList<DnsEventDto>()
        readableDatabase.query(
            TABLE,
            arrayOf("id", "timestamp_ms", "domain", "package_name"),
            "id > ?",
            arrayOf(afterId.toString()),
            null,
            null,
            "id ASC",
            limit.toString(),
        ).use { cursor ->
            while (cursor.moveToNext()) {
                events += DnsEventDto(
                    id = cursor.getLong(0),
                    timestampMs = cursor.getLong(1),
                    domain = cursor.getString(2),
                    packageName = if (cursor.isNull(3)) null else cursor.getString(3),
                )
            }
        }
        return events
    }

    @Synchronized
    fun deleteUpTo(id: Long) {
        writableDatabase.delete(TABLE, "id <= ?", arrayOf(id.toString()))
    }

    @Synchronized
    fun clear() {
        writableDatabase.delete(TABLE, null, null)
    }

    companion object {
        private const val DATABASE_NAME = "dns_events.db"
        private const val DATABASE_VERSION = 1
        private const val TABLE = "blocked_events"
        private const val MAX_ROWS = 20_000
        private const val PRUNE_EVERY_INSERTS = 500

        @Volatile
        private var instance: DnsEventStore? = null

        fun get(context: Context): DnsEventStore =
            instance ?: synchronized(this) {
                instance ?: DnsEventStore(context.applicationContext).also { instance = it }
            }
    }
}
