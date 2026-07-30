// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
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
  List<GeneratedColumn> get $columns => [id, name, avatarId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
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
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String name;
  final String avatarId;
  final DateTime createdAt;
  const ProfileRow({
    required this.id,
    required this.name,
    required this.avatarId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar_id'] = Variable<String>(avatarId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      avatarId: Value(avatarId),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarId': serializer.toJson<String>(avatarId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? name,
    String? avatarId,
    DateTime? createdAt,
  }) => ProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    avatarId: avatarId ?? this.avatarId,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarId: $avatarId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarId == this.avatarId &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatarId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    required String avatarId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       avatarId = Value(avatarId),
       createdAt = Value(createdAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarId != null) 'avatar_id': avatarId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? avatarId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
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
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarId: $avatarId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivationsTable extends Activations
    with TableInfo<$ActivationsTable, ActivationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, exerciseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, exerciseId};
  @override
  ActivationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivationRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
    );
  }

  @override
  $ActivationsTable createAlias(String alias) {
    return $ActivationsTable(attachedDatabase, alias);
  }
}

class ActivationRow extends DataClass implements Insertable<ActivationRow> {
  final String profileId;
  final String exerciseId;
  const ActivationRow({required this.profileId, required this.exerciseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['exercise_id'] = Variable<String>(exerciseId);
    return map;
  }

  ActivationsCompanion toCompanion(bool nullToAbsent) {
    return ActivationsCompanion(
      profileId: Value(profileId),
      exerciseId: Value(exerciseId),
    );
  }

  factory ActivationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivationRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'exerciseId': serializer.toJson<String>(exerciseId),
    };
  }

  ActivationRow copyWith({String? profileId, String? exerciseId}) =>
      ActivationRow(
        profileId: profileId ?? this.profileId,
        exerciseId: exerciseId ?? this.exerciseId,
      );
  ActivationRow copyWithCompanion(ActivationsCompanion data) {
    return ActivationRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivationRow(')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, exerciseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivationRow &&
          other.profileId == this.profileId &&
          other.exerciseId == this.exerciseId);
}

