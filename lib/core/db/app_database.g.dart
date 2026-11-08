// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NeedsTable extends Needs with TableInfo<$NeedsTable, NeedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urgencyMeta = const VerificationMeta(
    'urgency',
  );
  @override
  late final GeneratedColumn<String> urgency = GeneratedColumn<String>(
    'urgency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    body,
    urgency,
    createdAt,
    syncStatus,
    details,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'needs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NeedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('urgency')) {
      context.handle(
        _urgencyMeta,
        urgency.isAcceptableOrUnknown(data['urgency']!, _urgencyMeta),
      );
    } else if (isInserting) {
      context.missing(_urgencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NeedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NeedRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      urgency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urgency'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $NeedsTable createAlias(String alias) {
    return $NeedsTable(attachedDatabase, alias);
  }
}

class NeedRow extends DataClass implements Insertable<NeedRow> {
  final String id;
  final String kind;
  final String body;
  final String urgency;
  final DateTime createdAt;
  final String syncStatus;
  final String? details;
  final String? photoPath;
  const NeedRow({
    required this.id,
    required this.kind,
    required this.body,
    required this.urgency,
    required this.createdAt,
    required this.syncStatus,
    this.details,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['body'] = Variable<String>(body);
    map['urgency'] = Variable<String>(urgency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  NeedsCompanion toCompanion(bool nullToAbsent) {
    return NeedsCompanion(
      id: Value(id),
      kind: Value(kind),
      body: Value(body),
      urgency: Value(urgency),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory NeedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NeedRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      body: serializer.fromJson<String>(json['body']),
      urgency: serializer.fromJson<String>(json['urgency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      details: serializer.fromJson<String?>(json['details']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'body': serializer.toJson<String>(body),
      'urgency': serializer.toJson<String>(urgency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'details': serializer.toJson<String?>(details),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  NeedRow copyWith({
    String? id,
    String? kind,
    String? body,
    String? urgency,
    DateTime? createdAt,
    String? syncStatus,
    Value<String?> details = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
  }) => NeedRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    body: body ?? this.body,
    urgency: urgency ?? this.urgency,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    details: details.present ? details.value : this.details,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  NeedRow copyWithCompanion(NeedsCompanion data) {
    return NeedRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      body: data.body.present ? data.body.value : this.body,
      urgency: data.urgency.present ? data.urgency.value : this.urgency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      details: data.details.present ? data.details.value : this.details,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NeedRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('body: $body, ')
          ..write('urgency: $urgency, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('details: $details, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    body,
    urgency,
    createdAt,
    syncStatus,
    details,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NeedRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.body == this.body &&
          other.urgency == this.urgency &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.details == this.details &&
          other.photoPath == this.photoPath);
}

class NeedsCompanion extends UpdateCompanion<NeedRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> body;
  final Value<String> urgency;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<String?> details;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const NeedsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.body = const Value.absent(),
    this.urgency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.details = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NeedsCompanion.insert({
    required String id,
    required String kind,
    required String body,
    required String urgency,
    required DateTime createdAt,
    required String syncStatus,
    this.details = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       body = Value(body),
       urgency = Value(urgency),
       createdAt = Value(createdAt),
       syncStatus = Value(syncStatus);
  static Insertable<NeedRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? body,
    Expression<String>? urgency,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<String>? details,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (body != null) 'body': body,
      if (urgency != null) 'urgency': urgency,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (details != null) 'details': details,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NeedsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? body,
    Value<String>? urgency,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<String?>? details,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return NeedsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      body: body ?? this.body,
      urgency: urgency ?? this.urgency,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      details: details ?? this.details,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (urgency.present) {
      map['urgency'] = Variable<String>(urgency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NeedsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('body: $body, ')
          ..write('urgency: $urgency, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('details: $details, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxOpsTable extends OutboxOps
    with TableInfo<$OutboxOpsTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
    'op_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    opType,
    payload,
    attempts,
    createdAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('op_type')) {
      context.handle(
        _opTypeMeta,
        opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      opType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxOpsTable createAlias(String alias) {
    return $OutboxOpsTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final String id;
  final String opType;
  final String payload;
  final int attempts;
  final DateTime createdAt;
  final String? lastError;
  const OutboxRow({
    required this.id,
    required this.opType,
    required this.payload,
    required this.attempts,
    required this.createdAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['op_type'] = Variable<String>(opType);
    map['payload'] = Variable<String>(payload);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxOpsCompanion toCompanion(bool nullToAbsent) {
    return OutboxOpsCompanion(
      id: Value(id),
      opType: Value(opType),
      payload: Value(payload),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<String>(json['id']),
      opType: serializer.fromJson<String>(json['opType']),
      payload: serializer.fromJson<String>(json['payload']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'opType': serializer.toJson<String>(opType),
      'payload': serializer.toJson<String>(payload),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxRow copyWith({
    String? id,
    String? opType,
    String? payload,
    int? attempts,
    DateTime? createdAt,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxRow(
    id: id ?? this.id,
    opType: opType ?? this.opType,
    payload: payload ?? this.payload,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxRow copyWithCompanion(OutboxOpsCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      opType: data.opType.present ? data.opType.value : this.opType,
      payload: data.payload.present ? data.payload.value : this.payload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, opType, payload, attempts, createdAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.opType == this.opType &&
          other.payload == this.payload &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.lastError == this.lastError);
}

class OutboxOpsCompanion extends UpdateCompanion<OutboxRow> {
  final Value<String> id;
  final Value<String> opType;
  final Value<String> payload;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const OutboxOpsCompanion({
    this.id = const Value.absent(),
    this.opType = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxOpsCompanion.insert({
    required String id,
    required String opType,
    required String payload,
    this.attempts = const Value.absent(),
    required DateTime createdAt,
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       opType = Value(opType),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
    Expression<String>? id,
    Expression<String>? opType,
    Expression<String>? payload,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (opType != null) 'op_type': opType,
      if (payload != null) 'payload': payload,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxOpsCompanion copyWith({
    Value<String>? id,
    Value<String>? opType,
    Value<String>? payload,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return OutboxOpsCompanion(
      id: id ?? this.id,
      opType: opType ?? this.opType,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOpsCompanion(')
          ..write('id: $id, ')
          ..write('opType: $opType, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DealsTable extends Deals with TableInfo<$DealsTable, DealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _needIdMeta = const VerificationMeta('needId');
  @override
  late final GeneratedColumn<String> needId = GeneratedColumn<String>(
    'need_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceSolesMeta = const VerificationMeta(
    'priceSoles',
  );
  @override
  late final GeneratedColumn<int> priceSoles = GeneratedColumn<int>(
    'price_soles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceLabelMeta = const VerificationMeta(
    'priceLabel',
  );
  @override
  late final GeneratedColumn<String> priceLabel = GeneratedColumn<String>(
    'price_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedAtMeta = const VerificationMeta(
    'acceptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
    'accepted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    needId,
    providerId,
    providerName,
    priceSoles,
    priceLabel,
    code,
    status,
    acceptedAt,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deals';
  @override
  VerificationContext validateIntegrity(
    Insertable<DealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('need_id')) {
      context.handle(
        _needIdMeta,
        needId.isAcceptableOrUnknown(data['need_id']!, _needIdMeta),
      );
    } else if (isInserting) {
      context.missing(_needIdMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('price_soles')) {
      context.handle(
        _priceSolesMeta,
        priceSoles.isAcceptableOrUnknown(data['price_soles']!, _priceSolesMeta),
      );
    } else if (isInserting) {
      context.missing(_priceSolesMeta);
    }
    if (data.containsKey('price_label')) {
      context.handle(
        _priceLabelMeta,
        priceLabel.isAcceptableOrUnknown(data['price_label']!, _priceLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_priceLabelMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
        _acceptedAtMeta,
        acceptedAt.isAcceptableOrUnknown(data['accepted_at']!, _acceptedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acceptedAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      needId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}need_id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      )!,
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      priceSoles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_soles'],
      )!,
      priceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_label'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      acceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accepted_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $DealsTable createAlias(String alias) {
    return $DealsTable(attachedDatabase, alias);
  }
}

class DealRow extends DataClass implements Insertable<DealRow> {
  final String id;
  final String needId;
  final String providerId;
  final String providerName;
  final int priceSoles;
  final String priceLabel;
  final String code;
  final String status;
  final DateTime acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const DealRow({
    required this.id,
    required this.needId,
    required this.providerId,
    required this.providerName,
    required this.priceSoles,
    required this.priceLabel,
    required this.code,
    required this.status,
    required this.acceptedAt,
    this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['need_id'] = Variable<String>(needId);
    map['provider_id'] = Variable<String>(providerId);
    map['provider_name'] = Variable<String>(providerName);
    map['price_soles'] = Variable<int>(priceSoles);
    map['price_label'] = Variable<String>(priceLabel);
    map['code'] = Variable<String>(code);
    map['status'] = Variable<String>(status);
    map['accepted_at'] = Variable<DateTime>(acceptedAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  DealsCompanion toCompanion(bool nullToAbsent) {
    return DealsCompanion(
      id: Value(id),
      needId: Value(needId),
      providerId: Value(providerId),
      providerName: Value(providerName),
      priceSoles: Value(priceSoles),
      priceLabel: Value(priceLabel),
      code: Value(code),
      status: Value(status),
      acceptedAt: Value(acceptedAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory DealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DealRow(
      id: serializer.fromJson<String>(json['id']),
      needId: serializer.fromJson<String>(json['needId']),
      providerId: serializer.fromJson<String>(json['providerId']),
      providerName: serializer.fromJson<String>(json['providerName']),
      priceSoles: serializer.fromJson<int>(json['priceSoles']),
      priceLabel: serializer.fromJson<String>(json['priceLabel']),
      code: serializer.fromJson<String>(json['code']),
      status: serializer.fromJson<String>(json['status']),
      acceptedAt: serializer.fromJson<DateTime>(json['acceptedAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'needId': serializer.toJson<String>(needId),
      'providerId': serializer.toJson<String>(providerId),
      'providerName': serializer.toJson<String>(providerName),
      'priceSoles': serializer.toJson<int>(priceSoles),
      'priceLabel': serializer.toJson<String>(priceLabel),
      'code': serializer.toJson<String>(code),
      'status': serializer.toJson<String>(status),
      'acceptedAt': serializer.toJson<DateTime>(acceptedAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  DealRow copyWith({
    String? id,
    String? needId,
    String? providerId,
    String? providerName,
    int? priceSoles,
    String? priceLabel,
    String? code,
    String? status,
    DateTime? acceptedAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => DealRow(
    id: id ?? this.id,
    needId: needId ?? this.needId,
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    priceSoles: priceSoles ?? this.priceSoles,
    priceLabel: priceLabel ?? this.priceLabel,
    code: code ?? this.code,
    status: status ?? this.status,
    acceptedAt: acceptedAt ?? this.acceptedAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  DealRow copyWithCompanion(DealsCompanion data) {
    return DealRow(
      id: data.id.present ? data.id.value : this.id,
      needId: data.needId.present ? data.needId.value : this.needId,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      priceSoles: data.priceSoles.present
          ? data.priceSoles.value
          : this.priceSoles,
      priceLabel: data.priceLabel.present
          ? data.priceLabel.value
          : this.priceLabel,
      code: data.code.present ? data.code.value : this.code,
      status: data.status.present ? data.status.value : this.status,
      acceptedAt: data.acceptedAt.present
          ? data.acceptedAt.value
          : this.acceptedAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DealRow(')
          ..write('id: $id, ')
          ..write('needId: $needId, ')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('priceLabel: $priceLabel, ')
          ..write('code: $code, ')
          ..write('status: $status, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    needId,
    providerId,
    providerName,
    priceSoles,
    priceLabel,
    code,
    status,
    acceptedAt,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DealRow &&
          other.id == this.id &&
          other.needId == this.needId &&
          other.providerId == this.providerId &&
          other.providerName == this.providerName &&
          other.priceSoles == this.priceSoles &&
          other.priceLabel == this.priceLabel &&
          other.code == this.code &&
          other.status == this.status &&
          other.acceptedAt == this.acceptedAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class DealsCompanion extends UpdateCompanion<DealRow> {
  final Value<String> id;
  final Value<String> needId;
  final Value<String> providerId;
  final Value<String> providerName;
  final Value<int> priceSoles;
  final Value<String> priceLabel;
  final Value<String> code;
  final Value<String> status;
  final Value<DateTime> acceptedAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const DealsCompanion({
    this.id = const Value.absent(),
    this.needId = const Value.absent(),
    this.providerId = const Value.absent(),
    this.providerName = const Value.absent(),
    this.priceSoles = const Value.absent(),
    this.priceLabel = const Value.absent(),
    this.code = const Value.absent(),
    this.status = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DealsCompanion.insert({
    required String id,
    required String needId,
    required String providerId,
    required String providerName,
    required int priceSoles,
    required String priceLabel,
    required String code,
    required String status,
    required DateTime acceptedAt,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       needId = Value(needId),
       providerId = Value(providerId),
       providerName = Value(providerName),
       priceSoles = Value(priceSoles),
       priceLabel = Value(priceLabel),
       code = Value(code),
       status = Value(status),
       acceptedAt = Value(acceptedAt);
  static Insertable<DealRow> custom({
    Expression<String>? id,
    Expression<String>? needId,
    Expression<String>? providerId,
    Expression<String>? providerName,
    Expression<int>? priceSoles,
    Expression<String>? priceLabel,
    Expression<String>? code,
    Expression<String>? status,
    Expression<DateTime>? acceptedAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (needId != null) 'need_id': needId,
      if (providerId != null) 'provider_id': providerId,
      if (providerName != null) 'provider_name': providerName,
      if (priceSoles != null) 'price_soles': priceSoles,
      if (priceLabel != null) 'price_label': priceLabel,
      if (code != null) 'code': code,
      if (status != null) 'status': status,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DealsCompanion copyWith({
    Value<String>? id,
    Value<String>? needId,
    Value<String>? providerId,
    Value<String>? providerName,
    Value<int>? priceSoles,
    Value<String>? priceLabel,
    Value<String>? code,
    Value<String>? status,
    Value<DateTime>? acceptedAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return DealsCompanion(
      id: id ?? this.id,
      needId: needId ?? this.needId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      priceSoles: priceSoles ?? this.priceSoles,
      priceLabel: priceLabel ?? this.priceLabel,
      code: code ?? this.code,
      status: status ?? this.status,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (needId.present) {
      map['need_id'] = Variable<String>(needId.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (priceSoles.present) {
      map['price_soles'] = Variable<int>(priceSoles.value);
    }
    if (priceLabel.present) {
      map['price_label'] = Variable<String>(priceLabel.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DealsCompanion(')
          ..write('id: $id, ')
          ..write('needId: $needId, ')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('priceLabel: $priceLabel, ')
          ..write('code: $code, ')
          ..write('status: $status, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InteractionsTable extends Interactions
    with TableInfo<$InteractionsTable, InteractionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InteractionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<String> dealId = GeneratedColumn<String>(
    'deal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _raterIdMeta = const VerificationMeta(
    'raterId',
  );
  @override
  late final GeneratedColumn<String> raterId = GeneratedColumn<String>(
    'rater_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommendedMeta = const VerificationMeta(
    'recommended',
  );
  @override
  late final GeneratedColumn<bool> recommended = GeneratedColumn<bool>(
    'recommended',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recommended" IN (0, 1))',
    ),
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dealId,
    providerId,
    raterId,
    stars,
    recommended,
    closedAt,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InteractionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deal_id')) {
      context.handle(
        _dealIdMeta,
        dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dealIdMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('rater_id')) {
      context.handle(
        _raterIdMeta,
        raterId.isAcceptableOrUnknown(data['rater_id']!, _raterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_raterIdMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('recommended')) {
      context.handle(
        _recommendedMeta,
        recommended.isAcceptableOrUnknown(
          data['recommended']!,
          _recommendedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendedMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_closedAtMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InteractionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InteractionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deal_id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      )!,
      raterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rater_id'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      recommended: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recommended'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      )!,
    );
  }

  @override
  $InteractionsTable createAlias(String alias) {
    return $InteractionsTable(attachedDatabase, alias);
  }
}

class InteractionRow extends DataClass implements Insertable<InteractionRow> {
  final String id;
  final String dealId;
  final String providerId;
  final String raterId;
  final int stars;
  final bool recommended;
  final DateTime closedAt;
  final String comment;
  const InteractionRow({
    required this.id,
    required this.dealId,
    required this.providerId,
    required this.raterId,
    required this.stars,
    required this.recommended,
    required this.closedAt,
    required this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deal_id'] = Variable<String>(dealId);
    map['provider_id'] = Variable<String>(providerId);
    map['rater_id'] = Variable<String>(raterId);
    map['stars'] = Variable<int>(stars);
    map['recommended'] = Variable<bool>(recommended);
    map['closed_at'] = Variable<DateTime>(closedAt);
    map['comment'] = Variable<String>(comment);
    return map;
  }

  InteractionsCompanion toCompanion(bool nullToAbsent) {
    return InteractionsCompanion(
      id: Value(id),
      dealId: Value(dealId),
      providerId: Value(providerId),
      raterId: Value(raterId),
      stars: Value(stars),
      recommended: Value(recommended),
      closedAt: Value(closedAt),
      comment: Value(comment),
    );
  }

  factory InteractionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InteractionRow(
      id: serializer.fromJson<String>(json['id']),
      dealId: serializer.fromJson<String>(json['dealId']),
      providerId: serializer.fromJson<String>(json['providerId']),
      raterId: serializer.fromJson<String>(json['raterId']),
      stars: serializer.fromJson<int>(json['stars']),
      recommended: serializer.fromJson<bool>(json['recommended']),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dealId': serializer.toJson<String>(dealId),
      'providerId': serializer.toJson<String>(providerId),
      'raterId': serializer.toJson<String>(raterId),
      'stars': serializer.toJson<int>(stars),
      'recommended': serializer.toJson<bool>(recommended),
      'closedAt': serializer.toJson<DateTime>(closedAt),
      'comment': serializer.toJson<String>(comment),
    };
  }

  InteractionRow copyWith({
    String? id,
    String? dealId,
    String? providerId,
    String? raterId,
    int? stars,
    bool? recommended,
    DateTime? closedAt,
    String? comment,
  }) => InteractionRow(
    id: id ?? this.id,
    dealId: dealId ?? this.dealId,
    providerId: providerId ?? this.providerId,
    raterId: raterId ?? this.raterId,
    stars: stars ?? this.stars,
    recommended: recommended ?? this.recommended,
    closedAt: closedAt ?? this.closedAt,
    comment: comment ?? this.comment,
  );
  InteractionRow copyWithCompanion(InteractionsCompanion data) {
    return InteractionRow(
      id: data.id.present ? data.id.value : this.id,
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      raterId: data.raterId.present ? data.raterId.value : this.raterId,
      stars: data.stars.present ? data.stars.value : this.stars,
      recommended: data.recommended.present
          ? data.recommended.value
          : this.recommended,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InteractionRow(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('providerId: $providerId, ')
          ..write('raterId: $raterId, ')
          ..write('stars: $stars, ')
          ..write('recommended: $recommended, ')
          ..write('closedAt: $closedAt, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dealId,
    providerId,
    raterId,
    stars,
    recommended,
    closedAt,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InteractionRow &&
          other.id == this.id &&
          other.dealId == this.dealId &&
          other.providerId == this.providerId &&
          other.raterId == this.raterId &&
          other.stars == this.stars &&
          other.recommended == this.recommended &&
          other.closedAt == this.closedAt &&
          other.comment == this.comment);
}

class InteractionsCompanion extends UpdateCompanion<InteractionRow> {
  final Value<String> id;
  final Value<String> dealId;
  final Value<String> providerId;
  final Value<String> raterId;
  final Value<int> stars;
  final Value<bool> recommended;
  final Value<DateTime> closedAt;
  final Value<String> comment;
  final Value<int> rowid;
  const InteractionsCompanion({
    this.id = const Value.absent(),
    this.dealId = const Value.absent(),
    this.providerId = const Value.absent(),
    this.raterId = const Value.absent(),
    this.stars = const Value.absent(),
    this.recommended = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InteractionsCompanion.insert({
    required String id,
    required String dealId,
    required String providerId,
    required String raterId,
    required int stars,
    required bool recommended,
    required DateTime closedAt,
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dealId = Value(dealId),
       providerId = Value(providerId),
       raterId = Value(raterId),
       stars = Value(stars),
       recommended = Value(recommended),
       closedAt = Value(closedAt);
  static Insertable<InteractionRow> custom({
    Expression<String>? id,
    Expression<String>? dealId,
    Expression<String>? providerId,
    Expression<String>? raterId,
    Expression<int>? stars,
    Expression<bool>? recommended,
    Expression<DateTime>? closedAt,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dealId != null) 'deal_id': dealId,
      if (providerId != null) 'provider_id': providerId,
      if (raterId != null) 'rater_id': raterId,
      if (stars != null) 'stars': stars,
      if (recommended != null) 'recommended': recommended,
      if (closedAt != null) 'closed_at': closedAt,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InteractionsCompanion copyWith({
    Value<String>? id,
    Value<String>? dealId,
    Value<String>? providerId,
    Value<String>? raterId,
    Value<int>? stars,
    Value<bool>? recommended,
    Value<DateTime>? closedAt,
    Value<String>? comment,
    Value<int>? rowid,
  }) {
    return InteractionsCompanion(
      id: id ?? this.id,
      dealId: dealId ?? this.dealId,
      providerId: providerId ?? this.providerId,
      raterId: raterId ?? this.raterId,
      stars: stars ?? this.stars,
      recommended: recommended ?? this.recommended,
      closedAt: closedAt ?? this.closedAt,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dealId.present) {
      map['deal_id'] = Variable<String>(dealId.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (raterId.present) {
      map['rater_id'] = Variable<String>(raterId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (recommended.present) {
      map['recommended'] = Variable<bool>(recommended.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InteractionsCompanion(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('providerId: $providerId, ')
          ..write('raterId: $raterId, ')
          ..write('stars: $stars, ')
          ..write('recommended: $recommended, ')
          ..write('closedAt: $closedAt, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyPostsTable extends EmergencyPosts
    with TableInfo<$EmergencyPostsTable, EmergencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _whyMeta = const VerificationMeta('why');
  @override
  late final GeneratedColumn<String> why = GeneratedColumn<String>(
    'why',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _needsMeta = const VerificationMeta('needs');
  @override
  late final GeneratedColumn<String> needs = GeneratedColumn<String>(
    'needs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    why,
    needs,
    createdAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('why')) {
      context.handle(
        _whyMeta,
        why.isAcceptableOrUnknown(data['why']!, _whyMeta),
      );
    } else if (isInserting) {
      context.missing(_whyMeta);
    }
    if (data.containsKey('needs')) {
      context.handle(
        _needsMeta,
        needs.isAcceptableOrUnknown(data['needs']!, _needsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      why: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}why'],
      )!,
      needs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}needs'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $EmergencyPostsTable createAlias(String alias) {
    return $EmergencyPostsTable(attachedDatabase, alias);
  }
}

class EmergencyRow extends DataClass implements Insertable<EmergencyRow> {
  final String id;
  final String type;
  final String why;
  final String needs;
  final DateTime createdAt;
  final String syncStatus;
  const EmergencyRow({
    required this.id,
    required this.type,
    required this.why,
    required this.needs,
    required this.createdAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['why'] = Variable<String>(why);
    map['needs'] = Variable<String>(needs);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  EmergencyPostsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyPostsCompanion(
      id: Value(id),
      type: Value(type),
      why: Value(why),
      needs: Value(needs),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory EmergencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyRow(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      why: serializer.fromJson<String>(json['why']),
      needs: serializer.fromJson<String>(json['needs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'why': serializer.toJson<String>(why),
      'needs': serializer.toJson<String>(needs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  EmergencyRow copyWith({
    String? id,
    String? type,
    String? why,
    String? needs,
    DateTime? createdAt,
    String? syncStatus,
  }) => EmergencyRow(
    id: id ?? this.id,
    type: type ?? this.type,
    why: why ?? this.why,
    needs: needs ?? this.needs,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  EmergencyRow copyWithCompanion(EmergencyPostsCompanion data) {
    return EmergencyRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      why: data.why.present ? data.why.value : this.why,
      needs: data.needs.present ? data.needs.value : this.needs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('why: $why, ')
          ..write('needs: $needs, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, why, needs, createdAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.why == this.why &&
          other.needs == this.needs &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus);
}

class EmergencyPostsCompanion extends UpdateCompanion<EmergencyRow> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> why;
  final Value<String> needs;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const EmergencyPostsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.why = const Value.absent(),
    this.needs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyPostsCompanion.insert({
    required String id,
    required String type,
    required String why,
    this.needs = const Value.absent(),
    required DateTime createdAt,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       why = Value(why),
       createdAt = Value(createdAt),
       syncStatus = Value(syncStatus);
  static Insertable<EmergencyRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? why,
    Expression<String>? needs,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (why != null) 'why': why,
      if (needs != null) 'needs': needs,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyPostsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? why,
    Value<String>? needs,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return EmergencyPostsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      why: why ?? this.why,
      needs: needs ?? this.needs,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (why.present) {
      map['why'] = Variable<String>(why.value);
    }
    if (needs.present) {
      map['needs'] = Variable<String>(needs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyPostsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('why: $why, ')
          ..write('needs: $needs, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceOffersTable extends ServiceOffers
    with TableInfo<$ServiceOffersTable, ServiceOfferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tradeMeta = const VerificationMeta('trade');
  @override
  late final GeneratedColumn<String> trade = GeneratedColumn<String>(
    'trade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, trade, availability, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_offers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceOfferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trade')) {
      context.handle(
        _tradeMeta,
        trade.isAcceptableOrUnknown(data['trade']!, _tradeMeta),
      );
    } else if (isInserting) {
      context.missing(_tradeMeta);
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availabilityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceOfferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceOfferRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trade'],
      )!,
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServiceOffersTable createAlias(String alias) {
    return $ServiceOffersTable(attachedDatabase, alias);
  }
}

class ServiceOfferRow extends DataClass implements Insertable<ServiceOfferRow> {
  final String id;
  final String trade;
  final String availability;
  final DateTime createdAt;
  const ServiceOfferRow({
    required this.id,
    required this.trade,
    required this.availability,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trade'] = Variable<String>(trade);
    map['availability'] = Variable<String>(availability);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServiceOffersCompanion toCompanion(bool nullToAbsent) {
    return ServiceOffersCompanion(
      id: Value(id),
      trade: Value(trade),
      availability: Value(availability),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceOfferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceOfferRow(
      id: serializer.fromJson<String>(json['id']),
      trade: serializer.fromJson<String>(json['trade']),
      availability: serializer.fromJson<String>(json['availability']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trade': serializer.toJson<String>(trade),
      'availability': serializer.toJson<String>(availability),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServiceOfferRow copyWith({
    String? id,
    String? trade,
    String? availability,
    DateTime? createdAt,
  }) => ServiceOfferRow(
    id: id ?? this.id,
    trade: trade ?? this.trade,
    availability: availability ?? this.availability,
    createdAt: createdAt ?? this.createdAt,
  );
  ServiceOfferRow copyWithCompanion(ServiceOffersCompanion data) {
    return ServiceOfferRow(
      id: data.id.present ? data.id.value : this.id,
      trade: data.trade.present ? data.trade.value : this.trade,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceOfferRow(')
          ..write('id: $id, ')
          ..write('trade: $trade, ')
          ..write('availability: $availability, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trade, availability, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceOfferRow &&
          other.id == this.id &&
          other.trade == this.trade &&
          other.availability == this.availability &&
          other.createdAt == this.createdAt);
}

class ServiceOffersCompanion extends UpdateCompanion<ServiceOfferRow> {
  final Value<String> id;
  final Value<String> trade;
  final Value<String> availability;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ServiceOffersCompanion({
    this.id = const Value.absent(),
    this.trade = const Value.absent(),
    this.availability = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceOffersCompanion.insert({
    required String id,
    required String trade,
    required String availability,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trade = Value(trade),
       availability = Value(availability),
       createdAt = Value(createdAt);
  static Insertable<ServiceOfferRow> custom({
    Expression<String>? id,
    Expression<String>? trade,
    Expression<String>? availability,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trade != null) 'trade': trade,
      if (availability != null) 'availability': availability,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceOffersCompanion copyWith({
    Value<String>? id,
    Value<String>? trade,
    Value<String>? availability,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ServiceOffersCompanion(
      id: id ?? this.id,
      trade: trade ?? this.trade,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trade.present) {
      map['trade'] = Variable<String>(trade.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceOffersCompanion(')
          ..write('id: $id, ')
          ..write('trade: $trade, ')
          ..write('availability: $availability, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JobProposalsTable extends JobProposals
    with TableInfo<$JobProposalsTable, JobProposalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceSolesMeta = const VerificationMeta(
    'priceSoles',
  );
  @override
  late final GeneratedColumn<int> priceSoles = GeneratedColumn<int>(
    'price_soles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [jobId, priceSoles, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'job_proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<JobProposalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('price_soles')) {
      context.handle(
        _priceSolesMeta,
        priceSoles.isAcceptableOrUnknown(data['price_soles']!, _priceSolesMeta),
      );
    } else if (isInserting) {
      context.missing(_priceSolesMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {jobId};
  @override
  JobProposalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobProposalRow(
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      priceSoles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_soles'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
    );
  }

  @override
  $JobProposalsTable createAlias(String alias) {
    return $JobProposalsTable(attachedDatabase, alias);
  }
}

class JobProposalRow extends DataClass implements Insertable<JobProposalRow> {
  final String jobId;
  final int priceSoles;
  final DateTime sentAt;
  const JobProposalRow({
    required this.jobId,
    required this.priceSoles,
    required this.sentAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['job_id'] = Variable<String>(jobId);
    map['price_soles'] = Variable<int>(priceSoles);
    map['sent_at'] = Variable<DateTime>(sentAt);
    return map;
  }

  JobProposalsCompanion toCompanion(bool nullToAbsent) {
    return JobProposalsCompanion(
      jobId: Value(jobId),
      priceSoles: Value(priceSoles),
      sentAt: Value(sentAt),
    );
  }

  factory JobProposalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobProposalRow(
      jobId: serializer.fromJson<String>(json['jobId']),
      priceSoles: serializer.fromJson<int>(json['priceSoles']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'jobId': serializer.toJson<String>(jobId),
      'priceSoles': serializer.toJson<int>(priceSoles),
      'sentAt': serializer.toJson<DateTime>(sentAt),
    };
  }

  JobProposalRow copyWith({String? jobId, int? priceSoles, DateTime? sentAt}) =>
      JobProposalRow(
        jobId: jobId ?? this.jobId,
        priceSoles: priceSoles ?? this.priceSoles,
        sentAt: sentAt ?? this.sentAt,
      );
  JobProposalRow copyWithCompanion(JobProposalsCompanion data) {
    return JobProposalRow(
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      priceSoles: data.priceSoles.present
          ? data.priceSoles.value
          : this.priceSoles,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobProposalRow(')
          ..write('jobId: $jobId, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(jobId, priceSoles, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobProposalRow &&
          other.jobId == this.jobId &&
          other.priceSoles == this.priceSoles &&
          other.sentAt == this.sentAt);
}

class JobProposalsCompanion extends UpdateCompanion<JobProposalRow> {
  final Value<String> jobId;
  final Value<int> priceSoles;
  final Value<DateTime> sentAt;
  final Value<int> rowid;
  const JobProposalsCompanion({
    this.jobId = const Value.absent(),
    this.priceSoles = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JobProposalsCompanion.insert({
    required String jobId,
    required int priceSoles,
    required DateTime sentAt,
    this.rowid = const Value.absent(),
  }) : jobId = Value(jobId),
       priceSoles = Value(priceSoles),
       sentAt = Value(sentAt);
  static Insertable<JobProposalRow> custom({
    Expression<String>? jobId,
    Expression<int>? priceSoles,
    Expression<DateTime>? sentAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (jobId != null) 'job_id': jobId,
      if (priceSoles != null) 'price_soles': priceSoles,
      if (sentAt != null) 'sent_at': sentAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JobProposalsCompanion copyWith({
    Value<String>? jobId,
    Value<int>? priceSoles,
    Value<DateTime>? sentAt,
    Value<int>? rowid,
  }) {
    return JobProposalsCompanion(
      jobId: jobId ?? this.jobId,
      priceSoles: priceSoles ?? this.priceSoles,
      sentAt: sentAt ?? this.sentAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (priceSoles.present) {
      map['price_soles'] = Variable<int>(priceSoles.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobProposalsCompanion(')
          ..write('jobId: $jobId, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('sentAt: $sentAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<String> dealId = GeneratedColumn<String>(
    'deal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromMeMeta = const VerificationMeta('fromMe');
  @override
  late final GeneratedColumn<bool> fromMe = GeneratedColumn<bool>(
    'from_me',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_me" IN (0, 1))',
    ),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isExampleMeta = const VerificationMeta(
    'isExample',
  );
  @override
  late final GeneratedColumn<bool> isExample = GeneratedColumn<bool>(
    'is_example',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_example" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dealId,
    fromMe,
    body,
    isExample,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deal_id')) {
      context.handle(
        _dealIdMeta,
        dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dealIdMeta);
    }
    if (data.containsKey('from_me')) {
      context.handle(
        _fromMeMeta,
        fromMe.isAcceptableOrUnknown(data['from_me']!, _fromMeMeta),
      );
    } else if (isInserting) {
      context.missing(_fromMeMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_example')) {
      context.handle(
        _isExampleMeta,
        isExample.isAcceptableOrUnknown(data['is_example']!, _isExampleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deal_id'],
      )!,
      fromMe: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_me'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isExample: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_example'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageRow extends DataClass implements Insertable<ChatMessageRow> {
  final String id;
  final String dealId;
  final bool fromMe;
  final String body;
  final bool isExample;
  final DateTime createdAt;
  const ChatMessageRow({
    required this.id,
    required this.dealId,
    required this.fromMe,
    required this.body,
    required this.isExample,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deal_id'] = Variable<String>(dealId);
    map['from_me'] = Variable<bool>(fromMe);
    map['body'] = Variable<String>(body);
    map['is_example'] = Variable<bool>(isExample);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      dealId: Value(dealId),
      fromMe: Value(fromMe),
      body: Value(body),
      isExample: Value(isExample),
      createdAt: Value(createdAt),
    );
  }

  factory ChatMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageRow(
      id: serializer.fromJson<String>(json['id']),
      dealId: serializer.fromJson<String>(json['dealId']),
      fromMe: serializer.fromJson<bool>(json['fromMe']),
      body: serializer.fromJson<String>(json['body']),
      isExample: serializer.fromJson<bool>(json['isExample']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dealId': serializer.toJson<String>(dealId),
      'fromMe': serializer.toJson<bool>(fromMe),
      'body': serializer.toJson<String>(body),
      'isExample': serializer.toJson<bool>(isExample),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChatMessageRow copyWith({
    String? id,
    String? dealId,
    bool? fromMe,
    String? body,
    bool? isExample,
    DateTime? createdAt,
  }) => ChatMessageRow(
    id: id ?? this.id,
    dealId: dealId ?? this.dealId,
    fromMe: fromMe ?? this.fromMe,
    body: body ?? this.body,
    isExample: isExample ?? this.isExample,
    createdAt: createdAt ?? this.createdAt,
  );
  ChatMessageRow copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageRow(
      id: data.id.present ? data.id.value : this.id,
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
      fromMe: data.fromMe.present ? data.fromMe.value : this.fromMe,
      body: data.body.present ? data.body.value : this.body,
      isExample: data.isExample.present ? data.isExample.value : this.isExample,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageRow(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('fromMe: $fromMe, ')
          ..write('body: $body, ')
          ..write('isExample: $isExample, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dealId, fromMe, body, isExample, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageRow &&
          other.id == this.id &&
          other.dealId == this.dealId &&
          other.fromMe == this.fromMe &&
          other.body == this.body &&
          other.isExample == this.isExample &&
          other.createdAt == this.createdAt);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageRow> {
  final Value<String> id;
  final Value<String> dealId;
  final Value<bool> fromMe;
  final Value<String> body;
  final Value<bool> isExample;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.dealId = const Value.absent(),
    this.fromMe = const Value.absent(),
    this.body = const Value.absent(),
    this.isExample = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String dealId,
    required bool fromMe,
    required String body,
    this.isExample = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dealId = Value(dealId),
       fromMe = Value(fromMe),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<ChatMessageRow> custom({
    Expression<String>? id,
    Expression<String>? dealId,
    Expression<bool>? fromMe,
    Expression<String>? body,
    Expression<bool>? isExample,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dealId != null) 'deal_id': dealId,
      if (fromMe != null) 'from_me': fromMe,
      if (body != null) 'body': body,
      if (isExample != null) 'is_example': isExample,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? dealId,
    Value<bool>? fromMe,
    Value<String>? body,
    Value<bool>? isExample,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      dealId: dealId ?? this.dealId,
      fromMe: fromMe ?? this.fromMe,
      body: body ?? this.body,
      isExample: isExample ?? this.isExample,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dealId.present) {
      map['deal_id'] = Variable<String>(dealId.value);
    }
    if (fromMe.present) {
      map['from_me'] = Variable<bool>(fromMe.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isExample.present) {
      map['is_example'] = Variable<bool>(isExample.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('dealId: $dealId, ')
          ..write('fromMe: $fromMe, ')
          ..write('body: $body, ')
          ..write('isExample: $isExample, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductSalesTable extends ProductSales
    with TableInfo<$ProductSalesTable, ProductSaleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceSolesMeta = const VerificationMeta(
    'priceSoles',
  );
  @override
  late final GeneratedColumn<int> priceSoles = GeneratedColumn<int>(
    'price_soles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soldMeta = const VerificationMeta('sold');
  @override
  late final GeneratedColumn<bool> sold = GeneratedColumn<bool>(
    'sold',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sold" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _soldPriceMeta = const VerificationMeta(
    'soldPrice',
  );
  @override
  late final GeneratedColumn<int> soldPrice = GeneratedColumn<int>(
    'sold_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _soldToMeta = const VerificationMeta('soldTo');
  @override
  late final GeneratedColumn<String> soldTo = GeneratedColumn<String>(
    'sold_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rejectedMeta = const VerificationMeta(
    'rejected',
  );
  @override
  late final GeneratedColumn<String> rejected = GeneratedColumn<String>(
    'rejected',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    priceSoles,
    sold,
    soldPrice,
    soldTo,
    rejected,
    createdAt,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductSaleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('price_soles')) {
      context.handle(
        _priceSolesMeta,
        priceSoles.isAcceptableOrUnknown(data['price_soles']!, _priceSolesMeta),
      );
    } else if (isInserting) {
      context.missing(_priceSolesMeta);
    }
    if (data.containsKey('sold')) {
      context.handle(
        _soldMeta,
        sold.isAcceptableOrUnknown(data['sold']!, _soldMeta),
      );
    }
    if (data.containsKey('sold_price')) {
      context.handle(
        _soldPriceMeta,
        soldPrice.isAcceptableOrUnknown(data['sold_price']!, _soldPriceMeta),
      );
    }
    if (data.containsKey('sold_to')) {
      context.handle(
        _soldToMeta,
        soldTo.isAcceptableOrUnknown(data['sold_to']!, _soldToMeta),
      );
    }
    if (data.containsKey('rejected')) {
      context.handle(
        _rejectedMeta,
        rejected.isAcceptableOrUnknown(data['rejected']!, _rejectedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductSaleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSaleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      priceSoles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_soles'],
      )!,
      sold: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sold'],
      )!,
      soldPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sold_price'],
      ),
      soldTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sold_to'],
      ),
      rejected: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejected'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $ProductSalesTable createAlias(String alias) {
    return $ProductSalesTable(attachedDatabase, alias);
  }
}

class ProductSaleRow extends DataClass implements Insertable<ProductSaleRow> {
  final String id;
  final String body;
  final int priceSoles;
  final bool sold;
  final int? soldPrice;
  final String? soldTo;
  final String rejected;
  final DateTime createdAt;
  final String? photoPath;
  const ProductSaleRow({
    required this.id,
    required this.body,
    required this.priceSoles,
    required this.sold,
    this.soldPrice,
    this.soldTo,
    required this.rejected,
    required this.createdAt,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    map['price_soles'] = Variable<int>(priceSoles);
    map['sold'] = Variable<bool>(sold);
    if (!nullToAbsent || soldPrice != null) {
      map['sold_price'] = Variable<int>(soldPrice);
    }
    if (!nullToAbsent || soldTo != null) {
      map['sold_to'] = Variable<String>(soldTo);
    }
    map['rejected'] = Variable<String>(rejected);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  ProductSalesCompanion toCompanion(bool nullToAbsent) {
    return ProductSalesCompanion(
      id: Value(id),
      body: Value(body),
      priceSoles: Value(priceSoles),
      sold: Value(sold),
      soldPrice: soldPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(soldPrice),
      soldTo: soldTo == null && nullToAbsent
          ? const Value.absent()
          : Value(soldTo),
      rejected: Value(rejected),
      createdAt: Value(createdAt),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory ProductSaleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSaleRow(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      priceSoles: serializer.fromJson<int>(json['priceSoles']),
      sold: serializer.fromJson<bool>(json['sold']),
      soldPrice: serializer.fromJson<int?>(json['soldPrice']),
      soldTo: serializer.fromJson<String?>(json['soldTo']),
      rejected: serializer.fromJson<String>(json['rejected']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'priceSoles': serializer.toJson<int>(priceSoles),
      'sold': serializer.toJson<bool>(sold),
      'soldPrice': serializer.toJson<int?>(soldPrice),
      'soldTo': serializer.toJson<String?>(soldTo),
      'rejected': serializer.toJson<String>(rejected),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  ProductSaleRow copyWith({
    String? id,
    String? body,
    int? priceSoles,
    bool? sold,
    Value<int?> soldPrice = const Value.absent(),
    Value<String?> soldTo = const Value.absent(),
    String? rejected,
    DateTime? createdAt,
    Value<String?> photoPath = const Value.absent(),
  }) => ProductSaleRow(
    id: id ?? this.id,
    body: body ?? this.body,
    priceSoles: priceSoles ?? this.priceSoles,
    sold: sold ?? this.sold,
    soldPrice: soldPrice.present ? soldPrice.value : this.soldPrice,
    soldTo: soldTo.present ? soldTo.value : this.soldTo,
    rejected: rejected ?? this.rejected,
    createdAt: createdAt ?? this.createdAt,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  ProductSaleRow copyWithCompanion(ProductSalesCompanion data) {
    return ProductSaleRow(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      priceSoles: data.priceSoles.present
          ? data.priceSoles.value
          : this.priceSoles,
      sold: data.sold.present ? data.sold.value : this.sold,
      soldPrice: data.soldPrice.present ? data.soldPrice.value : this.soldPrice,
      soldTo: data.soldTo.present ? data.soldTo.value : this.soldTo,
      rejected: data.rejected.present ? data.rejected.value : this.rejected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductSaleRow(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('sold: $sold, ')
          ..write('soldPrice: $soldPrice, ')
          ..write('soldTo: $soldTo, ')
          ..write('rejected: $rejected, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    body,
    priceSoles,
    sold,
    soldPrice,
    soldTo,
    rejected,
    createdAt,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductSaleRow &&
          other.id == this.id &&
          other.body == this.body &&
          other.priceSoles == this.priceSoles &&
          other.sold == this.sold &&
          other.soldPrice == this.soldPrice &&
          other.soldTo == this.soldTo &&
          other.rejected == this.rejected &&
          other.createdAt == this.createdAt &&
          other.photoPath == this.photoPath);
}

class ProductSalesCompanion extends UpdateCompanion<ProductSaleRow> {
  final Value<String> id;
  final Value<String> body;
  final Value<int> priceSoles;
  final Value<bool> sold;
  final Value<int?> soldPrice;
  final Value<String?> soldTo;
  final Value<String> rejected;
  final Value<DateTime> createdAt;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const ProductSalesCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.priceSoles = const Value.absent(),
    this.sold = const Value.absent(),
    this.soldPrice = const Value.absent(),
    this.soldTo = const Value.absent(),
    this.rejected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSalesCompanion.insert({
    required String id,
    required String body,
    required int priceSoles,
    this.sold = const Value.absent(),
    this.soldPrice = const Value.absent(),
    this.soldTo = const Value.absent(),
    this.rejected = const Value.absent(),
    required DateTime createdAt,
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       body = Value(body),
       priceSoles = Value(priceSoles),
       createdAt = Value(createdAt);
  static Insertable<ProductSaleRow> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<int>? priceSoles,
    Expression<bool>? sold,
    Expression<int>? soldPrice,
    Expression<String>? soldTo,
    Expression<String>? rejected,
    Expression<DateTime>? createdAt,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (priceSoles != null) 'price_soles': priceSoles,
      if (sold != null) 'sold': sold,
      if (soldPrice != null) 'sold_price': soldPrice,
      if (soldTo != null) 'sold_to': soldTo,
      if (rejected != null) 'rejected': rejected,
      if (createdAt != null) 'created_at': createdAt,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductSalesCompanion copyWith({
    Value<String>? id,
    Value<String>? body,
    Value<int>? priceSoles,
    Value<bool>? sold,
    Value<int?>? soldPrice,
    Value<String?>? soldTo,
    Value<String>? rejected,
    Value<DateTime>? createdAt,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return ProductSalesCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      priceSoles: priceSoles ?? this.priceSoles,
      sold: sold ?? this.sold,
      soldPrice: soldPrice ?? this.soldPrice,
      soldTo: soldTo ?? this.soldTo,
      rejected: rejected ?? this.rejected,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (priceSoles.present) {
      map['price_soles'] = Variable<int>(priceSoles.value);
    }
    if (sold.present) {
      map['sold'] = Variable<bool>(sold.value);
    }
    if (soldPrice.present) {
      map['sold_price'] = Variable<int>(soldPrice.value);
    }
    if (soldTo.present) {
      map['sold_to'] = Variable<String>(soldTo.value);
    }
    if (rejected.present) {
      map['rejected'] = Variable<String>(rejected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductSalesCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('priceSoles: $priceSoles, ')
          ..write('sold: $sold, ')
          ..write('soldPrice: $soldPrice, ')
          ..write('soldTo: $soldTo, ')
          ..write('rejected: $rejected, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WallOffersTable extends WallOffers
    with TableInfo<$WallOffersTable, WallOfferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WallOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mode, body, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wall_offers';
  @override
  VerificationContext validateIntegrity(
    Insertable<WallOfferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WallOfferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WallOfferRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WallOffersTable createAlias(String alias) {
    return $WallOffersTable(attachedDatabase, alias);
  }
}

class WallOfferRow extends DataClass implements Insertable<WallOfferRow> {
  final String id;
  final String mode;
  final String body;
  final DateTime createdAt;
  const WallOfferRow({
    required this.id,
    required this.mode,
    required this.body,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mode'] = Variable<String>(mode);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WallOffersCompanion toCompanion(bool nullToAbsent) {
    return WallOffersCompanion(
      id: Value(id),
      mode: Value(mode),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory WallOfferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WallOfferRow(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<String>(mode),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WallOfferRow copyWith({
    String? id,
    String? mode,
    String? body,
    DateTime? createdAt,
  }) => WallOfferRow(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
  );
  WallOfferRow copyWithCompanion(WallOffersCompanion data) {
    return WallOfferRow(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WallOfferRow(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mode, body, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WallOfferRow &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class WallOffersCompanion extends UpdateCompanion<WallOfferRow> {
  final Value<String> id;
  final Value<String> mode;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WallOffersCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WallOffersCompanion.insert({
    required String id,
    required String mode,
    required String body,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<WallOfferRow> custom({
    Expression<String>? id,
    Expression<String>? mode,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WallOffersCompanion copyWith({
    Value<String>? id,
    Value<String>? mode,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WallOffersCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WallOffersCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NeedsTable needs = $NeedsTable(this);
  late final $OutboxOpsTable outboxOps = $OutboxOpsTable(this);
  late final $DealsTable deals = $DealsTable(this);
  late final $InteractionsTable interactions = $InteractionsTable(this);
  late final $EmergencyPostsTable emergencyPosts = $EmergencyPostsTable(this);
  late final $ServiceOffersTable serviceOffers = $ServiceOffersTable(this);
  late final $JobProposalsTable jobProposals = $JobProposalsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $ProductSalesTable productSales = $ProductSalesTable(this);
  late final $WallOffersTable wallOffers = $WallOffersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    needs,
    outboxOps,
    deals,
    interactions,
    emergencyPosts,
    serviceOffers,
    jobProposals,
    chatMessages,
    productSales,
    wallOffers,
  ];
}

typedef $$NeedsTableCreateCompanionBuilder = NeedsCompanion Function({
  required String id,
  required String kind,
  required String body,
  required String urgency,
  required DateTime createdAt,
  required String syncStatus,
  Value<String?> details,
  Value<String?> photoPath,
  Value<int> rowid,
});
typedef $$NeedsTableUpdateCompanionBuilder = NeedsCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String> body,
  Value<String> urgency,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<String?> details,
  Value<String?> photoPath,
  Value<int> rowid,
});

class $$NeedsTableFilterComposer extends Composer<_$AppDatabase, $NeedsTable> {
  $$NeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urgency => $composableBuilder(
    column: $table.urgency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $NeedsTable> {
  $$NeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urgency => $composableBuilder(
    column: $table.urgency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NeedsTable> {
  $$NeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get urgency =>
      $composableBuilder(column: $table.urgency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$NeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NeedsTable,
          NeedRow,
          $$NeedsTableFilterComposer,
          $$NeedsTableOrderingComposer,
          $$NeedsTableAnnotationComposer,
          $$NeedsTableCreateCompanionBuilder,
          $$NeedsTableUpdateCompanionBuilder,
          (NeedRow, BaseReferences<_$AppDatabase, $NeedsTable, NeedRow>),
          NeedRow,
          PrefetchHooks Function()
        > {
  $$NeedsTableTableManager(_$AppDatabase db, $NeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> urgency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NeedsCompanion(
                id: id,
                kind: kind,
                body: body,
                urgency: urgency,
                createdAt: createdAt,
                syncStatus: syncStatus,
                details: details,
                photoPath: photoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String body,
                required String urgency,
                required DateTime createdAt,
                required String syncStatus,
                Value<String?> details = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NeedsCompanion.insert(
                id: id,
                kind: kind,
                body: body,
                urgency: urgency,
                createdAt: createdAt,
                syncStatus: syncStatus,
                details: details,
                photoPath: photoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NeedsTable, NeedRow>(table),
                  BaseReferences<_$AppDatabase, $NeedsTable, NeedRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NeedsTable,
      NeedRow,
      $$NeedsTableFilterComposer,
      $$NeedsTableOrderingComposer,
      $$NeedsTableAnnotationComposer,
      $$NeedsTableCreateCompanionBuilder,
      $$NeedsTableUpdateCompanionBuilder,
      (NeedRow, BaseReferences<_$AppDatabase, $NeedsTable, NeedRow>),
      NeedRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxOpsTableCreateCompanionBuilder = OutboxOpsCompanion Function({
  required String id,
  required String opType,
  required String payload,
  Value<int> attempts,
  required DateTime createdAt,
  Value<String?> lastError,
  Value<int> rowid,
});
typedef $$OutboxOpsTableUpdateCompanionBuilder = OutboxOpsCompanion Function({
  Value<String> id,
  Value<String> opType,
  Value<String> payload,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<String?> lastError,
  Value<int> rowid,
});

class $$OutboxOpsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get opType =>
      $composableBuilder(column: $table.opType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxOpsTable,
          OutboxRow,
          $$OutboxOpsTableFilterComposer,
          $$OutboxOpsTableOrderingComposer,
          $$OutboxOpsTableAnnotationComposer,
          $$OutboxOpsTableCreateCompanionBuilder,
          $$OutboxOpsTableUpdateCompanionBuilder,
          (
            OutboxRow,
            BaseReferences<_$AppDatabase, $OutboxOpsTable, OutboxRow>,
          ),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxOpsTableTableManager(_$AppDatabase db, $OutboxOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> opType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOpsCompanion(
                id: id,
                opType: opType,
                payload: payload,
                attempts: attempts,
                createdAt: createdAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String opType,
                required String payload,
                Value<int> attempts = const Value.absent(),
                required DateTime createdAt,
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOpsCompanion.insert(
                id: id,
                opType: opType,
                payload: payload,
                attempts: attempts,
                createdAt: createdAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxOpsTable, OutboxRow>(table),
                  BaseReferences<_$AppDatabase, $OutboxOpsTable, OutboxRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxOpsTable,
      OutboxRow,
      $$OutboxOpsTableFilterComposer,
      $$OutboxOpsTableOrderingComposer,
      $$OutboxOpsTableAnnotationComposer,
      $$OutboxOpsTableCreateCompanionBuilder,
      $$OutboxOpsTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxOpsTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$DealsTableCreateCompanionBuilder = DealsCompanion Function({
  required String id,
  required String needId,
  required String providerId,
  required String providerName,
  required int priceSoles,
  required String priceLabel,
  required String code,
  required String status,
  required DateTime acceptedAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$DealsTableUpdateCompanionBuilder = DealsCompanion Function({
  Value<String> id,
  Value<String> needId,
  Value<String> providerId,
  Value<String> providerName,
  Value<int> priceSoles,
  Value<String> priceLabel,
  Value<String> code,
  Value<String> status,
  Value<DateTime> acceptedAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$DealsTableFilterComposer extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get needId => $composableBuilder(
    column: $table.needId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceLabel => $composableBuilder(
    column: $table.priceLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
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
}

class $$DealsTableOrderingComposer
    extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get needId => $composableBuilder(
    column: $table.needId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceLabel => $composableBuilder(
    column: $table.priceLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
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
}

class $$DealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DealsTable> {
  $$DealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get needId =>
      $composableBuilder(column: $table.needId, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceLabel => $composableBuilder(
    column: $table.priceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$DealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DealsTable,
          DealRow,
          $$DealsTableFilterComposer,
          $$DealsTableOrderingComposer,
          $$DealsTableAnnotationComposer,
          $$DealsTableCreateCompanionBuilder,
          $$DealsTableUpdateCompanionBuilder,
          (DealRow, BaseReferences<_$AppDatabase, $DealsTable, DealRow>),
          DealRow,
          PrefetchHooks Function()
        > {
  $$DealsTableTableManager(_$AppDatabase db, $DealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> needId = const Value.absent(),
                Value<String> providerId = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<int> priceSoles = const Value.absent(),
                Value<String> priceLabel = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> acceptedAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DealsCompanion(
                id: id,
                needId: needId,
                providerId: providerId,
                providerName: providerName,
                priceSoles: priceSoles,
                priceLabel: priceLabel,
                code: code,
                status: status,
                acceptedAt: acceptedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String needId,
                required String providerId,
                required String providerName,
                required int priceSoles,
                required String priceLabel,
                required String code,
                required String status,
                required DateTime acceptedAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DealsCompanion.insert(
                id: id,
                needId: needId,
                providerId: providerId,
                providerName: providerName,
                priceSoles: priceSoles,
                priceLabel: priceLabel,
                code: code,
                status: status,
                acceptedAt: acceptedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DealsTable, DealRow>(table),
                  BaseReferences<_$AppDatabase, $DealsTable, DealRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DealsTable,
      DealRow,
      $$DealsTableFilterComposer,
      $$DealsTableOrderingComposer,
      $$DealsTableAnnotationComposer,
      $$DealsTableCreateCompanionBuilder,
      $$DealsTableUpdateCompanionBuilder,
      (DealRow, BaseReferences<_$AppDatabase, $DealsTable, DealRow>),
      DealRow,
      PrefetchHooks Function()
    >;
typedef $$InteractionsTableCreateCompanionBuilder =
    InteractionsCompanion Function({
      required String id,
      required String dealId,
      required String providerId,
      required String raterId,
      required int stars,
      required bool recommended,
      required DateTime closedAt,
      Value<String> comment,
      Value<int> rowid,
    });
typedef $$InteractionsTableUpdateCompanionBuilder =
    InteractionsCompanion Function({
      Value<String> id,
      Value<String> dealId,
      Value<String> providerId,
      Value<String> raterId,
      Value<int> stars,
      Value<bool> recommended,
      Value<DateTime> closedAt,
      Value<String> comment,
      Value<int> rowid,
    });

class $$InteractionsTableFilterComposer
    extends Composer<_$AppDatabase, $InteractionsTable> {
  $$InteractionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get raterId => $composableBuilder(
    column: $table.raterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recommended => $composableBuilder(
    column: $table.recommended,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InteractionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InteractionsTable> {
  $$InteractionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get raterId => $composableBuilder(
    column: $table.raterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recommended => $composableBuilder(
    column: $table.recommended,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InteractionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InteractionsTable> {
  $$InteractionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dealId =>
      $composableBuilder(column: $table.dealId, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get raterId =>
      $composableBuilder(column: $table.raterId, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<bool> get recommended => $composableBuilder(
    column: $table.recommended,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$InteractionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InteractionsTable,
          InteractionRow,
          $$InteractionsTableFilterComposer,
          $$InteractionsTableOrderingComposer,
          $$InteractionsTableAnnotationComposer,
          $$InteractionsTableCreateCompanionBuilder,
          $$InteractionsTableUpdateCompanionBuilder,
          (
            InteractionRow,
            BaseReferences<_$AppDatabase, $InteractionsTable, InteractionRow>,
          ),
          InteractionRow,
          PrefetchHooks Function()
        > {
  $$InteractionsTableTableManager(_$AppDatabase db, $InteractionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InteractionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InteractionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InteractionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dealId = const Value.absent(),
                Value<String> providerId = const Value.absent(),
                Value<String> raterId = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<bool> recommended = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InteractionsCompanion(
                id: id,
                dealId: dealId,
                providerId: providerId,
                raterId: raterId,
                stars: stars,
                recommended: recommended,
                closedAt: closedAt,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dealId,
                required String providerId,
                required String raterId,
                required int stars,
                required bool recommended,
                required DateTime closedAt,
                Value<String> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InteractionsCompanion.insert(
                id: id,
                dealId: dealId,
                providerId: providerId,
                raterId: raterId,
                stars: stars,
                recommended: recommended,
                closedAt: closedAt,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InteractionsTable, InteractionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InteractionsTable,
                    InteractionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InteractionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InteractionsTable,
      InteractionRow,
      $$InteractionsTableFilterComposer,
      $$InteractionsTableOrderingComposer,
      $$InteractionsTableAnnotationComposer,
      $$InteractionsTableCreateCompanionBuilder,
      $$InteractionsTableUpdateCompanionBuilder,
      (
        InteractionRow,
        BaseReferences<_$AppDatabase, $InteractionsTable, InteractionRow>,
      ),
      InteractionRow,
      PrefetchHooks Function()
    >;
typedef $$EmergencyPostsTableCreateCompanionBuilder =
    EmergencyPostsCompanion Function({
      required String id,
      required String type,
      required String why,
      Value<String> needs,
      required DateTime createdAt,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$EmergencyPostsTableUpdateCompanionBuilder =
    EmergencyPostsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> why,
      Value<String> needs,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$EmergencyPostsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyPostsTable> {
  $$EmergencyPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get why => $composableBuilder(
    column: $table.why,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get needs => $composableBuilder(
    column: $table.needs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyPostsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyPostsTable> {
  $$EmergencyPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get why => $composableBuilder(
    column: $table.why,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get needs => $composableBuilder(
    column: $table.needs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyPostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyPostsTable> {
  $$EmergencyPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get why =>
      $composableBuilder(column: $table.why, builder: (column) => column);

  GeneratedColumn<String> get needs =>
      $composableBuilder(column: $table.needs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$EmergencyPostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyPostsTable,
          EmergencyRow,
          $$EmergencyPostsTableFilterComposer,
          $$EmergencyPostsTableOrderingComposer,
          $$EmergencyPostsTableAnnotationComposer,
          $$EmergencyPostsTableCreateCompanionBuilder,
          $$EmergencyPostsTableUpdateCompanionBuilder,
          (
            EmergencyRow,
            BaseReferences<_$AppDatabase, $EmergencyPostsTable, EmergencyRow>,
          ),
          EmergencyRow,
          PrefetchHooks Function()
        > {
  $$EmergencyPostsTableTableManager(
    _$AppDatabase db,
    $EmergencyPostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> why = const Value.absent(),
                Value<String> needs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyPostsCompanion(
                id: id,
                type: type,
                why: why,
                needs: needs,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String why,
                Value<String> needs = const Value.absent(),
                required DateTime createdAt,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => EmergencyPostsCompanion.insert(
                id: id,
                type: type,
                why: why,
                needs: needs,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyPostsTable, EmergencyRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmergencyPostsTable,
                    EmergencyRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyPostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyPostsTable,
      EmergencyRow,
      $$EmergencyPostsTableFilterComposer,
      $$EmergencyPostsTableOrderingComposer,
      $$EmergencyPostsTableAnnotationComposer,
      $$EmergencyPostsTableCreateCompanionBuilder,
      $$EmergencyPostsTableUpdateCompanionBuilder,
      (
        EmergencyRow,
        BaseReferences<_$AppDatabase, $EmergencyPostsTable, EmergencyRow>,
      ),
      EmergencyRow,
      PrefetchHooks Function()
    >;
typedef $$ServiceOffersTableCreateCompanionBuilder =
    ServiceOffersCompanion Function({
      required String id,
      required String trade,
      required String availability,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ServiceOffersTableUpdateCompanionBuilder =
    ServiceOffersCompanion Function({
      Value<String> id,
      Value<String> trade,
      Value<String> availability,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ServiceOffersTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceOffersTable> {
  $$ServiceOffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trade => $composableBuilder(
    column: $table.trade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceOffersTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceOffersTable> {
  $$ServiceOffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trade => $composableBuilder(
    column: $table.trade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceOffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceOffersTable> {
  $$ServiceOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trade =>
      $composableBuilder(column: $table.trade, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ServiceOffersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceOffersTable,
          ServiceOfferRow,
          $$ServiceOffersTableFilterComposer,
          $$ServiceOffersTableOrderingComposer,
          $$ServiceOffersTableAnnotationComposer,
          $$ServiceOffersTableCreateCompanionBuilder,
          $$ServiceOffersTableUpdateCompanionBuilder,
          (
            ServiceOfferRow,
            BaseReferences<_$AppDatabase, $ServiceOffersTable, ServiceOfferRow>,
          ),
          ServiceOfferRow,
          PrefetchHooks Function()
        > {
  $$ServiceOffersTableTableManager(_$AppDatabase db, $ServiceOffersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trade = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceOffersCompanion(
                id: id,
                trade: trade,
                availability: availability,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trade,
                required String availability,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ServiceOffersCompanion.insert(
                id: id,
                trade: trade,
                availability: availability,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServiceOffersTable, ServiceOfferRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ServiceOffersTable,
                    ServiceOfferRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceOffersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceOffersTable,
      ServiceOfferRow,
      $$ServiceOffersTableFilterComposer,
      $$ServiceOffersTableOrderingComposer,
      $$ServiceOffersTableAnnotationComposer,
      $$ServiceOffersTableCreateCompanionBuilder,
      $$ServiceOffersTableUpdateCompanionBuilder,
      (
        ServiceOfferRow,
        BaseReferences<_$AppDatabase, $ServiceOffersTable, ServiceOfferRow>,
      ),
      ServiceOfferRow,
      PrefetchHooks Function()
    >;
typedef $$JobProposalsTableCreateCompanionBuilder =
    JobProposalsCompanion Function({
      required String jobId,
      required int priceSoles,
      required DateTime sentAt,
      Value<int> rowid,
    });
typedef $$JobProposalsTableUpdateCompanionBuilder =
    JobProposalsCompanion Function({
      Value<String> jobId,
      Value<int> priceSoles,
      Value<DateTime> sentAt,
      Value<int> rowid,
    });

class $$JobProposalsTableFilterComposer
    extends Composer<_$AppDatabase, $JobProposalsTable> {
  $$JobProposalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JobProposalsTableOrderingComposer
    extends Composer<_$AppDatabase, $JobProposalsTable> {
  $$JobProposalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JobProposalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobProposalsTable> {
  $$JobProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get jobId =>
      $composableBuilder(column: $table.jobId, builder: (column) => column);

  GeneratedColumn<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$JobProposalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JobProposalsTable,
          JobProposalRow,
          $$JobProposalsTableFilterComposer,
          $$JobProposalsTableOrderingComposer,
          $$JobProposalsTableAnnotationComposer,
          $$JobProposalsTableCreateCompanionBuilder,
          $$JobProposalsTableUpdateCompanionBuilder,
          (
            JobProposalRow,
            BaseReferences<_$AppDatabase, $JobProposalsTable, JobProposalRow>,
          ),
          JobProposalRow,
          PrefetchHooks Function()
        > {
  $$JobProposalsTableTableManager(_$AppDatabase db, $JobProposalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JobProposalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> jobId = const Value.absent(),
                Value<int> priceSoles = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JobProposalsCompanion(
                jobId: jobId,
                priceSoles: priceSoles,
                sentAt: sentAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String jobId,
                required int priceSoles,
                required DateTime sentAt,
                Value<int> rowid = const Value.absent(),
              }) => JobProposalsCompanion.insert(
                jobId: jobId,
                priceSoles: priceSoles,
                sentAt: sentAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JobProposalsTable, JobProposalRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JobProposalsTable,
                    JobProposalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JobProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JobProposalsTable,
      JobProposalRow,
      $$JobProposalsTableFilterComposer,
      $$JobProposalsTableOrderingComposer,
      $$JobProposalsTableAnnotationComposer,
      $$JobProposalsTableCreateCompanionBuilder,
      $$JobProposalsTableUpdateCompanionBuilder,
      (
        JobProposalRow,
        BaseReferences<_$AppDatabase, $JobProposalsTable, JobProposalRow>,
      ),
      JobProposalRow,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      required String id,
      required String dealId,
      required bool fromMe,
      required String body,
      Value<bool> isExample,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<String> id,
      Value<String> dealId,
      Value<bool> fromMe,
      Value<String> body,
      Value<bool> isExample,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromMe => $composableBuilder(
    column: $table.fromMe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExample => $composableBuilder(
    column: $table.isExample,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromMe => $composableBuilder(
    column: $table.fromMe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExample => $composableBuilder(
    column: $table.isExample,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dealId =>
      $composableBuilder(column: $table.dealId, builder: (column) => column);

  GeneratedColumn<bool> get fromMe =>
      $composableBuilder(column: $table.fromMe, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isExample =>
      $composableBuilder(column: $table.isExample, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageRow,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessageRow,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
          ),
          ChatMessageRow,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dealId = const Value.absent(),
                Value<bool> fromMe = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isExample = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                dealId: dealId,
                fromMe: fromMe,
                body: body,
                isExample: isExample,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dealId,
                required bool fromMe,
                required String body,
                Value<bool> isExample = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                dealId: dealId,
                fromMe: fromMe,
                body: body,
                isExample: isExample,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatMessagesTable, ChatMessageRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChatMessagesTable,
                    ChatMessageRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageRow,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessageRow,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageRow>,
      ),
      ChatMessageRow,
      PrefetchHooks Function()
    >;
typedef $$ProductSalesTableCreateCompanionBuilder =
    ProductSalesCompanion Function({
      required String id,
      required String body,
      required int priceSoles,
      Value<bool> sold,
      Value<int?> soldPrice,
      Value<String?> soldTo,
      Value<String> rejected,
      required DateTime createdAt,
      Value<String?> photoPath,
      Value<int> rowid,
    });
typedef $$ProductSalesTableUpdateCompanionBuilder =
    ProductSalesCompanion Function({
      Value<String> id,
      Value<String> body,
      Value<int> priceSoles,
      Value<bool> sold,
      Value<int?> soldPrice,
      Value<String?> soldTo,
      Value<String> rejected,
      Value<DateTime> createdAt,
      Value<String?> photoPath,
      Value<int> rowid,
    });

class $$ProductSalesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductSalesTable> {
  $$ProductSalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sold => $composableBuilder(
    column: $table.sold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get soldPrice => $composableBuilder(
    column: $table.soldPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soldTo => $composableBuilder(
    column: $table.soldTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejected => $composableBuilder(
    column: $table.rejected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductSalesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductSalesTable> {
  $$ProductSalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sold => $composableBuilder(
    column: $table.sold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get soldPrice => $composableBuilder(
    column: $table.soldPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soldTo => $composableBuilder(
    column: $table.soldTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejected => $composableBuilder(
    column: $table.rejected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductSalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductSalesTable> {
  $$ProductSalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get priceSoles => $composableBuilder(
    column: $table.priceSoles,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sold =>
      $composableBuilder(column: $table.sold, builder: (column) => column);

  GeneratedColumn<int> get soldPrice =>
      $composableBuilder(column: $table.soldPrice, builder: (column) => column);

  GeneratedColumn<String> get soldTo =>
      $composableBuilder(column: $table.soldTo, builder: (column) => column);

  GeneratedColumn<String> get rejected =>
      $composableBuilder(column: $table.rejected, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$ProductSalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductSalesTable,
          ProductSaleRow,
          $$ProductSalesTableFilterComposer,
          $$ProductSalesTableOrderingComposer,
          $$ProductSalesTableAnnotationComposer,
          $$ProductSalesTableCreateCompanionBuilder,
          $$ProductSalesTableUpdateCompanionBuilder,
          (
            ProductSaleRow,
            BaseReferences<_$AppDatabase, $ProductSalesTable, ProductSaleRow>,
          ),
          ProductSaleRow,
          PrefetchHooks Function()
        > {
  $$ProductSalesTableTableManager(_$AppDatabase db, $ProductSalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductSalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductSalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductSalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> priceSoles = const Value.absent(),
                Value<bool> sold = const Value.absent(),
                Value<int?> soldPrice = const Value.absent(),
                Value<String?> soldTo = const Value.absent(),
                Value<String> rejected = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductSalesCompanion(
                id: id,
                body: body,
                priceSoles: priceSoles,
                sold: sold,
                soldPrice: soldPrice,
                soldTo: soldTo,
                rejected: rejected,
                createdAt: createdAt,
                photoPath: photoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String body,
                required int priceSoles,
                Value<bool> sold = const Value.absent(),
                Value<int?> soldPrice = const Value.absent(),
                Value<String?> soldTo = const Value.absent(),
                Value<String> rejected = const Value.absent(),
                required DateTime createdAt,
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductSalesCompanion.insert(
                id: id,
                body: body,
                priceSoles: priceSoles,
                sold: sold,
                soldPrice: soldPrice,
                soldTo: soldTo,
                rejected: rejected,
                createdAt: createdAt,
                photoPath: photoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductSalesTable, ProductSaleRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProductSalesTable,
                    ProductSaleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductSalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductSalesTable,
      ProductSaleRow,
      $$ProductSalesTableFilterComposer,
      $$ProductSalesTableOrderingComposer,
      $$ProductSalesTableAnnotationComposer,
      $$ProductSalesTableCreateCompanionBuilder,
      $$ProductSalesTableUpdateCompanionBuilder,
      (
        ProductSaleRow,
        BaseReferences<_$AppDatabase, $ProductSalesTable, ProductSaleRow>,
      ),
      ProductSaleRow,
      PrefetchHooks Function()
    >;
typedef $$WallOffersTableCreateCompanionBuilder = WallOffersCompanion Function({
  required String id,
  required String mode,
  required String body,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$WallOffersTableUpdateCompanionBuilder = WallOffersCompanion Function({
  Value<String> id,
  Value<String> mode,
  Value<String> body,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$WallOffersTableFilterComposer
    extends Composer<_$AppDatabase, $WallOffersTable> {
  $$WallOffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WallOffersTableOrderingComposer
    extends Composer<_$AppDatabase, $WallOffersTable> {
  $$WallOffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WallOffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WallOffersTable> {
  $$WallOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WallOffersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WallOffersTable,
          WallOfferRow,
          $$WallOffersTableFilterComposer,
          $$WallOffersTableOrderingComposer,
          $$WallOffersTableAnnotationComposer,
          $$WallOffersTableCreateCompanionBuilder,
          $$WallOffersTableUpdateCompanionBuilder,
          (
            WallOfferRow,
            BaseReferences<_$AppDatabase, $WallOffersTable, WallOfferRow>,
          ),
          WallOfferRow,
          PrefetchHooks Function()
        > {
  $$WallOffersTableTableManager(_$AppDatabase db, $WallOffersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WallOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WallOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WallOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WallOffersCompanion(
                id: id,
                mode: mode,
                body: body,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mode,
                required String body,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WallOffersCompanion.insert(
                id: id,
                mode: mode,
                body: body,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WallOffersTable, WallOfferRow>(table),
                  BaseReferences<_$AppDatabase, $WallOffersTable, WallOfferRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WallOffersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WallOffersTable,
      WallOfferRow,
      $$WallOffersTableFilterComposer,
      $$WallOffersTableOrderingComposer,
      $$WallOffersTableAnnotationComposer,
      $$WallOffersTableCreateCompanionBuilder,
      $$WallOffersTableUpdateCompanionBuilder,
      (
        WallOfferRow,
        BaseReferences<_$AppDatabase, $WallOffersTable, WallOfferRow>,
      ),
      WallOfferRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NeedsTableTableManager get needs =>
      $$NeedsTableTableManager(_db, _db.needs);
  $$OutboxOpsTableTableManager get outboxOps =>
      $$OutboxOpsTableTableManager(_db, _db.outboxOps);
  $$DealsTableTableManager get deals =>
      $$DealsTableTableManager(_db, _db.deals);
  $$InteractionsTableTableManager get interactions =>
      $$InteractionsTableTableManager(_db, _db.interactions);
  $$EmergencyPostsTableTableManager get emergencyPosts =>
      $$EmergencyPostsTableTableManager(_db, _db.emergencyPosts);
  $$ServiceOffersTableTableManager get serviceOffers =>
      $$ServiceOffersTableTableManager(_db, _db.serviceOffers);
  $$JobProposalsTableTableManager get jobProposals =>
      $$JobProposalsTableTableManager(_db, _db.jobProposals);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$ProductSalesTableTableManager get productSales =>
      $$ProductSalesTableTableManager(_db, _db.productSales);
  $$WallOffersTableTableManager get wallOffers =>
      $$WallOffersTableTableManager(_db, _db.wallOffers);
}
