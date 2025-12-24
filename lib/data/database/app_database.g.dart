// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<int> openingBalance = GeneratedColumn<int>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<int> currentBalance = GeneratedColumn<int>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billingStartDayMeta = const VerificationMeta(
    'billingStartDay',
  );
  @override
  late final GeneratedColumn<int> billingStartDay = GeneratedColumn<int>(
    'billing_start_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    openingBalance,
    currentBalance,
    creditLimit,
    billingStartDay,
    dueDay,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceMeta);
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentBalanceMeta);
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('billing_start_day')) {
      context.handle(
        _billingStartDayMeta,
        billingStartDay.isAcceptableOrUnknown(
          data['billing_start_day']!,
          _billingStartDayMeta,
        ),
      );
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_balance'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit'],
      ),
      billingStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_start_day'],
      ),
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final AccountType type;
  final int openingBalance;
  final int currentBalance;
  final int? creditLimit;
  final int? billingStartDay;
  final int? dueDay;
  final bool isArchived;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.currentBalance,
    this.creditLimit,
    this.billingStartDay,
    this.dueDay,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['opening_balance'] = Variable<int>(openingBalance);
    map['current_balance'] = Variable<int>(currentBalance);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<int>(creditLimit);
    }
    if (!nullToAbsent || billingStartDay != null) {
      map['billing_start_day'] = Variable<int>(billingStartDay);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      openingBalance: Value(openingBalance),
      currentBalance: Value(currentBalance),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      billingStartDay: billingStartDay == null && nullToAbsent
          ? const Value.absent()
          : Value(billingStartDay),
      dueDay: dueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDay),
      isArchived: Value(isArchived),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      openingBalance: serializer.fromJson<int>(json['openingBalance']),
      currentBalance: serializer.fromJson<int>(json['currentBalance']),
      creditLimit: serializer.fromJson<int?>(json['creditLimit']),
      billingStartDay: serializer.fromJson<int?>(json['billingStartDay']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'openingBalance': serializer.toJson<int>(openingBalance),
      'currentBalance': serializer.toJson<int>(currentBalance),
      'creditLimit': serializer.toJson<int?>(creditLimit),
      'billingStartDay': serializer.toJson<int?>(billingStartDay),
      'dueDay': serializer.toJson<int?>(dueDay),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    AccountType? type,
    int? openingBalance,
    int? currentBalance,
    Value<int?> creditLimit = const Value.absent(),
    Value<int?> billingStartDay = const Value.absent(),
    Value<int?> dueDay = const Value.absent(),
    bool? isArchived,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    openingBalance: openingBalance ?? this.openingBalance,
    currentBalance: currentBalance ?? this.currentBalance,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
    billingStartDay: billingStartDay.present
        ? billingStartDay.value
        : this.billingStartDay,
    dueDay: dueDay.present ? dueDay.value : this.dueDay,
    isArchived: isArchived ?? this.isArchived,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      billingStartDay: data.billingStartDay.present
          ? data.billingStartDay.value
          : this.billingStartDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('billingStartDay: $billingStartDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    openingBalance,
    currentBalance,
    creditLimit,
    billingStartDay,
    dueDay,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.openingBalance == this.openingBalance &&
          other.currentBalance == this.currentBalance &&
          other.creditLimit == this.creditLimit &&
          other.billingStartDay == this.billingStartDay &&
          other.dueDay == this.dueDay &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> openingBalance;
  final Value<int> currentBalance;
  final Value<int?> creditLimit;
  final Value<int?> billingStartDay;
  final Value<int?> dueDay;
  final Value<bool> isArchived;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.billingStartDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountType type,
    required int openingBalance,
    required int currentBalance,
    this.creditLimit = const Value.absent(),
    this.billingStartDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isArchived = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       openingBalance = Value(openingBalance),
       currentBalance = Value(currentBalance);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? openingBalance,
    Expression<int>? currentBalance,
    Expression<int>? creditLimit,
    Expression<int>? billingStartDay,
    Expression<int>? dueDay,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (billingStartDay != null) 'billing_start_day': billingStartDay,
      if (dueDay != null) 'due_day': dueDay,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? openingBalance,
    Value<int>? currentBalance,
    Value<int?>? creditLimit,
    Value<int?>? billingStartDay,
    Value<int?>? dueDay,
    Value<bool>? isArchived,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      billingStartDay: billingStartDay ?? this.billingStartDay,
      dueDay: dueDay ?? this.dueDay,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(openingBalance.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<int>(currentBalance.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (billingStartDay.present) {
      map['billing_start_day'] = Variable<int>(billingStartDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('billingStartDay: $billingStartDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    color,
    icon,
    isIncome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      )!,
      isIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_income'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int? parentId;
  final int color;
  final int icon;
  final bool isIncome;
  const Category({
    required this.id,
    required this.name,
    this.parentId,
    required this.color,
    required this.icon,
    required this.isIncome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['color'] = Variable<int>(color);
    map['icon'] = Variable<int>(icon);
    map['is_income'] = Variable<bool>(isIncome);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      color: Value(color),
      icon: Value(icon),
      isIncome: Value(isIncome),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      color: serializer.fromJson<int>(json['color']),
      icon: serializer.fromJson<int>(json['icon']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'color': serializer.toJson<int>(color),
      'icon': serializer.toJson<int>(icon),
      'isIncome': serializer.toJson<bool>(isIncome),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    Value<int?> parentId = const Value.absent(),
    int? color,
    int? icon,
    bool? isIncome,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    color: color ?? this.color,
    icon: icon ?? this.icon,
    isIncome: isIncome ?? this.isIncome,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, color, icon, isIncome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.isIncome == this.isIncome);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<int> color;
  final Value<int> icon;
  final Value<bool> isIncome;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isIncome = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required int color,
    required int icon,
    this.isIncome = const Value.absent(),
  }) : name = Value(name),
       color = Value(color),
       icon = Value(icon);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<int>? color,
    Expression<int>? icon,
    Expression<bool>? isIncome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (isIncome != null) 'is_income': isIncome,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<int>? color,
    Value<int>? icon,
    Value<bool>? isIncome,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _firstDayOfWeekMeta = const VerificationMeta(
    'firstDayOfWeek',
  );
  @override
  late final GeneratedColumn<int> firstDayOfWeek = GeneratedColumn<int>(
    'first_day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(DateTime.monday),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('system'),
      ).withConverter<AppThemeMode>($PreferencesTable.$converterthemeMode);
  static const VerificationMeta _isDemoModeMeta = const VerificationMeta(
    'isDemoMode',
  );
  @override
  late final GeneratedColumn<bool> isDemoMode = GeneratedColumn<bool>(
    'is_demo_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasSeenFirstRunPromptMeta =
      const VerificationMeta('hasSeenFirstRunPrompt');
  @override
  late final GeneratedColumn<bool> hasSeenFirstRunPrompt =
      GeneratedColumn<bool>(
        'has_seen_first_run_prompt',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_seen_first_run_prompt" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currencyCode,
    firstDayOfWeek,
    themeMode,
    isDemoMode,
    hasSeenFirstRunPrompt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('first_day_of_week')) {
      context.handle(
        _firstDayOfWeekMeta,
        firstDayOfWeek.isAcceptableOrUnknown(
          data['first_day_of_week']!,
          _firstDayOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('is_demo_mode')) {
      context.handle(
        _isDemoModeMeta,
        isDemoMode.isAcceptableOrUnknown(
          data['is_demo_mode']!,
          _isDemoModeMeta,
        ),
      );
    }
    if (data.containsKey('has_seen_first_run_prompt')) {
      context.handle(
        _hasSeenFirstRunPromptMeta,
        hasSeenFirstRunPrompt.isAcceptableOrUnknown(
          data['has_seen_first_run_prompt']!,
          _hasSeenFirstRunPromptMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      firstDayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_day_of_week'],
      )!,
      themeMode: $PreferencesTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      isDemoMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo_mode'],
      )!,
      hasSeenFirstRunPrompt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_seen_first_run_prompt'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
}

class Preference extends DataClass implements Insertable<Preference> {
  final int id;
  final String currencyCode;
  final int firstDayOfWeek;
  final AppThemeMode themeMode;
  final bool isDemoMode;
  final bool hasSeenFirstRunPrompt;
  const Preference({
    required this.id,
    required this.currencyCode,
    required this.firstDayOfWeek,
    required this.themeMode,
    required this.isDemoMode,
    required this.hasSeenFirstRunPrompt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_code'] = Variable<String>(currencyCode);
    map['first_day_of_week'] = Variable<int>(firstDayOfWeek);
    {
      map['theme_mode'] = Variable<String>(
        $PreferencesTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['is_demo_mode'] = Variable<bool>(isDemoMode);
    map['has_seen_first_run_prompt'] = Variable<bool>(hasSeenFirstRunPrompt);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      currencyCode: Value(currencyCode),
      firstDayOfWeek: Value(firstDayOfWeek),
      themeMode: Value(themeMode),
      isDemoMode: Value(isDemoMode),
      hasSeenFirstRunPrompt: Value(hasSeenFirstRunPrompt),
    );
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<int>(json['id']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      firstDayOfWeek: serializer.fromJson<int>(json['firstDayOfWeek']),
      themeMode: $PreferencesTable.$converterthemeMode.fromJson(
        serializer.fromJson<String>(json['themeMode']),
      ),
      isDemoMode: serializer.fromJson<bool>(json['isDemoMode']),
      hasSeenFirstRunPrompt: serializer.fromJson<bool>(
        json['hasSeenFirstRunPrompt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'firstDayOfWeek': serializer.toJson<int>(firstDayOfWeek),
      'themeMode': serializer.toJson<String>(
        $PreferencesTable.$converterthemeMode.toJson(themeMode),
      ),
      'isDemoMode': serializer.toJson<bool>(isDemoMode),
      'hasSeenFirstRunPrompt': serializer.toJson<bool>(hasSeenFirstRunPrompt),
    };
  }

  Preference copyWith({
    int? id,
    String? currencyCode,
    int? firstDayOfWeek,
    AppThemeMode? themeMode,
    bool? isDemoMode,
    bool? hasSeenFirstRunPrompt,
  }) => Preference(
    id: id ?? this.id,
    currencyCode: currencyCode ?? this.currencyCode,
    firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    themeMode: themeMode ?? this.themeMode,
    isDemoMode: isDemoMode ?? this.isDemoMode,
    hasSeenFirstRunPrompt: hasSeenFirstRunPrompt ?? this.hasSeenFirstRunPrompt,
  );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      firstDayOfWeek: data.firstDayOfWeek.present
          ? data.firstDayOfWeek.value
          : this.firstDayOfWeek,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      isDemoMode: data.isDemoMode.present
          ? data.isDemoMode.value
          : this.isDemoMode,
      hasSeenFirstRunPrompt: data.hasSeenFirstRunPrompt.present
          ? data.hasSeenFirstRunPrompt.value
          : this.hasSeenFirstRunPrompt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('themeMode: $themeMode, ')
          ..write('isDemoMode: $isDemoMode, ')
          ..write('hasSeenFirstRunPrompt: $hasSeenFirstRunPrompt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currencyCode,
    firstDayOfWeek,
    themeMode,
    isDemoMode,
    hasSeenFirstRunPrompt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.currencyCode == this.currencyCode &&
          other.firstDayOfWeek == this.firstDayOfWeek &&
          other.themeMode == this.themeMode &&
          other.isDemoMode == this.isDemoMode &&
          other.hasSeenFirstRunPrompt == this.hasSeenFirstRunPrompt);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<int> id;
  final Value<String> currencyCode;
  final Value<int> firstDayOfWeek;
  final Value<AppThemeMode> themeMode;
  final Value<bool> isDemoMode;
  final Value<bool> hasSeenFirstRunPrompt;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.isDemoMode = const Value.absent(),
    this.hasSeenFirstRunPrompt = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.isDemoMode = const Value.absent(),
    this.hasSeenFirstRunPrompt = const Value.absent(),
  });
  static Insertable<Preference> custom({
    Expression<int>? id,
    Expression<String>? currencyCode,
    Expression<int>? firstDayOfWeek,
    Expression<String>? themeMode,
    Expression<bool>? isDemoMode,
    Expression<bool>? hasSeenFirstRunPrompt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (firstDayOfWeek != null) 'first_day_of_week': firstDayOfWeek,
      if (themeMode != null) 'theme_mode': themeMode,
      if (isDemoMode != null) 'is_demo_mode': isDemoMode,
      if (hasSeenFirstRunPrompt != null)
        'has_seen_first_run_prompt': hasSeenFirstRunPrompt,
    });
  }

  PreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? currencyCode,
    Value<int>? firstDayOfWeek,
    Value<AppThemeMode>? themeMode,
    Value<bool>? isDemoMode,
    Value<bool>? hasSeenFirstRunPrompt,
  }) {
    return PreferencesCompanion(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      themeMode: themeMode ?? this.themeMode,
      isDemoMode: isDemoMode ?? this.isDemoMode,
      hasSeenFirstRunPrompt:
          hasSeenFirstRunPrompt ?? this.hasSeenFirstRunPrompt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (firstDayOfWeek.present) {
      map['first_day_of_week'] = Variable<int>(firstDayOfWeek.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
        $PreferencesTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (isDemoMode.present) {
      map['is_demo_mode'] = Variable<bool>(isDemoMode.value);
    }
    if (hasSeenFirstRunPrompt.present) {
      map['has_seen_first_run_prompt'] = Variable<bool>(
        hasSeenFirstRunPrompt.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('themeMode: $themeMode, ')
          ..write('isDemoMode: $isDemoMode, ')
          ..write('hasSeenFirstRunPrompt: $hasSeenFirstRunPrompt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<bool> isPending = GeneratedColumn<bool>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    type,
    accountId,
    categoryId,
    note,
    date,
    isPending,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int amount;
  final TransactionType type;
  final int accountId;
  final int? categoryId;
  final String? note;
  final DateTime date;
  final bool isPending;
  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.accountId,
    this.categoryId,
    this.note,
    required this.date,
    required this.isPending,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_pending'] = Variable<bool>(isPending);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      isPending: Value(isPending),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      isPending: serializer.fromJson<bool>(json['isPending']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'isPending': serializer.toJson<bool>(isPending),
    };
  }

  Transaction copyWith({
    int? id,
    int? amount,
    TransactionType? type,
    int? accountId,
    Value<int?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? date,
    bool? isPending,
  }) => Transaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
    date: date ?? this.date,
    isPending: isPending ?? this.isPending,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isPending: $isPending')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    type,
    accountId,
    categoryId,
    note,
    date,
    isPending,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.date == this.date &&
          other.isPending == this.isPending);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> amount;
  final Value<TransactionType> type;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<bool> isPending;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.isPending = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required TransactionType type,
    required int accountId,
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime date,
    this.isPending = const Value.absent(),
  }) : amount = Value(amount),
       type = Value(type),
       accountId = Value(accountId),
       date = Value(date);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? type,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<bool>? isPending,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (isPending != null) 'is_pending': isPending,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<TransactionType>? type,
    Value<int>? accountId,
    Value<int?>? categoryId,
    Value<String?>? note,
    Value<DateTime>? date,
    Value<bool>? isPending,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<bool>(isPending.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isPending: $isPending')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<int> fromAccountId = GeneratedColumn<int>(
    'from_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkedTransactionIdsMeta =
      const VerificationMeta('linkedTransactionIds');
  @override
  late final GeneratedColumn<String> linkedTransactionIds =
      GeneratedColumn<String>(
        'linked_transaction_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromAccountId,
    toAccountId,
    amount,
    date,
    linkedTransactionIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transfer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromAccountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toAccountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('linked_transaction_ids')) {
      context.handle(
        _linkedTransactionIdsMeta,
        linkedTransactionIds.isAcceptableOrUnknown(
          data['linked_transaction_ids']!,
          _linkedTransactionIdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_account_id'],
      )!,
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_account_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      linkedTransactionIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_transaction_ids'],
      )!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int fromAccountId;
  final int toAccountId;
  final int amount;
  final DateTime date;
  final String linkedTransactionIds;
  const Transfer({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    required this.linkedTransactionIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_account_id'] = Variable<int>(fromAccountId);
    map['to_account_id'] = Variable<int>(toAccountId);
    map['amount'] = Variable<int>(amount);
    map['date'] = Variable<DateTime>(date);
    map['linked_transaction_ids'] = Variable<String>(linkedTransactionIds);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      fromAccountId: Value(fromAccountId),
      toAccountId: Value(toAccountId),
      amount: Value(amount),
      date: Value(date),
      linkedTransactionIds: Value(linkedTransactionIds),
    );
  }

  factory Transfer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      fromAccountId: serializer.fromJson<int>(json['fromAccountId']),
      toAccountId: serializer.fromJson<int>(json['toAccountId']),
      amount: serializer.fromJson<int>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      linkedTransactionIds: serializer.fromJson<String>(
        json['linkedTransactionIds'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromAccountId': serializer.toJson<int>(fromAccountId),
      'toAccountId': serializer.toJson<int>(toAccountId),
      'amount': serializer.toJson<int>(amount),
      'date': serializer.toJson<DateTime>(date),
      'linkedTransactionIds': serializer.toJson<String>(linkedTransactionIds),
    };
  }

  Transfer copyWith({
    int? id,
    int? fromAccountId,
    int? toAccountId,
    int? amount,
    DateTime? date,
    String? linkedTransactionIds,
  }) => Transfer(
    id: id ?? this.id,
    fromAccountId: fromAccountId ?? this.fromAccountId,
    toAccountId: toAccountId ?? this.toAccountId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    linkedTransactionIds: linkedTransactionIds ?? this.linkedTransactionIds,
  );
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
      id: data.id.present ? data.id.value : this.id,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      linkedTransactionIds: data.linkedTransactionIds.present
          ? data.linkedTransactionIds.value
          : this.linkedTransactionIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('linkedTransactionIds: $linkedTransactionIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromAccountId,
    toAccountId,
    amount,
    date,
    linkedTransactionIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.linkedTransactionIds == this.linkedTransactionIds);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> fromAccountId;
  final Value<int> toAccountId;
  final Value<int> amount;
  final Value<DateTime> date;
  final Value<String> linkedTransactionIds;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.linkedTransactionIds = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int fromAccountId,
    required int toAccountId,
    required int amount,
    required DateTime date,
    this.linkedTransactionIds = const Value.absent(),
  }) : fromAccountId = Value(fromAccountId),
       toAccountId = Value(toAccountId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? fromAccountId,
    Expression<int>? toAccountId,
    Expression<int>? amount,
    Expression<DateTime>? date,
    Expression<String>? linkedTransactionIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (linkedTransactionIds != null)
        'linked_transaction_ids': linkedTransactionIds,
    });
  }

  TransfersCompanion copyWith({
    Value<int>? id,
    Value<int>? fromAccountId,
    Value<int>? toAccountId,
    Value<int>? amount,
    Value<DateTime>? date,
    Value<String>? linkedTransactionIds,
  }) {
    return TransfersCompanion(
      id: id ?? this.id,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      linkedTransactionIds: linkedTransactionIds ?? this.linkedTransactionIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<int>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (linkedTransactionIds.present) {
      map['linked_transaction_ids'] = Variable<String>(
        linkedTransactionIds.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('linkedTransactionIds: $linkedTransactionIds')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _disbursementTransactionIdMeta =
      const VerificationMeta('disbursementTransactionId');
  @override
  late final GeneratedColumn<int> disbursementTransactionId =
      GeneratedColumn<int>(
        'disbursement_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id)',
        ),
      );
  static const VerificationMeta _principalAmountMeta = const VerificationMeta(
    'principalAmount',
  );
  @override
  late final GeneratedColumn<int> principalAmount = GeneratedColumn<int>(
    'principal_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoanInterestType, String>
  interestType = GeneratedColumn<String>(
    'interest_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LoanInterestType>($LoansTable.$converterinterestType);
  static const VerificationMeta _durationMonthsMeta = const VerificationMeta(
    'durationMonths',
  );
  @override
  late final GeneratedColumn<int> durationMonths = GeneratedColumn<int>(
    'duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDayMeta = const VerificationMeta(
    'paymentDay',
  );
  @override
  late final GeneratedColumn<int> paymentDay = GeneratedColumn<int>(
    'payment_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPayableAmountMeta =
      const VerificationMeta('totalPayableAmount');
  @override
  late final GeneratedColumn<int> totalPayableAmount = GeneratedColumn<int>(
    'total_payable_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyInstallmentMeta =
      const VerificationMeta('monthlyInstallment');
  @override
  late final GeneratedColumn<int> monthlyInstallment = GeneratedColumn<int>(
    'monthly_installment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outstandingAmountMeta = const VerificationMeta(
    'outstandingAmount',
  );
  @override
  late final GeneratedColumn<int> outstandingAmount = GeneratedColumn<int>(
    'outstanding_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    accountId,
    disbursementTransactionId,
    principalAmount,
    interestRate,
    interestType,
    durationMonths,
    paymentDay,
    totalPayableAmount,
    monthlyInstallment,
    outstandingAmount,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('disbursement_transaction_id')) {
      context.handle(
        _disbursementTransactionIdMeta,
        disbursementTransactionId.isAcceptableOrUnknown(
          data['disbursement_transaction_id']!,
          _disbursementTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('principal_amount')) {
      context.handle(
        _principalAmountMeta,
        principalAmount.isAcceptableOrUnknown(
          data['principal_amount']!,
          _principalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalAmountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('duration_months')) {
      context.handle(
        _durationMonthsMeta,
        durationMonths.isAcceptableOrUnknown(
          data['duration_months']!,
          _durationMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMonthsMeta);
    }
    if (data.containsKey('payment_day')) {
      context.handle(
        _paymentDayMeta,
        paymentDay.isAcceptableOrUnknown(data['payment_day']!, _paymentDayMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentDayMeta);
    }
    if (data.containsKey('total_payable_amount')) {
      context.handle(
        _totalPayableAmountMeta,
        totalPayableAmount.isAcceptableOrUnknown(
          data['total_payable_amount']!,
          _totalPayableAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPayableAmountMeta);
    }
    if (data.containsKey('monthly_installment')) {
      context.handle(
        _monthlyInstallmentMeta,
        monthlyInstallment.isAcceptableOrUnknown(
          data['monthly_installment']!,
          _monthlyInstallmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyInstallmentMeta);
    }
    if (data.containsKey('outstanding_amount')) {
      context.handle(
        _outstandingAmountMeta,
        outstandingAmount.isAcceptableOrUnknown(
          data['outstanding_amount']!,
          _outstandingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outstandingAmountMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      disbursementTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disbursement_transaction_id'],
      ),
      principalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_amount'],
      )!,
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      )!,
      interestType: $LoansTable.$converterinterestType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}interest_type'],
        )!,
      ),
      durationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_months'],
      )!,
      paymentDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_day'],
      )!,
      totalPayableAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_payable_amount'],
      )!,
      monthlyInstallment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_installment'],
      )!,
      outstandingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outstanding_amount'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoanInterestType, String, String>
  $converterinterestType = const EnumNameConverter<LoanInterestType>(
    LoanInterestType.values,
  );
}

class Loan extends DataClass implements Insertable<Loan> {
  final int id;
  final String name;
  final int accountId;
  final int? disbursementTransactionId;
  final int principalAmount;
  final double interestRate;
  final LoanInterestType interestType;
  final int durationMonths;
  final int paymentDay;
  final int totalPayableAmount;
  final int monthlyInstallment;
  final int outstandingAmount;
  final bool isClosed;
  const Loan({
    required this.id,
    required this.name,
    required this.accountId,
    this.disbursementTransactionId,
    required this.principalAmount,
    required this.interestRate,
    required this.interestType,
    required this.durationMonths,
    required this.paymentDay,
    required this.totalPayableAmount,
    required this.monthlyInstallment,
    required this.outstandingAmount,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || disbursementTransactionId != null) {
      map['disbursement_transaction_id'] = Variable<int>(
        disbursementTransactionId,
      );
    }
    map['principal_amount'] = Variable<int>(principalAmount);
    map['interest_rate'] = Variable<double>(interestRate);
    {
      map['interest_type'] = Variable<String>(
        $LoansTable.$converterinterestType.toSql(interestType),
      );
    }
    map['duration_months'] = Variable<int>(durationMonths);
    map['payment_day'] = Variable<int>(paymentDay);
    map['total_payable_amount'] = Variable<int>(totalPayableAmount);
    map['monthly_installment'] = Variable<int>(monthlyInstallment);
    map['outstanding_amount'] = Variable<int>(outstandingAmount);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      name: Value(name),
      accountId: Value(accountId),
      disbursementTransactionId:
          disbursementTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(disbursementTransactionId),
      principalAmount: Value(principalAmount),
      interestRate: Value(interestRate),
      interestType: Value(interestType),
      durationMonths: Value(durationMonths),
      paymentDay: Value(paymentDay),
      totalPayableAmount: Value(totalPayableAmount),
      monthlyInstallment: Value(monthlyInstallment),
      outstandingAmount: Value(outstandingAmount),
      isClosed: Value(isClosed),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountId: serializer.fromJson<int>(json['accountId']),
      disbursementTransactionId: serializer.fromJson<int?>(
        json['disbursementTransactionId'],
      ),
      principalAmount: serializer.fromJson<int>(json['principalAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      interestType: $LoansTable.$converterinterestType.fromJson(
        serializer.fromJson<String>(json['interestType']),
      ),
      durationMonths: serializer.fromJson<int>(json['durationMonths']),
      paymentDay: serializer.fromJson<int>(json['paymentDay']),
      totalPayableAmount: serializer.fromJson<int>(json['totalPayableAmount']),
      monthlyInstallment: serializer.fromJson<int>(json['monthlyInstallment']),
      outstandingAmount: serializer.fromJson<int>(json['outstandingAmount']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'accountId': serializer.toJson<int>(accountId),
      'disbursementTransactionId': serializer.toJson<int?>(
        disbursementTransactionId,
      ),
      'principalAmount': serializer.toJson<int>(principalAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'interestType': serializer.toJson<String>(
        $LoansTable.$converterinterestType.toJson(interestType),
      ),
      'durationMonths': serializer.toJson<int>(durationMonths),
      'paymentDay': serializer.toJson<int>(paymentDay),
      'totalPayableAmount': serializer.toJson<int>(totalPayableAmount),
      'monthlyInstallment': serializer.toJson<int>(monthlyInstallment),
      'outstandingAmount': serializer.toJson<int>(outstandingAmount),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  Loan copyWith({
    int? id,
    String? name,
    int? accountId,
    Value<int?> disbursementTransactionId = const Value.absent(),
    int? principalAmount,
    double? interestRate,
    LoanInterestType? interestType,
    int? durationMonths,
    int? paymentDay,
    int? totalPayableAmount,
    int? monthlyInstallment,
    int? outstandingAmount,
    bool? isClosed,
  }) => Loan(
    id: id ?? this.id,
    name: name ?? this.name,
    accountId: accountId ?? this.accountId,
    disbursementTransactionId: disbursementTransactionId.present
        ? disbursementTransactionId.value
        : this.disbursementTransactionId,
    principalAmount: principalAmount ?? this.principalAmount,
    interestRate: interestRate ?? this.interestRate,
    interestType: interestType ?? this.interestType,
    durationMonths: durationMonths ?? this.durationMonths,
    paymentDay: paymentDay ?? this.paymentDay,
    totalPayableAmount: totalPayableAmount ?? this.totalPayableAmount,
    monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
    outstandingAmount: outstandingAmount ?? this.outstandingAmount,
    isClosed: isClosed ?? this.isClosed,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      disbursementTransactionId: data.disbursementTransactionId.present
          ? data.disbursementTransactionId.value
          : this.disbursementTransactionId,
      principalAmount: data.principalAmount.present
          ? data.principalAmount.value
          : this.principalAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      interestType: data.interestType.present
          ? data.interestType.value
          : this.interestType,
      durationMonths: data.durationMonths.present
          ? data.durationMonths.value
          : this.durationMonths,
      paymentDay: data.paymentDay.present
          ? data.paymentDay.value
          : this.paymentDay,
      totalPayableAmount: data.totalPayableAmount.present
          ? data.totalPayableAmount.value
          : this.totalPayableAmount,
      monthlyInstallment: data.monthlyInstallment.present
          ? data.monthlyInstallment.value
          : this.monthlyInstallment,
      outstandingAmount: data.outstandingAmount.present
          ? data.outstandingAmount.value
          : this.outstandingAmount,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('disbursementTransactionId: $disbursementTransactionId, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('interestType: $interestType, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('paymentDay: $paymentDay, ')
          ..write('totalPayableAmount: $totalPayableAmount, ')
          ..write('monthlyInstallment: $monthlyInstallment, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    accountId,
    disbursementTransactionId,
    principalAmount,
    interestRate,
    interestType,
    durationMonths,
    paymentDay,
    totalPayableAmount,
    monthlyInstallment,
    outstandingAmount,
    isClosed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountId == this.accountId &&
          other.disbursementTransactionId == this.disbursementTransactionId &&
          other.principalAmount == this.principalAmount &&
          other.interestRate == this.interestRate &&
          other.interestType == this.interestType &&
          other.durationMonths == this.durationMonths &&
          other.paymentDay == this.paymentDay &&
          other.totalPayableAmount == this.totalPayableAmount &&
          other.monthlyInstallment == this.monthlyInstallment &&
          other.outstandingAmount == this.outstandingAmount &&
          other.isClosed == this.isClosed);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> accountId;
  final Value<int?> disbursementTransactionId;
  final Value<int> principalAmount;
  final Value<double> interestRate;
  final Value<LoanInterestType> interestType;
  final Value<int> durationMonths;
  final Value<int> paymentDay;
  final Value<int> totalPayableAmount;
  final Value<int> monthlyInstallment;
  final Value<int> outstandingAmount;
  final Value<bool> isClosed;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountId = const Value.absent(),
    this.disbursementTransactionId = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.interestType = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.paymentDay = const Value.absent(),
    this.totalPayableAmount = const Value.absent(),
    this.monthlyInstallment = const Value.absent(),
    this.outstandingAmount = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int accountId,
    this.disbursementTransactionId = const Value.absent(),
    required int principalAmount,
    required double interestRate,
    required LoanInterestType interestType,
    required int durationMonths,
    required int paymentDay,
    required int totalPayableAmount,
    required int monthlyInstallment,
    required int outstandingAmount,
    this.isClosed = const Value.absent(),
  }) : name = Value(name),
       accountId = Value(accountId),
       principalAmount = Value(principalAmount),
       interestRate = Value(interestRate),
       interestType = Value(interestType),
       durationMonths = Value(durationMonths),
       paymentDay = Value(paymentDay),
       totalPayableAmount = Value(totalPayableAmount),
       monthlyInstallment = Value(monthlyInstallment),
       outstandingAmount = Value(outstandingAmount);
  static Insertable<Loan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? accountId,
    Expression<int>? disbursementTransactionId,
    Expression<int>? principalAmount,
    Expression<double>? interestRate,
    Expression<String>? interestType,
    Expression<int>? durationMonths,
    Expression<int>? paymentDay,
    Expression<int>? totalPayableAmount,
    Expression<int>? monthlyInstallment,
    Expression<int>? outstandingAmount,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountId != null) 'account_id': accountId,
      if (disbursementTransactionId != null)
        'disbursement_transaction_id': disbursementTransactionId,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (interestType != null) 'interest_type': interestType,
      if (durationMonths != null) 'duration_months': durationMonths,
      if (paymentDay != null) 'payment_day': paymentDay,
      if (totalPayableAmount != null)
        'total_payable_amount': totalPayableAmount,
      if (monthlyInstallment != null) 'monthly_installment': monthlyInstallment,
      if (outstandingAmount != null) 'outstanding_amount': outstandingAmount,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? accountId,
    Value<int?>? disbursementTransactionId,
    Value<int>? principalAmount,
    Value<double>? interestRate,
    Value<LoanInterestType>? interestType,
    Value<int>? durationMonths,
    Value<int>? paymentDay,
    Value<int>? totalPayableAmount,
    Value<int>? monthlyInstallment,
    Value<int>? outstandingAmount,
    Value<bool>? isClosed,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountId: accountId ?? this.accountId,
      disbursementTransactionId:
          disbursementTransactionId ?? this.disbursementTransactionId,
      principalAmount: principalAmount ?? this.principalAmount,
      interestRate: interestRate ?? this.interestRate,
      interestType: interestType ?? this.interestType,
      durationMonths: durationMonths ?? this.durationMonths,
      paymentDay: paymentDay ?? this.paymentDay,
      totalPayableAmount: totalPayableAmount ?? this.totalPayableAmount,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (disbursementTransactionId.present) {
      map['disbursement_transaction_id'] = Variable<int>(
        disbursementTransactionId.value,
      );
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<int>(principalAmount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (interestType.present) {
      map['interest_type'] = Variable<String>(
        $LoansTable.$converterinterestType.toSql(interestType.value),
      );
    }
    if (durationMonths.present) {
      map['duration_months'] = Variable<int>(durationMonths.value);
    }
    if (paymentDay.present) {
      map['payment_day'] = Variable<int>(paymentDay.value);
    }
    if (totalPayableAmount.present) {
      map['total_payable_amount'] = Variable<int>(totalPayableAmount.value);
    }
    if (monthlyInstallment.present) {
      map['monthly_installment'] = Variable<int>(monthlyInstallment.value);
    }
    if (outstandingAmount.present) {
      map['outstanding_amount'] = Variable<int>(outstandingAmount.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('disbursementTransactionId: $disbursementTransactionId, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('interestType: $interestType, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('paymentDay: $paymentDay, ')
          ..write('totalPayableAmount: $totalPayableAmount, ')
          ..write('monthlyInstallment: $monthlyInstallment, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $LoanInstallmentsTable extends LoanInstallments
    with TableInfo<$LoanInstallmentsTable, LoanInstallment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanInstallmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id)',
    ),
  );
  static const VerificationMeta _installmentNumberMeta = const VerificationMeta(
    'installmentNumber',
  );
  @override
  late final GeneratedColumn<int> installmentNumber = GeneratedColumn<int>(
    'installment_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalDueMeta = const VerificationMeta(
    'principalDue',
  );
  @override
  late final GeneratedColumn<int> principalDue = GeneratedColumn<int>(
    'principal_due',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestDueMeta = const VerificationMeta(
    'interestDue',
  );
  @override
  late final GeneratedColumn<int> interestDue = GeneratedColumn<int>(
    'interest_due',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDueMeta = const VerificationMeta(
    'totalDue',
  );
  @override
  late final GeneratedColumn<int> totalDue = GeneratedColumn<int>(
    'total_due',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    installmentNumber,
    dueDate,
    principalDue,
    interestDue,
    totalDue,
    isPaid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanInstallment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('installment_number')) {
      context.handle(
        _installmentNumberMeta,
        installmentNumber.isAcceptableOrUnknown(
          data['installment_number']!,
          _installmentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentNumberMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('principal_due')) {
      context.handle(
        _principalDueMeta,
        principalDue.isAcceptableOrUnknown(
          data['principal_due']!,
          _principalDueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalDueMeta);
    }
    if (data.containsKey('interest_due')) {
      context.handle(
        _interestDueMeta,
        interestDue.isAcceptableOrUnknown(
          data['interest_due']!,
          _interestDueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestDueMeta);
    }
    if (data.containsKey('total_due')) {
      context.handle(
        _totalDueMeta,
        totalDue.isAcceptableOrUnknown(data['total_due']!, _totalDueMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDueMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanInstallment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanInstallment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      installmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_number'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      principalDue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_due'],
      )!,
      interestDue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_due'],
      )!,
      totalDue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_due'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
    );
  }

  @override
  $LoanInstallmentsTable createAlias(String alias) {
    return $LoanInstallmentsTable(attachedDatabase, alias);
  }
}

class LoanInstallment extends DataClass implements Insertable<LoanInstallment> {
  final int id;
  final int loanId;
  final int installmentNumber;
  final DateTime dueDate;
  final int principalDue;
  final int interestDue;
  final int totalDue;
  final bool isPaid;
  const LoanInstallment({
    required this.id,
    required this.loanId,
    required this.installmentNumber,
    required this.dueDate,
    required this.principalDue,
    required this.interestDue,
    required this.totalDue,
    required this.isPaid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['installment_number'] = Variable<int>(installmentNumber);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['principal_due'] = Variable<int>(principalDue);
    map['interest_due'] = Variable<int>(interestDue);
    map['total_due'] = Variable<int>(totalDue);
    map['is_paid'] = Variable<bool>(isPaid);
    return map;
  }

  LoanInstallmentsCompanion toCompanion(bool nullToAbsent) {
    return LoanInstallmentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      installmentNumber: Value(installmentNumber),
      dueDate: Value(dueDate),
      principalDue: Value(principalDue),
      interestDue: Value(interestDue),
      totalDue: Value(totalDue),
      isPaid: Value(isPaid),
    );
  }

  factory LoanInstallment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanInstallment(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      installmentNumber: serializer.fromJson<int>(json['installmentNumber']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      principalDue: serializer.fromJson<int>(json['principalDue']),
      interestDue: serializer.fromJson<int>(json['interestDue']),
      totalDue: serializer.fromJson<int>(json['totalDue']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'installmentNumber': serializer.toJson<int>(installmentNumber),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'principalDue': serializer.toJson<int>(principalDue),
      'interestDue': serializer.toJson<int>(interestDue),
      'totalDue': serializer.toJson<int>(totalDue),
      'isPaid': serializer.toJson<bool>(isPaid),
    };
  }

  LoanInstallment copyWith({
    int? id,
    int? loanId,
    int? installmentNumber,
    DateTime? dueDate,
    int? principalDue,
    int? interestDue,
    int? totalDue,
    bool? isPaid,
  }) => LoanInstallment(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    installmentNumber: installmentNumber ?? this.installmentNumber,
    dueDate: dueDate ?? this.dueDate,
    principalDue: principalDue ?? this.principalDue,
    interestDue: interestDue ?? this.interestDue,
    totalDue: totalDue ?? this.totalDue,
    isPaid: isPaid ?? this.isPaid,
  );
  LoanInstallment copyWithCompanion(LoanInstallmentsCompanion data) {
    return LoanInstallment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      installmentNumber: data.installmentNumber.present
          ? data.installmentNumber.value
          : this.installmentNumber,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      principalDue: data.principalDue.present
          ? data.principalDue.value
          : this.principalDue,
      interestDue: data.interestDue.present
          ? data.interestDue.value
          : this.interestDue,
      totalDue: data.totalDue.present ? data.totalDue.value : this.totalDue,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanInstallment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('dueDate: $dueDate, ')
          ..write('principalDue: $principalDue, ')
          ..write('interestDue: $interestDue, ')
          ..write('totalDue: $totalDue, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loanId,
    installmentNumber,
    dueDate,
    principalDue,
    interestDue,
    totalDue,
    isPaid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanInstallment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.installmentNumber == this.installmentNumber &&
          other.dueDate == this.dueDate &&
          other.principalDue == this.principalDue &&
          other.interestDue == this.interestDue &&
          other.totalDue == this.totalDue &&
          other.isPaid == this.isPaid);
}

class LoanInstallmentsCompanion extends UpdateCompanion<LoanInstallment> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> installmentNumber;
  final Value<DateTime> dueDate;
  final Value<int> principalDue;
  final Value<int> interestDue;
  final Value<int> totalDue;
  final Value<bool> isPaid;
  const LoanInstallmentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.installmentNumber = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.principalDue = const Value.absent(),
    this.interestDue = const Value.absent(),
    this.totalDue = const Value.absent(),
    this.isPaid = const Value.absent(),
  });
  LoanInstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int installmentNumber,
    required DateTime dueDate,
    required int principalDue,
    required int interestDue,
    required int totalDue,
    this.isPaid = const Value.absent(),
  }) : loanId = Value(loanId),
       installmentNumber = Value(installmentNumber),
       dueDate = Value(dueDate),
       principalDue = Value(principalDue),
       interestDue = Value(interestDue),
       totalDue = Value(totalDue);
  static Insertable<LoanInstallment> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? installmentNumber,
    Expression<DateTime>? dueDate,
    Expression<int>? principalDue,
    Expression<int>? interestDue,
    Expression<int>? totalDue,
    Expression<bool>? isPaid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (installmentNumber != null) 'installment_number': installmentNumber,
      if (dueDate != null) 'due_date': dueDate,
      if (principalDue != null) 'principal_due': principalDue,
      if (interestDue != null) 'interest_due': interestDue,
      if (totalDue != null) 'total_due': totalDue,
      if (isPaid != null) 'is_paid': isPaid,
    });
  }

  LoanInstallmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<int>? installmentNumber,
    Value<DateTime>? dueDate,
    Value<int>? principalDue,
    Value<int>? interestDue,
    Value<int>? totalDue,
    Value<bool>? isPaid,
  }) {
    return LoanInstallmentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      principalDue: principalDue ?? this.principalDue,
      interestDue: interestDue ?? this.interestDue,
      totalDue: totalDue ?? this.totalDue,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (installmentNumber.present) {
      map['installment_number'] = Variable<int>(installmentNumber.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (principalDue.present) {
      map['principal_due'] = Variable<int>(principalDue.value);
    }
    if (interestDue.present) {
      map['interest_due'] = Variable<int>(interestDue.value);
    }
    if (totalDue.present) {
      map['total_due'] = Variable<int>(totalDue.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanInstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('dueDate: $dueDate, ')
          ..write('principalDue: $principalDue, ')
          ..write('interestDue: $interestDue, ')
          ..write('totalDue: $totalDue, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTable extends LoanPayments
    with TableInfo<$LoanPaymentsTable, LoanPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id)',
    ),
  );
  static const VerificationMeta _installmentIdMeta = const VerificationMeta(
    'installmentId',
  );
  @override
  late final GeneratedColumn<int> installmentId = GeneratedColumn<int>(
    'installment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loan_installments (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalPartMeta = const VerificationMeta(
    'principalPart',
  );
  @override
  late final GeneratedColumn<int> principalPart = GeneratedColumn<int>(
    'principal_part',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestPartMeta = const VerificationMeta(
    'interestPart',
  );
  @override
  late final GeneratedColumn<int> interestPart = GeneratedColumn<int>(
    'interest_part',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    installmentId,
    transactionId,
    amount,
    principalPart,
    interestPart,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('installment_id')) {
      context.handle(
        _installmentIdMeta,
        installmentId.isAcceptableOrUnknown(
          data['installment_id']!,
          _installmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('principal_part')) {
      context.handle(
        _principalPartMeta,
        principalPart.isAcceptableOrUnknown(
          data['principal_part']!,
          _principalPartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalPartMeta);
    }
    if (data.containsKey('interest_part')) {
      context.handle(
        _interestPartMeta,
        interestPart.isAcceptableOrUnknown(
          data['interest_part']!,
          _interestPartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestPartMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      installmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      principalPart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_part'],
      )!,
      interestPart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_part'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $LoanPaymentsTable createAlias(String alias) {
    return $LoanPaymentsTable(attachedDatabase, alias);
  }
}

class LoanPayment extends DataClass implements Insertable<LoanPayment> {
  final int id;
  final int loanId;
  final int installmentId;
  final int transactionId;
  final int amount;
  final int principalPart;
  final int interestPart;
  final DateTime date;
  const LoanPayment({
    required this.id,
    required this.loanId,
    required this.installmentId,
    required this.transactionId,
    required this.amount,
    required this.principalPart,
    required this.interestPart,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['installment_id'] = Variable<int>(installmentId);
    map['transaction_id'] = Variable<int>(transactionId);
    map['amount'] = Variable<int>(amount);
    map['principal_part'] = Variable<int>(principalPart);
    map['interest_part'] = Variable<int>(interestPart);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  LoanPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      installmentId: Value(installmentId),
      transactionId: Value(transactionId),
      amount: Value(amount),
      principalPart: Value(principalPart),
      interestPart: Value(interestPart),
      date: Value(date),
    );
  }

  factory LoanPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPayment(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      installmentId: serializer.fromJson<int>(json['installmentId']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      amount: serializer.fromJson<int>(json['amount']),
      principalPart: serializer.fromJson<int>(json['principalPart']),
      interestPart: serializer.fromJson<int>(json['interestPart']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'installmentId': serializer.toJson<int>(installmentId),
      'transactionId': serializer.toJson<int>(transactionId),
      'amount': serializer.toJson<int>(amount),
      'principalPart': serializer.toJson<int>(principalPart),
      'interestPart': serializer.toJson<int>(interestPart),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  LoanPayment copyWith({
    int? id,
    int? loanId,
    int? installmentId,
    int? transactionId,
    int? amount,
    int? principalPart,
    int? interestPart,
    DateTime? date,
  }) => LoanPayment(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    installmentId: installmentId ?? this.installmentId,
    transactionId: transactionId ?? this.transactionId,
    amount: amount ?? this.amount,
    principalPart: principalPart ?? this.principalPart,
    interestPart: interestPart ?? this.interestPart,
    date: date ?? this.date,
  );
  LoanPayment copyWithCompanion(LoanPaymentsCompanion data) {
    return LoanPayment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      installmentId: data.installmentId.present
          ? data.installmentId.value
          : this.installmentId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      principalPart: data.principalPart.present
          ? data.principalPart.value
          : this.principalPart,
      interestPart: data.interestPart.present
          ? data.interestPart.value
          : this.interestPart,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPayment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentId: $installmentId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amount: $amount, ')
          ..write('principalPart: $principalPart, ')
          ..write('interestPart: $interestPart, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loanId,
    installmentId,
    transactionId,
    amount,
    principalPart,
    interestPart,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPayment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.installmentId == this.installmentId &&
          other.transactionId == this.transactionId &&
          other.amount == this.amount &&
          other.principalPart == this.principalPart &&
          other.interestPart == this.interestPart &&
          other.date == this.date);
}

class LoanPaymentsCompanion extends UpdateCompanion<LoanPayment> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> installmentId;
  final Value<int> transactionId;
  final Value<int> amount;
  final Value<int> principalPart;
  final Value<int> interestPart;
  final Value<DateTime> date;
  const LoanPaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.installmentId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.principalPart = const Value.absent(),
    this.interestPart = const Value.absent(),
    this.date = const Value.absent(),
  });
  LoanPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int installmentId,
    required int transactionId,
    required int amount,
    required int principalPart,
    required int interestPart,
    required DateTime date,
  }) : loanId = Value(loanId),
       installmentId = Value(installmentId),
       transactionId = Value(transactionId),
       amount = Value(amount),
       principalPart = Value(principalPart),
       interestPart = Value(interestPart),
       date = Value(date);
  static Insertable<LoanPayment> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? installmentId,
    Expression<int>? transactionId,
    Expression<int>? amount,
    Expression<int>? principalPart,
    Expression<int>? interestPart,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (installmentId != null) 'installment_id': installmentId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (amount != null) 'amount': amount,
      if (principalPart != null) 'principal_part': principalPart,
      if (interestPart != null) 'interest_part': interestPart,
      if (date != null) 'date': date,
    });
  }

  LoanPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<int>? installmentId,
    Value<int>? transactionId,
    Value<int>? amount,
    Value<int>? principalPart,
    Value<int>? interestPart,
    Value<DateTime>? date,
  }) {
    return LoanPaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      installmentId: installmentId ?? this.installmentId,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      principalPart: principalPart ?? this.principalPart,
      interestPart: interestPart ?? this.interestPart,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (installmentId.present) {
      map['installment_id'] = Variable<int>(installmentId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (principalPart.present) {
      map['principal_part'] = Variable<int>(principalPart.value);
    }
    if (interestPart.present) {
      map['interest_part'] = Variable<int>(interestPart.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('installmentId: $installmentId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amount: $amount, ')
          ..write('principalPart: $principalPart, ')
          ..write('interestPart: $interestPart, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $LoanInstallmentsTable loanInstallments = $LoanInstallmentsTable(
    this,
  );
  late final $LoanPaymentsTable loanPayments = $LoanPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    preferences,
    transactions,
    transfers,
    loans,
    loanInstallments,
    loanPayments,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String name,
      required AccountType type,
      required int openingBalance,
      required int currentBalance,
      Value<int?> creditLimit,
      Value<int?> billingStartDay,
      Value<int?> dueDay,
      Value<bool> isArchived,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<AccountType> type,
      Value<int> openingBalance,
      Value<int> currentBalance,
      Value<int?> creditLimit,
      Value<int?> billingStartDay,
      Value<int?> dueDay,
      Value<bool> isArchived,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.transactions.accountId),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTable, List<Transfer>>
  _outgoingTransfersTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfers,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.transfers.fromAccountId),
  );

  $$TransfersTableProcessedTableManager get outgoingTransfers {
    final manager = $$TransfersTableTableManager(
      $_db,
      $_db.transfers,
    ).filter((f) => f.fromAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_outgoingTransfersTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTable, List<Transfer>>
  _incomingTransfersTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfers,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.transfers.toAccountId),
  );

  $$TransfersTableProcessedTableManager get incomingTransfers {
    final manager = $$TransfersTableTableManager(
      $_db,
      $_db.transfers,
    ).filter((f) => f.toAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomingTransfersTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoansTable, List<Loan>> _loansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.loans.accountId),
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingStartDay => $composableBuilder(
    column: $table.billingStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outgoingTransfers(
    Expression<bool> Function($$TransfersTableFilterComposer f) f,
  ) {
    final $$TransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.fromAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableFilterComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingTransfers(
    Expression<bool> Function($$TransfersTableFilterComposer f) f,
  ) {
    final $$TransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.toAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableFilterComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingStartDay => $composableBuilder(
    column: $table.billingStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billingStartDay => $composableBuilder(
    column: $table.billingStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> outgoingTransfers<T extends Object>(
    Expression<T> Function($$TransfersTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.fromAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableAnnotationComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingTransfers<T extends Object>(
    Expression<T> Function($$TransfersTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.toAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableAnnotationComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool outgoingTransfers,
            bool incomingTransfers,
            bool loansRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<int> currentBalance = const Value.absent(),
                Value<int?> creditLimit = const Value.absent(),
                Value<int?> billingStartDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                openingBalance: openingBalance,
                currentBalance: currentBalance,
                creditLimit: creditLimit,
                billingStartDay: billingStartDay,
                dueDay: dueDay,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required AccountType type,
                required int openingBalance,
                required int currentBalance,
                Value<int?> creditLimit = const Value.absent(),
                Value<int?> billingStartDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                openingBalance: openingBalance,
                currentBalance: currentBalance,
                creditLimit: creditLimit,
                billingStartDay: billingStartDay,
                dueDay: dueDay,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                outgoingTransfers = false,
                incomingTransfers = false,
                loansRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (outgoingTransfers) db.transfers,
                    if (incomingTransfers) db.transfers,
                    if (loansRefs) db.loans,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (outgoingTransfers)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Transfer
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._outgoingTransfersTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingTransfers,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingTransfers)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Transfer
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._incomingTransfersTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingTransfers,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loansRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Loan
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._loansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).loansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
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

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool outgoingTransfers,
        bool incomingTransfers,
        bool loansRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> parentId,
      required int color,
      required int icon,
      Value<bool> isIncome,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> parentId,
      Value<int> color,
      Value<int> icon,
      Value<bool> isIncome,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.categories.parentId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.transactions.categoryId,
    ),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool parentId, bool transactionsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> icon = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                color: color,
                icon: icon,
                isIncome: isIncome,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> parentId = const Value.absent(),
                required int color,
                required int icon,
                Value<bool> isIncome = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                color: color,
                icon: icon,
                isIncome: isIncome,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({parentId = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
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
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$CategoriesTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn:
                                        $$CategoriesTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
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

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool parentId, bool transactionsRefs})
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String> currencyCode,
      Value<int> firstDayOfWeek,
      Value<AppThemeMode> themeMode,
      Value<bool> isDemoMode,
      Value<bool> hasSeenFirstRunPrompt,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String> currencyCode,
      Value<int> firstDayOfWeek,
      Value<AppThemeMode> themeMode,
      Value<bool> isDemoMode,
      Value<bool> hasSeenFirstRunPrompt,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
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

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDemoMode => $composableBuilder(
    column: $table.isDemoMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSeenFirstRunPrompt => $composableBuilder(
    column: $table.hasSeenFirstRunPrompt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
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

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemoMode => $composableBuilder(
    column: $table.isDemoMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSeenFirstRunPrompt => $composableBuilder(
    column: $table.hasSeenFirstRunPrompt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get isDemoMode => $composableBuilder(
    column: $table.isDemoMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSeenFirstRunPrompt => $composableBuilder(
    column: $table.hasSeenFirstRunPrompt,
    builder: (column) => column,
  );
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> firstDayOfWeek = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> isDemoMode = const Value.absent(),
                Value<bool> hasSeenFirstRunPrompt = const Value.absent(),
              }) => PreferencesCompanion(
                id: id,
                currencyCode: currencyCode,
                firstDayOfWeek: firstDayOfWeek,
                themeMode: themeMode,
                isDemoMode: isDemoMode,
                hasSeenFirstRunPrompt: hasSeenFirstRunPrompt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> firstDayOfWeek = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<bool> isDemoMode = const Value.absent(),
                Value<bool> hasSeenFirstRunPrompt = const Value.absent(),
              }) => PreferencesCompanion.insert(
                id: id,
                currencyCode: currencyCode,
                firstDayOfWeek: firstDayOfWeek,
                themeMode: themeMode,
                isDemoMode: isDemoMode,
                hasSeenFirstRunPrompt: hasSeenFirstRunPrompt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int amount,
      required TransactionType type,
      required int accountId,
      Value<int?> categoryId,
      Value<String?> note,
      required DateTime date,
      Value<bool> isPending,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> amount,
      Value<TransactionType> type,
      Value<int> accountId,
      Value<int?> categoryId,
      Value<String?> note,
      Value<DateTime> date,
      Value<bool> isPending,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.transactions.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.transactions.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LoansTable, List<Loan>> _loansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.loans.disbursementTransactionId,
    ),
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager($_db, $_db.loans).filter(
      (f) => f.disbursementTransactionId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
  _loanPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanPayments,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.loanPayments.transactionId,
    ),
  );

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager(
      $_db,
      $_db.loanPayments,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.disbursementTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loanPaymentsRefs(
    Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f,
  ) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.disbursementTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loanPaymentsRefs<T extends Object>(
    Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool loansRefs,
            bool loanPaymentsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isPending = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amount: amount,
                type: type,
                accountId: accountId,
                categoryId: categoryId,
                note: note,
                date: date,
                isPending: isPending,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amount,
                required TransactionType type,
                required int accountId,
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime date,
                Value<bool> isPending = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amount: amount,
                type: type,
                accountId: accountId,
                categoryId: categoryId,
                note: note,
                date: date,
                isPending: isPending,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                categoryId = false,
                loansRefs = false,
                loanPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (loansRefs) db.loans,
                    if (loanPaymentsRefs) db.loanPayments,
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
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (loansRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          Loan
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._loansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).loansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.disbursementTransactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loanPaymentsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          LoanPayment
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._loanPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).loanPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
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

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool accountId,
        bool categoryId,
        bool loansRefs,
        bool loanPaymentsRefs,
      })
    >;
typedef $$TransfersTableCreateCompanionBuilder =
    TransfersCompanion Function({
      Value<int> id,
      required int fromAccountId,
      required int toAccountId,
      required int amount,
      required DateTime date,
      Value<String> linkedTransactionIds,
    });
typedef $$TransfersTableUpdateCompanionBuilder =
    TransfersCompanion Function({
      Value<int> id,
      Value<int> fromAccountId,
      Value<int> toAccountId,
      Value<int> amount,
      Value<DateTime> date,
      Value<String> linkedTransactionIds,
    });

final class $$TransfersTableReferences
    extends BaseReferences<_$AppDatabase, $TransfersTable, Transfer> {
  $$TransfersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _fromAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.transfers.fromAccountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get fromAccountId {
    final $_column = $_itemColumn<int>('from_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _toAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.transfers.toAccountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransfersTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer({
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

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedTransactionIds => $composableBuilder(
    column: $table.linkedTransactionIds,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get fromAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get toAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer({
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

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedTransactionIds => $composableBuilder(
    column: $table.linkedTransactionIds,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get fromAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get toAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get linkedTransactionIds => $composableBuilder(
    column: $table.linkedTransactionIds,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get fromAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get toAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransfersTable,
          Transfer,
          $$TransfersTableFilterComposer,
          $$TransfersTableOrderingComposer,
          $$TransfersTableAnnotationComposer,
          $$TransfersTableCreateCompanionBuilder,
          $$TransfersTableUpdateCompanionBuilder,
          (Transfer, $$TransfersTableReferences),
          Transfer,
          PrefetchHooks Function({bool fromAccountId, bool toAccountId})
        > {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromAccountId = const Value.absent(),
                Value<int> toAccountId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> linkedTransactionIds = const Value.absent(),
              }) => TransfersCompanion(
                id: id,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amount: amount,
                date: date,
                linkedTransactionIds: linkedTransactionIds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromAccountId,
                required int toAccountId,
                required int amount,
                required DateTime date,
                Value<String> linkedTransactionIds = const Value.absent(),
              }) => TransfersCompanion.insert(
                id: id,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amount: amount,
                date: date,
                linkedTransactionIds: linkedTransactionIds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransfersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fromAccountId = false, toAccountId = false}) {
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
                        if (fromAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromAccountId,
                                    referencedTable: $$TransfersTableReferences
                                        ._fromAccountIdTable(db),
                                    referencedColumn: $$TransfersTableReferences
                                        ._fromAccountIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (toAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toAccountId,
                                    referencedTable: $$TransfersTableReferences
                                        ._toAccountIdTable(db),
                                    referencedColumn: $$TransfersTableReferences
                                        ._toAccountIdTable(db)
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

typedef $$TransfersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransfersTable,
      Transfer,
      $$TransfersTableFilterComposer,
      $$TransfersTableOrderingComposer,
      $$TransfersTableAnnotationComposer,
      $$TransfersTableCreateCompanionBuilder,
      $$TransfersTableUpdateCompanionBuilder,
      (Transfer, $$TransfersTableReferences),
      Transfer,
      PrefetchHooks Function({bool fromAccountId, bool toAccountId})
    >;
typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      required String name,
      required int accountId,
      Value<int?> disbursementTransactionId,
      required int principalAmount,
      required double interestRate,
      required LoanInterestType interestType,
      required int durationMonths,
      required int paymentDay,
      required int totalPayableAmount,
      required int monthlyInstallment,
      required int outstandingAmount,
      Value<bool> isClosed,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> accountId,
      Value<int?> disbursementTransactionId,
      Value<int> principalAmount,
      Value<double> interestRate,
      Value<LoanInterestType> interestType,
      Value<int> durationMonths,
      Value<int> paymentDay,
      Value<int> totalPayableAmount,
      Value<int> monthlyInstallment,
      Value<int> outstandingAmount,
      Value<bool> isClosed,
    });

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) => db.accounts
      .createAlias($_aliasNameGenerator(db.loans.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _disbursementTransactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.loans.disbursementTransactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager? get disbursementTransactionId {
    final $_column = $_itemColumn<int>('disbursement_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _disbursementTransactionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LoanInstallmentsTable, List<LoanInstallment>>
  _loanInstallmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanInstallments,
    aliasName: $_aliasNameGenerator(db.loans.id, db.loanInstallments.loanId),
  );

  $$LoanInstallmentsTableProcessedTableManager get loanInstallmentsRefs {
    final manager = $$LoanInstallmentsTableTableManager(
      $_db,
      $_db.loanInstallments,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _loanInstallmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
  _loanPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanPayments,
    aliasName: $_aliasNameGenerator(db.loans.id, db.loanPayments.loanId),
  );

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager(
      $_db,
      $_db.loanPayments,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoanInterestType, LoanInterestType, String>
  get interestType => $composableBuilder(
    column: $table.interestType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentDay => $composableBuilder(
    column: $table.paymentDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPayableAmount => $composableBuilder(
    column: $table.totalPayableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyInstallment => $composableBuilder(
    column: $table.monthlyInstallment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get disbursementTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disbursementTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> loanInstallmentsRefs(
    Expression<bool> Function($$LoanInstallmentsTableFilterComposer f) f,
  ) {
    final $$LoanInstallmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanInstallments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanInstallmentsTableFilterComposer(
            $db: $db,
            $table: $db.loanInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loanPaymentsRefs(
    Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f,
  ) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interestType => $composableBuilder(
    column: $table.interestType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentDay => $composableBuilder(
    column: $table.paymentDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPayableAmount => $composableBuilder(
    column: $table.totalPayableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyInstallment => $composableBuilder(
    column: $table.monthlyInstallment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get disbursementTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disbursementTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LoanInterestType, String> get interestType =>
      $composableBuilder(
        column: $table.interestType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentDay => $composableBuilder(
    column: $table.paymentDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPayableAmount => $composableBuilder(
    column: $table.totalPayableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyInstallment => $composableBuilder(
    column: $table.monthlyInstallment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outstandingAmount => $composableBuilder(
    column: $table.outstandingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get disbursementTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disbursementTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> loanInstallmentsRefs<T extends Object>(
    Expression<T> Function($$LoanInstallmentsTableAnnotationComposer a) f,
  ) {
    final $$LoanInstallmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanInstallments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanInstallmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loanPaymentsRefs<T extends Object>(
    Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, $$LoansTableReferences),
          Loan,
          PrefetchHooks Function({
            bool accountId,
            bool disbursementTransactionId,
            bool loanInstallmentsRefs,
            bool loanPaymentsRefs,
          })
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> disbursementTransactionId = const Value.absent(),
                Value<int> principalAmount = const Value.absent(),
                Value<double> interestRate = const Value.absent(),
                Value<LoanInterestType> interestType = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<int> paymentDay = const Value.absent(),
                Value<int> totalPayableAmount = const Value.absent(),
                Value<int> monthlyInstallment = const Value.absent(),
                Value<int> outstandingAmount = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                name: name,
                accountId: accountId,
                disbursementTransactionId: disbursementTransactionId,
                principalAmount: principalAmount,
                interestRate: interestRate,
                interestType: interestType,
                durationMonths: durationMonths,
                paymentDay: paymentDay,
                totalPayableAmount: totalPayableAmount,
                monthlyInstallment: monthlyInstallment,
                outstandingAmount: outstandingAmount,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int accountId,
                Value<int?> disbursementTransactionId = const Value.absent(),
                required int principalAmount,
                required double interestRate,
                required LoanInterestType interestType,
                required int durationMonths,
                required int paymentDay,
                required int totalPayableAmount,
                required int monthlyInstallment,
                required int outstandingAmount,
                Value<bool> isClosed = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                name: name,
                accountId: accountId,
                disbursementTransactionId: disbursementTransactionId,
                principalAmount: principalAmount,
                interestRate: interestRate,
                interestType: interestType,
                durationMonths: durationMonths,
                paymentDay: paymentDay,
                totalPayableAmount: totalPayableAmount,
                monthlyInstallment: monthlyInstallment,
                outstandingAmount: outstandingAmount,
                isClosed: isClosed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LoansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                disbursementTransactionId = false,
                loanInstallmentsRefs = false,
                loanPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (loanInstallmentsRefs) db.loanInstallments,
                    if (loanPaymentsRefs) db.loanPayments,
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
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable: $$LoansTableReferences
                                        ._accountIdTable(db),
                                    referencedColumn: $$LoansTableReferences
                                        ._accountIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (disbursementTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.disbursementTransactionId,
                                    referencedTable: $$LoansTableReferences
                                        ._disbursementTransactionIdTable(db),
                                    referencedColumn: $$LoansTableReferences
                                        ._disbursementTransactionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (loanInstallmentsRefs)
                        await $_getPrefetchedData<
                          Loan,
                          $LoansTable,
                          LoanInstallment
                        >(
                          currentTable: table,
                          referencedTable: $$LoansTableReferences
                              ._loanInstallmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LoansTableReferences(
                                db,
                                table,
                                p0,
                              ).loanInstallmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loanPaymentsRefs)
                        await $_getPrefetchedData<
                          Loan,
                          $LoansTable,
                          LoanPayment
                        >(
                          currentTable: table,
                          referencedTable: $$LoansTableReferences
                              ._loanPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LoansTableReferences(
                                db,
                                table,
                                p0,
                              ).loanPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loanId == item.id,
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

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, $$LoansTableReferences),
      Loan,
      PrefetchHooks Function({
        bool accountId,
        bool disbursementTransactionId,
        bool loanInstallmentsRefs,
        bool loanPaymentsRefs,
      })
    >;
typedef $$LoanInstallmentsTableCreateCompanionBuilder =
    LoanInstallmentsCompanion Function({
      Value<int> id,
      required int loanId,
      required int installmentNumber,
      required DateTime dueDate,
      required int principalDue,
      required int interestDue,
      required int totalDue,
      Value<bool> isPaid,
    });
typedef $$LoanInstallmentsTableUpdateCompanionBuilder =
    LoanInstallmentsCompanion Function({
      Value<int> id,
      Value<int> loanId,
      Value<int> installmentNumber,
      Value<DateTime> dueDate,
      Value<int> principalDue,
      Value<int> interestDue,
      Value<int> totalDue,
      Value<bool> isPaid,
    });

final class $$LoanInstallmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $LoanInstallmentsTable, LoanInstallment> {
  $$LoanInstallmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LoansTable _loanIdTable(_$AppDatabase db) => db.loans.createAlias(
    $_aliasNameGenerator(db.loanInstallments.loanId, db.loans.id),
  );

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
  _loanPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanPayments,
    aliasName: $_aliasNameGenerator(
      db.loanInstallments.id,
      db.loanPayments.installmentId,
    ),
  );

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager(
      $_db,
      $_db.loanPayments,
    ).filter((f) => f.installmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoanInstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanInstallmentsTable> {
  $$LoanInstallmentsTableFilterComposer({
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

  ColumnFilters<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalDue => $composableBuilder(
    column: $table.principalDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestDue => $composableBuilder(
    column: $table.interestDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDue => $composableBuilder(
    column: $table.totalDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> loanPaymentsRefs(
    Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f,
  ) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.installmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoanInstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanInstallmentsTable> {
  $$LoanInstallmentsTableOrderingComposer({
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

  ColumnOrderings<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalDue => $composableBuilder(
    column: $table.principalDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestDue => $composableBuilder(
    column: $table.interestDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDue => $composableBuilder(
    column: $table.totalDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanInstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanInstallmentsTable> {
  $$LoanInstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get principalDue => $composableBuilder(
    column: $table.principalDue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestDue => $composableBuilder(
    column: $table.interestDue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDue =>
      $composableBuilder(column: $table.totalDue, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> loanPaymentsRefs<T extends Object>(
    Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.installmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoanInstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanInstallmentsTable,
          LoanInstallment,
          $$LoanInstallmentsTableFilterComposer,
          $$LoanInstallmentsTableOrderingComposer,
          $$LoanInstallmentsTableAnnotationComposer,
          $$LoanInstallmentsTableCreateCompanionBuilder,
          $$LoanInstallmentsTableUpdateCompanionBuilder,
          (LoanInstallment, $$LoanInstallmentsTableReferences),
          LoanInstallment,
          PrefetchHooks Function({bool loanId, bool loanPaymentsRefs})
        > {
  $$LoanInstallmentsTableTableManager(
    _$AppDatabase db,
    $LoanInstallmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanInstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanInstallmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanInstallmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<int> installmentNumber = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> principalDue = const Value.absent(),
                Value<int> interestDue = const Value.absent(),
                Value<int> totalDue = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
              }) => LoanInstallmentsCompanion(
                id: id,
                loanId: loanId,
                installmentNumber: installmentNumber,
                dueDate: dueDate,
                principalDue: principalDue,
                interestDue: interestDue,
                totalDue: totalDue,
                isPaid: isPaid,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required int installmentNumber,
                required DateTime dueDate,
                required int principalDue,
                required int interestDue,
                required int totalDue,
                Value<bool> isPaid = const Value.absent(),
              }) => LoanInstallmentsCompanion.insert(
                id: id,
                loanId: loanId,
                installmentNumber: installmentNumber,
                dueDate: dueDate,
                principalDue: principalDue,
                interestDue: interestDue,
                totalDue: totalDue,
                isPaid: isPaid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoanInstallmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loanId = false, loanPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loanPaymentsRefs) db.loanPayments],
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
                    if (loanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.loanId,
                                referencedTable:
                                    $$LoanInstallmentsTableReferences
                                        ._loanIdTable(db),
                                referencedColumn:
                                    $$LoanInstallmentsTableReferences
                                        ._loanIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loanPaymentsRefs)
                    await $_getPrefetchedData<
                      LoanInstallment,
                      $LoanInstallmentsTable,
                      LoanPayment
                    >(
                      currentTable: table,
                      referencedTable: $$LoanInstallmentsTableReferences
                          ._loanPaymentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LoanInstallmentsTableReferences(
                            db,
                            table,
                            p0,
                          ).loanPaymentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.installmentId == item.id,
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

typedef $$LoanInstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanInstallmentsTable,
      LoanInstallment,
      $$LoanInstallmentsTableFilterComposer,
      $$LoanInstallmentsTableOrderingComposer,
      $$LoanInstallmentsTableAnnotationComposer,
      $$LoanInstallmentsTableCreateCompanionBuilder,
      $$LoanInstallmentsTableUpdateCompanionBuilder,
      (LoanInstallment, $$LoanInstallmentsTableReferences),
      LoanInstallment,
      PrefetchHooks Function({bool loanId, bool loanPaymentsRefs})
    >;
typedef $$LoanPaymentsTableCreateCompanionBuilder =
    LoanPaymentsCompanion Function({
      Value<int> id,
      required int loanId,
      required int installmentId,
      required int transactionId,
      required int amount,
      required int principalPart,
      required int interestPart,
      required DateTime date,
    });
typedef $$LoanPaymentsTableUpdateCompanionBuilder =
    LoanPaymentsCompanion Function({
      Value<int> id,
      Value<int> loanId,
      Value<int> installmentId,
      Value<int> transactionId,
      Value<int> amount,
      Value<int> principalPart,
      Value<int> interestPart,
      Value<DateTime> date,
    });

final class $$LoanPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $LoanPaymentsTable, LoanPayment> {
  $$LoanPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDatabase db) => db.loans.createAlias(
    $_aliasNameGenerator(db.loanPayments.loanId, db.loans.id),
  );

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LoanInstallmentsTable _installmentIdTable(_$AppDatabase db) =>
      db.loanInstallments.createAlias(
        $_aliasNameGenerator(
          db.loanPayments.installmentId,
          db.loanInstallments.id,
        ),
      );

  $$LoanInstallmentsTableProcessedTableManager get installmentId {
    final $_column = $_itemColumn<int>('installment_id')!;

    final manager = $$LoanInstallmentsTableTableManager(
      $_db,
      $_db.loanInstallments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_installmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(db.loanPayments.transactionId, db.transactions.id),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoanPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableFilterComposer({
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

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalPart => $composableBuilder(
    column: $table.principalPart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestPart => $composableBuilder(
    column: $table.interestPart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LoanInstallmentsTableFilterComposer get installmentId {
    final $$LoanInstallmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentId,
      referencedTable: $db.loanInstallments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanInstallmentsTableFilterComposer(
            $db: $db,
            $table: $db.loanInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableOrderingComposer({
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

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalPart => $composableBuilder(
    column: $table.principalPart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestPart => $composableBuilder(
    column: $table.interestPart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LoanInstallmentsTableOrderingComposer get installmentId {
    final $$LoanInstallmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentId,
      referencedTable: $db.loanInstallments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanInstallmentsTableOrderingComposer(
            $db: $db,
            $table: $db.loanInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get principalPart => $composableBuilder(
    column: $table.principalPart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestPart => $composableBuilder(
    column: $table.interestPart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LoanInstallmentsTableAnnotationComposer get installmentId {
    final $$LoanInstallmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentId,
      referencedTable: $db.loanInstallments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanInstallmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanPaymentsTable,
          LoanPayment,
          $$LoanPaymentsTableFilterComposer,
          $$LoanPaymentsTableOrderingComposer,
          $$LoanPaymentsTableAnnotationComposer,
          $$LoanPaymentsTableCreateCompanionBuilder,
          $$LoanPaymentsTableUpdateCompanionBuilder,
          (LoanPayment, $$LoanPaymentsTableReferences),
          LoanPayment,
          PrefetchHooks Function({
            bool loanId,
            bool installmentId,
            bool transactionId,
          })
        > {
  $$LoanPaymentsTableTableManager(_$AppDatabase db, $LoanPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<int> installmentId = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> principalPart = const Value.absent(),
                Value<int> interestPart = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => LoanPaymentsCompanion(
                id: id,
                loanId: loanId,
                installmentId: installmentId,
                transactionId: transactionId,
                amount: amount,
                principalPart: principalPart,
                interestPart: interestPart,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required int installmentId,
                required int transactionId,
                required int amount,
                required int principalPart,
                required int interestPart,
                required DateTime date,
              }) => LoanPaymentsCompanion.insert(
                id: id,
                loanId: loanId,
                installmentId: installmentId,
                transactionId: transactionId,
                amount: amount,
                principalPart: principalPart,
                interestPart: interestPart,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoanPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({loanId = false, installmentId = false, transactionId = false}) {
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
                        if (loanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.loanId,
                                    referencedTable:
                                        $$LoanPaymentsTableReferences
                                            ._loanIdTable(db),
                                    referencedColumn:
                                        $$LoanPaymentsTableReferences
                                            ._loanIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (installmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.installmentId,
                                    referencedTable:
                                        $$LoanPaymentsTableReferences
                                            ._installmentIdTable(db),
                                    referencedColumn:
                                        $$LoanPaymentsTableReferences
                                            ._installmentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transactionId,
                                    referencedTable:
                                        $$LoanPaymentsTableReferences
                                            ._transactionIdTable(db),
                                    referencedColumn:
                                        $$LoanPaymentsTableReferences
                                            ._transactionIdTable(db)
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

typedef $$LoanPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanPaymentsTable,
      LoanPayment,
      $$LoanPaymentsTableFilterComposer,
      $$LoanPaymentsTableOrderingComposer,
      $$LoanPaymentsTableAnnotationComposer,
      $$LoanPaymentsTableCreateCompanionBuilder,
      $$LoanPaymentsTableUpdateCompanionBuilder,
      (LoanPayment, $$LoanPaymentsTableReferences),
      LoanPayment,
      PrefetchHooks Function({
        bool loanId,
        bool installmentId,
        bool transactionId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$LoanInstallmentsTableTableManager get loanInstallments =>
      $$LoanInstallmentsTableTableManager(_db, _db.loanInstallments);
  $$LoanPaymentsTableTableManager get loanPayments =>
      $$LoanPaymentsTableTableManager(_db, _db.loanPayments);
}
