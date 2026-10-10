// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScansTable extends Scans with TableInfo<$ScansTable, Scan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appCountMeta = const VerificationMeta(
    'appCount',
  );
  @override
  late final GeneratedColumn<int> appCount = GeneratedColumn<int>(
    'app_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _findingCountMeta = const VerificationMeta(
    'findingCount',
  );
  @override
  late final GeneratedColumn<int> findingCount = GeneratedColumn<int>(
    'finding_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hadUsageAccessMeta = const VerificationMeta(
    'hadUsageAccess',
  );
  @override
  late final GeneratedColumn<bool> hadUsageAccess = GeneratedColumn<bool>(
    'had_usage_access',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_usage_access" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    completedAt,
    appCount,
    findingCount,
    hadUsageAccess,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Scan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('app_count')) {
      context.handle(
        _appCountMeta,
        appCount.isAcceptableOrUnknown(data['app_count']!, _appCountMeta),
      );
    }
    if (data.containsKey('finding_count')) {
      context.handle(
        _findingCountMeta,
        findingCount.isAcceptableOrUnknown(
          data['finding_count']!,
          _findingCountMeta,
        ),
      );
    }
    if (data.containsKey('had_usage_access')) {
      context.handle(
        _hadUsageAccessMeta,
        hadUsageAccess.isAcceptableOrUnknown(
          data['had_usage_access']!,
          _hadUsageAccessMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hadUsageAccessMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Scan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Scan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      appCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}app_count'],
      )!,
      findingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}finding_count'],
      )!,
      hadUsageAccess: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_usage_access'],
      )!,
    );
  }

  @override
  $ScansTable createAlias(String alias) {
    return $ScansTable(attachedDatabase, alias);
  }
}

class Scan extends DataClass implements Insertable<Scan> {
  final int id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int appCount;
  final int findingCount;
  final bool hadUsageAccess;
  const Scan({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.appCount,
    required this.findingCount,
    required this.hadUsageAccess,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['app_count'] = Variable<int>(appCount);
    map['finding_count'] = Variable<int>(findingCount);
    map['had_usage_access'] = Variable<bool>(hadUsageAccess);
    return map;
  }

  ScansCompanion toCompanion(bool nullToAbsent) {
    return ScansCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      appCount: Value(appCount),
      findingCount: Value(findingCount),
      hadUsageAccess: Value(hadUsageAccess),
    );
  }

  factory Scan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Scan(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      appCount: serializer.fromJson<int>(json['appCount']),
      findingCount: serializer.fromJson<int>(json['findingCount']),
      hadUsageAccess: serializer.fromJson<bool>(json['hadUsageAccess']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'appCount': serializer.toJson<int>(appCount),
      'findingCount': serializer.toJson<int>(findingCount),
      'hadUsageAccess': serializer.toJson<bool>(hadUsageAccess),
    };
  }

  Scan copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    int? appCount,
    int? findingCount,
    bool? hadUsageAccess,
  }) => Scan(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    appCount: appCount ?? this.appCount,
    findingCount: findingCount ?? this.findingCount,
    hadUsageAccess: hadUsageAccess ?? this.hadUsageAccess,
  );
  Scan copyWithCompanion(ScansCompanion data) {
    return Scan(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      appCount: data.appCount.present ? data.appCount.value : this.appCount,
      findingCount: data.findingCount.present
          ? data.findingCount.value
          : this.findingCount,
      hadUsageAccess: data.hadUsageAccess.present
          ? data.hadUsageAccess.value
          : this.hadUsageAccess,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Scan(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('appCount: $appCount, ')
          ..write('findingCount: $findingCount, ')
          ..write('hadUsageAccess: $hadUsageAccess')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    completedAt,
    appCount,
    findingCount,
    hadUsageAccess,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Scan &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.appCount == this.appCount &&
          other.findingCount == this.findingCount &&
          other.hadUsageAccess == this.hadUsageAccess);
}

class ScansCompanion extends UpdateCompanion<Scan> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> appCount;
  final Value<int> findingCount;
  final Value<bool> hadUsageAccess;
  const ScansCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.appCount = const Value.absent(),
    this.findingCount = const Value.absent(),
    this.hadUsageAccess = const Value.absent(),
  });
  ScansCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.appCount = const Value.absent(),
    this.findingCount = const Value.absent(),
    required bool hadUsageAccess,
  }) : startedAt = Value(startedAt),
       hadUsageAccess = Value(hadUsageAccess);
  static Insertable<Scan> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? appCount,
    Expression<int>? findingCount,
    Expression<bool>? hadUsageAccess,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (appCount != null) 'app_count': appCount,
      if (findingCount != null) 'finding_count': findingCount,
      if (hadUsageAccess != null) 'had_usage_access': hadUsageAccess,
    });
  }

  ScansCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? appCount,
    Value<int>? findingCount,
    Value<bool>? hadUsageAccess,
  }) {
    return ScansCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      appCount: appCount ?? this.appCount,
      findingCount: findingCount ?? this.findingCount,
      hadUsageAccess: hadUsageAccess ?? this.hadUsageAccess,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (appCount.present) {
      map['app_count'] = Variable<int>(appCount.value);
    }
    if (findingCount.present) {
      map['finding_count'] = Variable<int>(findingCount.value);
    }
    if (hadUsageAccess.present) {
      map['had_usage_access'] = Variable<bool>(hadUsageAccess.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScansCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('appCount: $appCount, ')
          ..write('findingCount: $findingCount, ')
          ..write('hadUsageAccess: $hadUsageAccess')
          ..write(')'))
        .toString();
  }
}