class ActivationsCompanion extends UpdateCompanion<ActivationRow> {
  final Value<String> profileId;
  final Value<String> exerciseId;
  final Value<int> rowid;
  const ActivationsCompanion({
    this.profileId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivationsCompanion.insert({
    required String profileId,
    required String exerciseId,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       exerciseId = Value(exerciseId);
  static Insertable<ActivationRow> custom({
    Expression<String>? profileId,
    Expression<String>? exerciseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivationsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? exerciseId,
    Value<int>? rowid,
  }) {
    return ActivationsCompanion(
      profileId: profileId ?? this.profileId,
      exerciseId: exerciseId ?? this.exerciseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivationsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerformancesTable extends Performances
    with TableInfo<$PerformancesTable, PerformanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _badgeLevelMeta = const VerificationMeta(
    'badgeLevel',
  );
  @override
  late final GeneratedColumn<int> badgeLevel = GeneratedColumn<int>(
    'badge_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successRatePercentMeta =
      const VerificationMeta('successRatePercent');
  @override
  late final GeneratedColumn<int> successRatePercent = GeneratedColumn<int>(
    'success_rate_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsCountMeta = const VerificationMeta(
    'attemptsCount',
  );
  @override
  late final GeneratedColumn<int> attemptsCount = GeneratedColumn<int>(
    'attempts_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPracticedAtMeta = const VerificationMeta(
    'lastPracticedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPracticedAt =
      GeneratedColumn<DateTime>(
        'last_practiced_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    exerciseId,
    badgeLevel,
    successRatePercent,
    attemptsCount,
    lastPracticedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performances';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('badge_level')) {
      context.handle(
        _badgeLevelMeta,
        badgeLevel.isAcceptableOrUnknown(data['badge_level']!, _badgeLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeLevelMeta);
    }
    if (data.containsKey('success_rate_percent')) {
      context.handle(
        _successRatePercentMeta,
        successRatePercent.isAcceptableOrUnknown(
          data['success_rate_percent']!,
          _successRatePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_successRatePercentMeta);
    }
    if (data.containsKey('attempts_count')) {
      context.handle(
        _attemptsCountMeta,
        attemptsCount.isAcceptableOrUnknown(
          data['attempts_count']!,
          _attemptsCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptsCountMeta);
    }
    if (data.containsKey('last_practiced_at')) {
      context.handle(
        _lastPracticedAtMeta,
        lastPracticedAt.isAcceptableOrUnknown(
          data['last_practiced_at']!,
          _lastPracticedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, exerciseId};
  @override
  PerformanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformanceRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      badgeLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}badge_level'],
      )!,
      successRatePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}success_rate_percent'],
      )!,
      attemptsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts_count'],
      )!,
      lastPracticedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_practiced_at'],
      ),
    );
  }

  @override
  $PerformancesTable createAlias(String alias) {
    return $PerformancesTable(attachedDatabase, alias);
  }
}

class PerformanceRow extends DataClass implements Insertable<PerformanceRow> {
  final String profileId;
  final String exerciseId;
  final int badgeLevel;
  final int successRatePercent;
  final int attemptsCount;
  final DateTime? lastPracticedAt;
  const PerformanceRow({
    required this.profileId,
    required this.exerciseId,
    required this.badgeLevel,
    required this.successRatePercent,
    required this.attemptsCount,
    this.lastPracticedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['badge_level'] = Variable<int>(badgeLevel);
    map['success_rate_percent'] = Variable<int>(successRatePercent);
    map['attempts_count'] = Variable<int>(attemptsCount);
    if (!nullToAbsent || lastPracticedAt != null) {
      map['last_practiced_at'] = Variable<DateTime>(lastPracticedAt);
    }
    return map;
  }

  PerformancesCompanion toCompanion(bool nullToAbsent) {
    return PerformancesCompanion(
      profileId: Value(profileId),
      exerciseId: Value(exerciseId),
      badgeLevel: Value(badgeLevel),
      successRatePercent: Value(successRatePercent),
      attemptsCount: Value(attemptsCount),
      lastPracticedAt: lastPracticedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPracticedAt),
    );
  }

  factory PerformanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformanceRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      badgeLevel: serializer.fromJson<int>(json['badgeLevel']),
      successRatePercent: serializer.fromJson<int>(json['successRatePercent']),
      attemptsCount: serializer.fromJson<int>(json['attemptsCount']),
      lastPracticedAt: serializer.fromJson<DateTime?>(json['lastPracticedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'badgeLevel': serializer.toJson<int>(badgeLevel),
      'successRatePercent': serializer.toJson<int>(successRatePercent),
      'attemptsCount': serializer.toJson<int>(attemptsCount),
      'lastPracticedAt': serializer.toJson<DateTime?>(lastPracticedAt),
    };
  }

  PerformanceRow copyWith({
    String? profileId,
    String? exerciseId,
    int? badgeLevel,
    int? successRatePercent,
    int? attemptsCount,
    Value<DateTime?> lastPracticedAt = const Value.absent(),
  }) => PerformanceRow(
    profileId: profileId ?? this.profileId,
    exerciseId: exerciseId ?? this.exerciseId,
    badgeLevel: badgeLevel ?? this.badgeLevel,
    successRatePercent: successRatePercent ?? this.successRatePercent,
    attemptsCount: attemptsCount ?? this.attemptsCount,
    lastPracticedAt: lastPracticedAt.present
        ? lastPracticedAt.value
        : this.lastPracticedAt,
  );
  PerformanceRow copyWithCompanion(PerformancesCompanion data) {
    return PerformanceRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      badgeLevel: data.badgeLevel.present
          ? data.badgeLevel.value
          : this.badgeLevel,
      successRatePercent: data.successRatePercent.present
          ? data.successRatePercent.value
          : this.successRatePercent,
      attemptsCount: data.attemptsCount.present
          ? data.attemptsCount.value
          : this.attemptsCount,
      lastPracticedAt: data.lastPracticedAt.present
          ? data.lastPracticedAt.value
          : this.lastPracticedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformanceRow(')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('badgeLevel: $badgeLevel, ')
          ..write('successRatePercent: $successRatePercent, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('lastPracticedAt: $lastPracticedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    exerciseId,
    badgeLevel,
    successRatePercent,
    attemptsCount,
    lastPracticedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformanceRow &&
          other.profileId == this.profileId &&
          other.exerciseId == this.exerciseId &&
          other.badgeLevel == this.badgeLevel &&
          other.successRatePercent == this.successRatePercent &&
          other.attemptsCount == this.attemptsCount &&
          other.lastPracticedAt == this.lastPracticedAt);
}

class PerformancesCompanion extends UpdateCompanion<PerformanceRow> {
  final Value<String> profileId;
  final Value<String> exerciseId;
  final Value<int> badgeLevel;
  final Value<int> successRatePercent;
  final Value<int> attemptsCount;
  final Value<DateTime?> lastPracticedAt;
  final Value<int> rowid;
  const PerformancesCompanion({
    this.profileId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.badgeLevel = const Value.absent(),
    this.successRatePercent = const Value.absent(),
    this.attemptsCount = const Value.absent(),
    this.lastPracticedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PerformancesCompanion.insert({
    required String profileId,
    required String exerciseId,
    required int badgeLevel,
    required int successRatePercent,
    required int attemptsCount,
    this.lastPracticedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       exerciseId = Value(exerciseId),
       badgeLevel = Value(badgeLevel),
       successRatePercent = Value(successRatePercent),
       attemptsCount = Value(attemptsCount);
  static Insertable<PerformanceRow> custom({
    Expression<String>? profileId,
    Expression<String>? exerciseId,
    Expression<int>? badgeLevel,
    Expression<int>? successRatePercent,
    Expression<int>? attemptsCount,
    Expression<DateTime>? lastPracticedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (badgeLevel != null) 'badge_level': badgeLevel,
      if (successRatePercent != null)
        'success_rate_percent': successRatePercent,
      if (attemptsCount != null) 'attempts_count': attemptsCount,
      if (lastPracticedAt != null) 'last_practiced_at': lastPracticedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PerformancesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? exerciseId,
    Value<int>? badgeLevel,
    Value<int>? successRatePercent,
    Value<int>? attemptsCount,
    Value<DateTime?>? lastPracticedAt,
    Value<int>? rowid,
  }) {
    return PerformancesCompanion(
      profileId: profileId ?? this.profileId,
      exerciseId: exerciseId ?? this.exerciseId,
      badgeLevel: badgeLevel ?? this.badgeLevel,
      successRatePercent: successRatePercent ?? this.successRatePercent,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (badgeLevel.present) {
      map['badge_level'] = Variable<int>(badgeLevel.value);
    }
    if (successRatePercent.present) {
      map['success_rate_percent'] = Variable<int>(successRatePercent.value);
    }
    if (attemptsCount.present) {
      map['attempts_count'] = Variable<int>(attemptsCount.value);
    }
    if (lastPracticedAt.present) {
      map['last_practiced_at'] = Variable<DateTime>(lastPracticedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformancesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('badgeLevel: $badgeLevel, ')
          ..write('successRatePercent: $successRatePercent, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('lastPracticedAt: $lastPracticedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionAttemptsTable extends QuestionAttempts
    with TableInfo<$QuestionAttemptsTable, QuestionAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionAttemptsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseTimeMsMeta = const VerificationMeta(
    'responseTimeMs',
  );
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
    'response_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta(
    'attemptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
    'attempted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    exerciseId,
    questionId,
    responseTimeMs,
    attemptedAt,
    correct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
        _responseTimeMsMeta,
        responseTimeMs.isAcceptableOrUnknown(
          data['response_time_ms']!,
          _responseTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseTimeMsMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
        _attemptedAtMeta,
        attemptedAt.isAcceptableOrUnknown(
          data['attempted_at']!,
          _attemptedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionAttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      responseTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_ms'],
      )!,
      attemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}attempted_at'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      ),
    );
  }

  @override
  $QuestionAttemptsTable createAlias(String alias) {
    return $QuestionAttemptsTable(attachedDatabase, alias);
  }
}

class QuestionAttemptRow extends DataClass
    implements Insertable<QuestionAttemptRow> {
  final int id;
  final String profileId;
  final String exerciseId;
  final String questionId;
  final int responseTimeMs;
  final DateTime attemptedAt;

  /// Tentative réussie (bonne réponse) ou non (réponse révélée après 2
  /// échecs, cf. PRD 6.2). **Nullable pour les lignes antérieures au suivi
  /// de la justesse** : elles ne portent qu'un temps de réponse, et les
  /// compter d'un côté ou de l'autre fausserait le taux de réussite — elles
  /// sont donc exclues de son calcul (cf. PRD 6.6).
  final bool? correct;
  const QuestionAttemptRow({
    required this.id,
    required this.profileId,
    required this.exerciseId,
    required this.questionId,
    required this.responseTimeMs,
    required this.attemptedAt,
    this.correct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['question_id'] = Variable<String>(questionId);
    map['response_time_ms'] = Variable<int>(responseTimeMs);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    if (!nullToAbsent || correct != null) {
      map['correct'] = Variable<bool>(correct);
    }
    return map;
  }

  QuestionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuestionAttemptsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      exerciseId: Value(exerciseId),
      questionId: Value(questionId),
      responseTimeMs: Value(responseTimeMs),
      attemptedAt: Value(attemptedAt),
      correct: correct == null && nullToAbsent
          ? const Value.absent()
          : Value(correct),
    );
  }

  factory QuestionAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionAttemptRow(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      responseTimeMs: serializer.fromJson<int>(json['responseTimeMs']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
      correct: serializer.fromJson<bool?>(json['correct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<String>(profileId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'questionId': serializer.toJson<String>(questionId),
      'responseTimeMs': serializer.toJson<int>(responseTimeMs),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
      'correct': serializer.toJson<bool?>(correct),
    };
  }

  QuestionAttemptRow copyWith({
    int? id,
    String? profileId,
    String? exerciseId,
    String? questionId,
    int? responseTimeMs,
    DateTime? attemptedAt,
    Value<bool?> correct = const Value.absent(),
  }) => QuestionAttemptRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    exerciseId: exerciseId ?? this.exerciseId,
    questionId: questionId ?? this.questionId,
    responseTimeMs: responseTimeMs ?? this.responseTimeMs,
    attemptedAt: attemptedAt ?? this.attemptedAt,
    correct: correct.present ? correct.value : this.correct,
  );
  QuestionAttemptRow copyWithCompanion(QuestionAttemptsCompanion data) {
    return QuestionAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
      attemptedAt: data.attemptedAt.present
          ? data.attemptedAt.value
          : this.attemptedAt,
      correct: data.correct.present ? data.correct.value : this.correct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttemptRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('questionId: $questionId, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('correct: $correct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    exerciseId,
    questionId,
    responseTimeMs,
    attemptedAt,
    correct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionAttemptRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.exerciseId == this.exerciseId &&
          other.questionId == this.questionId &&
          other.responseTimeMs == this.responseTimeMs &&
          other.attemptedAt == this.attemptedAt &&
          other.correct == this.correct);
}

class QuestionAttemptsCompanion extends UpdateCompanion<QuestionAttemptRow> {
  final Value<int> id;
  final Value<String> profileId;
  final Value<String> exerciseId;
  final Value<String> questionId;
  final Value<int> responseTimeMs;
  final Value<DateTime> attemptedAt;
  final Value<bool?> correct;
  const QuestionAttemptsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.attemptedAt = const Value.absent(),
    this.correct = const Value.absent(),
  });
  QuestionAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String profileId,
    required String exerciseId,
    required String questionId,
    required int responseTimeMs,
    required DateTime attemptedAt,
    this.correct = const Value.absent(),
  }) : profileId = Value(profileId),
       exerciseId = Value(exerciseId),
       questionId = Value(questionId),
       responseTimeMs = Value(responseTimeMs),
       attemptedAt = Value(attemptedAt);
  static Insertable<QuestionAttemptRow> custom({
    Expression<int>? id,
    Expression<String>? profileId,
    Expression<String>? exerciseId,
    Expression<String>? questionId,
    Expression<int>? responseTimeMs,
    Expression<DateTime>? attemptedAt,
    Expression<bool>? correct,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (questionId != null) 'question_id': questionId,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
      if (correct != null) 'correct': correct,
    });
  }

  QuestionAttemptsCompanion copyWith({
    Value<int>? id,
    Value<String>? profileId,
    Value<String>? exerciseId,
    Value<String>? questionId,
    Value<int>? responseTimeMs,
    Value<DateTime>? attemptedAt,
    Value<bool?>? correct,
  }) {
    return QuestionAttemptsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      exerciseId: exerciseId ?? this.exerciseId,
      questionId: questionId ?? this.questionId,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      correct: correct ?? this.correct,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('questionId: $questionId, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('correct: $correct')
          ..write(')'))
        .toString();
  }
}

class $ExerciseSettingsTable extends ExerciseSettings
    with TableInfo<$ExerciseSettingsTable, ExerciseSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionsPerSeriesMeta =
      const VerificationMeta('questionsPerSeries');
  @override
  late final GeneratedColumn<int> questionsPerSeries = GeneratedColumn<int>(
    'questions_per_series',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bronzeThresholdMsMeta = const VerificationMeta(
    'bronzeThresholdMs',
  );
  @override
  late final GeneratedColumn<int> bronzeThresholdMs = GeneratedColumn<int>(
    'bronze_threshold_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _silverThresholdMsMeta = const VerificationMeta(
    'silverThresholdMs',
  );
  @override
  late final GeneratedColumn<int> silverThresholdMs = GeneratedColumn<int>(
    'silver_threshold_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goldThresholdMsMeta = const VerificationMeta(
    'goldThresholdMs',
  );
  @override
  late final GeneratedColumn<int> goldThresholdMs = GeneratedColumn<int>(
    'gold_threshold_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    questionsPerSeries,
    bronzeThresholdMs,
    silverThresholdMs,
    goldThresholdMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('questions_per_series')) {
      context.handle(
        _questionsPerSeriesMeta,
        questionsPerSeries.isAcceptableOrUnknown(
          data['questions_per_series']!,
          _questionsPerSeriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionsPerSeriesMeta);
    }
    if (data.containsKey('bronze_threshold_ms')) {
      context.handle(
        _bronzeThresholdMsMeta,
        bronzeThresholdMs.isAcceptableOrUnknown(
          data['bronze_threshold_ms']!,
          _bronzeThresholdMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bronzeThresholdMsMeta);
    }
    if (data.containsKey('silver_threshold_ms')) {
      context.handle(
        _silverThresholdMsMeta,
        silverThresholdMs.isAcceptableOrUnknown(
          data['silver_threshold_ms']!,
          _silverThresholdMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_silverThresholdMsMeta);
    }
    if (data.containsKey('gold_threshold_ms')) {
      context.handle(
        _goldThresholdMsMeta,
        goldThresholdMs.isAcceptableOrUnknown(
          data['gold_threshold_ms']!,
          _goldThresholdMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goldThresholdMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId};
  @override
  ExerciseSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSettingsRow(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      questionsPerSeries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}questions_per_series'],
      )!,
      bronzeThresholdMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bronze_threshold_ms'],
      )!,
      silverThresholdMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}silver_threshold_ms'],
      )!,
      goldThresholdMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gold_threshold_ms'],
      )!,
    );
  }

  @override
  $ExerciseSettingsTable createAlias(String alias) {
    return $ExerciseSettingsTable(attachedDatabase, alias);
  }
}

class ExerciseSettingsRow extends DataClass
    implements Insertable<ExerciseSettingsRow> {
  final String exerciseId;
  final int questionsPerSeries;
  final int bronzeThresholdMs;
  final int silverThresholdMs;
  final int goldThresholdMs;
  const ExerciseSettingsRow({
    required this.exerciseId,
    required this.questionsPerSeries,
    required this.bronzeThresholdMs,
    required this.silverThresholdMs,
    required this.goldThresholdMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['questions_per_series'] = Variable<int>(questionsPerSeries);
    map['bronze_threshold_ms'] = Variable<int>(bronzeThresholdMs);
    map['silver_threshold_ms'] = Variable<int>(silverThresholdMs);
    map['gold_threshold_ms'] = Variable<int>(goldThresholdMs);
    return map;
  }

  ExerciseSettingsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseSettingsCompanion(
      exerciseId: Value(exerciseId),
      questionsPerSeries: Value(questionsPerSeries),
      bronzeThresholdMs: Value(bronzeThresholdMs),
      silverThresholdMs: Value(silverThresholdMs),
      goldThresholdMs: Value(goldThresholdMs),
    );
  }

  factory ExerciseSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSettingsRow(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      questionsPerSeries: serializer.fromJson<int>(json['questionsPerSeries']),
      bronzeThresholdMs: serializer.fromJson<int>(json['bronzeThresholdMs']),
      silverThresholdMs: serializer.fromJson<int>(json['silverThresholdMs']),
      goldThresholdMs: serializer.fromJson<int>(json['goldThresholdMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'questionsPerSeries': serializer.toJson<int>(questionsPerSeries),
      'bronzeThresholdMs': serializer.toJson<int>(bronzeThresholdMs),
      'silverThresholdMs': serializer.toJson<int>(silverThresholdMs),
      'goldThresholdMs': serializer.toJson<int>(goldThresholdMs),
    };
  }

  ExerciseSettingsRow copyWith({
    String? exerciseId,
    int? questionsPerSeries,
    int? bronzeThresholdMs,
    int? silverThresholdMs,
    int? goldThresholdMs,
  }) => ExerciseSettingsRow(
    exerciseId: exerciseId ?? this.exerciseId,
    questionsPerSeries: questionsPerSeries ?? this.questionsPerSeries,
    bronzeThresholdMs: bronzeThresholdMs ?? this.bronzeThresholdMs,
    silverThresholdMs: silverThresholdMs ?? this.silverThresholdMs,
    goldThresholdMs: goldThresholdMs ?? this.goldThresholdMs,
  );
  ExerciseSettingsRow copyWithCompanion(ExerciseSettingsCompanion data) {
    return ExerciseSettingsRow(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      questionsPerSeries: data.questionsPerSeries.present
          ? data.questionsPerSeries.value
          : this.questionsPerSeries,
      bronzeThresholdMs: data.bronzeThresholdMs.present
          ? data.bronzeThresholdMs.value
          : this.bronzeThresholdMs,
      silverThresholdMs: data.silverThresholdMs.present
          ? data.silverThresholdMs.value
          : this.silverThresholdMs,
      goldThresholdMs: data.goldThresholdMs.present
          ? data.goldThresholdMs.value
          : this.goldThresholdMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSettingsRow(')
          ..write('exerciseId: $exerciseId, ')
          ..write('questionsPerSeries: $questionsPerSeries, ')
          ..write('bronzeThresholdMs: $bronzeThresholdMs, ')
          ..write('silverThresholdMs: $silverThresholdMs, ')
          ..write('goldThresholdMs: $goldThresholdMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    exerciseId,
    questionsPerSeries,
    bronzeThresholdMs,
    silverThresholdMs,
    goldThresholdMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseSettingsRow &&
          other.exerciseId == this.exerciseId &&
          other.questionsPerSeries == this.questionsPerSeries &&
          other.bronzeThresholdMs == this.bronzeThresholdMs &&
          other.silverThresholdMs == this.silverThresholdMs &&
          other.goldThresholdMs == this.goldThresholdMs);
}

class ExerciseSettingsCompanion extends UpdateCompanion<ExerciseSettingsRow> {
  final Value<String> exerciseId;
  final Value<int> questionsPerSeries;
  final Value<int> bronzeThresholdMs;
  final Value<int> silverThresholdMs;
  final Value<int> goldThresholdMs;
  final Value<int> rowid;
  const ExerciseSettingsCompanion({
    this.exerciseId = const Value.absent(),
    this.questionsPerSeries = const Value.absent(),
    this.bronzeThresholdMs = const Value.absent(),
    this.silverThresholdMs = const Value.absent(),
    this.goldThresholdMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseSettingsCompanion.insert({
    required String exerciseId,
    required int questionsPerSeries,
    required int bronzeThresholdMs,
    required int silverThresholdMs,
    required int goldThresholdMs,
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       questionsPerSeries = Value(questionsPerSeries),
       bronzeThresholdMs = Value(bronzeThresholdMs),
       silverThresholdMs = Value(silverThresholdMs),
       goldThresholdMs = Value(goldThresholdMs);
  static Insertable<ExerciseSettingsRow> custom({
    Expression<String>? exerciseId,
    Expression<int>? questionsPerSeries,
    Expression<int>? bronzeThresholdMs,
    Expression<int>? silverThresholdMs,
    Expression<int>? goldThresholdMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (questionsPerSeries != null)
        'questions_per_series': questionsPerSeries,
      if (bronzeThresholdMs != null) 'bronze_threshold_ms': bronzeThresholdMs,
      if (silverThresholdMs != null) 'silver_threshold_ms': silverThresholdMs,
      if (goldThresholdMs != null) 'gold_threshold_ms': goldThresholdMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseSettingsCompanion copyWith({
    Value<String>? exerciseId,
    Value<int>? questionsPerSeries,
    Value<int>? bronzeThresholdMs,
    Value<int>? silverThresholdMs,
    Value<int>? goldThresholdMs,
    Value<int>? rowid,
  }) {
    return ExerciseSettingsCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      questionsPerSeries: questionsPerSeries ?? this.questionsPerSeries,
      bronzeThresholdMs: bronzeThresholdMs ?? this.bronzeThresholdMs,
      silverThresholdMs: silverThresholdMs ?? this.silverThresholdMs,
      goldThresholdMs: goldThresholdMs ?? this.goldThresholdMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (questionsPerSeries.present) {
      map['questions_per_series'] = Variable<int>(questionsPerSeries.value);
    }
    if (bronzeThresholdMs.present) {
      map['bronze_threshold_ms'] = Variable<int>(bronzeThresholdMs.value);
    }
    if (silverThresholdMs.present) {
      map['silver_threshold_ms'] = Variable<int>(silverThresholdMs.value);
    }
    if (goldThresholdMs.present) {
      map['gold_threshold_ms'] = Variable<int>(goldThresholdMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSettingsCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('questionsPerSeries: $questionsPerSeries, ')
          ..write('bronzeThresholdMs: $bronzeThresholdMs, ')
          ..write('silverThresholdMs: $silverThresholdMs, ')
          ..write('goldThresholdMs: $goldThresholdMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ActivationsTable activations = $ActivationsTable(this);
  late final $PerformancesTable performances = $PerformancesTable(this);
  late final $QuestionAttemptsTable questionAttempts = $QuestionAttemptsTable(
    this,
  );
  late final $ExerciseSettingsTable exerciseSettings = $ExerciseSettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    activations,
    performances,
    questionAttempts,
    exerciseSettings,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      required String name,
      required String avatarId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> avatarId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                avatarId: avatarId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String avatarId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                avatarId: avatarId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$ActivationsTableCreateCompanionBuilder =
    ActivationsCompanion Function({
      required String profileId,
      required String exerciseId,
      Value<int> rowid,
    });
typedef $$ActivationsTableUpdateCompanionBuilder =
    ActivationsCompanion Function({
      Value<String> profileId,
      Value<String> exerciseId,
      Value<int> rowid,
    });

class $$ActivationsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivationsTable> {
  $$ActivationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivationsTable> {
  $$ActivationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivationsTable> {
  $$ActivationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );
}

class $$ActivationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivationsTable,
          ActivationRow,
          $$ActivationsTableFilterComposer,
          $$ActivationsTableOrderingComposer,
          $$ActivationsTableAnnotationComposer,
          $$ActivationsTableCreateCompanionBuilder,
          $$ActivationsTableUpdateCompanionBuilder,
          (
            ActivationRow,
            BaseReferences<_$AppDatabase, $ActivationsTable, ActivationRow>,
          ),
          ActivationRow,
          PrefetchHooks Function()
        > {
  $$ActivationsTableTableManager(_$AppDatabase db, $ActivationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivationsCompanion(
                profileId: profileId,
                exerciseId: exerciseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String exerciseId,
                Value<int> rowid = const Value.absent(),
              }) => ActivationsCompanion.insert(
                profileId: profileId,
                exerciseId: exerciseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivationsTable,
      ActivationRow,
      $$ActivationsTableFilterComposer,
      $$ActivationsTableOrderingComposer,
      $$ActivationsTableAnnotationComposer,
      $$ActivationsTableCreateCompanionBuilder,
      $$ActivationsTableUpdateCompanionBuilder,
      (
        ActivationRow,
        BaseReferences<_$AppDatabase, $ActivationsTable, ActivationRow>,
      ),
      ActivationRow,
      PrefetchHooks Function()
    >;
typedef $$PerformancesTableCreateCompanionBuilder =
    PerformancesCompanion Function({
      required String profileId,
      required String exerciseId,
      required int badgeLevel,
      required int successRatePercent,
      required int attemptsCount,
      Value<DateTime?> lastPracticedAt,
      Value<int> rowid,
    });
typedef $$PerformancesTableUpdateCompanionBuilder =
    PerformancesCompanion Function({
      Value<String> profileId,
      Value<String> exerciseId,
      Value<int> badgeLevel,
      Value<int> successRatePercent,
      Value<int> attemptsCount,
      Value<DateTime?> lastPracticedAt,
      Value<int> rowid,
    });

class $$PerformancesTableFilterComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get badgeLevel => $composableBuilder(
    column: $table.badgeLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successRatePercent => $composableBuilder(
    column: $table.successRatePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptsCount => $composableBuilder(
    column: $table.attemptsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPracticedAt => $composableBuilder(
    column: $table.lastPracticedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PerformancesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get badgeLevel => $composableBuilder(
    column: $table.badgeLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successRatePercent => $composableBuilder(
    column: $table.successRatePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptsCount => $composableBuilder(
    column: $table.attemptsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPracticedAt => $composableBuilder(
    column: $table.lastPracticedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerformancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get badgeLevel => $composableBuilder(
    column: $table.badgeLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get successRatePercent => $composableBuilder(
    column: $table.successRatePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptsCount => $composableBuilder(
    column: $table.attemptsCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPracticedAt => $composableBuilder(
    column: $table.lastPracticedAt,
    builder: (column) => column,
  );
}

class $$PerformancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformancesTable,
          PerformanceRow,
          $$PerformancesTableFilterComposer,
          $$PerformancesTableOrderingComposer,
          $$PerformancesTableAnnotationComposer,
          $$PerformancesTableCreateCompanionBuilder,
          $$PerformancesTableUpdateCompanionBuilder,
          (
            PerformanceRow,
            BaseReferences<_$AppDatabase, $PerformancesTable, PerformanceRow>,
          ),
          PerformanceRow,
          PrefetchHooks Function()
        > {
  $$PerformancesTableTableManager(_$AppDatabase db, $PerformancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerformancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> badgeLevel = const Value.absent(),
                Value<int> successRatePercent = const Value.absent(),
                Value<int> attemptsCount = const Value.absent(),
                Value<DateTime?> lastPracticedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformancesCompanion(
                profileId: profileId,
                exerciseId: exerciseId,
                badgeLevel: badgeLevel,
                successRatePercent: successRatePercent,
                attemptsCount: attemptsCount,
                lastPracticedAt: lastPracticedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String exerciseId,
                required int badgeLevel,
                required int successRatePercent,
                required int attemptsCount,
                Value<DateTime?> lastPracticedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PerformancesCompanion.insert(
                profileId: profileId,
                exerciseId: exerciseId,
                badgeLevel: badgeLevel,
                successRatePercent: successRatePercent,
                attemptsCount: attemptsCount,
                lastPracticedAt: lastPracticedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PerformancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformancesTable,
      PerformanceRow,
      $$PerformancesTableFilterComposer,
      $$PerformancesTableOrderingComposer,
      $$PerformancesTableAnnotationComposer,
      $$PerformancesTableCreateCompanionBuilder,
      $$PerformancesTableUpdateCompanionBuilder,
      (
        PerformanceRow,
        BaseReferences<_$AppDatabase, $PerformancesTable, PerformanceRow>,
      ),
      PerformanceRow,
      PrefetchHooks Function()
    >;
typedef $$QuestionAttemptsTableCreateCompanionBuilder =
    QuestionAttemptsCompanion Function({
      Value<int> id,
      required String profileId,
      required String exerciseId,
      required String questionId,
      required int responseTimeMs,
      required DateTime attemptedAt,
      Value<bool?> correct,
    });
typedef $$QuestionAttemptsTableUpdateCompanionBuilder =
    QuestionAttemptsCompanion Function({
      Value<int> id,
      Value<String> profileId,
      Value<String> exerciseId,
      Value<String> questionId,
      Value<int> responseTimeMs,
      Value<DateTime> attemptedAt,
      Value<bool?> correct,
    });

class $$QuestionAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableFilterComposer({
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

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableOrderingComposer({
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

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);
}

class $$QuestionAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionAttemptsTable,
          QuestionAttemptRow,
          $$QuestionAttemptsTableFilterComposer,
          $$QuestionAttemptsTableOrderingComposer,
          $$QuestionAttemptsTableAnnotationComposer,
          $$QuestionAttemptsTableCreateCompanionBuilder,
          $$QuestionAttemptsTableUpdateCompanionBuilder,
          (
            QuestionAttemptRow,
            BaseReferences<
              _$AppDatabase,
              $QuestionAttemptsTable,
              QuestionAttemptRow
            >,
          ),
          QuestionAttemptRow,
          PrefetchHooks Function()
        > {
  $$QuestionAttemptsTableTableManager(
    _$AppDatabase db,
    $QuestionAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> responseTimeMs = const Value.absent(),
                Value<DateTime> attemptedAt = const Value.absent(),
                Value<bool?> correct = const Value.absent(),
              }) => QuestionAttemptsCompanion(
                id: id,
                profileId: profileId,
                exerciseId: exerciseId,
                questionId: questionId,
                responseTimeMs: responseTimeMs,
                attemptedAt: attemptedAt,
                correct: correct,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String profileId,
                required String exerciseId,
                required String questionId,
                required int responseTimeMs,
                required DateTime attemptedAt,
                Value<bool?> correct = const Value.absent(),
              }) => QuestionAttemptsCompanion.insert(
                id: id,
                profileId: profileId,
                exerciseId: exerciseId,
                questionId: questionId,
                responseTimeMs: responseTimeMs,
                attemptedAt: attemptedAt,
                correct: correct,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionAttemptsTable,
      QuestionAttemptRow,
      $$QuestionAttemptsTableFilterComposer,
      $$QuestionAttemptsTableOrderingComposer,
      $$QuestionAttemptsTableAnnotationComposer,
      $$QuestionAttemptsTableCreateCompanionBuilder,
      $$QuestionAttemptsTableUpdateCompanionBuilder,
      (
        QuestionAttemptRow,
        BaseReferences<
          _$AppDatabase,
          $QuestionAttemptsTable,
          QuestionAttemptRow
        >,
      ),
      QuestionAttemptRow,
      PrefetchHooks Function()
    >;
typedef $$ExerciseSettingsTableCreateCompanionBuilder =
    ExerciseSettingsCompanion Function({
      required String exerciseId,
      required int questionsPerSeries,
      required int bronzeThresholdMs,
      required int silverThresholdMs,
      required int goldThresholdMs,
      Value<int> rowid,
    });
typedef $$ExerciseSettingsTableUpdateCompanionBuilder =
    ExerciseSettingsCompanion Function({
      Value<String> exerciseId,
      Value<int> questionsPerSeries,
      Value<int> bronzeThresholdMs,
      Value<int> silverThresholdMs,
      Value<int> goldThresholdMs,
      Value<int> rowid,
    });

class $$ExerciseSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseSettingsTable> {
  $$ExerciseSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionsPerSeries => $composableBuilder(
    column: $table.questionsPerSeries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bronzeThresholdMs => $composableBuilder(
    column: $table.bronzeThresholdMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get silverThresholdMs => $composableBuilder(
    column: $table.silverThresholdMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goldThresholdMs => $composableBuilder(
    column: $table.goldThresholdMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseSettingsTable> {
  $$ExerciseSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionsPerSeries => $composableBuilder(
    column: $table.questionsPerSeries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bronzeThresholdMs => $composableBuilder(
    column: $table.bronzeThresholdMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get silverThresholdMs => $composableBuilder(
    column: $table.silverThresholdMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goldThresholdMs => $composableBuilder(
    column: $table.goldThresholdMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseSettingsTable> {
  $$ExerciseSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questionsPerSeries => $composableBuilder(
    column: $table.questionsPerSeries,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bronzeThresholdMs => $composableBuilder(
    column: $table.bronzeThresholdMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get silverThresholdMs => $composableBuilder(
    column: $table.silverThresholdMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goldThresholdMs => $composableBuilder(
    column: $table.goldThresholdMs,
    builder: (column) => column,
  );
}

class $$ExerciseSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseSettingsTable,
          ExerciseSettingsRow,
          $$ExerciseSettingsTableFilterComposer,
          $$ExerciseSettingsTableOrderingComposer,
          $$ExerciseSettingsTableAnnotationComposer,
          $$ExerciseSettingsTableCreateCompanionBuilder,
          $$ExerciseSettingsTableUpdateCompanionBuilder,
          (
            ExerciseSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $ExerciseSettingsTable,
              ExerciseSettingsRow
            >,
          ),
          ExerciseSettingsRow,
          PrefetchHooks Function()
        > {
  $$ExerciseSettingsTableTableManager(
    _$AppDatabase db,
    $ExerciseSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<int> questionsPerSeries = const Value.absent(),
                Value<int> bronzeThresholdMs = const Value.absent(),
                Value<int> silverThresholdMs = const Value.absent(),
                Value<int> goldThresholdMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSettingsCompanion(
                exerciseId: exerciseId,
                questionsPerSeries: questionsPerSeries,
                bronzeThresholdMs: bronzeThresholdMs,
                silverThresholdMs: silverThresholdMs,
                goldThresholdMs: goldThresholdMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required int questionsPerSeries,
                required int bronzeThresholdMs,
                required int silverThresholdMs,
                required int goldThresholdMs,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSettingsCompanion.insert(
                exerciseId: exerciseId,
                questionsPerSeries: questionsPerSeries,
                bronzeThresholdMs: bronzeThresholdMs,
                silverThresholdMs: silverThresholdMs,
                goldThresholdMs: goldThresholdMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseSettingsTable,
      ExerciseSettingsRow,
      $$ExerciseSettingsTableFilterComposer,
      $$ExerciseSettingsTableOrderingComposer,
      $$ExerciseSettingsTableAnnotationComposer,
      $$ExerciseSettingsTableCreateCompanionBuilder,
      $$ExerciseSettingsTableUpdateCompanionBuilder,
      (
        ExerciseSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $ExerciseSettingsTable,
          ExerciseSettingsRow
        >,
      ),
      ExerciseSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ActivationsTableTableManager get activations =>
      $$ActivationsTableTableManager(_db, _db.activations);
  $$PerformancesTableTableManager get performances =>
      $$PerformancesTableTableManager(_db, _db.performances);
  $$QuestionAttemptsTableTableManager get questionAttempts =>
      $$QuestionAttemptsTableTableManager(_db, _db.questionAttempts);
  $$ExerciseSettingsTableTableManager get exerciseSettings =>
      $$ExerciseSettingsTableTableManager(_db, _db.exerciseSettings);
}
