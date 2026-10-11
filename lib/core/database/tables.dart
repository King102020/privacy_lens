import 'package:drift/drift.dart';

class Scans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get appCount => integer().withDefault(const Constant(0))();
  IntColumn get findingCount => integer().withDefault(const Constant(0))();
  BoolColumn get hadUsageAccess => boolean()();
}

@DataClassName('AppRow')
class Apps extends Table {
  TextColumn get packageName => text()();
  TextColumn get label => text()();
  TextColumn get versionName => text().nullable()();
  IntColumn get versionCode => integer()();
  BoolColumn get isSystemApp => boolean()();
  TextColumn get installerPackage => text().nullable()();
  DateTimeColumn get installedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get iconPath => text().nullable()();
  BoolColumn get requestsInternet => boolean()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  TextColumn get trackerScanKey => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {packageName};
}

@DataClassName('AppPermissionRow')
class AppPermissions extends Table {
  TextColumn get packageName =>
      text().references(Apps, #packageName, onDelete: KeyAction.cascade)();
  TextColumn get permission => text()();
  BoolColumn get isGranted => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {packageName, permission};
}

@DataClassName('SpecialAccessRow')
class SpecialAccess extends Table {
  TextColumn get packageName =>
      text().references(Apps, #packageName, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();

  @override
  Set<Column<Object>> get primaryKey => {packageName, kind};
}

@DataClassName('UsageDailyRow')
class UsageDaily extends Table {
  TextColumn get packageName =>
      text().references(Apps, #packageName, onDelete: KeyAction.cascade)();

  DateTimeColumn get day => dateTime()();
  IntColumn get foregroundMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {packageName, day};
}

@DataClassName('TrackerSdkMatchRow')
class TrackerSdkMatches extends Table {
  TextColumn get packageName =>
      text().references(Apps, #packageName, onDelete: KeyAction.cascade)();
  TextColumn get trackerId => text()();

  @override
  Set<Column<Object>> get primaryKey => {packageName, trackerId};
}

@DataClassName('DnsEventRow')
class DnsEvents extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get domain => text()();
  TextColumn get packageName => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FindingRow')
class Findings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scanId =>
      integer().references(Scans, #id, onDelete: KeyAction.cascade)();
  TextColumn get packageName => text()();
  TextColumn get type => text()();
  TextColumn get severity => text()();
}

@DataClassName('FindingEvidenceRow')
class FindingEvidence extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get findingId =>
      integer().references(Findings, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  TextColumn get value => text()();
}
