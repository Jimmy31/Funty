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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ActivationsTable activations = $ActivationsTable(this);
  late final $PerformancesTable performances = $PerformancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    activations,
    performances,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ActivationsTableTableManager get activations =>
      $$ActivationsTableTableManager(_db, _db.activations);
  $$PerformancesTableTableManager get performances =>
      $$PerformancesTableTableManager(_db, _db.performances);
}
