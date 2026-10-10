import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:privacy_lens/core/database/app_database.dart';

AppDatabase memoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
