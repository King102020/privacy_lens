import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

import '../logging/app_logger.dart';
import 'app_database.dart';
import 'database_key_store.dart';

const String databaseFileName = 'privacy_lens.db';

Future<File> databaseFile() async {
  final directory = await getApplicationSupportDirectory();
  return File(p.join(directory.path, databaseFileName));
}

Future<AppDatabase> openAppDatabase({
  required DatabaseKeyStore keyStore,
  required AppLogger logger,
}) async {
  final file = await databaseFile();
  final key = await keyStore.readOrCreate();
  final database = AppDatabase(_encryptedExecutor(file, key));
  try {
    await database.customSelect('SELECT count(*) FROM sqlite_master').get();
    return database;
  } on Object catch (error, stackTrace) {
    logger.error(
      'Database could not be opened; starting with an empty database',
      error: error,
      stackTrace: stackTrace,
    );
    await database.close();
    if (file.existsSync()) await file.delete();
    final freshKey = keyStore.generate();
    await keyStore.save(freshKey);
    return AppDatabase(_encryptedExecutor(file, freshKey));
  }
}

QueryExecutor _encryptedExecutor(File file, String hexKey) =>
    NativeDatabase.createInBackground(
      file,
      isolateSetup: _useSqlCipher,
      setup: (Database database) {
        final cipher = database.select('PRAGMA cipher_version');
        if (cipher.isEmpty) {
          throw StateError('SQLCipher is not available');
        }
        database
          ..execute('PRAGMA key = "x\'$hexKey\'"')
          ..execute('PRAGMA secure_delete = ON');
      },
    );

void _useSqlCipher() {
  open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
}