class $AppsTable extends Apps with TableInfo<$AppsTable, AppRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionNameMeta = const VerificationMeta(
    'versionName',
  );
  @override
  late final GeneratedColumn<String> versionName = GeneratedColumn<String>(
    'version_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionCodeMeta = const VerificationMeta(
    'versionCode',
  );
  @override
  late final GeneratedColumn<int> versionCode = GeneratedColumn<int>(
    'version_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemAppMeta = const VerificationMeta(
    'isSystemApp',
  );
  @override
  late final GeneratedColumn<bool> isSystemApp = GeneratedColumn<bool>(
    'is_system_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_app" IN (0, 1))',
    ),
  );
  static const VerificationMeta _installerPackageMeta = const VerificationMeta(
    'installerPackage',
  );
  @override
  late final GeneratedColumn<String> installerPackage = GeneratedColumn<String>(
    'installer_package',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestsInternetMeta = const VerificationMeta(
    'requestsInternet',
  );
  @override
  late final GeneratedColumn<bool> requestsInternet = GeneratedColumn<bool>(
    'requests_internet',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requests_internet" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackerScanKeyMeta = const VerificationMeta(
    'trackerScanKey',
  );
  @override
  late final GeneratedColumn<String> trackerScanKey = GeneratedColumn<String>(
    'tracker_scan_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packageName,
    label,
    versionName,
    versionCode,
    isSystemApp,
    installerPackage,
    installedAt,
    updatedAt,
    iconPath,
    requestsInternet,
    lastUsedAt,
    trackerScanKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('version_name')) {
      context.handle(
        _versionNameMeta,
        versionName.isAcceptableOrUnknown(
          data['version_name']!,
          _versionNameMeta,
        ),
      );
    }
    if (data.containsKey('version_code')) {
      context.handle(
        _versionCodeMeta,
        versionCode.isAcceptableOrUnknown(
          data['version_code']!,
          _versionCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionCodeMeta);
    }
    if (data.containsKey('is_system_app')) {
      context.handle(
        _isSystemAppMeta,
        isSystemApp.isAcceptableOrUnknown(
          data['is_system_app']!,
          _isSystemAppMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isSystemAppMeta);
    }
    if (data.containsKey('installer_package')) {
      context.handle(
        _installerPackageMeta,
        installerPackage.isAcceptableOrUnknown(
          data['installer_package']!,
          _installerPackageMeta,
        ),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('requests_internet')) {
      context.handle(
        _requestsInternetMeta,
        requestsInternet.isAcceptableOrUnknown(
          data['requests_internet']!,
          _requestsInternetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestsInternetMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('tracker_scan_key')) {
      context.handle(
        _trackerScanKeyMeta,
        trackerScanKey.isAcceptableOrUnknown(
          data['tracker_scan_key']!,
          _trackerScanKeyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  AppRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      versionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version_name'],
      ),
      versionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_code'],
      )!,
      isSystemApp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_app'],
      )!,
      installerPackage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installer_package'],
      ),
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      requestsInternet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requests_internet'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      trackerScanKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_scan_key'],
      ),
    );
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class AppRow extends DataClass implements Insertable<AppRow> {
  final String packageName;
  final String label;
  final String? versionName;
  final int versionCode;
  final bool isSystemApp;
  final String? installerPackage;
  final DateTime installedAt;
  final DateTime updatedAt;
  final String? iconPath;
  final bool requestsInternet;
  final DateTime? lastUsedAt;

  /// `versionCode:lastUpdate:rulePackVersion` of the last tracker SDK scan.
  /// A package is rescanned only when this changes.
  final String? trackerScanKey;
  const AppRow({
    required this.packageName,
    required this.label,
    this.versionName,
    required this.versionCode,
    required this.isSystemApp,
    this.installerPackage,
    required this.installedAt,
    required this.updatedAt,
    this.iconPath,
    required this.requestsInternet,
    this.lastUsedAt,
    this.trackerScanKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || versionName != null) {
      map['version_name'] = Variable<String>(versionName);
    }
    map['version_code'] = Variable<int>(versionCode);
    map['is_system_app'] = Variable<bool>(isSystemApp);
    if (!nullToAbsent || installerPackage != null) {
      map['installer_package'] = Variable<String>(installerPackage);
    }
    map['installed_at'] = Variable<DateTime>(installedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    map['requests_internet'] = Variable<bool>(requestsInternet);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    if (!nullToAbsent || trackerScanKey != null) {
      map['tracker_scan_key'] = Variable<String>(trackerScanKey);
    }
    return map;
  }

  AppsCompanion toCompanion(bool nullToAbsent) {
    return AppsCompanion(
      packageName: Value(packageName),
      label: Value(label),
      versionName: versionName == null && nullToAbsent
          ? const Value.absent()
          : Value(versionName),
      versionCode: Value(versionCode),
      isSystemApp: Value(isSystemApp),
      installerPackage: installerPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(installerPackage),
      installedAt: Value(installedAt),
      updatedAt: Value(updatedAt),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      requestsInternet: Value(requestsInternet),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      trackerScanKey: trackerScanKey == null && nullToAbsent
          ? const Value.absent()
          : Value(trackerScanKey),
    );
  }

  factory AppRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      label: serializer.fromJson<String>(json['label']),
      versionName: serializer.fromJson<String?>(json['versionName']),
      versionCode: serializer.fromJson<int>(json['versionCode']),
      isSystemApp: serializer.fromJson<bool>(json['isSystemApp']),
      installerPackage: serializer.fromJson<String?>(json['installerPackage']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      requestsInternet: serializer.fromJson<bool>(json['requestsInternet']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      trackerScanKey: serializer.fromJson<String?>(json['trackerScanKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'label': serializer.toJson<String>(label),
      'versionName': serializer.toJson<String?>(versionName),
      'versionCode': serializer.toJson<int>(versionCode),
      'isSystemApp': serializer.toJson<bool>(isSystemApp),
      'installerPackage': serializer.toJson<String?>(installerPackage),
      'installedAt': serializer.toJson<DateTime>(installedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'iconPath': serializer.toJson<String?>(iconPath),
      'requestsInternet': serializer.toJson<bool>(requestsInternet),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'trackerScanKey': serializer.toJson<String?>(trackerScanKey),
    };
  }

  AppRow copyWith({
    String? packageName,
    String? label,
    Value<String?> versionName = const Value.absent(),
    int? versionCode,
    bool? isSystemApp,
    Value<String?> installerPackage = const Value.absent(),
    DateTime? installedAt,
    DateTime? updatedAt,
    Value<String?> iconPath = const Value.absent(),
    bool? requestsInternet,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    Value<String?> trackerScanKey = const Value.absent(),
  }) => AppRow(
    packageName: packageName ?? this.packageName,
    label: label ?? this.label,
    versionName: versionName.present ? versionName.value : this.versionName,
    versionCode: versionCode ?? this.versionCode,
    isSystemApp: isSystemApp ?? this.isSystemApp,
    installerPackage: installerPackage.present
        ? installerPackage.value
        : this.installerPackage,
    installedAt: installedAt ?? this.installedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    requestsInternet: requestsInternet ?? this.requestsInternet,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    trackerScanKey: trackerScanKey.present
        ? trackerScanKey.value
        : this.trackerScanKey,
  );
  AppRow copyWithCompanion(AppsCompanion data) {
    return AppRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      label: data.label.present ? data.label.value : this.label,
      versionName: data.versionName.present
          ? data.versionName.value
          : this.versionName,
      versionCode: data.versionCode.present
          ? data.versionCode.value
          : this.versionCode,
      isSystemApp: data.isSystemApp.present
          ? data.isSystemApp.value
          : this.isSystemApp,
      installerPackage: data.installerPackage.present
          ? data.installerPackage.value
          : this.installerPackage,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      requestsInternet: data.requestsInternet.present
          ? data.requestsInternet.value
          : this.requestsInternet,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      trackerScanKey: data.trackerScanKey.present
          ? data.trackerScanKey.value
          : this.trackerScanKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppRow(')
          ..write('packageName: $packageName, ')
          ..write('label: $label, ')
          ..write('versionName: $versionName, ')
          ..write('versionCode: $versionCode, ')
          ..write('isSystemApp: $isSystemApp, ')
          ..write('installerPackage: $installerPackage, ')
          ..write('installedAt: $installedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('iconPath: $iconPath, ')
          ..write('requestsInternet: $requestsInternet, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('trackerScanKey: $trackerScanKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packageName,
    label,
    versionName,
    versionCode,
    isSystemApp,
    installerPackage,
    installedAt,
    updatedAt,
    iconPath,
    requestsInternet,
    lastUsedAt,
    trackerScanKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppRow &&
          other.packageName == this.packageName &&
          other.label == this.label &&
          other.versionName == this.versionName &&
          other.versionCode == this.versionCode &&
          other.isSystemApp == this.isSystemApp &&
          other.installerPackage == this.installerPackage &&
          other.installedAt == this.installedAt &&
          other.updatedAt == this.updatedAt &&
          other.iconPath == this.iconPath &&
          other.requestsInternet == this.requestsInternet &&
          other.lastUsedAt == this.lastUsedAt &&
          other.trackerScanKey == this.trackerScanKey);
}

class AppsCompanion extends UpdateCompanion<AppRow> {
  final Value<String> packageName;
  final Value<String> label;
  final Value<String?> versionName;
  final Value<int> versionCode;
  final Value<bool> isSystemApp;
  final Value<String?> installerPackage;
  final Value<DateTime> installedAt;
  final Value<DateTime> updatedAt;
  final Value<String?> iconPath;
  final Value<bool> requestsInternet;
  final Value<DateTime?> lastUsedAt;
  final Value<String?> trackerScanKey;
  final Value<int> rowid;
  const AppsCompanion({
    this.packageName = const Value.absent(),
    this.label = const Value.absent(),
    this.versionName = const Value.absent(),
    this.versionCode = const Value.absent(),
    this.isSystemApp = const Value.absent(),
    this.installerPackage = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.requestsInternet = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.trackerScanKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppsCompanion.insert({
    required String packageName,
    required String label,
    this.versionName = const Value.absent(),
    required int versionCode,
    required bool isSystemApp,
    this.installerPackage = const Value.absent(),
    required DateTime installedAt,
    required DateTime updatedAt,
    this.iconPath = const Value.absent(),
    required bool requestsInternet,
    this.lastUsedAt = const Value.absent(),
    this.trackerScanKey = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       label = Value(label),
       versionCode = Value(versionCode),
       isSystemApp = Value(isSystemApp),
       installedAt = Value(installedAt),
       updatedAt = Value(updatedAt),
       requestsInternet = Value(requestsInternet);
  static Insertable<AppRow> custom({
    Expression<String>? packageName,
    Expression<String>? label,
    Expression<String>? versionName,
    Expression<int>? versionCode,
    Expression<bool>? isSystemApp,
    Expression<String>? installerPackage,
    Expression<DateTime>? installedAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? iconPath,
    Expression<bool>? requestsInternet,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? trackerScanKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (label != null) 'label': label,
      if (versionName != null) 'version_name': versionName,
      if (versionCode != null) 'version_code': versionCode,
      if (isSystemApp != null) 'is_system_app': isSystemApp,
      if (installerPackage != null) 'installer_package': installerPackage,
      if (installedAt != null) 'installed_at': installedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (iconPath != null) 'icon_path': iconPath,
      if (requestsInternet != null) 'requests_internet': requestsInternet,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (trackerScanKey != null) 'tracker_scan_key': trackerScanKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppsCompanion copyWith({
    Value<String>? packageName,
    Value<String>? label,
    Value<String?>? versionName,
    Value<int>? versionCode,
    Value<bool>? isSystemApp,
    Value<String?>? installerPackage,
    Value<DateTime>? installedAt,
    Value<DateTime>? updatedAt,
    Value<String?>? iconPath,
    Value<bool>? requestsInternet,
    Value<DateTime?>? lastUsedAt,
    Value<String?>? trackerScanKey,
    Value<int>? rowid,
  }) {
    return AppsCompanion(
      packageName: packageName ?? this.packageName,
      label: label ?? this.label,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      installerPackage: installerPackage ?? this.installerPackage,
      installedAt: installedAt ?? this.installedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iconPath: iconPath ?? this.iconPath,
      requestsInternet: requestsInternet ?? this.requestsInternet,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      trackerScanKey: trackerScanKey ?? this.trackerScanKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (versionName.present) {
      map['version_name'] = Variable<String>(versionName.value);
    }
    if (versionCode.present) {
      map['version_code'] = Variable<int>(versionCode.value);
    }
    if (isSystemApp.present) {
      map['is_system_app'] = Variable<bool>(isSystemApp.value);
    }
    if (installerPackage.present) {
      map['installer_package'] = Variable<String>(installerPackage.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (requestsInternet.present) {
      map['requests_internet'] = Variable<bool>(requestsInternet.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (trackerScanKey.present) {
      map['tracker_scan_key'] = Variable<String>(trackerScanKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCompanion(')
          ..write('packageName: $packageName, ')
          ..write('label: $label, ')
          ..write('versionName: $versionName, ')
          ..write('versionCode: $versionCode, ')
          ..write('isSystemApp: $isSystemApp, ')
          ..write('installerPackage: $installerPackage, ')
          ..write('installedAt: $installedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('iconPath: $iconPath, ')
          ..write('requestsInternet: $requestsInternet, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('trackerScanKey: $trackerScanKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPermissionsTable extends AppPermissions
    with TableInfo<$AppPermissionsTable, AppPermissionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (package_name) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _permissionMeta = const VerificationMeta(
    'permission',
  );
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
    'permission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGrantedMeta = const VerificationMeta(
    'isGranted',
  );
  @override
  late final GeneratedColumn<bool> isGranted = GeneratedColumn<bool>(
    'is_granted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_granted" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, permission, isGranted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_permissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPermissionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
        _permissionMeta,
        permission.isAcceptableOrUnknown(data['permission']!, _permissionMeta),
      );
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    if (data.containsKey('is_granted')) {
      context.handle(
        _isGrantedMeta,
        isGranted.isAcceptableOrUnknown(data['is_granted']!, _isGrantedMeta),
      );
    } else if (isInserting) {
      context.missing(_isGrantedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, permission};
  @override
  AppPermissionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPermissionRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      permission: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permission'],
      )!,
      isGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_granted'],
      )!,
    );
  }

  @override
  $AppPermissionsTable createAlias(String alias) {
    return $AppPermissionsTable(attachedDatabase, alias);
  }
}

class AppPermissionRow extends DataClass
    implements Insertable<AppPermissionRow> {
  final String packageName;
  final String permission;
  final bool isGranted;
  const AppPermissionRow({
    required this.packageName,
    required this.permission,
    required this.isGranted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['permission'] = Variable<String>(permission);
    map['is_granted'] = Variable<bool>(isGranted);
    return map;
  }

  AppPermissionsCompanion toCompanion(bool nullToAbsent) {
    return AppPermissionsCompanion(
      packageName: Value(packageName),
      permission: Value(permission),
      isGranted: Value(isGranted),
    );
  }

  factory AppPermissionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPermissionRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      permission: serializer.fromJson<String>(json['permission']),
      isGranted: serializer.fromJson<bool>(json['isGranted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'permission': serializer.toJson<String>(permission),
      'isGranted': serializer.toJson<bool>(isGranted),
    };
  }

  AppPermissionRow copyWith({
    String? packageName,
    String? permission,
    bool? isGranted,
  }) => AppPermissionRow(
    packageName: packageName ?? this.packageName,
    permission: permission ?? this.permission,
    isGranted: isGranted ?? this.isGranted,
  );
  AppPermissionRow copyWithCompanion(AppPermissionsCompanion data) {
    return AppPermissionRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      permission: data.permission.present
          ? data.permission.value
          : this.permission,
      isGranted: data.isGranted.present ? data.isGranted.value : this.isGranted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPermissionRow(')
          ..write('packageName: $packageName, ')
          ..write('permission: $permission, ')
          ..write('isGranted: $isGranted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, permission, isGranted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPermissionRow &&
          other.packageName == this.packageName &&
          other.permission == this.permission &&
          other.isGranted == this.isGranted);
}

class AppPermissionsCompanion extends UpdateCompanion<AppPermissionRow> {
  final Value<String> packageName;
  final Value<String> permission;
  final Value<bool> isGranted;
  final Value<int> rowid;
  const AppPermissionsCompanion({
    this.packageName = const Value.absent(),
    this.permission = const Value.absent(),
    this.isGranted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPermissionsCompanion.insert({
    required String packageName,
    required String permission,
    required bool isGranted,
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       permission = Value(permission),
       isGranted = Value(isGranted);
  static Insertable<AppPermissionRow> custom({
    Expression<String>? packageName,
    Expression<String>? permission,
    Expression<bool>? isGranted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (permission != null) 'permission': permission,
      if (isGranted != null) 'is_granted': isGranted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPermissionsCompanion copyWith({
    Value<String>? packageName,
    Value<String>? permission,
    Value<bool>? isGranted,
    Value<int>? rowid,
  }) {
    return AppPermissionsCompanion(
      packageName: packageName ?? this.packageName,
      permission: permission ?? this.permission,
      isGranted: isGranted ?? this.isGranted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (isGranted.present) {
      map['is_granted'] = Variable<bool>(isGranted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPermissionsCompanion(')
          ..write('packageName: $packageName, ')
          ..write('permission: $permission, ')
          ..write('isGranted: $isGranted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpecialAccessTable extends SpecialAccess
    with TableInfo<$SpecialAccessTable, SpecialAccessRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpecialAccessTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (package_name) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'special_access';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpecialAccessRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, kind};
  @override
  SpecialAccessRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpecialAccessRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $SpecialAccessTable createAlias(String alias) {
    return $SpecialAccessTable(attachedDatabase, alias);
  }
}

class SpecialAccessRow extends DataClass
    implements Insertable<SpecialAccessRow> {
  final String packageName;
  final String kind;
  const SpecialAccessRow({required this.packageName, required this.kind});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  SpecialAccessCompanion toCompanion(bool nullToAbsent) {
    return SpecialAccessCompanion(
      packageName: Value(packageName),
      kind: Value(kind),
    );
  }

  factory SpecialAccessRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpecialAccessRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'kind': serializer.toJson<String>(kind),
    };
  }

  SpecialAccessRow copyWith({String? packageName, String? kind}) =>
      SpecialAccessRow(
        packageName: packageName ?? this.packageName,
        kind: kind ?? this.kind,
      );
  SpecialAccessRow copyWithCompanion(SpecialAccessCompanion data) {
    return SpecialAccessRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpecialAccessRow(')
          ..write('packageName: $packageName, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpecialAccessRow &&
          other.packageName == this.packageName &&
          other.kind == this.kind);
}

class SpecialAccessCompanion extends UpdateCompanion<SpecialAccessRow> {
  final Value<String> packageName;
  final Value<String> kind;
  final Value<int> rowid;
  const SpecialAccessCompanion({
    this.packageName = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpecialAccessCompanion.insert({
    required String packageName,
    required String kind,
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       kind = Value(kind);
  static Insertable<SpecialAccessRow> custom({
    Expression<String>? packageName,
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpecialAccessCompanion copyWith({
    Value<String>? packageName,
    Value<String>? kind,
    Value<int>? rowid,
  }) {
    return SpecialAccessCompanion(
      packageName: packageName ?? this.packageName,
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpecialAccessCompanion(')
          ..write('packageName: $packageName, ')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageDailyTable extends UsageDaily
    with TableInfo<$UsageDailyTable, UsageDailyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (package_name) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foregroundMsMeta = const VerificationMeta(
    'foregroundMs',
  );
  @override
  late final GeneratedColumn<int> foregroundMs = GeneratedColumn<int>(
    'foreground_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, day, foregroundMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageDailyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('foreground_ms')) {
      context.handle(
        _foregroundMsMeta,
        foregroundMs.isAcceptableOrUnknown(
          data['foreground_ms']!,
          _foregroundMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foregroundMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, day};
  @override
  UsageDailyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageDailyRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      foregroundMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}foreground_ms'],
      )!,
    );
  }

  @override
  $UsageDailyTable createAlias(String alias) {
    return $UsageDailyTable(attachedDatabase, alias);
  }
}

class UsageDailyRow extends DataClass implements Insertable<UsageDailyRow> {
  final String packageName;

  /// Start of the user's local day.
  final DateTime day;
  final int foregroundMs;
  const UsageDailyRow({
    required this.packageName,
    required this.day,
    required this.foregroundMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['day'] = Variable<DateTime>(day);
    map['foreground_ms'] = Variable<int>(foregroundMs);
    return map;
  }

  UsageDailyCompanion toCompanion(bool nullToAbsent) {
    return UsageDailyCompanion(
      packageName: Value(packageName),
      day: Value(day),
      foregroundMs: Value(foregroundMs),
    );
  }

  factory UsageDailyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageDailyRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      day: serializer.fromJson<DateTime>(json['day']),
      foregroundMs: serializer.fromJson<int>(json['foregroundMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'day': serializer.toJson<DateTime>(day),
      'foregroundMs': serializer.toJson<int>(foregroundMs),
    };
  }

  UsageDailyRow copyWith({
    String? packageName,
    DateTime? day,
    int? foregroundMs,
  }) => UsageDailyRow(
    packageName: packageName ?? this.packageName,
    day: day ?? this.day,
    foregroundMs: foregroundMs ?? this.foregroundMs,
  );
  UsageDailyRow copyWithCompanion(UsageDailyCompanion data) {
    return UsageDailyRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      day: data.day.present ? data.day.value : this.day,
      foregroundMs: data.foregroundMs.present
          ? data.foregroundMs.value
          : this.foregroundMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageDailyRow(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('foregroundMs: $foregroundMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, day, foregroundMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageDailyRow &&
          other.packageName == this.packageName &&
          other.day == this.day &&
          other.foregroundMs == this.foregroundMs);
}

class UsageDailyCompanion extends UpdateCompanion<UsageDailyRow> {
  final Value<String> packageName;
  final Value<DateTime> day;
  final Value<int> foregroundMs;
  final Value<int> rowid;
  const UsageDailyCompanion({
    this.packageName = const Value.absent(),
    this.day = const Value.absent(),
    this.foregroundMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageDailyCompanion.insert({
    required String packageName,
    required DateTime day,
    required int foregroundMs,
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       day = Value(day),
       foregroundMs = Value(foregroundMs);
  static Insertable<UsageDailyRow> custom({
    Expression<String>? packageName,
    Expression<DateTime>? day,
    Expression<int>? foregroundMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (day != null) 'day': day,
      if (foregroundMs != null) 'foreground_ms': foregroundMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageDailyCompanion copyWith({
    Value<String>? packageName,
    Value<DateTime>? day,
    Value<int>? foregroundMs,
    Value<int>? rowid,
  }) {
    return UsageDailyCompanion(
      packageName: packageName ?? this.packageName,
      day: day ?? this.day,
      foregroundMs: foregroundMs ?? this.foregroundMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (foregroundMs.present) {
      map['foreground_ms'] = Variable<int>(foregroundMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageDailyCompanion(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('foregroundMs: $foregroundMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackerSdkMatchesTable extends TrackerSdkMatches
    with TableInfo<$TrackerSdkMatchesTable, TrackerSdkMatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackerSdkMatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (package_name) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, trackerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracker_sdk_matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackerSdkMatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, trackerId};
  @override
  TrackerSdkMatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackerSdkMatchRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
    );
  }

  @override
  $TrackerSdkMatchesTable createAlias(String alias) {
    return $TrackerSdkMatchesTable(attachedDatabase, alias);
  }
}

class TrackerSdkMatchRow extends DataClass
    implements Insertable<TrackerSdkMatchRow> {
  final String packageName;
  final String trackerId;
  const TrackerSdkMatchRow({
    required this.packageName,
    required this.trackerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['tracker_id'] = Variable<String>(trackerId);
    return map;
  }

  TrackerSdkMatchesCompanion toCompanion(bool nullToAbsent) {
    return TrackerSdkMatchesCompanion(
      packageName: Value(packageName),
      trackerId: Value(trackerId),
    );
  }

  factory TrackerSdkMatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackerSdkMatchRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'trackerId': serializer.toJson<String>(trackerId),
    };
  }

  TrackerSdkMatchRow copyWith({String? packageName, String? trackerId}) =>
      TrackerSdkMatchRow(
        packageName: packageName ?? this.packageName,
        trackerId: trackerId ?? this.trackerId,
      );
  TrackerSdkMatchRow copyWithCompanion(TrackerSdkMatchesCompanion data) {
    return TrackerSdkMatchRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackerSdkMatchRow(')
          ..write('packageName: $packageName, ')
          ..write('trackerId: $trackerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, trackerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerSdkMatchRow &&
          other.packageName == this.packageName &&
          other.trackerId == this.trackerId);
}

class TrackerSdkMatchesCompanion extends UpdateCompanion<TrackerSdkMatchRow> {
  final Value<String> packageName;
  final Value<String> trackerId;
  final Value<int> rowid;
  const TrackerSdkMatchesCompanion({
    this.packageName = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackerSdkMatchesCompanion.insert({
    required String packageName,
    required String trackerId,
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       trackerId = Value(trackerId);
  static Insertable<TrackerSdkMatchRow> custom({
    Expression<String>? packageName,
    Expression<String>? trackerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (trackerId != null) 'tracker_id': trackerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackerSdkMatchesCompanion copyWith({
    Value<String>? packageName,
    Value<String>? trackerId,
    Value<int>? rowid,
  }) {
    return TrackerSdkMatchesCompanion(
      packageName: packageName ?? this.packageName,
      trackerId: trackerId ?? this.trackerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackerSdkMatchesCompanion(')
          ..write('packageName: $packageName, ')
          ..write('trackerId: $trackerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DnsEventsTable extends DnsEvents
    with TableInfo<$DnsEventsTable, DnsEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DnsEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, occurredAt, domain, packageName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dns_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<DnsEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DnsEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DnsEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      ),
    );
  }

  @override
  $DnsEventsTable createAlias(String alias) {
    return $DnsEventsTable(attachedDatabase, alias);
  }
}

class DnsEventRow extends DataClass implements Insertable<DnsEventRow> {
  /// Id assigned by the native event store, used to import exactly once.
  final int id;
  final DateTime occurredAt;
  final String domain;

  /// Null when Android could not attribute the lookup to an app.
  final String? packageName;
  const DnsEventRow({
    required this.id,
    required this.occurredAt,
    required this.domain,
    this.packageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['domain'] = Variable<String>(domain);
    if (!nullToAbsent || packageName != null) {
      map['package_name'] = Variable<String>(packageName);
    }
    return map;
  }

  DnsEventsCompanion toCompanion(bool nullToAbsent) {
    return DnsEventsCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      domain: Value(domain),
      packageName: packageName == null && nullToAbsent
          ? const Value.absent()
          : Value(packageName),
    );
  }

  factory DnsEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DnsEventRow(
      id: serializer.fromJson<int>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      domain: serializer.fromJson<String>(json['domain']),
      packageName: serializer.fromJson<String?>(json['packageName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'domain': serializer.toJson<String>(domain),
      'packageName': serializer.toJson<String?>(packageName),
    };
  }

  DnsEventRow copyWith({
    int? id,
    DateTime? occurredAt,
    String? domain,
    Value<String?> packageName = const Value.absent(),
  }) => DnsEventRow(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    domain: domain ?? this.domain,
    packageName: packageName.present ? packageName.value : this.packageName,
  );
  DnsEventRow copyWithCompanion(DnsEventsCompanion data) {
    return DnsEventRow(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      domain: data.domain.present ? data.domain.value : this.domain,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DnsEventRow(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('domain: $domain, ')
          ..write('packageName: $packageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, occurredAt, domain, packageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DnsEventRow &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.domain == this.domain &&
          other.packageName == this.packageName);
}

class DnsEventsCompanion extends UpdateCompanion<DnsEventRow> {
  final Value<int> id;
  final Value<DateTime> occurredAt;
  final Value<String> domain;
  final Value<String?> packageName;
  const DnsEventsCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.domain = const Value.absent(),
    this.packageName = const Value.absent(),
  });
  DnsEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime occurredAt,
    required String domain,
    this.packageName = const Value.absent(),
  }) : occurredAt = Value(occurredAt),
       domain = Value(domain);
  static Insertable<DnsEventRow> custom({
    Expression<int>? id,
    Expression<DateTime>? occurredAt,
    Expression<String>? domain,
    Expression<String>? packageName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (domain != null) 'domain': domain,
      if (packageName != null) 'package_name': packageName,
    });
  }

  DnsEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? occurredAt,
    Value<String>? domain,
    Value<String?>? packageName,
  }) {
    return DnsEventsCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      domain: domain ?? this.domain,
      packageName: packageName ?? this.packageName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DnsEventsCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('domain: $domain, ')
          ..write('packageName: $packageName')
          ..write(')'))
        .toString();
  }
}

class $FindingsTable extends Findings
    with TableInfo<$FindingsTable, FindingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scanIdMeta = const VerificationMeta('scanId');
  @override
  late final GeneratedColumn<int> scanId = GeneratedColumn<int>(
    'scan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scanId,
    packageName,
    type,
    severity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'findings';
  @override
  VerificationContext validateIntegrity(
    Insertable<FindingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scan_id')) {
      context.handle(
        _scanIdMeta,
        scanId.isAcceptableOrUnknown(data['scan_id']!, _scanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scanIdMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scan_id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
    );
  }

  @override
  $FindingsTable createAlias(String alias) {
    return $FindingsTable(attachedDatabase, alias);
  }
}

class FindingRow extends DataClass implements Insertable<FindingRow> {
  final int id;
  final int scanId;
  final String packageName;
  final String type;
  final String severity;
  const FindingRow({
    required this.id,
    required this.scanId,
    required this.packageName,
    required this.type,
    required this.severity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scan_id'] = Variable<int>(scanId);
    map['package_name'] = Variable<String>(packageName);
    map['type'] = Variable<String>(type);
    map['severity'] = Variable<String>(severity);
    return map;
  }

  FindingsCompanion toCompanion(bool nullToAbsent) {
    return FindingsCompanion(
      id: Value(id),
      scanId: Value(scanId),
      packageName: Value(packageName),
      type: Value(type),
      severity: Value(severity),
    );
  }

  factory FindingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingRow(
      id: serializer.fromJson<int>(json['id']),
      scanId: serializer.fromJson<int>(json['scanId']),
      packageName: serializer.fromJson<String>(json['packageName']),
      type: serializer.fromJson<String>(json['type']),
      severity: serializer.fromJson<String>(json['severity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scanId': serializer.toJson<int>(scanId),
      'packageName': serializer.toJson<String>(packageName),
      'type': serializer.toJson<String>(type),
      'severity': serializer.toJson<String>(severity),
    };
  }

  FindingRow copyWith({
    int? id,
    int? scanId,
    String? packageName,
    String? type,
    String? severity,
  }) => FindingRow(
    id: id ?? this.id,
    scanId: scanId ?? this.scanId,
    packageName: packageName ?? this.packageName,
    type: type ?? this.type,
    severity: severity ?? this.severity,
  );
  FindingRow copyWithCompanion(FindingsCompanion data) {
    return FindingRow(
      id: data.id.present ? data.id.value : this.id,
      scanId: data.scanId.present ? data.scanId.value : this.scanId,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      type: data.type.present ? data.type.value : this.type,
      severity: data.severity.present ? data.severity.value : this.severity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingRow(')
          ..write('id: $id, ')
          ..write('scanId: $scanId, ')
          ..write('packageName: $packageName, ')
          ..write('type: $type, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scanId, packageName, type, severity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingRow &&
          other.id == this.id &&
          other.scanId == this.scanId &&
          other.packageName == this.packageName &&
          other.type == this.type &&
          other.severity == this.severity);
}

class FindingsCompanion extends UpdateCompanion<FindingRow> {
  final Value<int> id;
  final Value<int> scanId;
  final Value<String> packageName;
  final Value<String> type;
  final Value<String> severity;
  const FindingsCompanion({
    this.id = const Value.absent(),
    this.scanId = const Value.absent(),
    this.packageName = const Value.absent(),
    this.type = const Value.absent(),
    this.severity = const Value.absent(),
  });
  FindingsCompanion.insert({
    this.id = const Value.absent(),
    required int scanId,
    required String packageName,
    required String type,
    required String severity,
  }) : scanId = Value(scanId),
       packageName = Value(packageName),
       type = Value(type),
       severity = Value(severity);
  static Insertable<FindingRow> custom({
    Expression<int>? id,
    Expression<int>? scanId,
    Expression<String>? packageName,
    Expression<String>? type,
    Expression<String>? severity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scanId != null) 'scan_id': scanId,
      if (packageName != null) 'package_name': packageName,
      if (type != null) 'type': type,
      if (severity != null) 'severity': severity,
    });
  }

  FindingsCompanion copyWith({
    Value<int>? id,
    Value<int>? scanId,
    Value<String>? packageName,
    Value<String>? type,
    Value<String>? severity,
  }) {
    return FindingsCompanion(
      id: id ?? this.id,
      scanId: scanId ?? this.scanId,
      packageName: packageName ?? this.packageName,
      type: type ?? this.type,
      severity: severity ?? this.severity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scanId.present) {
      map['scan_id'] = Variable<int>(scanId.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingsCompanion(')
          ..write('id: $id, ')
          ..write('scanId: $scanId, ')
          ..write('packageName: $packageName, ')
          ..write('type: $type, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }
}

class $FindingEvidenceTable extends FindingEvidence
    with TableInfo<$FindingEvidenceTable, FindingEvidenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingEvidenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _findingIdMeta = const VerificationMeta(
    'findingId',
  );
  @override
  late final GeneratedColumn<int> findingId = GeneratedColumn<int>(
    'finding_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES findings (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, findingId, kind, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finding_evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<FindingEvidenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('finding_id')) {
      context.handle(
        _findingIdMeta,
        findingId.isAcceptableOrUnknown(data['finding_id']!, _findingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_findingIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingEvidenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingEvidenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      findingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}finding_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $FindingEvidenceTable createAlias(String alias) {
    return $FindingEvidenceTable(attachedDatabase, alias);
  }
}

class FindingEvidenceRow extends DataClass
    implements Insertable<FindingEvidenceRow> {
  final int id;
  final int findingId;
  final String kind;
  final String value;
  const FindingEvidenceRow({
    required this.id,
    required this.findingId,
    required this.kind,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['finding_id'] = Variable<int>(findingId);
    map['kind'] = Variable<String>(kind);
    map['value'] = Variable<String>(value);
    return map;
  }

  FindingEvidenceCompanion toCompanion(bool nullToAbsent) {
    return FindingEvidenceCompanion(
      id: Value(id),
      findingId: Value(findingId),
      kind: Value(kind),
      value: Value(value),
    );
  }

  factory FindingEvidenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingEvidenceRow(
      id: serializer.fromJson<int>(json['id']),
      findingId: serializer.fromJson<int>(json['findingId']),
      kind: serializer.fromJson<String>(json['kind']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'findingId': serializer.toJson<int>(findingId),
      'kind': serializer.toJson<String>(kind),
      'value': serializer.toJson<String>(value),
    };
  }

  FindingEvidenceRow copyWith({
    int? id,
    int? findingId,
    String? kind,
    String? value,
  }) => FindingEvidenceRow(
    id: id ?? this.id,
    findingId: findingId ?? this.findingId,
    kind: kind ?? this.kind,
    value: value ?? this.value,
  );
  FindingEvidenceRow copyWithCompanion(FindingEvidenceCompanion data) {
    return FindingEvidenceRow(
      id: data.id.present ? data.id.value : this.id,
      findingId: data.findingId.present ? data.findingId.value : this.findingId,
      kind: data.kind.present ? data.kind.value : this.kind,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingEvidenceRow(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('kind: $kind, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, findingId, kind, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingEvidenceRow &&
          other.id == this.id &&
          other.findingId == this.findingId &&
          other.kind == this.kind &&
          other.value == this.value);
}

class FindingEvidenceCompanion extends UpdateCompanion<FindingEvidenceRow> {
  final Value<int> id;
  final Value<int> findingId;
  final Value<String> kind;
  final Value<String> value;
  const FindingEvidenceCompanion({
    this.id = const Value.absent(),
    this.findingId = const Value.absent(),
    this.kind = const Value.absent(),
    this.value = const Value.absent(),
  });
  FindingEvidenceCompanion.insert({
    this.id = const Value.absent(),
    required int findingId,
    required String kind,
    required String value,
  }) : findingId = Value(findingId),
       kind = Value(kind),
       value = Value(value);
  static Insertable<FindingEvidenceRow> custom({
    Expression<int>? id,
    Expression<int>? findingId,
    Expression<String>? kind,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (findingId != null) 'finding_id': findingId,
      if (kind != null) 'kind': kind,
      if (value != null) 'value': value,
    });
  }

  FindingEvidenceCompanion copyWith({
    Value<int>? id,
    Value<int>? findingId,
    Value<String>? kind,
    Value<String>? value,
  }) {
    return FindingEvidenceCompanion(
      id: id ?? this.id,
      findingId: findingId ?? this.findingId,
      kind: kind ?? this.kind,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (findingId.present) {
      map['finding_id'] = Variable<int>(findingId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingEvidenceCompanion(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('kind: $kind, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScansTable scans = $ScansTable(this);
  late final $AppsTable apps = $AppsTable(this);
  late final $AppPermissionsTable appPermissions = $AppPermissionsTable(this);
  late final $SpecialAccessTable specialAccess = $SpecialAccessTable(this);
  late final $UsageDailyTable usageDaily = $UsageDailyTable(this);
  late final $TrackerSdkMatchesTable trackerSdkMatches =
      $TrackerSdkMatchesTable(this);
  late final $DnsEventsTable dnsEvents = $DnsEventsTable(this);
  late final $FindingsTable findings = $FindingsTable(this);
  late final $FindingEvidenceTable findingEvidence = $FindingEvidenceTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scans,
    apps,
    appPermissions,
    specialAccess,
    usageDaily,
    trackerSdkMatches,
    dnsEvents,
    findings,
    findingEvidence,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'apps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('app_permissions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'apps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('special_access', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'apps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('usage_daily', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'apps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tracker_sdk_matches', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'scans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('findings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'findings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finding_evidence', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ScansTableCreateCompanionBuilder =
    ScansCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int> appCount,
      Value<int> findingCount,
      required bool hadUsageAccess,
    });
typedef $$ScansTableUpdateCompanionBuilder =
    ScansCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> appCount,
      Value<int> findingCount,
      Value<bool> hadUsageAccess,
    });

final class $$ScansTableReferences
    extends BaseReferences<_$AppDatabase, $ScansTable, Scan> {
  $$ScansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FindingsTable, List<FindingRow>>
  _findingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.findings,
    aliasName: $_aliasNameGenerator(db.scans.id, db.findings.scanId),
  );

  $$FindingsTableProcessedTableManager get findingsRefs {
    final manager = $$FindingsTableTableManager(
      $_db,
      $_db.findings,
    ).filter((f) => f.scanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_findingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScansTableFilterComposer extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appCount => $composableBuilder(
    column: $table.appCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get findingCount => $composableBuilder(
    column: $table.findingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadUsageAccess => $composableBuilder(
    column: $table.hadUsageAccess,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> findingsRefs(
    Expression<bool> Function($$FindingsTableFilterComposer f) f,
  ) {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.findings,
      getReferencedColumn: (t) => t.scanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingsTableFilterComposer(
            $db: $db,
            $table: $db.findings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScansTableOrderingComposer
    extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appCount => $composableBuilder(
    column: $table.appCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get findingCount => $composableBuilder(
    column: $table.findingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadUsageAccess => $composableBuilder(
    column: $table.hadUsageAccess,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScansTable> {
  $$ScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get appCount =>
      $composableBuilder(column: $table.appCount, builder: (column) => column);

  GeneratedColumn<int> get findingCount => $composableBuilder(
    column: $table.findingCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hadUsageAccess => $composableBuilder(
    column: $table.hadUsageAccess,
    builder: (column) => column,
  );

  Expression<T> findingsRefs<T extends Object>(
    Expression<T> Function($$FindingsTableAnnotationComposer a) f,
  ) {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.findings,
      getReferencedColumn: (t) => t.scanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingsTableAnnotationComposer(
            $db: $db,
            $table: $db.findings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScansTable,
          Scan,
          $$ScansTableFilterComposer,
          $$ScansTableOrderingComposer,
          $$ScansTableAnnotationComposer,
          $$ScansTableCreateCompanionBuilder,
          $$ScansTableUpdateCompanionBuilder,
          (Scan, $$ScansTableReferences),
          Scan,
          PrefetchHooks Function({bool findingsRefs})
        > {
  $$ScansTableTableManager(_$AppDatabase db, $ScansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> appCount = const Value.absent(),
                Value<int> findingCount = const Value.absent(),
                Value<bool> hadUsageAccess = const Value.absent(),
              }) => ScansCompanion(
                id: id,
                startedAt: startedAt,
                completedAt: completedAt,
                appCount: appCount,
                findingCount: findingCount,
                hadUsageAccess: hadUsageAccess,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> appCount = const Value.absent(),
                Value<int> findingCount = const Value.absent(),
                required bool hadUsageAccess,
              }) => ScansCompanion.insert(
                id: id,
                startedAt: startedAt,
                completedAt: completedAt,
                appCount: appCount,
                findingCount: findingCount,
                hadUsageAccess: hadUsageAccess,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ScansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({findingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (findingsRefs) db.findings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (findingsRefs)
                    await $_getPrefetchedData<Scan, $ScansTable, FindingRow>(
                      currentTable: table,
                      referencedTable: $$ScansTableReferences
                          ._findingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ScansTableReferences(db, table, p0).findingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.scanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ScansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScansTable,
      Scan,
      $$ScansTableFilterComposer,
      $$ScansTableOrderingComposer,
      $$ScansTableAnnotationComposer,
      $$ScansTableCreateCompanionBuilder,
      $$ScansTableUpdateCompanionBuilder,
      (Scan, $$ScansTableReferences),
      Scan,
      PrefetchHooks Function({bool findingsRefs})
    >;
typedef $$AppsTableCreateCompanionBuilder =
    AppsCompanion Function({
      required String packageName,
      required String label,
      Value<String?> versionName,
      required int versionCode,
      required bool isSystemApp,
      Value<String?> installerPackage,
      required DateTime installedAt,
      required DateTime updatedAt,
      Value<String?> iconPath,
      required bool requestsInternet,
      Value<DateTime?> lastUsedAt,
      Value<String?> trackerScanKey,
      Value<int> rowid,
    });
typedef $$AppsTableUpdateCompanionBuilder =
    AppsCompanion Function({
      Value<String> packageName,
      Value<String> label,
      Value<String?> versionName,
      Value<int> versionCode,
      Value<bool> isSystemApp,
      Value<String?> installerPackage,
      Value<DateTime> installedAt,
      Value<DateTime> updatedAt,
      Value<String?> iconPath,
      Value<bool> requestsInternet,
      Value<DateTime?> lastUsedAt,
      Value<String?> trackerScanKey,
      Value<int> rowid,
    });

final class $$AppsTableReferences
    extends BaseReferences<_$AppDatabase, $AppsTable, AppRow> {
  $$AppsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppPermissionsTable, List<AppPermissionRow>>
  _appPermissionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appPermissions,
    aliasName: $_aliasNameGenerator(
      db.apps.packageName,
      db.appPermissions.packageName,
    ),
  );

  $$AppPermissionsTableProcessedTableManager get appPermissionsRefs {
    final manager = $$AppPermissionsTableTableManager($_db, $_db.appPermissions)
        .filter(
          (f) => f.packageName.packageName.sqlEquals(
            $_itemColumn<String>('package_name')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_appPermissionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpecialAccessTable, List<SpecialAccessRow>>
  _specialAccessRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.specialAccess,
    aliasName: $_aliasNameGenerator(
      db.apps.packageName,
      db.specialAccess.packageName,
    ),
  );

  $$SpecialAccessTableProcessedTableManager get specialAccessRefs {
    final manager = $$SpecialAccessTableTableManager($_db, $_db.specialAccess)
        .filter(
          (f) => f.packageName.packageName.sqlEquals(
            $_itemColumn<String>('package_name')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_specialAccessRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsageDailyTable, List<UsageDailyRow>>
  _usageDailyRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usageDaily,
    aliasName: $_aliasNameGenerator(
      db.apps.packageName,
      db.usageDaily.packageName,
    ),
  );

  $$UsageDailyTableProcessedTableManager get usageDailyRefs {
    final manager = $$UsageDailyTableTableManager($_db, $_db.usageDaily).filter(
      (f) => f.packageName.packageName.sqlEquals(
        $_itemColumn<String>('package_name')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_usageDailyRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrackerSdkMatchesTable, List<TrackerSdkMatchRow>>
  _trackerSdkMatchesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trackerSdkMatches,
        aliasName: $_aliasNameGenerator(
          db.apps.packageName,
          db.trackerSdkMatches.packageName,
        ),
      );

  $$TrackerSdkMatchesTableProcessedTableManager get trackerSdkMatchesRefs {
    final manager =
        $$TrackerSdkMatchesTableTableManager(
          $_db,
          $_db.trackerSdkMatches,
        ).filter(
          (f) => f.packageName.packageName.sqlEquals(
            $_itemColumn<String>('package_name')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _trackerSdkMatchesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AppsTableFilterComposer extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versionName => $composableBuilder(
    column: $table.versionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionCode => $composableBuilder(
    column: $table.versionCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installerPackage => $composableBuilder(
    column: $table.installerPackage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requestsInternet => $composableBuilder(
    column: $table.requestsInternet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerScanKey => $composableBuilder(
    column: $table.trackerScanKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appPermissionsRefs(
    Expression<bool> Function($$AppPermissionsTableFilterComposer f) f,
  ) {
    final $$AppPermissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.appPermissions,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppPermissionsTableFilterComposer(
            $db: $db,
            $table: $db.appPermissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> specialAccessRefs(
    Expression<bool> Function($$SpecialAccessTableFilterComposer f) f,
  ) {
    final $$SpecialAccessTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.specialAccess,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecialAccessTableFilterComposer(
            $db: $db,
            $table: $db.specialAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> usageDailyRefs(
    Expression<bool> Function($$UsageDailyTableFilterComposer f) f,
  ) {
    final $$UsageDailyTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.usageDaily,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageDailyTableFilterComposer(
            $db: $db,
            $table: $db.usageDaily,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackerSdkMatchesRefs(
    Expression<bool> Function($$TrackerSdkMatchesTableFilterComposer f) f,
  ) {
    final $$TrackerSdkMatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.trackerSdkMatches,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackerSdkMatchesTableFilterComposer(
            $db: $db,
            $table: $db.trackerSdkMatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AppsTableOrderingComposer extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versionName => $composableBuilder(
    column: $table.versionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionCode => $composableBuilder(
    column: $table.versionCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installerPackage => $composableBuilder(
    column: $table.installerPackage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requestsInternet => $composableBuilder(
    column: $table.requestsInternet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerScanKey => $composableBuilder(
    column: $table.trackerScanKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get versionName => $composableBuilder(
    column: $table.versionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get versionCode => $composableBuilder(
    column: $table.versionCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get installerPackage => $composableBuilder(
    column: $table.installerPackage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<bool> get requestsInternet => $composableBuilder(
    column: $table.requestsInternet,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackerScanKey => $composableBuilder(
    column: $table.trackerScanKey,
    builder: (column) => column,
  );

  Expression<T> appPermissionsRefs<T extends Object>(
    Expression<T> Function($$AppPermissionsTableAnnotationComposer a) f,
  ) {
    final $$AppPermissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.appPermissions,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppPermissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.appPermissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> specialAccessRefs<T extends Object>(
    Expression<T> Function($$SpecialAccessTableAnnotationComposer a) f,
  ) {
    final $$SpecialAccessTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.specialAccess,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecialAccessTableAnnotationComposer(
            $db: $db,
            $table: $db.specialAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> usageDailyRefs<T extends Object>(
    Expression<T> Function($$UsageDailyTableAnnotationComposer a) f,
  ) {
    final $$UsageDailyTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.usageDaily,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageDailyTableAnnotationComposer(
            $db: $db,
            $table: $db.usageDaily,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackerSdkMatchesRefs<T extends Object>(
    Expression<T> Function($$TrackerSdkMatchesTableAnnotationComposer a) f,
  ) {
    final $$TrackerSdkMatchesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.packageName,
          referencedTable: $db.trackerSdkMatches,
          getReferencedColumn: (t) => t.packageName,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackerSdkMatchesTableAnnotationComposer(
                $db: $db,
                $table: $db.trackerSdkMatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AppsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppsTable,
          AppRow,
          $$AppsTableFilterComposer,
          $$AppsTableOrderingComposer,
          $$AppsTableAnnotationComposer,
          $$AppsTableCreateCompanionBuilder,
          $$AppsTableUpdateCompanionBuilder,
          (AppRow, $$AppsTableReferences),
          AppRow,
          PrefetchHooks Function({
            bool appPermissionsRefs,
            bool specialAccessRefs,
            bool usageDailyRefs,
            bool trackerSdkMatchesRefs,
          })
        > {
  $$AppsTableTableManager(_$AppDatabase db, $AppsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> versionName = const Value.absent(),
                Value<int> versionCode = const Value.absent(),
                Value<bool> isSystemApp = const Value.absent(),
                Value<String?> installerPackage = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<bool> requestsInternet = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<String?> trackerScanKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppsCompanion(
                packageName: packageName,
                label: label,
                versionName: versionName,
                versionCode: versionCode,
                isSystemApp: isSystemApp,
                installerPackage: installerPackage,
                installedAt: installedAt,
                updatedAt: updatedAt,
                iconPath: iconPath,
                requestsInternet: requestsInternet,
                lastUsedAt: lastUsedAt,
                trackerScanKey: trackerScanKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String label,
                Value<String?> versionName = const Value.absent(),
                required int versionCode,
                required bool isSystemApp,
                Value<String?> installerPackage = const Value.absent(),
                required DateTime installedAt,
                required DateTime updatedAt,
                Value<String?> iconPath = const Value.absent(),
                required bool requestsInternet,
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<String?> trackerScanKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppsCompanion.insert(
                packageName: packageName,
                label: label,
                versionName: versionName,
                versionCode: versionCode,
                isSystemApp: isSystemApp,
                installerPackage: installerPackage,
                installedAt: installedAt,
                updatedAt: updatedAt,
                iconPath: iconPath,
                requestsInternet: requestsInternet,
                lastUsedAt: lastUsedAt,
                trackerScanKey: trackerScanKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AppsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                appPermissionsRefs = false,
                specialAccessRefs = false,
                usageDailyRefs = false,
                trackerSdkMatchesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appPermissionsRefs) db.appPermissions,
                    if (specialAccessRefs) db.specialAccess,
                    if (usageDailyRefs) db.usageDaily,
                    if (trackerSdkMatchesRefs) db.trackerSdkMatches,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appPermissionsRefs)
                        await $_getPrefetchedData<
                          AppRow,
                          $AppsTable,
                          AppPermissionRow
                        >(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._appPermissionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$AppsTableReferences(
                            db,
                            table,
                            p0,
                          ).appPermissionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.packageName,
                              ),
                          typedResults: items,
                        ),
                      if (specialAccessRefs)
                        await $_getPrefetchedData<
                          AppRow,
                          $AppsTable,
                          SpecialAccessRow
                        >(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._specialAccessRefsTable(db),
                          managerFromTypedResult: (p0) => $$AppsTableReferences(
                            db,
                            table,
                            p0,
                          ).specialAccessRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.packageName,
                              ),
                          typedResults: items,
                        ),
                      if (usageDailyRefs)
                        await $_getPrefetchedData<
                          AppRow,
                          $AppsTable,
                          UsageDailyRow
                        >(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._usageDailyRefsTable(db),
                          managerFromTypedResult: (p0) => $$AppsTableReferences(
                            db,
                            table,
                            p0,
                          ).usageDailyRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.packageName,
                              ),
                          typedResults: items,
                        ),
                      if (trackerSdkMatchesRefs)
                        await $_getPrefetchedData<
                          AppRow,
                          $AppsTable,
                          TrackerSdkMatchRow
                        >(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._trackerSdkMatchesRefsTable(db),
                          managerFromTypedResult: (p0) => $$AppsTableReferences(
                            db,
                            table,
                            p0,
                          ).trackerSdkMatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.packageName,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AppsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppsTable,
      AppRow,
      $$AppsTableFilterComposer,
      $$AppsTableOrderingComposer,
      $$AppsTableAnnotationComposer,
      $$AppsTableCreateCompanionBuilder,
      $$AppsTableUpdateCompanionBuilder,
      (AppRow, $$AppsTableReferences),
      AppRow,
      PrefetchHooks Function({
        bool appPermissionsRefs,
        bool specialAccessRefs,
        bool usageDailyRefs,
        bool trackerSdkMatchesRefs,
      })
    >;
typedef $$AppPermissionsTableCreateCompanionBuilder =
    AppPermissionsCompanion Function({
      required String packageName,
      required String permission,
      required bool isGranted,
      Value<int> rowid,
    });
typedef $$AppPermissionsTableUpdateCompanionBuilder =
    AppPermissionsCompanion Function({
      Value<String> packageName,
      Value<String> permission,
      Value<bool> isGranted,
      Value<int> rowid,
    });

final class $$AppPermissionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $AppPermissionsTable, AppPermissionRow> {
  $$AppPermissionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppsTable _packageNameTable(_$AppDatabase db) => db.apps.createAlias(
    $_aliasNameGenerator(db.appPermissions.packageName, db.apps.packageName),
  );

  $$AppsTableProcessedTableManager get packageName {
    final $_column = $_itemColumn<String>('package_name')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.packageName.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageNameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppPermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $AppPermissionsTable> {
  $$AppPermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get permission => $composableBuilder(
    column: $table.permission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGranted => $composableBuilder(
    column: $table.isGranted,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get packageName {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPermissionsTable> {
  $$AppPermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get permission => $composableBuilder(
    column: $table.permission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGranted => $composableBuilder(
    column: $table.isGranted,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get packageName {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPermissionsTable> {
  $$AppPermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get permission => $composableBuilder(
    column: $table.permission,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGranted =>
      $composableBuilder(column: $table.isGranted, builder: (column) => column);

  $$AppsTableAnnotationComposer get packageName {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPermissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPermissionsTable,
          AppPermissionRow,
          $$AppPermissionsTableFilterComposer,
          $$AppPermissionsTableOrderingComposer,
          $$AppPermissionsTableAnnotationComposer,
          $$AppPermissionsTableCreateCompanionBuilder,
          $$AppPermissionsTableUpdateCompanionBuilder,
          (AppPermissionRow, $$AppPermissionsTableReferences),
          AppPermissionRow,
          PrefetchHooks Function({bool packageName})
        > {
  $$AppPermissionsTableTableManager(
    _$AppDatabase db,
    $AppPermissionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> permission = const Value.absent(),
                Value<bool> isGranted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppPermissionsCompanion(
                packageName: packageName,
                permission: permission,
                isGranted: isGranted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String permission,
                required bool isGranted,
                Value<int> rowid = const Value.absent(),
              }) => AppPermissionsCompanion.insert(
                packageName: packageName,
                permission: permission,
                isGranted: isGranted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AppPermissionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageName) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageName,
                                referencedTable: $$AppPermissionsTableReferences
                                    ._packageNameTable(db),
                                referencedColumn:
                                    $$AppPermissionsTableReferences
                                        ._packageNameTable(db)
                                        .packageName,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppPermissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPermissionsTable,
      AppPermissionRow,
      $$AppPermissionsTableFilterComposer,
      $$AppPermissionsTableOrderingComposer,
      $$AppPermissionsTableAnnotationComposer,
      $$AppPermissionsTableCreateCompanionBuilder,
      $$AppPermissionsTableUpdateCompanionBuilder,
      (AppPermissionRow, $$AppPermissionsTableReferences),
      AppPermissionRow,
      PrefetchHooks Function({bool packageName})
    >;
typedef $$SpecialAccessTableCreateCompanionBuilder =
    SpecialAccessCompanion Function({
      required String packageName,
      required String kind,
      Value<int> rowid,
    });
typedef $$SpecialAccessTableUpdateCompanionBuilder =
    SpecialAccessCompanion Function({
      Value<String> packageName,
      Value<String> kind,
      Value<int> rowid,
    });

final class $$SpecialAccessTableReferences
    extends
        BaseReferences<_$AppDatabase, $SpecialAccessTable, SpecialAccessRow> {
  $$SpecialAccessTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppsTable _packageNameTable(_$AppDatabase db) => db.apps.createAlias(
    $_aliasNameGenerator(db.specialAccess.packageName, db.apps.packageName),
  );

  $$AppsTableProcessedTableManager get packageName {
    final $_column = $_itemColumn<String>('package_name')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.packageName.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageNameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpecialAccessTableFilterComposer
    extends Composer<_$AppDatabase, $SpecialAccessTable> {
  $$SpecialAccessTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get packageName {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialAccessTableOrderingComposer
    extends Composer<_$AppDatabase, $SpecialAccessTable> {
  $$SpecialAccessTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get packageName {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialAccessTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpecialAccessTable> {
  $$SpecialAccessTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$AppsTableAnnotationComposer get packageName {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialAccessTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpecialAccessTable,
          SpecialAccessRow,
          $$SpecialAccessTableFilterComposer,
          $$SpecialAccessTableOrderingComposer,
          $$SpecialAccessTableAnnotationComposer,
          $$SpecialAccessTableCreateCompanionBuilder,
          $$SpecialAccessTableUpdateCompanionBuilder,
          (SpecialAccessRow, $$SpecialAccessTableReferences),
          SpecialAccessRow,
          PrefetchHooks Function({bool packageName})
        > {
  $$SpecialAccessTableTableManager(_$AppDatabase db, $SpecialAccessTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpecialAccessTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpecialAccessTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpecialAccessTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpecialAccessCompanion(
                packageName: packageName,
                kind: kind,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String kind,
                Value<int> rowid = const Value.absent(),
              }) => SpecialAccessCompanion.insert(
                packageName: packageName,
                kind: kind,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpecialAccessTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageName) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageName,
                                referencedTable: $$SpecialAccessTableReferences
                                    ._packageNameTable(db),
                                referencedColumn: $$SpecialAccessTableReferences
                                    ._packageNameTable(db)
                                    .packageName,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpecialAccessTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpecialAccessTable,
      SpecialAccessRow,
      $$SpecialAccessTableFilterComposer,
      $$SpecialAccessTableOrderingComposer,
      $$SpecialAccessTableAnnotationComposer,
      $$SpecialAccessTableCreateCompanionBuilder,
      $$SpecialAccessTableUpdateCompanionBuilder,
      (SpecialAccessRow, $$SpecialAccessTableReferences),
      SpecialAccessRow,
      PrefetchHooks Function({bool packageName})
    >;
typedef $$UsageDailyTableCreateCompanionBuilder =
    UsageDailyCompanion Function({
      required String packageName,
      required DateTime day,
      required int foregroundMs,
      Value<int> rowid,
    });
typedef $$UsageDailyTableUpdateCompanionBuilder =
    UsageDailyCompanion Function({
      Value<String> packageName,
      Value<DateTime> day,
      Value<int> foregroundMs,
      Value<int> rowid,
    });

final class $$UsageDailyTableReferences
    extends BaseReferences<_$AppDatabase, $UsageDailyTable, UsageDailyRow> {
  $$UsageDailyTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppsTable _packageNameTable(_$AppDatabase db) => db.apps.createAlias(
    $_aliasNameGenerator(db.usageDaily.packageName, db.apps.packageName),
  );

  $$AppsTableProcessedTableManager get packageName {
    final $_column = $_itemColumn<String>('package_name')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.packageName.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageNameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UsageDailyTableFilterComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foregroundMs => $composableBuilder(
    column: $table.foregroundMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get packageName {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foregroundMs => $composableBuilder(
    column: $table.foregroundMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get packageName {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get foregroundMs => $composableBuilder(
    column: $table.foregroundMs,
    builder: (column) => column,
  );

  $$AppsTableAnnotationComposer get packageName {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageDailyTable,
          UsageDailyRow,
          $$UsageDailyTableFilterComposer,
          $$UsageDailyTableOrderingComposer,
          $$UsageDailyTableAnnotationComposer,
          $$UsageDailyTableCreateCompanionBuilder,
          $$UsageDailyTableUpdateCompanionBuilder,
          (UsageDailyRow, $$UsageDailyTableReferences),
          UsageDailyRow,
          PrefetchHooks Function({bool packageName})
        > {
  $$UsageDailyTableTableManager(_$AppDatabase db, $UsageDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> foregroundMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageDailyCompanion(
                packageName: packageName,
                day: day,
                foregroundMs: foregroundMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required DateTime day,
                required int foregroundMs,
                Value<int> rowid = const Value.absent(),
              }) => UsageDailyCompanion.insert(
                packageName: packageName,
                day: day,
                foregroundMs: foregroundMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsageDailyTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageName) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageName,
                                referencedTable: $$UsageDailyTableReferences
                                    ._packageNameTable(db),
                                referencedColumn: $$UsageDailyTableReferences
                                    ._packageNameTable(db)
                                    .packageName,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UsageDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageDailyTable,
      UsageDailyRow,
      $$UsageDailyTableFilterComposer,
      $$UsageDailyTableOrderingComposer,
      $$UsageDailyTableAnnotationComposer,
      $$UsageDailyTableCreateCompanionBuilder,
      $$UsageDailyTableUpdateCompanionBuilder,
      (UsageDailyRow, $$UsageDailyTableReferences),
      UsageDailyRow,
      PrefetchHooks Function({bool packageName})
    >;
typedef $$TrackerSdkMatchesTableCreateCompanionBuilder =
    TrackerSdkMatchesCompanion Function({
      required String packageName,
      required String trackerId,
      Value<int> rowid,
    });
typedef $$TrackerSdkMatchesTableUpdateCompanionBuilder =
    TrackerSdkMatchesCompanion Function({
      Value<String> packageName,
      Value<String> trackerId,
      Value<int> rowid,
    });

final class $$TrackerSdkMatchesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackerSdkMatchesTable,
          TrackerSdkMatchRow
        > {
  $$TrackerSdkMatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppsTable _packageNameTable(_$AppDatabase db) => db.apps.createAlias(
    $_aliasNameGenerator(db.trackerSdkMatches.packageName, db.apps.packageName),
  );

  $$AppsTableProcessedTableManager get packageName {
    final $_column = $_itemColumn<String>('package_name')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.packageName.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageNameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackerSdkMatchesTableFilterComposer
    extends Composer<_$AppDatabase, $TrackerSdkMatchesTable> {
  $$TrackerSdkMatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get packageName {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerSdkMatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackerSdkMatchesTable> {
  $$TrackerSdkMatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get packageName {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerSdkMatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackerSdkMatchesTable> {
  $$TrackerSdkMatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  $$AppsTableAnnotationComposer get packageName {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerSdkMatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackerSdkMatchesTable,
          TrackerSdkMatchRow,
          $$TrackerSdkMatchesTableFilterComposer,
          $$TrackerSdkMatchesTableOrderingComposer,
          $$TrackerSdkMatchesTableAnnotationComposer,
          $$TrackerSdkMatchesTableCreateCompanionBuilder,
          $$TrackerSdkMatchesTableUpdateCompanionBuilder,
          (TrackerSdkMatchRow, $$TrackerSdkMatchesTableReferences),
          TrackerSdkMatchRow,
          PrefetchHooks Function({bool packageName})
        > {
  $$TrackerSdkMatchesTableTableManager(
    _$AppDatabase db,
    $TrackerSdkMatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackerSdkMatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackerSdkMatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackerSdkMatchesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerSdkMatchesCompanion(
                packageName: packageName,
                trackerId: trackerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String trackerId,
                Value<int> rowid = const Value.absent(),
              }) => TrackerSdkMatchesCompanion.insert(
                packageName: packageName,
                trackerId: trackerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackerSdkMatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageName) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageName,
                                referencedTable:
                                    $$TrackerSdkMatchesTableReferences
                                        ._packageNameTable(db),
                                referencedColumn:
                                    $$TrackerSdkMatchesTableReferences
                                        ._packageNameTable(db)
                                        .packageName,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackerSdkMatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackerSdkMatchesTable,
      TrackerSdkMatchRow,
      $$TrackerSdkMatchesTableFilterComposer,
      $$TrackerSdkMatchesTableOrderingComposer,
      $$TrackerSdkMatchesTableAnnotationComposer,
      $$TrackerSdkMatchesTableCreateCompanionBuilder,
      $$TrackerSdkMatchesTableUpdateCompanionBuilder,
      (TrackerSdkMatchRow, $$TrackerSdkMatchesTableReferences),
      TrackerSdkMatchRow,
      PrefetchHooks Function({bool packageName})
    >;
typedef $$DnsEventsTableCreateCompanionBuilder =
    DnsEventsCompanion Function({
      Value<int> id,
      required DateTime occurredAt,
      required String domain,
      Value<String?> packageName,
    });
typedef $$DnsEventsTableUpdateCompanionBuilder =
    DnsEventsCompanion Function({
      Value<int> id,
      Value<DateTime> occurredAt,
      Value<String> domain,
      Value<String?> packageName,
    });

class $$DnsEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DnsEventsTable> {
  $$DnsEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DnsEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DnsEventsTable> {
  $$DnsEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DnsEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DnsEventsTable> {
  $$DnsEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );
}

class $$DnsEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DnsEventsTable,
          DnsEventRow,
          $$DnsEventsTableFilterComposer,
          $$DnsEventsTableOrderingComposer,
          $$DnsEventsTableAnnotationComposer,
          $$DnsEventsTableCreateCompanionBuilder,
          $$DnsEventsTableUpdateCompanionBuilder,
          (
            DnsEventRow,
            BaseReferences<_$AppDatabase, $DnsEventsTable, DnsEventRow>,
          ),
          DnsEventRow,
          PrefetchHooks Function()
        > {
  $$DnsEventsTableTableManager(_$AppDatabase db, $DnsEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DnsEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DnsEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DnsEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<String?> packageName = const Value.absent(),
              }) => DnsEventsCompanion(
                id: id,
                occurredAt: occurredAt,
                domain: domain,
                packageName: packageName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime occurredAt,
                required String domain,
                Value<String?> packageName = const Value.absent(),
              }) => DnsEventsCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                domain: domain,
                packageName: packageName,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DnsEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DnsEventsTable,
      DnsEventRow,
      $$DnsEventsTableFilterComposer,
      $$DnsEventsTableOrderingComposer,
      $$DnsEventsTableAnnotationComposer,
      $$DnsEventsTableCreateCompanionBuilder,
      $$DnsEventsTableUpdateCompanionBuilder,
      (
        DnsEventRow,
        BaseReferences<_$AppDatabase, $DnsEventsTable, DnsEventRow>,
      ),
      DnsEventRow,
      PrefetchHooks Function()
    >;
typedef $$FindingsTableCreateCompanionBuilder =
    FindingsCompanion Function({
      Value<int> id,
      required int scanId,
      required String packageName,
      required String type,
      required String severity,
    });
typedef $$FindingsTableUpdateCompanionBuilder =
    FindingsCompanion Function({
      Value<int> id,
      Value<int> scanId,
      Value<String> packageName,
      Value<String> type,
      Value<String> severity,
    });

final class $$FindingsTableReferences
    extends BaseReferences<_$AppDatabase, $FindingsTable, FindingRow> {
  $$FindingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScansTable _scanIdTable(_$AppDatabase db) => db.scans.createAlias(
    $_aliasNameGenerator(db.findings.scanId, db.scans.id),
  );

  $$ScansTableProcessedTableManager get scanId {
    final $_column = $_itemColumn<int>('scan_id')!;

    final manager = $$ScansTableTableManager(
      $_db,
      $_db.scans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FindingEvidenceTable, List<FindingEvidenceRow>>
  _findingEvidenceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.findingEvidence,
    aliasName: $_aliasNameGenerator(
      db.findings.id,
      db.findingEvidence.findingId,
    ),
  );

  $$FindingEvidenceTableProcessedTableManager get findingEvidenceRefs {
    final manager = $$FindingEvidenceTableTableManager(
      $_db,
      $_db.findingEvidence,
    ).filter((f) => f.findingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _findingEvidenceRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FindingsTableFilterComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  $$ScansTableFilterComposer get scanId {
    final $$ScansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scanId,
      referencedTable: $db.scans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScansTableFilterComposer(
            $db: $db,
            $table: $db.scans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> findingEvidenceRefs(
    Expression<bool> Function($$FindingEvidenceTableFilterComposer f) f,
  ) {
    final $$FindingEvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.findingEvidence,
      getReferencedColumn: (t) => t.findingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingEvidenceTableFilterComposer(
            $db: $db,
            $table: $db.findingEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScansTableOrderingComposer get scanId {
    final $$ScansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scanId,
      referencedTable: $db.scans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScansTableOrderingComposer(
            $db: $db,
            $table: $db.scans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FindingsTable> {
  $$FindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  $$ScansTableAnnotationComposer get scanId {
    final $$ScansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scanId,
      referencedTable: $db.scans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScansTableAnnotationComposer(
            $db: $db,
            $table: $db.scans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> findingEvidenceRefs<T extends Object>(
    Expression<T> Function($$FindingEvidenceTableAnnotationComposer a) f,
  ) {
    final $$FindingEvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.findingEvidence,
      getReferencedColumn: (t) => t.findingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingEvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.findingEvidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FindingsTable,
          FindingRow,
          $$FindingsTableFilterComposer,
          $$FindingsTableOrderingComposer,
          $$FindingsTableAnnotationComposer,
          $$FindingsTableCreateCompanionBuilder,
          $$FindingsTableUpdateCompanionBuilder,
          (FindingRow, $$FindingsTableReferences),
          FindingRow,
          PrefetchHooks Function({bool scanId, bool findingEvidenceRefs})
        > {
  $$FindingsTableTableManager(_$AppDatabase db, $FindingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> scanId = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> severity = const Value.absent(),
              }) => FindingsCompanion(
                id: id,
                scanId: scanId,
                packageName: packageName,
                type: type,
                severity: severity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int scanId,
                required String packageName,
                required String type,
                required String severity,
              }) => FindingsCompanion.insert(
                id: id,
                scanId: scanId,
                packageName: packageName,
                type: type,
                severity: severity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FindingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({scanId = false, findingEvidenceRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (findingEvidenceRefs) db.findingEvidence,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (scanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.scanId,
                                    referencedTable: $$FindingsTableReferences
                                        ._scanIdTable(db),
                                    referencedColumn: $$FindingsTableReferences
                                        ._scanIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (findingEvidenceRefs)
                        await $_getPrefetchedData<
                          FindingRow,
                          $FindingsTable,
                          FindingEvidenceRow
                        >(
                          currentTable: table,
                          referencedTable: $$FindingsTableReferences
                              ._findingEvidenceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FindingsTableReferences(
                                db,
                                table,
                                p0,
                              ).findingEvidenceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.findingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FindingsTable,
      FindingRow,
      $$FindingsTableFilterComposer,
      $$FindingsTableOrderingComposer,
      $$FindingsTableAnnotationComposer,
      $$FindingsTableCreateCompanionBuilder,
      $$FindingsTableUpdateCompanionBuilder,
      (FindingRow, $$FindingsTableReferences),
      FindingRow,
      PrefetchHooks Function({bool scanId, bool findingEvidenceRefs})
    >;
typedef $$FindingEvidenceTableCreateCompanionBuilder =
    FindingEvidenceCompanion Function({
      Value<int> id,
      required int findingId,
      required String kind,
      required String value,
    });
typedef $$FindingEvidenceTableUpdateCompanionBuilder =
    FindingEvidenceCompanion Function({
      Value<int> id,
      Value<int> findingId,
      Value<String> kind,
      Value<String> value,
    });

final class $$FindingEvidenceTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FindingEvidenceTable,
          FindingEvidenceRow
        > {
  $$FindingEvidenceTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FindingsTable _findingIdTable(_$AppDatabase db) =>
      db.findings.createAlias(
        $_aliasNameGenerator(db.findingEvidence.findingId, db.findings.id),
      );

  $$FindingsTableProcessedTableManager get findingId {
    final $_column = $_itemColumn<int>('finding_id')!;

    final manager = $$FindingsTableTableManager(
      $_db,
      $_db.findings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_findingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FindingEvidenceTableFilterComposer
    extends Composer<_$AppDatabase, $FindingEvidenceTable> {
  $$FindingEvidenceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$FindingsTableFilterComposer get findingId {
    final $$FindingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.findingId,
      referencedTable: $db.findings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingsTableFilterComposer(
            $db: $db,
            $table: $db.findings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FindingEvidenceTableOrderingComposer
    extends Composer<_$AppDatabase, $FindingEvidenceTable> {
  $$FindingEvidenceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$FindingsTableOrderingComposer get findingId {
    final $$FindingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.findingId,
      referencedTable: $db.findings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingsTableOrderingComposer(
            $db: $db,
            $table: $db.findings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FindingEvidenceTableAnnotationComposer
    extends Composer<_$AppDatabase, $FindingEvidenceTable> {
  $$FindingEvidenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$FindingsTableAnnotationComposer get findingId {
    final $$FindingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.findingId,
      referencedTable: $db.findings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FindingsTableAnnotationComposer(
            $db: $db,
            $table: $db.findings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FindingEvidenceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FindingEvidenceTable,
          FindingEvidenceRow,
          $$FindingEvidenceTableFilterComposer,
          $$FindingEvidenceTableOrderingComposer,
          $$FindingEvidenceTableAnnotationComposer,
          $$FindingEvidenceTableCreateCompanionBuilder,
          $$FindingEvidenceTableUpdateCompanionBuilder,
          (FindingEvidenceRow, $$FindingEvidenceTableReferences),
          FindingEvidenceRow,
          PrefetchHooks Function({bool findingId})
        > {
  $$FindingEvidenceTableTableManager(
    _$AppDatabase db,
    $FindingEvidenceTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingEvidenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingEvidenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingEvidenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> findingId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => FindingEvidenceCompanion(
                id: id,
                findingId: findingId,
                kind: kind,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int findingId,
                required String kind,
                required String value,
              }) => FindingEvidenceCompanion.insert(
                id: id,
                findingId: findingId,
                kind: kind,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FindingEvidenceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({findingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (findingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.findingId,
                                referencedTable:
                                    $$FindingEvidenceTableReferences
                                        ._findingIdTable(db),
                                referencedColumn:
                                    $$FindingEvidenceTableReferences
                                        ._findingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FindingEvidenceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FindingEvidenceTable,
      FindingEvidenceRow,
      $$FindingEvidenceTableFilterComposer,
      $$FindingEvidenceTableOrderingComposer,
      $$FindingEvidenceTableAnnotationComposer,
      $$FindingEvidenceTableCreateCompanionBuilder,
      $$FindingEvidenceTableUpdateCompanionBuilder,
      (FindingEvidenceRow, $$FindingEvidenceTableReferences),
      FindingEvidenceRow,
      PrefetchHooks Function({bool findingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScansTableTableManager get scans =>
      $$ScansTableTableManager(_db, _db.scans);
  $$AppsTableTableManager get apps => $$AppsTableTableManager(_db, _db.apps);
  $$AppPermissionsTableTableManager get appPermissions =>
      $$AppPermissionsTableTableManager(_db, _db.appPermissions);
  $$SpecialAccessTableTableManager get specialAccess =>
      $$SpecialAccessTableTableManager(_db, _db.specialAccess);
  $$UsageDailyTableTableManager get usageDaily =>
      $$UsageDailyTableTableManager(_db, _db.usageDaily);
  $$TrackerSdkMatchesTableTableManager get trackerSdkMatches =>
      $$TrackerSdkMatchesTableTableManager(_db, _db.trackerSdkMatches);
  $$DnsEventsTableTableManager get dnsEvents =>
      $$DnsEventsTableTableManager(_db, _db.dnsEvents);
  $$FindingsTableTableManager get findings =>
      $$FindingsTableTableManager(_db, _db.findings);
  $$FindingEvidenceTableTableManager get findingEvidence =>
      $$FindingEvidenceTableTableManager(_db, _db.findingEvidence);
}
