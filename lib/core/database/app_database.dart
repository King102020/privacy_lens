import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Scans,
    Apps,
    AppPermissions,
    SpecialAccess,
    UsageDaily,
    TrackerSdkMatches,
    DnsEvents,
    Findings,
    FindingEvidence,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> wipeAndRekey(String newHexKey) async {
    await transaction(() async {
      for (final table in allTables.toList().reversed) {
        await delete(table).go();
      }
    });
    await customStatement('PRAGMA rekey = "x\'$newHexKey\'"');
    await customStatement('VACUUM');
  }
}
