import 'package:equatable/equatable.dart';

import '../../../core/errors/result.dart';

enum ExportFormat { json, csv }

enum ExportOutcome { saved, canceled, empty }

class VaultInfo extends Equatable {
  const VaultInfo({required this.sizeBytes, required this.cipherVersion});

  final int sizeBytes;

  /// SQLCipher version reported by the open database. Null means the database
  /// is not encrypted, which should never happen in a release build.
  final String? cipherVersion;

  bool get isEncrypted => cipherVersion != null;

  @override
  List<Object?> get props => [sizeBytes, cipherVersion];
}

abstract interface class DataVaultRepository {
  Future<Result<VaultInfo>> info();

  /// Deletes scans, usage, and blocked lookups older than the retention
  /// windows. The latest scan is always kept.
  Future<Result<void>> purgeExpired({
    required int retentionDays,
    required int dnsRetentionDays,
  });

  /// Writes the latest report to a file the user picks. Returns false when the
  /// user cancels the picker.
  Future<Result<ExportOutcome>> exportLatestReport(ExportFormat format);

  /// Deletes all stored audit data and re-encrypts the database with a new key.
  Future<Result<void>> wipeAll();
}
