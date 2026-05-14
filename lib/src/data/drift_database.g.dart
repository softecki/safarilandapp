// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mechantCodeMeta =
      const VerificationMeta('mechantCode');
  @override
  late final GeneratedColumn<String> mechantCode = GeneratedColumn<String>(
      'mechant_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _identificationNumberMeta =
      const VerificationMeta('identificationNumber');
  @override
  late final GeneratedColumn<String> identificationNumber =
      GeneratedColumn<String>('identification_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenceNumberMeta =
      const VerificationMeta('licenceNumber');
  @override
  late final GeneratedColumn<String> licenceNumber = GeneratedColumn<String>(
      'licence_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentRefenceIdMeta =
      const VerificationMeta('documentRefenceId');
  @override
  late final GeneratedColumn<String> documentRefenceId =
      GeneratedColumn<String>('document_refence_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<int> agentId = GeneratedColumn<int>(
      'agent_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _otpMeta = const VerificationMeta('otp');
  @override
  late final GeneratedColumn<String> otp = GeneratedColumn<String>(
      'otp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mechantCode,
        name,
        phone,
        password,
        email,
        identificationNumber,
        licenceNumber,
        documentRefenceId,
        status,
        agentId,
        userId,
        otp,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mechant_code')) {
      context.handle(
          _mechantCodeMeta,
          mechantCode.isAcceptableOrUnknown(
              data['mechant_code']!, _mechantCodeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('identification_number')) {
      context.handle(
          _identificationNumberMeta,
          identificationNumber.isAcceptableOrUnknown(
              data['identification_number']!, _identificationNumberMeta));
    }
    if (data.containsKey('licence_number')) {
      context.handle(
          _licenceNumberMeta,
          licenceNumber.isAcceptableOrUnknown(
              data['licence_number']!, _licenceNumberMeta));
    }
    if (data.containsKey('document_refence_id')) {
      context.handle(
          _documentRefenceIdMeta,
          documentRefenceId.isAcceptableOrUnknown(
              data['document_refence_id']!, _documentRefenceIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('otp')) {
      context.handle(
          _otpMeta, otp.isAcceptableOrUnknown(data['otp']!, _otpMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mechantCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mechant_code']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      identificationNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}identification_number']),
      licenceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}licence_number']),
      documentRefenceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}document_refence_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agent_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      otp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}otp']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String? mechantCode;
  final String? name;
  final String? phone;
  final String? password;
  final String? email;
  final String? identificationNumber;
  final String? licenceNumber;
  final String? documentRefenceId;
  final String? status;
  final int? agentId;
  final int? userId;
  final String? otp;
  final String? createdAt;
  final String? updatedAt;
  const User(
      {required this.id,
      this.mechantCode,
      this.name,
      this.phone,
      this.password,
      this.email,
      this.identificationNumber,
      this.licenceNumber,
      this.documentRefenceId,
      this.status,
      this.agentId,
      this.userId,
      this.otp,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || mechantCode != null) {
      map['mechant_code'] = Variable<String>(mechantCode);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || identificationNumber != null) {
      map['identification_number'] = Variable<String>(identificationNumber);
    }
    if (!nullToAbsent || licenceNumber != null) {
      map['licence_number'] = Variable<String>(licenceNumber);
    }
    if (!nullToAbsent || documentRefenceId != null) {
      map['document_refence_id'] = Variable<String>(documentRefenceId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || agentId != null) {
      map['agent_id'] = Variable<int>(agentId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || otp != null) {
      map['otp'] = Variable<String>(otp);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      mechantCode: mechantCode == null && nullToAbsent
          ? const Value.absent()
          : Value(mechantCode),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      identificationNumber: identificationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(identificationNumber),
      licenceNumber: licenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(licenceNumber),
      documentRefenceId: documentRefenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentRefenceId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      agentId: agentId == null && nullToAbsent
          ? const Value.absent()
          : Value(agentId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      otp: otp == null && nullToAbsent ? const Value.absent() : Value(otp),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      mechantCode: serializer.fromJson<String?>(json['mechantCode']),
      name: serializer.fromJson<String?>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      password: serializer.fromJson<String?>(json['password']),
      email: serializer.fromJson<String?>(json['email']),
      identificationNumber:
          serializer.fromJson<String?>(json['identificationNumber']),
      licenceNumber: serializer.fromJson<String?>(json['licenceNumber']),
      documentRefenceId:
          serializer.fromJson<String?>(json['documentRefenceId']),
      status: serializer.fromJson<String?>(json['status']),
      agentId: serializer.fromJson<int?>(json['agentId']),
      userId: serializer.fromJson<int?>(json['userId']),
      otp: serializer.fromJson<String?>(json['otp']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mechantCode': serializer.toJson<String?>(mechantCode),
      'name': serializer.toJson<String?>(name),
      'phone': serializer.toJson<String?>(phone),
      'password': serializer.toJson<String?>(password),
      'email': serializer.toJson<String?>(email),
      'identificationNumber': serializer.toJson<String?>(identificationNumber),
      'licenceNumber': serializer.toJson<String?>(licenceNumber),
      'documentRefenceId': serializer.toJson<String?>(documentRefenceId),
      'status': serializer.toJson<String?>(status),
      'agentId': serializer.toJson<int?>(agentId),
      'userId': serializer.toJson<int?>(userId),
      'otp': serializer.toJson<String?>(otp),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          Value<String?> mechantCode = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> password = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> identificationNumber = const Value.absent(),
          Value<String?> licenceNumber = const Value.absent(),
          Value<String?> documentRefenceId = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<int?> agentId = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          Value<String?> otp = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        mechantCode: mechantCode.present ? mechantCode.value : this.mechantCode,
        name: name.present ? name.value : this.name,
        phone: phone.present ? phone.value : this.phone,
        password: password.present ? password.value : this.password,
        email: email.present ? email.value : this.email,
        identificationNumber: identificationNumber.present
            ? identificationNumber.value
            : this.identificationNumber,
        licenceNumber:
            licenceNumber.present ? licenceNumber.value : this.licenceNumber,
        documentRefenceId: documentRefenceId.present
            ? documentRefenceId.value
            : this.documentRefenceId,
        status: status.present ? status.value : this.status,
        agentId: agentId.present ? agentId.value : this.agentId,
        userId: userId.present ? userId.value : this.userId,
        otp: otp.present ? otp.value : this.otp,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      mechantCode:
          data.mechantCode.present ? data.mechantCode.value : this.mechantCode,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      password: data.password.present ? data.password.value : this.password,
      email: data.email.present ? data.email.value : this.email,
      identificationNumber: data.identificationNumber.present
          ? data.identificationNumber.value
          : this.identificationNumber,
      licenceNumber: data.licenceNumber.present
          ? data.licenceNumber.value
          : this.licenceNumber,
      documentRefenceId: data.documentRefenceId.present
          ? data.documentRefenceId.value
          : this.documentRefenceId,
      status: data.status.present ? data.status.value : this.status,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      userId: data.userId.present ? data.userId.value : this.userId,
      otp: data.otp.present ? data.otp.value : this.otp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('mechantCode: $mechantCode, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('identificationNumber: $identificationNumber, ')
          ..write('licenceNumber: $licenceNumber, ')
          ..write('documentRefenceId: $documentRefenceId, ')
          ..write('status: $status, ')
          ..write('agentId: $agentId, ')
          ..write('userId: $userId, ')
          ..write('otp: $otp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      mechantCode,
      name,
      phone,
      password,
      email,
      identificationNumber,
      licenceNumber,
      documentRefenceId,
      status,
      agentId,
      userId,
      otp,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.mechantCode == this.mechantCode &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.password == this.password &&
          other.email == this.email &&
          other.identificationNumber == this.identificationNumber &&
          other.licenceNumber == this.licenceNumber &&
          other.documentRefenceId == this.documentRefenceId &&
          other.status == this.status &&
          other.agentId == this.agentId &&
          other.userId == this.userId &&
          other.otp == this.otp &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String?> mechantCode;
  final Value<String?> name;
  final Value<String?> phone;
  final Value<String?> password;
  final Value<String?> email;
  final Value<String?> identificationNumber;
  final Value<String?> licenceNumber;
  final Value<String?> documentRefenceId;
  final Value<String?> status;
  final Value<int?> agentId;
  final Value<int?> userId;
  final Value<String?> otp;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.mechantCode = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.identificationNumber = const Value.absent(),
    this.licenceNumber = const Value.absent(),
    this.documentRefenceId = const Value.absent(),
    this.status = const Value.absent(),
    this.agentId = const Value.absent(),
    this.userId = const Value.absent(),
    this.otp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.mechantCode = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.identificationNumber = const Value.absent(),
    this.licenceNumber = const Value.absent(),
    this.documentRefenceId = const Value.absent(),
    this.status = const Value.absent(),
    this.agentId = const Value.absent(),
    this.userId = const Value.absent(),
    this.otp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? mechantCode,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? password,
    Expression<String>? email,
    Expression<String>? identificationNumber,
    Expression<String>? licenceNumber,
    Expression<String>? documentRefenceId,
    Expression<String>? status,
    Expression<int>? agentId,
    Expression<int>? userId,
    Expression<String>? otp,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mechantCode != null) 'mechant_code': mechantCode,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (password != null) 'password': password,
      if (email != null) 'email': email,
      if (identificationNumber != null)
        'identification_number': identificationNumber,
      if (licenceNumber != null) 'licence_number': licenceNumber,
      if (documentRefenceId != null) 'document_refence_id': documentRefenceId,
      if (status != null) 'status': status,
      if (agentId != null) 'agent_id': agentId,
      if (userId != null) 'user_id': userId,
      if (otp != null) 'otp': otp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String?>? mechantCode,
      Value<String?>? name,
      Value<String?>? phone,
      Value<String?>? password,
      Value<String?>? email,
      Value<String?>? identificationNumber,
      Value<String?>? licenceNumber,
      Value<String?>? documentRefenceId,
      Value<String?>? status,
      Value<int?>? agentId,
      Value<int?>? userId,
      Value<String?>? otp,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      mechantCode: mechantCode ?? this.mechantCode,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      email: email ?? this.email,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      licenceNumber: licenceNumber ?? this.licenceNumber,
      documentRefenceId: documentRefenceId ?? this.documentRefenceId,
      status: status ?? this.status,
      agentId: agentId ?? this.agentId,
      userId: userId ?? this.userId,
      otp: otp ?? this.otp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mechantCode.present) {
      map['mechant_code'] = Variable<String>(mechantCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (identificationNumber.present) {
      map['identification_number'] =
          Variable<String>(identificationNumber.value);
    }
    if (licenceNumber.present) {
      map['licence_number'] = Variable<String>(licenceNumber.value);
    }
    if (documentRefenceId.present) {
      map['document_refence_id'] = Variable<String>(documentRefenceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<int>(agentId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (otp.present) {
      map['otp'] = Variable<String>(otp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('mechantCode: $mechantCode, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('identificationNumber: $identificationNumber, ')
          ..write('licenceNumber: $licenceNumber, ')
          ..write('documentRefenceId: $documentRefenceId, ')
          ..write('status: $status, ')
          ..write('agentId: $agentId, ')
          ..write('userId: $userId, ')
          ..write('otp: $otp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppTransactionTable extends AppTransaction
    with TableInfo<$AppTransactionTable, AppTransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppTransactionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiverAccountMeta =
      const VerificationMeta('receiverAccount');
  @override
  late final GeneratedColumn<String> receiverAccount = GeneratedColumn<String>(
      'receiver_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderAccountMeta =
      const VerificationMeta('senderAccount');
  @override
  late final GeneratedColumn<String> senderAccount = GeneratedColumn<String>(
      'sender_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        receiverAccount,
        senderAccount,
        amount,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_transaction';
  @override
  VerificationContext validateIntegrity(Insertable<AppTransactionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('receiver_account')) {
      context.handle(
          _receiverAccountMeta,
          receiverAccount.isAcceptableOrUnknown(
              data['receiver_account']!, _receiverAccountMeta));
    }
    if (data.containsKey('sender_account')) {
      context.handle(
          _senderAccountMeta,
          senderAccount.isAcceptableOrUnknown(
              data['sender_account']!, _senderAccountMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppTransactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppTransactionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      receiverAccount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receiver_account']),
      senderAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_account']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppTransactionTable createAlias(String alias) {
    return $AppTransactionTable(attachedDatabase, alias);
  }
}

class AppTransactionData extends DataClass
    implements Insertable<AppTransactionData> {
  final int id;
  final String userId;
  final String? receiverAccount;
  final String? senderAccount;
  final String amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppTransactionData(
      {required this.id,
      required this.userId,
      this.receiverAccount,
      this.senderAccount,
      required this.amount,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || receiverAccount != null) {
      map['receiver_account'] = Variable<String>(receiverAccount);
    }
    if (!nullToAbsent || senderAccount != null) {
      map['sender_account'] = Variable<String>(senderAccount);
    }
    map['amount'] = Variable<String>(amount);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppTransactionCompanion toCompanion(bool nullToAbsent) {
    return AppTransactionCompanion(
      id: Value(id),
      userId: Value(userId),
      receiverAccount: receiverAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(receiverAccount),
      senderAccount: senderAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(senderAccount),
      amount: Value(amount),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppTransactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppTransactionData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      receiverAccount: serializer.fromJson<String?>(json['receiverAccount']),
      senderAccount: serializer.fromJson<String?>(json['senderAccount']),
      amount: serializer.fromJson<String>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'receiverAccount': serializer.toJson<String?>(receiverAccount),
      'senderAccount': serializer.toJson<String?>(senderAccount),
      'amount': serializer.toJson<String>(amount),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppTransactionData copyWith(
          {int? id,
          String? userId,
          Value<String?> receiverAccount = const Value.absent(),
          Value<String?> senderAccount = const Value.absent(),
          String? amount,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AppTransactionData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        receiverAccount: receiverAccount.present
            ? receiverAccount.value
            : this.receiverAccount,
        senderAccount:
            senderAccount.present ? senderAccount.value : this.senderAccount,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppTransactionData copyWithCompanion(AppTransactionCompanion data) {
    return AppTransactionData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      receiverAccount: data.receiverAccount.present
          ? data.receiverAccount.value
          : this.receiverAccount,
      senderAccount: data.senderAccount.present
          ? data.senderAccount.value
          : this.senderAccount,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppTransactionData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('receiverAccount: $receiverAccount, ')
          ..write('senderAccount: $senderAccount, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, receiverAccount, senderAccount,
      amount, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppTransactionData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.receiverAccount == this.receiverAccount &&
          other.senderAccount == this.senderAccount &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppTransactionCompanion extends UpdateCompanion<AppTransactionData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String?> receiverAccount;
  final Value<String?> senderAccount;
  final Value<String> amount;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppTransactionCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.receiverAccount = const Value.absent(),
    this.senderAccount = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppTransactionCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.receiverAccount = const Value.absent(),
    this.senderAccount = const Value.absent(),
    required String amount,
    required String status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        amount = Value(amount),
        status = Value(status);
  static Insertable<AppTransactionData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? receiverAccount,
    Expression<String>? senderAccount,
    Expression<String>? amount,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (receiverAccount != null) 'receiver_account': receiverAccount,
      if (senderAccount != null) 'sender_account': senderAccount,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppTransactionCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String?>? receiverAccount,
      Value<String?>? senderAccount,
      Value<String>? amount,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AppTransactionCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      receiverAccount: receiverAccount ?? this.receiverAccount,
      senderAccount: senderAccount ?? this.senderAccount,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (receiverAccount.present) {
      map['receiver_account'] = Variable<String>(receiverAccount.value);
    }
    if (senderAccount.present) {
      map['sender_account'] = Variable<String>(senderAccount.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppTransactionCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('receiverAccount: $receiverAccount, ')
          ..write('senderAccount: $senderAccount, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BalanceTable extends Balance with TableInfo<$BalanceTable, BalanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, userId, amount, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance';
  @override
  VerificationContext validateIntegrity(Insertable<BalanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $BalanceTable createAlias(String alias) {
    return $BalanceTable(attachedDatabase, alias);
  }
}

class BalanceData extends DataClass implements Insertable<BalanceData> {
  final int id;
  final String userId;
  final String? amount;
  final DateTime date;
  const BalanceData(
      {required this.id,
      required this.userId,
      this.amount,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<String>(amount);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  BalanceCompanion toCompanion(bool nullToAbsent) {
    return BalanceCompanion(
      id: Value(id),
      userId: Value(userId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      date: Value(date),
    );
  }

  factory BalanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amount: serializer.fromJson<String?>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'amount': serializer.toJson<String?>(amount),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  BalanceData copyWith(
          {int? id,
          String? userId,
          Value<String?> amount = const Value.absent(),
          DateTime? date}) =>
      BalanceData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amount: amount.present ? amount.value : this.amount,
        date: date ?? this.date,
      );
  BalanceData copyWithCompanion(BalanceCompanion data) {
    return BalanceData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, amount, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.date == this.date);
}

class BalanceCompanion extends UpdateCompanion<BalanceData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String?> amount;
  final Value<DateTime> date;
  const BalanceCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
  });
  BalanceCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<BalanceData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? amount,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
    });
  }

  BalanceCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String?>? amount,
      Value<DateTime>? date}) {
    return BalanceCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $CustomerTable extends Customer
    with TableInfo<$CustomerTable, CustomerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _externalIdMeta =
      const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
      'external_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountNoMeta =
      const VerificationMeta('accountNo');
  @override
  late final GeneratedColumn<String> accountNo = GeneratedColumn<String>(
      'account_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mobileNoMeta =
      const VerificationMeta('mobileNo');
  @override
  late final GeneratedColumn<String> mobileNo = GeneratedColumn<String>(
      'mobile_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _otpMeta = const VerificationMeta('otp');
  @override
  late final GeneratedColumn<String> otp = GeneratedColumn<String>(
      'otp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _loanAmountMeta =
      const VerificationMeta('loanAmount');
  @override
  late final GeneratedColumn<String> loanAmount = GeneratedColumn<String>(
      'loan_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remainLoanAmountMeta =
      const VerificationMeta('remainLoanAmount');
  @override
  late final GeneratedColumn<String> remainLoanAmount = GeneratedColumn<String>(
      'remain_loan_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        displayName,
        externalId,
        accountNo,
        mobileNo,
        otp,
        loanAmount,
        remainLoanAmount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
          _externalIdMeta,
          externalId.isAcceptableOrUnknown(
              data['external_id']!, _externalIdMeta));
    }
    if (data.containsKey('account_no')) {
      context.handle(_accountNoMeta,
          accountNo.isAcceptableOrUnknown(data['account_no']!, _accountNoMeta));
    }
    if (data.containsKey('mobile_no')) {
      context.handle(_mobileNoMeta,
          mobileNo.isAcceptableOrUnknown(data['mobile_no']!, _mobileNoMeta));
    }
    if (data.containsKey('otp')) {
      context.handle(
          _otpMeta, otp.isAcceptableOrUnknown(data['otp']!, _otpMeta));
    }
    if (data.containsKey('loan_amount')) {
      context.handle(
          _loanAmountMeta,
          loanAmount.isAcceptableOrUnknown(
              data['loan_amount']!, _loanAmountMeta));
    }
    if (data.containsKey('remain_loan_amount')) {
      context.handle(
          _remainLoanAmountMeta,
          remainLoanAmount.isAcceptableOrUnknown(
              data['remain_loan_amount']!, _remainLoanAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      externalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_id']),
      accountNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_no']),
      mobileNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile_no']),
      otp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}otp']),
      loanAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loan_amount']),
      remainLoanAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remain_loan_amount']),
    );
  }

  @override
  $CustomerTable createAlias(String alias) {
    return $CustomerTable(attachedDatabase, alias);
  }
}

class CustomerData extends DataClass implements Insertable<CustomerData> {
  final int id;
  final String? displayName;
  final String? externalId;
  final String? accountNo;
  final String? mobileNo;
  final String? otp;
  final String? loanAmount;
  final String? remainLoanAmount;
  const CustomerData(
      {required this.id,
      this.displayName,
      this.externalId,
      this.accountNo,
      this.mobileNo,
      this.otp,
      this.loanAmount,
      this.remainLoanAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || accountNo != null) {
      map['account_no'] = Variable<String>(accountNo);
    }
    if (!nullToAbsent || mobileNo != null) {
      map['mobile_no'] = Variable<String>(mobileNo);
    }
    if (!nullToAbsent || otp != null) {
      map['otp'] = Variable<String>(otp);
    }
    if (!nullToAbsent || loanAmount != null) {
      map['loan_amount'] = Variable<String>(loanAmount);
    }
    if (!nullToAbsent || remainLoanAmount != null) {
      map['remain_loan_amount'] = Variable<String>(remainLoanAmount);
    }
    return map;
  }

  CustomerCompanion toCompanion(bool nullToAbsent) {
    return CustomerCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      accountNo: accountNo == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNo),
      mobileNo: mobileNo == null && nullToAbsent
          ? const Value.absent()
          : Value(mobileNo),
      otp: otp == null && nullToAbsent ? const Value.absent() : Value(otp),
      loanAmount: loanAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(loanAmount),
      remainLoanAmount: remainLoanAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(remainLoanAmount),
    );
  }

  factory CustomerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerData(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      accountNo: serializer.fromJson<String?>(json['accountNo']),
      mobileNo: serializer.fromJson<String?>(json['mobileNo']),
      otp: serializer.fromJson<String?>(json['otp']),
      loanAmount: serializer.fromJson<String?>(json['loanAmount']),
      remainLoanAmount: serializer.fromJson<String?>(json['remainLoanAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'externalId': serializer.toJson<String?>(externalId),
      'accountNo': serializer.toJson<String?>(accountNo),
      'mobileNo': serializer.toJson<String?>(mobileNo),
      'otp': serializer.toJson<String?>(otp),
      'loanAmount': serializer.toJson<String?>(loanAmount),
      'remainLoanAmount': serializer.toJson<String?>(remainLoanAmount),
    };
  }

  CustomerData copyWith(
          {int? id,
          Value<String?> displayName = const Value.absent(),
          Value<String?> externalId = const Value.absent(),
          Value<String?> accountNo = const Value.absent(),
          Value<String?> mobileNo = const Value.absent(),
          Value<String?> otp = const Value.absent(),
          Value<String?> loanAmount = const Value.absent(),
          Value<String?> remainLoanAmount = const Value.absent()}) =>
      CustomerData(
        id: id ?? this.id,
        displayName: displayName.present ? displayName.value : this.displayName,
        externalId: externalId.present ? externalId.value : this.externalId,
        accountNo: accountNo.present ? accountNo.value : this.accountNo,
        mobileNo: mobileNo.present ? mobileNo.value : this.mobileNo,
        otp: otp.present ? otp.value : this.otp,
        loanAmount: loanAmount.present ? loanAmount.value : this.loanAmount,
        remainLoanAmount: remainLoanAmount.present
            ? remainLoanAmount.value
            : this.remainLoanAmount,
      );
  CustomerData copyWithCompanion(CustomerCompanion data) {
    return CustomerData(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
      accountNo: data.accountNo.present ? data.accountNo.value : this.accountNo,
      mobileNo: data.mobileNo.present ? data.mobileNo.value : this.mobileNo,
      otp: data.otp.present ? data.otp.value : this.otp,
      loanAmount:
          data.loanAmount.present ? data.loanAmount.value : this.loanAmount,
      remainLoanAmount: data.remainLoanAmount.present
          ? data.remainLoanAmount.value
          : this.remainLoanAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerData(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('externalId: $externalId, ')
          ..write('accountNo: $accountNo, ')
          ..write('mobileNo: $mobileNo, ')
          ..write('otp: $otp, ')
          ..write('loanAmount: $loanAmount, ')
          ..write('remainLoanAmount: $remainLoanAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, externalId, accountNo,
      mobileNo, otp, loanAmount, remainLoanAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerData &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.externalId == this.externalId &&
          other.accountNo == this.accountNo &&
          other.mobileNo == this.mobileNo &&
          other.otp == this.otp &&
          other.loanAmount == this.loanAmount &&
          other.remainLoanAmount == this.remainLoanAmount);
}

class CustomerCompanion extends UpdateCompanion<CustomerData> {
  final Value<int> id;
  final Value<String?> displayName;
  final Value<String?> externalId;
  final Value<String?> accountNo;
  final Value<String?> mobileNo;
  final Value<String?> otp;
  final Value<String?> loanAmount;
  final Value<String?> remainLoanAmount;
  const CustomerCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.externalId = const Value.absent(),
    this.accountNo = const Value.absent(),
    this.mobileNo = const Value.absent(),
    this.otp = const Value.absent(),
    this.loanAmount = const Value.absent(),
    this.remainLoanAmount = const Value.absent(),
  });
  CustomerCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.externalId = const Value.absent(),
    this.accountNo = const Value.absent(),
    this.mobileNo = const Value.absent(),
    this.otp = const Value.absent(),
    this.loanAmount = const Value.absent(),
    this.remainLoanAmount = const Value.absent(),
  });
  static Insertable<CustomerData> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? externalId,
    Expression<String>? accountNo,
    Expression<String>? mobileNo,
    Expression<String>? otp,
    Expression<String>? loanAmount,
    Expression<String>? remainLoanAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (externalId != null) 'external_id': externalId,
      if (accountNo != null) 'account_no': accountNo,
      if (mobileNo != null) 'mobile_no': mobileNo,
      if (otp != null) 'otp': otp,
      if (loanAmount != null) 'loan_amount': loanAmount,
      if (remainLoanAmount != null) 'remain_loan_amount': remainLoanAmount,
    });
  }

  CustomerCompanion copyWith(
      {Value<int>? id,
      Value<String?>? displayName,
      Value<String?>? externalId,
      Value<String?>? accountNo,
      Value<String?>? mobileNo,
      Value<String?>? otp,
      Value<String?>? loanAmount,
      Value<String?>? remainLoanAmount}) {
    return CustomerCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      externalId: externalId ?? this.externalId,
      accountNo: accountNo ?? this.accountNo,
      mobileNo: mobileNo ?? this.mobileNo,
      otp: otp ?? this.otp,
      loanAmount: loanAmount ?? this.loanAmount,
      remainLoanAmount: remainLoanAmount ?? this.remainLoanAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (accountNo.present) {
      map['account_no'] = Variable<String>(accountNo.value);
    }
    if (mobileNo.present) {
      map['mobile_no'] = Variable<String>(mobileNo.value);
    }
    if (otp.present) {
      map['otp'] = Variable<String>(otp.value);
    }
    if (loanAmount.present) {
      map['loan_amount'] = Variable<String>(loanAmount.value);
    }
    if (remainLoanAmount.present) {
      map['remain_loan_amount'] = Variable<String>(remainLoanAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('externalId: $externalId, ')
          ..write('accountNo: $accountNo, ')
          ..write('mobileNo: $mobileNo, ')
          ..write('otp: $otp, ')
          ..write('loanAmount: $loanAmount, ')
          ..write('remainLoanAmount: $remainLoanAmount')
          ..write(')'))
        .toString();
  }
}

class $LoanTable extends Loan with TableInfo<$LoanTable, LoanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _totalRepaymentDerivedMeta =
      const VerificationMeta('totalRepaymentDerived');
  @override
  late final GeneratedColumn<String> totalRepaymentDerived =
      GeneratedColumn<String>('total_repayment_derived', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalExpectedRepaymentDerivedMeta =
      const VerificationMeta('totalExpectedRepaymentDerived');
  @override
  late final GeneratedColumn<String> totalExpectedRepaymentDerived =
      GeneratedColumn<String>(
          'total_expected_repayment_derived', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _principalRepaidDerivedMeta =
      const VerificationMeta('principalRepaidDerived');
  @override
  late final GeneratedColumn<String> principalRepaidDerived =
      GeneratedColumn<String>('principal_repaid_derived', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _principalAmountMeta =
      const VerificationMeta('principalAmount');
  @override
  late final GeneratedColumn<String> principalAmount = GeneratedColumn<String>(
      'principal_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        totalRepaymentDerived,
        totalExpectedRepaymentDerived,
        principalRepaidDerived,
        principalAmount,
        clientId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan';
  @override
  VerificationContext validateIntegrity(Insertable<LoanData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_repayment_derived')) {
      context.handle(
          _totalRepaymentDerivedMeta,
          totalRepaymentDerived.isAcceptableOrUnknown(
              data['total_repayment_derived']!, _totalRepaymentDerivedMeta));
    }
    if (data.containsKey('total_expected_repayment_derived')) {
      context.handle(
          _totalExpectedRepaymentDerivedMeta,
          totalExpectedRepaymentDerived.isAcceptableOrUnknown(
              data['total_expected_repayment_derived']!,
              _totalExpectedRepaymentDerivedMeta));
    }
    if (data.containsKey('principal_repaid_derived')) {
      context.handle(
          _principalRepaidDerivedMeta,
          principalRepaidDerived.isAcceptableOrUnknown(
              data['principal_repaid_derived']!, _principalRepaidDerivedMeta));
    }
    if (data.containsKey('principal_amount')) {
      context.handle(
          _principalAmountMeta,
          principalAmount.isAcceptableOrUnknown(
              data['principal_amount']!, _principalAmountMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      totalRepaymentDerived: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}total_repayment_derived']),
      totalExpectedRepaymentDerived: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}total_expected_repayment_derived']),
      principalRepaidDerived: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}principal_repaid_derived']),
      principalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}principal_amount']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id']),
    );
  }

  @override
  $LoanTable createAlias(String alias) {
    return $LoanTable(attachedDatabase, alias);
  }
}

class LoanData extends DataClass implements Insertable<LoanData> {
  final int id;
  final String? totalRepaymentDerived;
  final String? totalExpectedRepaymentDerived;
  final String? principalRepaidDerived;
  final String? principalAmount;
  final String? clientId;
  const LoanData(
      {required this.id,
      this.totalRepaymentDerived,
      this.totalExpectedRepaymentDerived,
      this.principalRepaidDerived,
      this.principalAmount,
      this.clientId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || totalRepaymentDerived != null) {
      map['total_repayment_derived'] = Variable<String>(totalRepaymentDerived);
    }
    if (!nullToAbsent || totalExpectedRepaymentDerived != null) {
      map['total_expected_repayment_derived'] =
          Variable<String>(totalExpectedRepaymentDerived);
    }
    if (!nullToAbsent || principalRepaidDerived != null) {
      map['principal_repaid_derived'] =
          Variable<String>(principalRepaidDerived);
    }
    if (!nullToAbsent || principalAmount != null) {
      map['principal_amount'] = Variable<String>(principalAmount);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    return map;
  }

  LoanCompanion toCompanion(bool nullToAbsent) {
    return LoanCompanion(
      id: Value(id),
      totalRepaymentDerived: totalRepaymentDerived == null && nullToAbsent
          ? const Value.absent()
          : Value(totalRepaymentDerived),
      totalExpectedRepaymentDerived:
          totalExpectedRepaymentDerived == null && nullToAbsent
              ? const Value.absent()
              : Value(totalExpectedRepaymentDerived),
      principalRepaidDerived: principalRepaidDerived == null && nullToAbsent
          ? const Value.absent()
          : Value(principalRepaidDerived),
      principalAmount: principalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(principalAmount),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
    );
  }

  factory LoanData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanData(
      id: serializer.fromJson<int>(json['id']),
      totalRepaymentDerived:
          serializer.fromJson<String?>(json['totalRepaymentDerived']),
      totalExpectedRepaymentDerived:
          serializer.fromJson<String?>(json['totalExpectedRepaymentDerived']),
      principalRepaidDerived:
          serializer.fromJson<String?>(json['principalRepaidDerived']),
      principalAmount: serializer.fromJson<String?>(json['principalAmount']),
      clientId: serializer.fromJson<String?>(json['clientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalRepaymentDerived':
          serializer.toJson<String?>(totalRepaymentDerived),
      'totalExpectedRepaymentDerived':
          serializer.toJson<String?>(totalExpectedRepaymentDerived),
      'principalRepaidDerived':
          serializer.toJson<String?>(principalRepaidDerived),
      'principalAmount': serializer.toJson<String?>(principalAmount),
      'clientId': serializer.toJson<String?>(clientId),
    };
  }

  LoanData copyWith(
          {int? id,
          Value<String?> totalRepaymentDerived = const Value.absent(),
          Value<String?> totalExpectedRepaymentDerived = const Value.absent(),
          Value<String?> principalRepaidDerived = const Value.absent(),
          Value<String?> principalAmount = const Value.absent(),
          Value<String?> clientId = const Value.absent()}) =>
      LoanData(
        id: id ?? this.id,
        totalRepaymentDerived: totalRepaymentDerived.present
            ? totalRepaymentDerived.value
            : this.totalRepaymentDerived,
        totalExpectedRepaymentDerived: totalExpectedRepaymentDerived.present
            ? totalExpectedRepaymentDerived.value
            : this.totalExpectedRepaymentDerived,
        principalRepaidDerived: principalRepaidDerived.present
            ? principalRepaidDerived.value
            : this.principalRepaidDerived,
        principalAmount: principalAmount.present
            ? principalAmount.value
            : this.principalAmount,
        clientId: clientId.present ? clientId.value : this.clientId,
      );
  LoanData copyWithCompanion(LoanCompanion data) {
    return LoanData(
      id: data.id.present ? data.id.value : this.id,
      totalRepaymentDerived: data.totalRepaymentDerived.present
          ? data.totalRepaymentDerived.value
          : this.totalRepaymentDerived,
      totalExpectedRepaymentDerived: data.totalExpectedRepaymentDerived.present
          ? data.totalExpectedRepaymentDerived.value
          : this.totalExpectedRepaymentDerived,
      principalRepaidDerived: data.principalRepaidDerived.present
          ? data.principalRepaidDerived.value
          : this.principalRepaidDerived,
      principalAmount: data.principalAmount.present
          ? data.principalAmount.value
          : this.principalAmount,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanData(')
          ..write('id: $id, ')
          ..write('totalRepaymentDerived: $totalRepaymentDerived, ')
          ..write(
              'totalExpectedRepaymentDerived: $totalExpectedRepaymentDerived, ')
          ..write('principalRepaidDerived: $principalRepaidDerived, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      totalRepaymentDerived,
      totalExpectedRepaymentDerived,
      principalRepaidDerived,
      principalAmount,
      clientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanData &&
          other.id == this.id &&
          other.totalRepaymentDerived == this.totalRepaymentDerived &&
          other.totalExpectedRepaymentDerived ==
              this.totalExpectedRepaymentDerived &&
          other.principalRepaidDerived == this.principalRepaidDerived &&
          other.principalAmount == this.principalAmount &&
          other.clientId == this.clientId);
}

class LoanCompanion extends UpdateCompanion<LoanData> {
  final Value<int> id;
  final Value<String?> totalRepaymentDerived;
  final Value<String?> totalExpectedRepaymentDerived;
  final Value<String?> principalRepaidDerived;
  final Value<String?> principalAmount;
  final Value<String?> clientId;
  const LoanCompanion({
    this.id = const Value.absent(),
    this.totalRepaymentDerived = const Value.absent(),
    this.totalExpectedRepaymentDerived = const Value.absent(),
    this.principalRepaidDerived = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.clientId = const Value.absent(),
  });
  LoanCompanion.insert({
    this.id = const Value.absent(),
    this.totalRepaymentDerived = const Value.absent(),
    this.totalExpectedRepaymentDerived = const Value.absent(),
    this.principalRepaidDerived = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.clientId = const Value.absent(),
  });
  static Insertable<LoanData> custom({
    Expression<int>? id,
    Expression<String>? totalRepaymentDerived,
    Expression<String>? totalExpectedRepaymentDerived,
    Expression<String>? principalRepaidDerived,
    Expression<String>? principalAmount,
    Expression<String>? clientId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalRepaymentDerived != null)
        'total_repayment_derived': totalRepaymentDerived,
      if (totalExpectedRepaymentDerived != null)
        'total_expected_repayment_derived': totalExpectedRepaymentDerived,
      if (principalRepaidDerived != null)
        'principal_repaid_derived': principalRepaidDerived,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (clientId != null) 'client_id': clientId,
    });
  }

  LoanCompanion copyWith(
      {Value<int>? id,
      Value<String?>? totalRepaymentDerived,
      Value<String?>? totalExpectedRepaymentDerived,
      Value<String?>? principalRepaidDerived,
      Value<String?>? principalAmount,
      Value<String?>? clientId}) {
    return LoanCompanion(
      id: id ?? this.id,
      totalRepaymentDerived:
          totalRepaymentDerived ?? this.totalRepaymentDerived,
      totalExpectedRepaymentDerived:
          totalExpectedRepaymentDerived ?? this.totalExpectedRepaymentDerived,
      principalRepaidDerived:
          principalRepaidDerived ?? this.principalRepaidDerived,
      principalAmount: principalAmount ?? this.principalAmount,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalRepaymentDerived.present) {
      map['total_repayment_derived'] =
          Variable<String>(totalRepaymentDerived.value);
    }
    if (totalExpectedRepaymentDerived.present) {
      map['total_expected_repayment_derived'] =
          Variable<String>(totalExpectedRepaymentDerived.value);
    }
    if (principalRepaidDerived.present) {
      map['principal_repaid_derived'] =
          Variable<String>(principalRepaidDerived.value);
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<String>(principalAmount.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanCompanion(')
          ..write('id: $id, ')
          ..write('totalRepaymentDerived: $totalRepaymentDerived, ')
          ..write(
              'totalExpectedRepaymentDerived: $totalExpectedRepaymentDerived, ')
          ..write('principalRepaidDerived: $principalRepaidDerived, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }
}

class $MechantChargeConfigurationsTable extends MechantChargeConfigurations
    with
        TableInfo<$MechantChargeConfigurationsTable,
            MechantChargeConfiguration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MechantChargeConfigurationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mechantIdMeta =
      const VerificationMeta('mechantId');
  @override
  late final GeneratedColumn<String> mechantId = GeneratedColumn<String>(
      'mechant_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chargeIdMeta =
      const VerificationMeta('chargeId');
  @override
  late final GeneratedColumn<String> chargeId = GeneratedColumn<String>(
      'charge_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, mechantId, chargeId, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mechant_charge_configurations';
  @override
  VerificationContext validateIntegrity(
      Insertable<MechantChargeConfiguration> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mechant_id')) {
      context.handle(_mechantIdMeta,
          mechantId.isAcceptableOrUnknown(data['mechant_id']!, _mechantIdMeta));
    }
    if (data.containsKey('charge_id')) {
      context.handle(_chargeIdMeta,
          chargeId.isAcceptableOrUnknown(data['charge_id']!, _chargeIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MechantChargeConfiguration map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MechantChargeConfiguration(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mechantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mechant_id']),
      chargeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}charge_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $MechantChargeConfigurationsTable createAlias(String alias) {
    return $MechantChargeConfigurationsTable(attachedDatabase, alias);
  }
}

class MechantChargeConfiguration extends DataClass
    implements Insertable<MechantChargeConfiguration> {
  final int id;
  final String? mechantId;
  final String? chargeId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  const MechantChargeConfiguration(
      {required this.id,
      this.mechantId,
      this.chargeId,
      this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || mechantId != null) {
      map['mechant_id'] = Variable<String>(mechantId);
    }
    if (!nullToAbsent || chargeId != null) {
      map['charge_id'] = Variable<String>(chargeId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  MechantChargeConfigurationsCompanion toCompanion(bool nullToAbsent) {
    return MechantChargeConfigurationsCompanion(
      id: Value(id),
      mechantId: mechantId == null && nullToAbsent
          ? const Value.absent()
          : Value(mechantId),
      chargeId: chargeId == null && nullToAbsent
          ? const Value.absent()
          : Value(chargeId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MechantChargeConfiguration.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MechantChargeConfiguration(
      id: serializer.fromJson<int>(json['id']),
      mechantId: serializer.fromJson<String?>(json['mechantId']),
      chargeId: serializer.fromJson<String?>(json['chargeId']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mechantId': serializer.toJson<String?>(mechantId),
      'chargeId': serializer.toJson<String?>(chargeId),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  MechantChargeConfiguration copyWith(
          {int? id,
          Value<String?> mechantId = const Value.absent(),
          Value<String?> chargeId = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      MechantChargeConfiguration(
        id: id ?? this.id,
        mechantId: mechantId.present ? mechantId.value : this.mechantId,
        chargeId: chargeId.present ? chargeId.value : this.chargeId,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  MechantChargeConfiguration copyWithCompanion(
      MechantChargeConfigurationsCompanion data) {
    return MechantChargeConfiguration(
      id: data.id.present ? data.id.value : this.id,
      mechantId: data.mechantId.present ? data.mechantId.value : this.mechantId,
      chargeId: data.chargeId.present ? data.chargeId.value : this.chargeId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MechantChargeConfiguration(')
          ..write('id: $id, ')
          ..write('mechantId: $mechantId, ')
          ..write('chargeId: $chargeId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mechantId, chargeId, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MechantChargeConfiguration &&
          other.id == this.id &&
          other.mechantId == this.mechantId &&
          other.chargeId == this.chargeId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MechantChargeConfigurationsCompanion
    extends UpdateCompanion<MechantChargeConfiguration> {
  final Value<int> id;
  final Value<String?> mechantId;
  final Value<String?> chargeId;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const MechantChargeConfigurationsCompanion({
    this.id = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.chargeId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MechantChargeConfigurationsCompanion.insert({
    this.id = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.chargeId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<MechantChargeConfiguration> custom({
    Expression<int>? id,
    Expression<String>? mechantId,
    Expression<String>? chargeId,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mechantId != null) 'mechant_id': mechantId,
      if (chargeId != null) 'charge_id': chargeId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MechantChargeConfigurationsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? mechantId,
      Value<String?>? chargeId,
      Value<String?>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return MechantChargeConfigurationsCompanion(
      id: id ?? this.id,
      mechantId: mechantId ?? this.mechantId,
      chargeId: chargeId ?? this.chargeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mechantId.present) {
      map['mechant_id'] = Variable<String>(mechantId.value);
    }
    if (chargeId.present) {
      map['charge_id'] = Variable<String>(chargeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MechantChargeConfigurationsCompanion(')
          ..write('id: $id, ')
          ..write('mechantId: $mechantId, ')
          ..write('chargeId: $chargeId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AccountSetupTable extends AccountSetup
    with TableInfo<$AccountSetupTable, AccountSetupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountSetupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mechantIdMeta =
      const VerificationMeta('mechantId');
  @override
  late final GeneratedColumn<int> mechantId = GeneratedColumn<int>(
      'mechant_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _paymentTypeMeta =
      const VerificationMeta('paymentType');
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
      'payment_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _institutionNameMeta =
      const VerificationMeta('institutionName');
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
      'institution_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receivingNumberMeta =
      const VerificationMeta('receivingNumber');
  @override
  late final GeneratedColumn<String> receivingNumber = GeneratedColumn<String>(
      'receiving_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedMeta =
      const VerificationMeta('verified');
  @override
  late final GeneratedColumn<String> verified = GeneratedColumn<String>(
      'verified', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mechantId,
        paymentType,
        institutionName,
        receivingNumber,
        status,
        verified,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_setup';
  @override
  VerificationContext validateIntegrity(Insertable<AccountSetupData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mechant_id')) {
      context.handle(_mechantIdMeta,
          mechantId.isAcceptableOrUnknown(data['mechant_id']!, _mechantIdMeta));
    }
    if (data.containsKey('payment_type')) {
      context.handle(
          _paymentTypeMeta,
          paymentType.isAcceptableOrUnknown(
              data['payment_type']!, _paymentTypeMeta));
    }
    if (data.containsKey('institution_name')) {
      context.handle(
          _institutionNameMeta,
          institutionName.isAcceptableOrUnknown(
              data['institution_name']!, _institutionNameMeta));
    }
    if (data.containsKey('receiving_number')) {
      context.handle(
          _receivingNumberMeta,
          receivingNumber.isAcceptableOrUnknown(
              data['receiving_number']!, _receivingNumberMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('verified')) {
      context.handle(_verifiedMeta,
          verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountSetupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountSetupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mechantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mechant_id']),
      paymentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_type']),
      institutionName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}institution_name']),
      receivingNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receiving_number']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      verified: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AccountSetupTable createAlias(String alias) {
    return $AccountSetupTable(attachedDatabase, alias);
  }
}

class AccountSetupData extends DataClass
    implements Insertable<AccountSetupData> {
  final int id;
  final int? mechantId;
  final String? paymentType;
  final String? institutionName;
  final String? receivingNumber;
  final String? status;
  final String? verified;
  final String? createdAt;
  final String? updatedAt;
  const AccountSetupData(
      {required this.id,
      this.mechantId,
      this.paymentType,
      this.institutionName,
      this.receivingNumber,
      this.status,
      this.verified,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || mechantId != null) {
      map['mechant_id'] = Variable<int>(mechantId);
    }
    if (!nullToAbsent || paymentType != null) {
      map['payment_type'] = Variable<String>(paymentType);
    }
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    if (!nullToAbsent || receivingNumber != null) {
      map['receiving_number'] = Variable<String>(receivingNumber);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || verified != null) {
      map['verified'] = Variable<String>(verified);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  AccountSetupCompanion toCompanion(bool nullToAbsent) {
    return AccountSetupCompanion(
      id: Value(id),
      mechantId: mechantId == null && nullToAbsent
          ? const Value.absent()
          : Value(mechantId),
      paymentType: paymentType == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentType),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      receivingNumber: receivingNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receivingNumber),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      verified: verified == null && nullToAbsent
          ? const Value.absent()
          : Value(verified),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AccountSetupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountSetupData(
      id: serializer.fromJson<int>(json['id']),
      mechantId: serializer.fromJson<int?>(json['mechantId']),
      paymentType: serializer.fromJson<String?>(json['paymentType']),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      receivingNumber: serializer.fromJson<String?>(json['receivingNumber']),
      status: serializer.fromJson<String?>(json['status']),
      verified: serializer.fromJson<String?>(json['verified']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mechantId': serializer.toJson<int?>(mechantId),
      'paymentType': serializer.toJson<String?>(paymentType),
      'institutionName': serializer.toJson<String?>(institutionName),
      'receivingNumber': serializer.toJson<String?>(receivingNumber),
      'status': serializer.toJson<String?>(status),
      'verified': serializer.toJson<String?>(verified),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  AccountSetupData copyWith(
          {int? id,
          Value<int?> mechantId = const Value.absent(),
          Value<String?> paymentType = const Value.absent(),
          Value<String?> institutionName = const Value.absent(),
          Value<String?> receivingNumber = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> verified = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      AccountSetupData(
        id: id ?? this.id,
        mechantId: mechantId.present ? mechantId.value : this.mechantId,
        paymentType: paymentType.present ? paymentType.value : this.paymentType,
        institutionName: institutionName.present
            ? institutionName.value
            : this.institutionName,
        receivingNumber: receivingNumber.present
            ? receivingNumber.value
            : this.receivingNumber,
        status: status.present ? status.value : this.status,
        verified: verified.present ? verified.value : this.verified,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AccountSetupData copyWithCompanion(AccountSetupCompanion data) {
    return AccountSetupData(
      id: data.id.present ? data.id.value : this.id,
      mechantId: data.mechantId.present ? data.mechantId.value : this.mechantId,
      paymentType:
          data.paymentType.present ? data.paymentType.value : this.paymentType,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      receivingNumber: data.receivingNumber.present
          ? data.receivingNumber.value
          : this.receivingNumber,
      status: data.status.present ? data.status.value : this.status,
      verified: data.verified.present ? data.verified.value : this.verified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountSetupData(')
          ..write('id: $id, ')
          ..write('mechantId: $mechantId, ')
          ..write('paymentType: $paymentType, ')
          ..write('institutionName: $institutionName, ')
          ..write('receivingNumber: $receivingNumber, ')
          ..write('status: $status, ')
          ..write('verified: $verified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mechantId, paymentType, institutionName,
      receivingNumber, status, verified, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountSetupData &&
          other.id == this.id &&
          other.mechantId == this.mechantId &&
          other.paymentType == this.paymentType &&
          other.institutionName == this.institutionName &&
          other.receivingNumber == this.receivingNumber &&
          other.status == this.status &&
          other.verified == this.verified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountSetupCompanion extends UpdateCompanion<AccountSetupData> {
  final Value<int> id;
  final Value<int?> mechantId;
  final Value<String?> paymentType;
  final Value<String?> institutionName;
  final Value<String?> receivingNumber;
  final Value<String?> status;
  final Value<String?> verified;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const AccountSetupCompanion({
    this.id = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.receivingNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountSetupCompanion.insert({
    this.id = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.receivingNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<AccountSetupData> custom({
    Expression<int>? id,
    Expression<int>? mechantId,
    Expression<String>? paymentType,
    Expression<String>? institutionName,
    Expression<String>? receivingNumber,
    Expression<String>? status,
    Expression<String>? verified,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mechantId != null) 'mechant_id': mechantId,
      if (paymentType != null) 'payment_type': paymentType,
      if (institutionName != null) 'institution_name': institutionName,
      if (receivingNumber != null) 'receiving_number': receivingNumber,
      if (status != null) 'status': status,
      if (verified != null) 'verified': verified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountSetupCompanion copyWith(
      {Value<int>? id,
      Value<int?>? mechantId,
      Value<String?>? paymentType,
      Value<String?>? institutionName,
      Value<String?>? receivingNumber,
      Value<String?>? status,
      Value<String?>? verified,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return AccountSetupCompanion(
      id: id ?? this.id,
      mechantId: mechantId ?? this.mechantId,
      paymentType: paymentType ?? this.paymentType,
      institutionName: institutionName ?? this.institutionName,
      receivingNumber: receivingNumber ?? this.receivingNumber,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mechantId.present) {
      map['mechant_id'] = Variable<int>(mechantId.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (receivingNumber.present) {
      map['receiving_number'] = Variable<String>(receivingNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (verified.present) {
      map['verified'] = Variable<String>(verified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountSetupCompanion(')
          ..write('id: $id, ')
          ..write('mechantId: $mechantId, ')
          ..write('paymentType: $paymentType, ')
          ..write('institutionName: $institutionName, ')
          ..write('receivingNumber: $receivingNumber, ')
          ..write('status: $status, ')
          ..write('verified: $verified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _admissionNoMeta =
      const VerificationMeta('admissionNo');
  @override
  late final GeneratedColumn<String> admissionNo = GeneratedColumn<String>(
      'admission_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rollNoMeta = const VerificationMeta('rollNo');
  @override
  late final GeneratedColumn<String> rollNo = GeneratedColumn<String>(
      'roll_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
      'dob', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _admissionDateMeta =
      const VerificationMeta('admissionDate');
  @override
  late final GeneratedColumn<String> admissionDate = GeneratedColumn<String>(
      'admission_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _studentCategoryIdMeta =
      const VerificationMeta('studentCategoryId');
  @override
  late final GeneratedColumn<int> studentCategoryId = GeneratedColumn<int>(
      'student_category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _religionIdMeta =
      const VerificationMeta('religionId');
  @override
  late final GeneratedColumn<int> religionId = GeneratedColumn<int>(
      'religion_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bloodGroupIdMeta =
      const VerificationMeta('bloodGroupId');
  @override
  late final GeneratedColumn<int> bloodGroupId = GeneratedColumn<int>(
      'blood_group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _genderIdMeta =
      const VerificationMeta('genderId');
  @override
  late final GeneratedColumn<int> genderId = GeneratedColumn<int>(
      'gender_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _imageIdMeta =
      const VerificationMeta('imageId');
  @override
  late final GeneratedColumn<int> imageId = GeneratedColumn<int>(
      'image_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _parentGuardianIdMeta =
      const VerificationMeta('parentGuardianId');
  @override
  late final GeneratedColumn<int> parentGuardianId = GeneratedColumn<int>(
      'parent_guardian_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uploadDocumentsMeta =
      const VerificationMeta('uploadDocuments');
  @override
  late final GeneratedColumn<String> uploadDocuments = GeneratedColumn<String>(
      'upload_documents', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolMeta =
      const VerificationMeta('previousSchool');
  @override
  late final GeneratedColumn<int> previousSchool = GeneratedColumn<int>(
      'previous_school', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolInfoMeta =
      const VerificationMeta('previousSchoolInfo');
  @override
  late final GeneratedColumn<String> previousSchoolInfo =
      GeneratedColumn<String>('previous_school_info', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolImageIdMeta =
      const VerificationMeta('previousSchoolImageId');
  @override
  late final GeneratedColumn<int> previousSchoolImageId = GeneratedColumn<int>(
      'previous_school_image_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _placeOfBirthMeta =
      const VerificationMeta('placeOfBirth');
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
      'place_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nationalityMeta =
      const VerificationMeta('nationality');
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
      'nationality', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cprNoMeta = const VerificationMeta('cprNo');
  @override
  late final GeneratedColumn<String> cprNo = GeneratedColumn<String>(
      'cpr_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _spokenLangAtHomeMeta =
      const VerificationMeta('spokenLangAtHome');
  @override
  late final GeneratedColumn<String> spokenLangAtHome = GeneratedColumn<String>(
      'spoken_lang_at_home', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _residanceAddressMeta =
      const VerificationMeta('residanceAddress');
  @override
  late final GeneratedColumn<String> residanceAddress = GeneratedColumn<String>(
      'residance_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _classNameMeta =
      const VerificationMeta('className');
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
      'class_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sectionNameMeta =
      const VerificationMeta('sectionName');
  @override
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
      'section_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        admissionNo,
        rollNo,
        firstName,
        lastName,
        mobile,
        email,
        dob,
        admissionDate,
        studentCategoryId,
        religionId,
        bloodGroupId,
        genderId,
        categoryId,
        imageId,
        parentGuardianId,
        userId,
        uploadDocuments,
        status,
        previousSchool,
        previousSchoolInfo,
        previousSchoolImageId,
        placeOfBirth,
        nationality,
        cprNo,
        spokenLangAtHome,
        residanceAddress,
        controlNumber,
        createdAt,
        updatedAt,
        fullName,
        className,
        sectionName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_no')) {
      context.handle(
          _admissionNoMeta,
          admissionNo.isAcceptableOrUnknown(
              data['admission_no']!, _admissionNoMeta));
    }
    if (data.containsKey('roll_no')) {
      context.handle(_rollNoMeta,
          rollNo.isAcceptableOrUnknown(data['roll_no']!, _rollNoMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('dob')) {
      context.handle(
          _dobMeta, dob.isAcceptableOrUnknown(data['dob']!, _dobMeta));
    }
    if (data.containsKey('admission_date')) {
      context.handle(
          _admissionDateMeta,
          admissionDate.isAcceptableOrUnknown(
              data['admission_date']!, _admissionDateMeta));
    }
    if (data.containsKey('student_category_id')) {
      context.handle(
          _studentCategoryIdMeta,
          studentCategoryId.isAcceptableOrUnknown(
              data['student_category_id']!, _studentCategoryIdMeta));
    }
    if (data.containsKey('religion_id')) {
      context.handle(
          _religionIdMeta,
          religionId.isAcceptableOrUnknown(
              data['religion_id']!, _religionIdMeta));
    }
    if (data.containsKey('blood_group_id')) {
      context.handle(
          _bloodGroupIdMeta,
          bloodGroupId.isAcceptableOrUnknown(
              data['blood_group_id']!, _bloodGroupIdMeta));
    }
    if (data.containsKey('gender_id')) {
      context.handle(_genderIdMeta,
          genderId.isAcceptableOrUnknown(data['gender_id']!, _genderIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('image_id')) {
      context.handle(_imageIdMeta,
          imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta));
    }
    if (data.containsKey('parent_guardian_id')) {
      context.handle(
          _parentGuardianIdMeta,
          parentGuardianId.isAcceptableOrUnknown(
              data['parent_guardian_id']!, _parentGuardianIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('upload_documents')) {
      context.handle(
          _uploadDocumentsMeta,
          uploadDocuments.isAcceptableOrUnknown(
              data['upload_documents']!, _uploadDocumentsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('previous_school')) {
      context.handle(
          _previousSchoolMeta,
          previousSchool.isAcceptableOrUnknown(
              data['previous_school']!, _previousSchoolMeta));
    }
    if (data.containsKey('previous_school_info')) {
      context.handle(
          _previousSchoolInfoMeta,
          previousSchoolInfo.isAcceptableOrUnknown(
              data['previous_school_info']!, _previousSchoolInfoMeta));
    }
    if (data.containsKey('previous_school_image_id')) {
      context.handle(
          _previousSchoolImageIdMeta,
          previousSchoolImageId.isAcceptableOrUnknown(
              data['previous_school_image_id']!, _previousSchoolImageIdMeta));
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
          _placeOfBirthMeta,
          placeOfBirth.isAcceptableOrUnknown(
              data['place_of_birth']!, _placeOfBirthMeta));
    }
    if (data.containsKey('nationality')) {
      context.handle(
          _nationalityMeta,
          nationality.isAcceptableOrUnknown(
              data['nationality']!, _nationalityMeta));
    }
    if (data.containsKey('cpr_no')) {
      context.handle(
          _cprNoMeta, cprNo.isAcceptableOrUnknown(data['cpr_no']!, _cprNoMeta));
    }
    if (data.containsKey('spoken_lang_at_home')) {
      context.handle(
          _spokenLangAtHomeMeta,
          spokenLangAtHome.isAcceptableOrUnknown(
              data['spoken_lang_at_home']!, _spokenLangAtHomeMeta));
    }
    if (data.containsKey('residance_address')) {
      context.handle(
          _residanceAddressMeta,
          residanceAddress.isAcceptableOrUnknown(
              data['residance_address']!, _residanceAddressMeta));
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    }
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta,
          className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    }
    if (data.containsKey('section_name')) {
      context.handle(
          _sectionNameMeta,
          sectionName.isAcceptableOrUnknown(
              data['section_name']!, _sectionNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      admissionNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}admission_no']),
      rollNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}roll_no']),
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      dob: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dob']),
      admissionDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}admission_date']),
      studentCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}student_category_id']),
      religionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}religion_id']),
      bloodGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}blood_group_id']),
      genderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id']),
      parentGuardianId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_guardian_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      uploadDocuments: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}upload_documents']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status']),
      previousSchool: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}previous_school']),
      previousSchoolInfo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}previous_school_info']),
      previousSchoolImageId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}previous_school_image_id']),
      placeOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_of_birth']),
      nationality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nationality']),
      cprNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpr_no']),
      spokenLangAtHome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}spoken_lang_at_home']),
      residanceAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}residance_address']),
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name']),
      className: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_name']),
      sectionName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section_name']),
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String? admissionNo;
  final String? rollNo;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? dob;
  final String? admissionDate;
  final int? studentCategoryId;
  final int? religionId;
  final int? bloodGroupId;
  final int? genderId;
  final int? categoryId;
  final int? imageId;
  final int? parentGuardianId;
  final int? userId;
  final String? uploadDocuments;
  final int? status;
  final int? previousSchool;
  final String? previousSchoolInfo;
  final int? previousSchoolImageId;
  final String? placeOfBirth;
  final String? nationality;
  final String? cprNo;
  final String? spokenLangAtHome;
  final String? residanceAddress;
  final String? controlNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? fullName;
  final String? className;
  final String? sectionName;
  const Student(
      {required this.id,
      this.admissionNo,
      this.rollNo,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.dob,
      this.admissionDate,
      this.studentCategoryId,
      this.religionId,
      this.bloodGroupId,
      this.genderId,
      this.categoryId,
      this.imageId,
      this.parentGuardianId,
      this.userId,
      this.uploadDocuments,
      this.status,
      this.previousSchool,
      this.previousSchoolInfo,
      this.previousSchoolImageId,
      this.placeOfBirth,
      this.nationality,
      this.cprNo,
      this.spokenLangAtHome,
      this.residanceAddress,
      this.controlNumber,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.className,
      this.sectionName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || admissionNo != null) {
      map['admission_no'] = Variable<String>(admissionNo);
    }
    if (!nullToAbsent || rollNo != null) {
      map['roll_no'] = Variable<String>(rollNo);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<String>(dob);
    }
    if (!nullToAbsent || admissionDate != null) {
      map['admission_date'] = Variable<String>(admissionDate);
    }
    if (!nullToAbsent || studentCategoryId != null) {
      map['student_category_id'] = Variable<int>(studentCategoryId);
    }
    if (!nullToAbsent || religionId != null) {
      map['religion_id'] = Variable<int>(religionId);
    }
    if (!nullToAbsent || bloodGroupId != null) {
      map['blood_group_id'] = Variable<int>(bloodGroupId);
    }
    if (!nullToAbsent || genderId != null) {
      map['gender_id'] = Variable<int>(genderId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || imageId != null) {
      map['image_id'] = Variable<int>(imageId);
    }
    if (!nullToAbsent || parentGuardianId != null) {
      map['parent_guardian_id'] = Variable<int>(parentGuardianId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || uploadDocuments != null) {
      map['upload_documents'] = Variable<String>(uploadDocuments);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || previousSchool != null) {
      map['previous_school'] = Variable<int>(previousSchool);
    }
    if (!nullToAbsent || previousSchoolInfo != null) {
      map['previous_school_info'] = Variable<String>(previousSchoolInfo);
    }
    if (!nullToAbsent || previousSchoolImageId != null) {
      map['previous_school_image_id'] = Variable<int>(previousSchoolImageId);
    }
    if (!nullToAbsent || placeOfBirth != null) {
      map['place_of_birth'] = Variable<String>(placeOfBirth);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || cprNo != null) {
      map['cpr_no'] = Variable<String>(cprNo);
    }
    if (!nullToAbsent || spokenLangAtHome != null) {
      map['spoken_lang_at_home'] = Variable<String>(spokenLangAtHome);
    }
    if (!nullToAbsent || residanceAddress != null) {
      map['residance_address'] = Variable<String>(residanceAddress);
    }
    if (!nullToAbsent || controlNumber != null) {
      map['control_number'] = Variable<String>(controlNumber);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || className != null) {
      map['class_name'] = Variable<String>(className);
    }
    if (!nullToAbsent || sectionName != null) {
      map['section_name'] = Variable<String>(sectionName);
    }
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      admissionNo: admissionNo == null && nullToAbsent
          ? const Value.absent()
          : Value(admissionNo),
      rollNo:
          rollNo == null && nullToAbsent ? const Value.absent() : Value(rollNo),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      admissionDate: admissionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(admissionDate),
      studentCategoryId: studentCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentCategoryId),
      religionId: religionId == null && nullToAbsent
          ? const Value.absent()
          : Value(religionId),
      bloodGroupId: bloodGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroupId),
      genderId: genderId == null && nullToAbsent
          ? const Value.absent()
          : Value(genderId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageId: imageId == null && nullToAbsent
          ? const Value.absent()
          : Value(imageId),
      parentGuardianId: parentGuardianId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentGuardianId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      uploadDocuments: uploadDocuments == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadDocuments),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      previousSchool: previousSchool == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchool),
      previousSchoolInfo: previousSchoolInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchoolInfo),
      previousSchoolImageId: previousSchoolImageId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchoolImageId),
      placeOfBirth: placeOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfBirth),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      cprNo:
          cprNo == null && nullToAbsent ? const Value.absent() : Value(cprNo),
      spokenLangAtHome: spokenLangAtHome == null && nullToAbsent
          ? const Value.absent()
          : Value(spokenLangAtHome),
      residanceAddress: residanceAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(residanceAddress),
      controlNumber: controlNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(controlNumber),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      className: className == null && nullToAbsent
          ? const Value.absent()
          : Value(className),
      sectionName: sectionName == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionName),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      admissionNo: serializer.fromJson<String?>(json['admissionNo']),
      rollNo: serializer.fromJson<String?>(json['rollNo']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      dob: serializer.fromJson<String?>(json['dob']),
      admissionDate: serializer.fromJson<String?>(json['admissionDate']),
      studentCategoryId: serializer.fromJson<int?>(json['studentCategoryId']),
      religionId: serializer.fromJson<int?>(json['religionId']),
      bloodGroupId: serializer.fromJson<int?>(json['bloodGroupId']),
      genderId: serializer.fromJson<int?>(json['genderId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      imageId: serializer.fromJson<int?>(json['imageId']),
      parentGuardianId: serializer.fromJson<int?>(json['parentGuardianId']),
      userId: serializer.fromJson<int?>(json['userId']),
      uploadDocuments: serializer.fromJson<String?>(json['uploadDocuments']),
      status: serializer.fromJson<int?>(json['status']),
      previousSchool: serializer.fromJson<int?>(json['previousSchool']),
      previousSchoolInfo:
          serializer.fromJson<String?>(json['previousSchoolInfo']),
      previousSchoolImageId:
          serializer.fromJson<int?>(json['previousSchoolImageId']),
      placeOfBirth: serializer.fromJson<String?>(json['placeOfBirth']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      cprNo: serializer.fromJson<String?>(json['cprNo']),
      spokenLangAtHome: serializer.fromJson<String?>(json['spokenLangAtHome']),
      residanceAddress: serializer.fromJson<String?>(json['residanceAddress']),
      controlNumber: serializer.fromJson<String?>(json['controlNumber']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      className: serializer.fromJson<String?>(json['className']),
      sectionName: serializer.fromJson<String?>(json['sectionName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionNo': serializer.toJson<String?>(admissionNo),
      'rollNo': serializer.toJson<String?>(rollNo),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'dob': serializer.toJson<String?>(dob),
      'admissionDate': serializer.toJson<String?>(admissionDate),
      'studentCategoryId': serializer.toJson<int?>(studentCategoryId),
      'religionId': serializer.toJson<int?>(religionId),
      'bloodGroupId': serializer.toJson<int?>(bloodGroupId),
      'genderId': serializer.toJson<int?>(genderId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'imageId': serializer.toJson<int?>(imageId),
      'parentGuardianId': serializer.toJson<int?>(parentGuardianId),
      'userId': serializer.toJson<int?>(userId),
      'uploadDocuments': serializer.toJson<String?>(uploadDocuments),
      'status': serializer.toJson<int?>(status),
      'previousSchool': serializer.toJson<int?>(previousSchool),
      'previousSchoolInfo': serializer.toJson<String?>(previousSchoolInfo),
      'previousSchoolImageId': serializer.toJson<int?>(previousSchoolImageId),
      'placeOfBirth': serializer.toJson<String?>(placeOfBirth),
      'nationality': serializer.toJson<String?>(nationality),
      'cprNo': serializer.toJson<String?>(cprNo),
      'spokenLangAtHome': serializer.toJson<String?>(spokenLangAtHome),
      'residanceAddress': serializer.toJson<String?>(residanceAddress),
      'controlNumber': serializer.toJson<String?>(controlNumber),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'fullName': serializer.toJson<String?>(fullName),
      'className': serializer.toJson<String?>(className),
      'sectionName': serializer.toJson<String?>(sectionName),
    };
  }

  Student copyWith(
          {int? id,
          Value<String?> admissionNo = const Value.absent(),
          Value<String?> rollNo = const Value.absent(),
          Value<String?> firstName = const Value.absent(),
          Value<String?> lastName = const Value.absent(),
          Value<String?> mobile = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> dob = const Value.absent(),
          Value<String?> admissionDate = const Value.absent(),
          Value<int?> studentCategoryId = const Value.absent(),
          Value<int?> religionId = const Value.absent(),
          Value<int?> bloodGroupId = const Value.absent(),
          Value<int?> genderId = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          Value<int?> imageId = const Value.absent(),
          Value<int?> parentGuardianId = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          Value<String?> uploadDocuments = const Value.absent(),
          Value<int?> status = const Value.absent(),
          Value<int?> previousSchool = const Value.absent(),
          Value<String?> previousSchoolInfo = const Value.absent(),
          Value<int?> previousSchoolImageId = const Value.absent(),
          Value<String?> placeOfBirth = const Value.absent(),
          Value<String?> nationality = const Value.absent(),
          Value<String?> cprNo = const Value.absent(),
          Value<String?> spokenLangAtHome = const Value.absent(),
          Value<String?> residanceAddress = const Value.absent(),
          Value<String?> controlNumber = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> fullName = const Value.absent(),
          Value<String?> className = const Value.absent(),
          Value<String?> sectionName = const Value.absent()}) =>
      Student(
        id: id ?? this.id,
        admissionNo: admissionNo.present ? admissionNo.value : this.admissionNo,
        rollNo: rollNo.present ? rollNo.value : this.rollNo,
        firstName: firstName.present ? firstName.value : this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        mobile: mobile.present ? mobile.value : this.mobile,
        email: email.present ? email.value : this.email,
        dob: dob.present ? dob.value : this.dob,
        admissionDate:
            admissionDate.present ? admissionDate.value : this.admissionDate,
        studentCategoryId: studentCategoryId.present
            ? studentCategoryId.value
            : this.studentCategoryId,
        religionId: religionId.present ? religionId.value : this.religionId,
        bloodGroupId:
            bloodGroupId.present ? bloodGroupId.value : this.bloodGroupId,
        genderId: genderId.present ? genderId.value : this.genderId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        imageId: imageId.present ? imageId.value : this.imageId,
        parentGuardianId: parentGuardianId.present
            ? parentGuardianId.value
            : this.parentGuardianId,
        userId: userId.present ? userId.value : this.userId,
        uploadDocuments: uploadDocuments.present
            ? uploadDocuments.value
            : this.uploadDocuments,
        status: status.present ? status.value : this.status,
        previousSchool:
            previousSchool.present ? previousSchool.value : this.previousSchool,
        previousSchoolInfo: previousSchoolInfo.present
            ? previousSchoolInfo.value
            : this.previousSchoolInfo,
        previousSchoolImageId: previousSchoolImageId.present
            ? previousSchoolImageId.value
            : this.previousSchoolImageId,
        placeOfBirth:
            placeOfBirth.present ? placeOfBirth.value : this.placeOfBirth,
        nationality: nationality.present ? nationality.value : this.nationality,
        cprNo: cprNo.present ? cprNo.value : this.cprNo,
        spokenLangAtHome: spokenLangAtHome.present
            ? spokenLangAtHome.value
            : this.spokenLangAtHome,
        residanceAddress: residanceAddress.present
            ? residanceAddress.value
            : this.residanceAddress,
        controlNumber:
            controlNumber.present ? controlNumber.value : this.controlNumber,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        fullName: fullName.present ? fullName.value : this.fullName,
        className: className.present ? className.value : this.className,
        sectionName: sectionName.present ? sectionName.value : this.sectionName,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      admissionNo:
          data.admissionNo.present ? data.admissionNo.value : this.admissionNo,
      rollNo: data.rollNo.present ? data.rollNo.value : this.rollNo,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      dob: data.dob.present ? data.dob.value : this.dob,
      admissionDate: data.admissionDate.present
          ? data.admissionDate.value
          : this.admissionDate,
      studentCategoryId: data.studentCategoryId.present
          ? data.studentCategoryId.value
          : this.studentCategoryId,
      religionId:
          data.religionId.present ? data.religionId.value : this.religionId,
      bloodGroupId: data.bloodGroupId.present
          ? data.bloodGroupId.value
          : this.bloodGroupId,
      genderId: data.genderId.present ? data.genderId.value : this.genderId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      parentGuardianId: data.parentGuardianId.present
          ? data.parentGuardianId.value
          : this.parentGuardianId,
      userId: data.userId.present ? data.userId.value : this.userId,
      uploadDocuments: data.uploadDocuments.present
          ? data.uploadDocuments.value
          : this.uploadDocuments,
      status: data.status.present ? data.status.value : this.status,
      previousSchool: data.previousSchool.present
          ? data.previousSchool.value
          : this.previousSchool,
      previousSchoolInfo: data.previousSchoolInfo.present
          ? data.previousSchoolInfo.value
          : this.previousSchoolInfo,
      previousSchoolImageId: data.previousSchoolImageId.present
          ? data.previousSchoolImageId.value
          : this.previousSchoolImageId,
      placeOfBirth: data.placeOfBirth.present
          ? data.placeOfBirth.value
          : this.placeOfBirth,
      nationality:
          data.nationality.present ? data.nationality.value : this.nationality,
      cprNo: data.cprNo.present ? data.cprNo.value : this.cprNo,
      spokenLangAtHome: data.spokenLangAtHome.present
          ? data.spokenLangAtHome.value
          : this.spokenLangAtHome,
      residanceAddress: data.residanceAddress.present
          ? data.residanceAddress.value
          : this.residanceAddress,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      className: data.className.present ? data.className.value : this.className,
      sectionName:
          data.sectionName.present ? data.sectionName.value : this.sectionName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('admissionNo: $admissionNo, ')
          ..write('rollNo: $rollNo, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('dob: $dob, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('studentCategoryId: $studentCategoryId, ')
          ..write('religionId: $religionId, ')
          ..write('bloodGroupId: $bloodGroupId, ')
          ..write('genderId: $genderId, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageId: $imageId, ')
          ..write('parentGuardianId: $parentGuardianId, ')
          ..write('userId: $userId, ')
          ..write('uploadDocuments: $uploadDocuments, ')
          ..write('status: $status, ')
          ..write('previousSchool: $previousSchool, ')
          ..write('previousSchoolInfo: $previousSchoolInfo, ')
          ..write('previousSchoolImageId: $previousSchoolImageId, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('cprNo: $cprNo, ')
          ..write('spokenLangAtHome: $spokenLangAtHome, ')
          ..write('residanceAddress: $residanceAddress, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fullName: $fullName, ')
          ..write('className: $className, ')
          ..write('sectionName: $sectionName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        admissionNo,
        rollNo,
        firstName,
        lastName,
        mobile,
        email,
        dob,
        admissionDate,
        studentCategoryId,
        religionId,
        bloodGroupId,
        genderId,
        categoryId,
        imageId,
        parentGuardianId,
        userId,
        uploadDocuments,
        status,
        previousSchool,
        previousSchoolInfo,
        previousSchoolImageId,
        placeOfBirth,
        nationality,
        cprNo,
        spokenLangAtHome,
        residanceAddress,
        controlNumber,
        createdAt,
        updatedAt,
        fullName,
        className,
        sectionName
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.admissionNo == this.admissionNo &&
          other.rollNo == this.rollNo &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.dob == this.dob &&
          other.admissionDate == this.admissionDate &&
          other.studentCategoryId == this.studentCategoryId &&
          other.religionId == this.religionId &&
          other.bloodGroupId == this.bloodGroupId &&
          other.genderId == this.genderId &&
          other.categoryId == this.categoryId &&
          other.imageId == this.imageId &&
          other.parentGuardianId == this.parentGuardianId &&
          other.userId == this.userId &&
          other.uploadDocuments == this.uploadDocuments &&
          other.status == this.status &&
          other.previousSchool == this.previousSchool &&
          other.previousSchoolInfo == this.previousSchoolInfo &&
          other.previousSchoolImageId == this.previousSchoolImageId &&
          other.placeOfBirth == this.placeOfBirth &&
          other.nationality == this.nationality &&
          other.cprNo == this.cprNo &&
          other.spokenLangAtHome == this.spokenLangAtHome &&
          other.residanceAddress == this.residanceAddress &&
          other.controlNumber == this.controlNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fullName == this.fullName &&
          other.className == this.className &&
          other.sectionName == this.sectionName);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String?> admissionNo;
  final Value<String?> rollNo;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> dob;
  final Value<String?> admissionDate;
  final Value<int?> studentCategoryId;
  final Value<int?> religionId;
  final Value<int?> bloodGroupId;
  final Value<int?> genderId;
  final Value<int?> categoryId;
  final Value<int?> imageId;
  final Value<int?> parentGuardianId;
  final Value<int?> userId;
  final Value<String?> uploadDocuments;
  final Value<int?> status;
  final Value<int?> previousSchool;
  final Value<String?> previousSchoolInfo;
  final Value<int?> previousSchoolImageId;
  final Value<String?> placeOfBirth;
  final Value<String?> nationality;
  final Value<String?> cprNo;
  final Value<String?> spokenLangAtHome;
  final Value<String?> residanceAddress;
  final Value<String?> controlNumber;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> fullName;
  final Value<String?> className;
  final Value<String?> sectionName;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.admissionNo = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.dob = const Value.absent(),
    this.admissionDate = const Value.absent(),
    this.studentCategoryId = const Value.absent(),
    this.religionId = const Value.absent(),
    this.bloodGroupId = const Value.absent(),
    this.genderId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageId = const Value.absent(),
    this.parentGuardianId = const Value.absent(),
    this.userId = const Value.absent(),
    this.uploadDocuments = const Value.absent(),
    this.status = const Value.absent(),
    this.previousSchool = const Value.absent(),
    this.previousSchoolInfo = const Value.absent(),
    this.previousSchoolImageId = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.cprNo = const Value.absent(),
    this.spokenLangAtHome = const Value.absent(),
    this.residanceAddress = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fullName = const Value.absent(),
    this.className = const Value.absent(),
    this.sectionName = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    this.admissionNo = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.dob = const Value.absent(),
    this.admissionDate = const Value.absent(),
    this.studentCategoryId = const Value.absent(),
    this.religionId = const Value.absent(),
    this.bloodGroupId = const Value.absent(),
    this.genderId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageId = const Value.absent(),
    this.parentGuardianId = const Value.absent(),
    this.userId = const Value.absent(),
    this.uploadDocuments = const Value.absent(),
    this.status = const Value.absent(),
    this.previousSchool = const Value.absent(),
    this.previousSchoolInfo = const Value.absent(),
    this.previousSchoolImageId = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.cprNo = const Value.absent(),
    this.spokenLangAtHome = const Value.absent(),
    this.residanceAddress = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fullName = const Value.absent(),
    this.className = const Value.absent(),
    this.sectionName = const Value.absent(),
  });
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? admissionNo,
    Expression<String>? rollNo,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? dob,
    Expression<String>? admissionDate,
    Expression<int>? studentCategoryId,
    Expression<int>? religionId,
    Expression<int>? bloodGroupId,
    Expression<int>? genderId,
    Expression<int>? categoryId,
    Expression<int>? imageId,
    Expression<int>? parentGuardianId,
    Expression<int>? userId,
    Expression<String>? uploadDocuments,
    Expression<int>? status,
    Expression<int>? previousSchool,
    Expression<String>? previousSchoolInfo,
    Expression<int>? previousSchoolImageId,
    Expression<String>? placeOfBirth,
    Expression<String>? nationality,
    Expression<String>? cprNo,
    Expression<String>? spokenLangAtHome,
    Expression<String>? residanceAddress,
    Expression<String>? controlNumber,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? fullName,
    Expression<String>? className,
    Expression<String>? sectionName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionNo != null) 'admission_no': admissionNo,
      if (rollNo != null) 'roll_no': rollNo,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (dob != null) 'dob': dob,
      if (admissionDate != null) 'admission_date': admissionDate,
      if (studentCategoryId != null) 'student_category_id': studentCategoryId,
      if (religionId != null) 'religion_id': religionId,
      if (bloodGroupId != null) 'blood_group_id': bloodGroupId,
      if (genderId != null) 'gender_id': genderId,
      if (categoryId != null) 'category_id': categoryId,
      if (imageId != null) 'image_id': imageId,
      if (parentGuardianId != null) 'parent_guardian_id': parentGuardianId,
      if (userId != null) 'user_id': userId,
      if (uploadDocuments != null) 'upload_documents': uploadDocuments,
      if (status != null) 'status': status,
      if (previousSchool != null) 'previous_school': previousSchool,
      if (previousSchoolInfo != null)
        'previous_school_info': previousSchoolInfo,
      if (previousSchoolImageId != null)
        'previous_school_image_id': previousSchoolImageId,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (nationality != null) 'nationality': nationality,
      if (cprNo != null) 'cpr_no': cprNo,
      if (spokenLangAtHome != null) 'spoken_lang_at_home': spokenLangAtHome,
      if (residanceAddress != null) 'residance_address': residanceAddress,
      if (controlNumber != null) 'control_number': controlNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fullName != null) 'full_name': fullName,
      if (className != null) 'class_name': className,
      if (sectionName != null) 'section_name': sectionName,
    });
  }

  StudentsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? admissionNo,
      Value<String?>? rollNo,
      Value<String?>? firstName,
      Value<String?>? lastName,
      Value<String?>? mobile,
      Value<String?>? email,
      Value<String?>? dob,
      Value<String?>? admissionDate,
      Value<int?>? studentCategoryId,
      Value<int?>? religionId,
      Value<int?>? bloodGroupId,
      Value<int?>? genderId,
      Value<int?>? categoryId,
      Value<int?>? imageId,
      Value<int?>? parentGuardianId,
      Value<int?>? userId,
      Value<String?>? uploadDocuments,
      Value<int?>? status,
      Value<int?>? previousSchool,
      Value<String?>? previousSchoolInfo,
      Value<int?>? previousSchoolImageId,
      Value<String?>? placeOfBirth,
      Value<String?>? nationality,
      Value<String?>? cprNo,
      Value<String?>? spokenLangAtHome,
      Value<String?>? residanceAddress,
      Value<String?>? controlNumber,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? fullName,
      Value<String?>? className,
      Value<String?>? sectionName}) {
    return StudentsCompanion(
      id: id ?? this.id,
      admissionNo: admissionNo ?? this.admissionNo,
      rollNo: rollNo ?? this.rollNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      admissionDate: admissionDate ?? this.admissionDate,
      studentCategoryId: studentCategoryId ?? this.studentCategoryId,
      religionId: religionId ?? this.religionId,
      bloodGroupId: bloodGroupId ?? this.bloodGroupId,
      genderId: genderId ?? this.genderId,
      categoryId: categoryId ?? this.categoryId,
      imageId: imageId ?? this.imageId,
      parentGuardianId: parentGuardianId ?? this.parentGuardianId,
      userId: userId ?? this.userId,
      uploadDocuments: uploadDocuments ?? this.uploadDocuments,
      status: status ?? this.status,
      previousSchool: previousSchool ?? this.previousSchool,
      previousSchoolInfo: previousSchoolInfo ?? this.previousSchoolInfo,
      previousSchoolImageId:
          previousSchoolImageId ?? this.previousSchoolImageId,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      nationality: nationality ?? this.nationality,
      cprNo: cprNo ?? this.cprNo,
      spokenLangAtHome: spokenLangAtHome ?? this.spokenLangAtHome,
      residanceAddress: residanceAddress ?? this.residanceAddress,
      controlNumber: controlNumber ?? this.controlNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionNo.present) {
      map['admission_no'] = Variable<String>(admissionNo.value);
    }
    if (rollNo.present) {
      map['roll_no'] = Variable<String>(rollNo.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (admissionDate.present) {
      map['admission_date'] = Variable<String>(admissionDate.value);
    }
    if (studentCategoryId.present) {
      map['student_category_id'] = Variable<int>(studentCategoryId.value);
    }
    if (religionId.present) {
      map['religion_id'] = Variable<int>(religionId.value);
    }
    if (bloodGroupId.present) {
      map['blood_group_id'] = Variable<int>(bloodGroupId.value);
    }
    if (genderId.present) {
      map['gender_id'] = Variable<int>(genderId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (parentGuardianId.present) {
      map['parent_guardian_id'] = Variable<int>(parentGuardianId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (uploadDocuments.present) {
      map['upload_documents'] = Variable<String>(uploadDocuments.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (previousSchool.present) {
      map['previous_school'] = Variable<int>(previousSchool.value);
    }
    if (previousSchoolInfo.present) {
      map['previous_school_info'] = Variable<String>(previousSchoolInfo.value);
    }
    if (previousSchoolImageId.present) {
      map['previous_school_image_id'] =
          Variable<int>(previousSchoolImageId.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (cprNo.present) {
      map['cpr_no'] = Variable<String>(cprNo.value);
    }
    if (spokenLangAtHome.present) {
      map['spoken_lang_at_home'] = Variable<String>(spokenLangAtHome.value);
    }
    if (residanceAddress.present) {
      map['residance_address'] = Variable<String>(residanceAddress.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('admissionNo: $admissionNo, ')
          ..write('rollNo: $rollNo, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('dob: $dob, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('studentCategoryId: $studentCategoryId, ')
          ..write('religionId: $religionId, ')
          ..write('bloodGroupId: $bloodGroupId, ')
          ..write('genderId: $genderId, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageId: $imageId, ')
          ..write('parentGuardianId: $parentGuardianId, ')
          ..write('userId: $userId, ')
          ..write('uploadDocuments: $uploadDocuments, ')
          ..write('status: $status, ')
          ..write('previousSchool: $previousSchool, ')
          ..write('previousSchoolInfo: $previousSchoolInfo, ')
          ..write('previousSchoolImageId: $previousSchoolImageId, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('cprNo: $cprNo, ')
          ..write('spokenLangAtHome: $spokenLangAtHome, ')
          ..write('residanceAddress: $residanceAddress, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fullName: $fullName, ')
          ..write('className: $className, ')
          ..write('sectionName: $sectionName')
          ..write(')'))
        .toString();
  }
}

class $FeesAssignmentsTable extends FeesAssignments
    with TableInfo<$FeesAssignmentsTable, FeesAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeesAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _feesAssignIdMeta =
      const VerificationMeta('feesAssignId');
  @override
  late final GeneratedColumn<int> feesAssignId = GeneratedColumn<int>(
      'fees_assign_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _feesMasterIdMeta =
      const VerificationMeta('feesMasterId');
  @override
  late final GeneratedColumn<int> feesMasterId = GeneratedColumn<int>(
      'fees_master_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _feesAmountMeta =
      const VerificationMeta('feesAmount');
  @override
  late final GeneratedColumn<String> feesAmount = GeneratedColumn<String>(
      'fees_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<String> paidAmount = GeneratedColumn<String>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _remainedAmountMeta =
      const VerificationMeta('remainedAmount');
  @override
  late final GeneratedColumn<String> remainedAmount = GeneratedColumn<String>(
      'remained_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _quaterAmountMeta =
      const VerificationMeta('quaterAmount');
  @override
  late final GeneratedColumn<String> quaterAmount = GeneratedColumn<String>(
      'quater_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quaterOneMeta =
      const VerificationMeta('quaterOne');
  @override
  late final GeneratedColumn<int> quaterOne = GeneratedColumn<int>(
      'quater_one', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterTwoMeta =
      const VerificationMeta('quaterTwo');
  @override
  late final GeneratedColumn<int> quaterTwo = GeneratedColumn<int>(
      'quater_two', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterThreeMeta =
      const VerificationMeta('quaterThree');
  @override
  late final GeneratedColumn<int> quaterThree = GeneratedColumn<int>(
      'quater_three', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterFourMeta =
      const VerificationMeta('quaterFour');
  @override
  late final GeneratedColumn<int> quaterFour = GeneratedColumn<int>(
      'quater_four', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outstandingbalanceMeta =
      const VerificationMeta('outstandingbalance');
  @override
  late final GeneratedColumn<String> outstandingbalance =
      GeneratedColumn<String>('outstandingbalance', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        feesAssignId,
        feesMasterId,
        studentId,
        controlNumber,
        feesAmount,
        paidAmount,
        remainedAmount,
        quaterAmount,
        quaterOne,
        quaterTwo,
        quaterThree,
        quaterFour,
        comment,
        outstandingbalance,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fees_assignments';
  @override
  VerificationContext validateIntegrity(Insertable<FeesAssignment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fees_assign_id')) {
      context.handle(
          _feesAssignIdMeta,
          feesAssignId.isAcceptableOrUnknown(
              data['fees_assign_id']!, _feesAssignIdMeta));
    } else if (isInserting) {
      context.missing(_feesAssignIdMeta);
    }
    if (data.containsKey('fees_master_id')) {
      context.handle(
          _feesMasterIdMeta,
          feesMasterId.isAcceptableOrUnknown(
              data['fees_master_id']!, _feesMasterIdMeta));
    } else if (isInserting) {
      context.missing(_feesMasterIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    } else if (isInserting) {
      context.missing(_controlNumberMeta);
    }
    if (data.containsKey('fees_amount')) {
      context.handle(
          _feesAmountMeta,
          feesAmount.isAcceptableOrUnknown(
              data['fees_amount']!, _feesAmountMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('remained_amount')) {
      context.handle(
          _remainedAmountMeta,
          remainedAmount.isAcceptableOrUnknown(
              data['remained_amount']!, _remainedAmountMeta));
    }
    if (data.containsKey('quater_amount')) {
      context.handle(
          _quaterAmountMeta,
          quaterAmount.isAcceptableOrUnknown(
              data['quater_amount']!, _quaterAmountMeta));
    }
    if (data.containsKey('quater_one')) {
      context.handle(_quaterOneMeta,
          quaterOne.isAcceptableOrUnknown(data['quater_one']!, _quaterOneMeta));
    }
    if (data.containsKey('quater_two')) {
      context.handle(_quaterTwoMeta,
          quaterTwo.isAcceptableOrUnknown(data['quater_two']!, _quaterTwoMeta));
    }
    if (data.containsKey('quater_three')) {
      context.handle(
          _quaterThreeMeta,
          quaterThree.isAcceptableOrUnknown(
              data['quater_three']!, _quaterThreeMeta));
    }
    if (data.containsKey('quater_four')) {
      context.handle(
          _quaterFourMeta,
          quaterFour.isAcceptableOrUnknown(
              data['quater_four']!, _quaterFourMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('outstandingbalance')) {
      context.handle(
          _outstandingbalanceMeta,
          outstandingbalance.isAcceptableOrUnknown(
              data['outstandingbalance']!, _outstandingbalanceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeesAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeesAssignment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      feesAssignId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fees_assign_id'])!,
      feesMasterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fees_master_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number'])!,
      feesAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fees_amount'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paid_amount'])!,
      remainedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remained_amount'])!,
      quaterAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quater_amount']),
      quaterOne: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_one']),
      quaterTwo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_two']),
      quaterThree: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_three']),
      quaterFour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_four']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      outstandingbalance: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}outstandingbalance']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FeesAssignmentsTable createAlias(String alias) {
    return $FeesAssignmentsTable(attachedDatabase, alias);
  }
}

class FeesAssignment extends DataClass implements Insertable<FeesAssignment> {
  final int id;
  final int feesAssignId;
  final int feesMasterId;
  final int studentId;
  final String controlNumber;
  final String feesAmount;
  final String paidAmount;
  final String remainedAmount;
  final String? quaterAmount;
  final int? quaterOne;
  final int? quaterTwo;
  final int? quaterThree;
  final int? quaterFour;
  final String? comment;
  final String? outstandingbalance;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FeesAssignment(
      {required this.id,
      required this.feesAssignId,
      required this.feesMasterId,
      required this.studentId,
      required this.controlNumber,
      required this.feesAmount,
      required this.paidAmount,
      required this.remainedAmount,
      this.quaterAmount,
      this.quaterOne,
      this.quaterTwo,
      this.quaterThree,
      this.quaterFour,
      this.comment,
      this.outstandingbalance,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fees_assign_id'] = Variable<int>(feesAssignId);
    map['fees_master_id'] = Variable<int>(feesMasterId);
    map['student_id'] = Variable<int>(studentId);
    map['control_number'] = Variable<String>(controlNumber);
    map['fees_amount'] = Variable<String>(feesAmount);
    map['paid_amount'] = Variable<String>(paidAmount);
    map['remained_amount'] = Variable<String>(remainedAmount);
    if (!nullToAbsent || quaterAmount != null) {
      map['quater_amount'] = Variable<String>(quaterAmount);
    }
    if (!nullToAbsent || quaterOne != null) {
      map['quater_one'] = Variable<int>(quaterOne);
    }
    if (!nullToAbsent || quaterTwo != null) {
      map['quater_two'] = Variable<int>(quaterTwo);
    }
    if (!nullToAbsent || quaterThree != null) {
      map['quater_three'] = Variable<int>(quaterThree);
    }
    if (!nullToAbsent || quaterFour != null) {
      map['quater_four'] = Variable<int>(quaterFour);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || outstandingbalance != null) {
      map['outstandingbalance'] = Variable<String>(outstandingbalance);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FeesAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return FeesAssignmentsCompanion(
      id: Value(id),
      feesAssignId: Value(feesAssignId),
      feesMasterId: Value(feesMasterId),
      studentId: Value(studentId),
      controlNumber: Value(controlNumber),
      feesAmount: Value(feesAmount),
      paidAmount: Value(paidAmount),
      remainedAmount: Value(remainedAmount),
      quaterAmount: quaterAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterAmount),
      quaterOne: quaterOne == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterOne),
      quaterTwo: quaterTwo == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterTwo),
      quaterThree: quaterThree == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterThree),
      quaterFour: quaterFour == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterFour),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      outstandingbalance: outstandingbalance == null && nullToAbsent
          ? const Value.absent()
          : Value(outstandingbalance),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeesAssignment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeesAssignment(
      id: serializer.fromJson<int>(json['id']),
      feesAssignId: serializer.fromJson<int>(json['feesAssignId']),
      feesMasterId: serializer.fromJson<int>(json['feesMasterId']),
      studentId: serializer.fromJson<int>(json['studentId']),
      controlNumber: serializer.fromJson<String>(json['controlNumber']),
      feesAmount: serializer.fromJson<String>(json['feesAmount']),
      paidAmount: serializer.fromJson<String>(json['paidAmount']),
      remainedAmount: serializer.fromJson<String>(json['remainedAmount']),
      quaterAmount: serializer.fromJson<String?>(json['quaterAmount']),
      quaterOne: serializer.fromJson<int?>(json['quaterOne']),
      quaterTwo: serializer.fromJson<int?>(json['quaterTwo']),
      quaterThree: serializer.fromJson<int?>(json['quaterThree']),
      quaterFour: serializer.fromJson<int?>(json['quaterFour']),
      comment: serializer.fromJson<String?>(json['comment']),
      outstandingbalance:
          serializer.fromJson<String?>(json['outstandingbalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feesAssignId': serializer.toJson<int>(feesAssignId),
      'feesMasterId': serializer.toJson<int>(feesMasterId),
      'studentId': serializer.toJson<int>(studentId),
      'controlNumber': serializer.toJson<String>(controlNumber),
      'feesAmount': serializer.toJson<String>(feesAmount),
      'paidAmount': serializer.toJson<String>(paidAmount),
      'remainedAmount': serializer.toJson<String>(remainedAmount),
      'quaterAmount': serializer.toJson<String?>(quaterAmount),
      'quaterOne': serializer.toJson<int?>(quaterOne),
      'quaterTwo': serializer.toJson<int?>(quaterTwo),
      'quaterThree': serializer.toJson<int?>(quaterThree),
      'quaterFour': serializer.toJson<int?>(quaterFour),
      'comment': serializer.toJson<String?>(comment),
      'outstandingbalance': serializer.toJson<String?>(outstandingbalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FeesAssignment copyWith(
          {int? id,
          int? feesAssignId,
          int? feesMasterId,
          int? studentId,
          String? controlNumber,
          String? feesAmount,
          String? paidAmount,
          String? remainedAmount,
          Value<String?> quaterAmount = const Value.absent(),
          Value<int?> quaterOne = const Value.absent(),
          Value<int?> quaterTwo = const Value.absent(),
          Value<int?> quaterThree = const Value.absent(),
          Value<int?> quaterFour = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          Value<String?> outstandingbalance = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FeesAssignment(
        id: id ?? this.id,
        feesAssignId: feesAssignId ?? this.feesAssignId,
        feesMasterId: feesMasterId ?? this.feesMasterId,
        studentId: studentId ?? this.studentId,
        controlNumber: controlNumber ?? this.controlNumber,
        feesAmount: feesAmount ?? this.feesAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        remainedAmount: remainedAmount ?? this.remainedAmount,
        quaterAmount:
            quaterAmount.present ? quaterAmount.value : this.quaterAmount,
        quaterOne: quaterOne.present ? quaterOne.value : this.quaterOne,
        quaterTwo: quaterTwo.present ? quaterTwo.value : this.quaterTwo,
        quaterThree: quaterThree.present ? quaterThree.value : this.quaterThree,
        quaterFour: quaterFour.present ? quaterFour.value : this.quaterFour,
        comment: comment.present ? comment.value : this.comment,
        outstandingbalance: outstandingbalance.present
            ? outstandingbalance.value
            : this.outstandingbalance,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FeesAssignment copyWithCompanion(FeesAssignmentsCompanion data) {
    return FeesAssignment(
      id: data.id.present ? data.id.value : this.id,
      feesAssignId: data.feesAssignId.present
          ? data.feesAssignId.value
          : this.feesAssignId,
      feesMasterId: data.feesMasterId.present
          ? data.feesMasterId.value
          : this.feesMasterId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      feesAmount:
          data.feesAmount.present ? data.feesAmount.value : this.feesAmount,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      remainedAmount: data.remainedAmount.present
          ? data.remainedAmount.value
          : this.remainedAmount,
      quaterAmount: data.quaterAmount.present
          ? data.quaterAmount.value
          : this.quaterAmount,
      quaterOne: data.quaterOne.present ? data.quaterOne.value : this.quaterOne,
      quaterTwo: data.quaterTwo.present ? data.quaterTwo.value : this.quaterTwo,
      quaterThree:
          data.quaterThree.present ? data.quaterThree.value : this.quaterThree,
      quaterFour:
          data.quaterFour.present ? data.quaterFour.value : this.quaterFour,
      comment: data.comment.present ? data.comment.value : this.comment,
      outstandingbalance: data.outstandingbalance.present
          ? data.outstandingbalance.value
          : this.outstandingbalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeesAssignment(')
          ..write('id: $id, ')
          ..write('feesAssignId: $feesAssignId, ')
          ..write('feesMasterId: $feesMasterId, ')
          ..write('studentId: $studentId, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('feesAmount: $feesAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('quaterAmount: $quaterAmount, ')
          ..write('quaterOne: $quaterOne, ')
          ..write('quaterTwo: $quaterTwo, ')
          ..write('quaterThree: $quaterThree, ')
          ..write('quaterFour: $quaterFour, ')
          ..write('comment: $comment, ')
          ..write('outstandingbalance: $outstandingbalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      feesAssignId,
      feesMasterId,
      studentId,
      controlNumber,
      feesAmount,
      paidAmount,
      remainedAmount,
      quaterAmount,
      quaterOne,
      quaterTwo,
      quaterThree,
      quaterFour,
      comment,
      outstandingbalance,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeesAssignment &&
          other.id == this.id &&
          other.feesAssignId == this.feesAssignId &&
          other.feesMasterId == this.feesMasterId &&
          other.studentId == this.studentId &&
          other.controlNumber == this.controlNumber &&
          other.feesAmount == this.feesAmount &&
          other.paidAmount == this.paidAmount &&
          other.remainedAmount == this.remainedAmount &&
          other.quaterAmount == this.quaterAmount &&
          other.quaterOne == this.quaterOne &&
          other.quaterTwo == this.quaterTwo &&
          other.quaterThree == this.quaterThree &&
          other.quaterFour == this.quaterFour &&
          other.comment == this.comment &&
          other.outstandingbalance == this.outstandingbalance &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FeesAssignmentsCompanion extends UpdateCompanion<FeesAssignment> {
  final Value<int> id;
  final Value<int> feesAssignId;
  final Value<int> feesMasterId;
  final Value<int> studentId;
  final Value<String> controlNumber;
  final Value<String> feesAmount;
  final Value<String> paidAmount;
  final Value<String> remainedAmount;
  final Value<String?> quaterAmount;
  final Value<int?> quaterOne;
  final Value<int?> quaterTwo;
  final Value<int?> quaterThree;
  final Value<int?> quaterFour;
  final Value<String?> comment;
  final Value<String?> outstandingbalance;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FeesAssignmentsCompanion({
    this.id = const Value.absent(),
    this.feesAssignId = const Value.absent(),
    this.feesMasterId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.feesAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.quaterAmount = const Value.absent(),
    this.quaterOne = const Value.absent(),
    this.quaterTwo = const Value.absent(),
    this.quaterThree = const Value.absent(),
    this.quaterFour = const Value.absent(),
    this.comment = const Value.absent(),
    this.outstandingbalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FeesAssignmentsCompanion.insert({
    this.id = const Value.absent(),
    required int feesAssignId,
    required int feesMasterId,
    required int studentId,
    required String controlNumber,
    this.feesAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.quaterAmount = const Value.absent(),
    this.quaterOne = const Value.absent(),
    this.quaterTwo = const Value.absent(),
    this.quaterThree = const Value.absent(),
    this.quaterFour = const Value.absent(),
    this.comment = const Value.absent(),
    this.outstandingbalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : feesAssignId = Value(feesAssignId),
        feesMasterId = Value(feesMasterId),
        studentId = Value(studentId),
        controlNumber = Value(controlNumber);
  static Insertable<FeesAssignment> custom({
    Expression<int>? id,
    Expression<int>? feesAssignId,
    Expression<int>? feesMasterId,
    Expression<int>? studentId,
    Expression<String>? controlNumber,
    Expression<String>? feesAmount,
    Expression<String>? paidAmount,
    Expression<String>? remainedAmount,
    Expression<String>? quaterAmount,
    Expression<int>? quaterOne,
    Expression<int>? quaterTwo,
    Expression<int>? quaterThree,
    Expression<int>? quaterFour,
    Expression<String>? comment,
    Expression<String>? outstandingbalance,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feesAssignId != null) 'fees_assign_id': feesAssignId,
      if (feesMasterId != null) 'fees_master_id': feesMasterId,
      if (studentId != null) 'student_id': studentId,
      if (controlNumber != null) 'control_number': controlNumber,
      if (feesAmount != null) 'fees_amount': feesAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainedAmount != null) 'remained_amount': remainedAmount,
      if (quaterAmount != null) 'quater_amount': quaterAmount,
      if (quaterOne != null) 'quater_one': quaterOne,
      if (quaterTwo != null) 'quater_two': quaterTwo,
      if (quaterThree != null) 'quater_three': quaterThree,
      if (quaterFour != null) 'quater_four': quaterFour,
      if (comment != null) 'comment': comment,
      if (outstandingbalance != null) 'outstandingbalance': outstandingbalance,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FeesAssignmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? feesAssignId,
      Value<int>? feesMasterId,
      Value<int>? studentId,
      Value<String>? controlNumber,
      Value<String>? feesAmount,
      Value<String>? paidAmount,
      Value<String>? remainedAmount,
      Value<String?>? quaterAmount,
      Value<int?>? quaterOne,
      Value<int?>? quaterTwo,
      Value<int?>? quaterThree,
      Value<int?>? quaterFour,
      Value<String?>? comment,
      Value<String?>? outstandingbalance,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return FeesAssignmentsCompanion(
      id: id ?? this.id,
      feesAssignId: feesAssignId ?? this.feesAssignId,
      feesMasterId: feesMasterId ?? this.feesMasterId,
      studentId: studentId ?? this.studentId,
      controlNumber: controlNumber ?? this.controlNumber,
      feesAmount: feesAmount ?? this.feesAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainedAmount: remainedAmount ?? this.remainedAmount,
      quaterAmount: quaterAmount ?? this.quaterAmount,
      quaterOne: quaterOne ?? this.quaterOne,
      quaterTwo: quaterTwo ?? this.quaterTwo,
      quaterThree: quaterThree ?? this.quaterThree,
      quaterFour: quaterFour ?? this.quaterFour,
      comment: comment ?? this.comment,
      outstandingbalance: outstandingbalance ?? this.outstandingbalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feesAssignId.present) {
      map['fees_assign_id'] = Variable<int>(feesAssignId.value);
    }
    if (feesMasterId.present) {
      map['fees_master_id'] = Variable<int>(feesMasterId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (feesAmount.present) {
      map['fees_amount'] = Variable<String>(feesAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<String>(paidAmount.value);
    }
    if (remainedAmount.present) {
      map['remained_amount'] = Variable<String>(remainedAmount.value);
    }
    if (quaterAmount.present) {
      map['quater_amount'] = Variable<String>(quaterAmount.value);
    }
    if (quaterOne.present) {
      map['quater_one'] = Variable<int>(quaterOne.value);
    }
    if (quaterTwo.present) {
      map['quater_two'] = Variable<int>(quaterTwo.value);
    }
    if (quaterThree.present) {
      map['quater_three'] = Variable<int>(quaterThree.value);
    }
    if (quaterFour.present) {
      map['quater_four'] = Variable<int>(quaterFour.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (outstandingbalance.present) {
      map['outstandingbalance'] = Variable<String>(outstandingbalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeesAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('feesAssignId: $feesAssignId, ')
          ..write('feesMasterId: $feesMasterId, ')
          ..write('studentId: $studentId, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('feesAmount: $feesAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('quaterAmount: $quaterAmount, ')
          ..write('quaterOne: $quaterOne, ')
          ..write('quaterTwo: $quaterTwo, ')
          ..write('quaterThree: $quaterThree, ')
          ..write('quaterFour: $quaterFour, ')
          ..write('comment: $comment, ')
          ..write('outstandingbalance: $outstandingbalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FeesAssignChildrenTable extends FeesAssignChildren
    with TableInfo<$FeesAssignChildrenTable, FeesAssignChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeesAssignChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _feesAssignIdMeta =
      const VerificationMeta('feesAssignId');
  @override
  late final GeneratedColumn<int> feesAssignId = GeneratedColumn<int>(
      'fees_assign_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _feesMasterIdMeta =
      const VerificationMeta('feesMasterId');
  @override
  late final GeneratedColumn<int> feesMasterId = GeneratedColumn<int>(
      'fees_master_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _feesAmountMeta =
      const VerificationMeta('feesAmount');
  @override
  late final GeneratedColumn<String> feesAmount = GeneratedColumn<String>(
      'fees_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<String> paidAmount = GeneratedColumn<String>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _remainedAmountMeta =
      const VerificationMeta('remainedAmount');
  @override
  late final GeneratedColumn<String> remainedAmount = GeneratedColumn<String>(
      'remained_amount', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _quaterAmountMeta =
      const VerificationMeta('quaterAmount');
  @override
  late final GeneratedColumn<String> quaterAmount = GeneratedColumn<String>(
      'quater_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quaterOneMeta =
      const VerificationMeta('quaterOne');
  @override
  late final GeneratedColumn<int> quaterOne = GeneratedColumn<int>(
      'quater_one', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterTwoMeta =
      const VerificationMeta('quaterTwo');
  @override
  late final GeneratedColumn<int> quaterTwo = GeneratedColumn<int>(
      'quater_two', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterThreeMeta =
      const VerificationMeta('quaterThree');
  @override
  late final GeneratedColumn<int> quaterThree = GeneratedColumn<int>(
      'quater_three', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quaterFourMeta =
      const VerificationMeta('quaterFour');
  @override
  late final GeneratedColumn<int> quaterFour = GeneratedColumn<int>(
      'quater_four', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outstandingbalanceMeta =
      const VerificationMeta('outstandingbalance');
  @override
  late final GeneratedColumn<String> outstandingbalance =
      GeneratedColumn<String>('outstandingbalance', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        feesAssignId,
        feesMasterId,
        studentId,
        controlNumber,
        feesAmount,
        paidAmount,
        remainedAmount,
        quaterAmount,
        quaterOne,
        quaterTwo,
        quaterThree,
        quaterFour,
        comment,
        outstandingbalance,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fees_assign_children';
  @override
  VerificationContext validateIntegrity(
      Insertable<FeesAssignChildrenData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fees_assign_id')) {
      context.handle(
          _feesAssignIdMeta,
          feesAssignId.isAcceptableOrUnknown(
              data['fees_assign_id']!, _feesAssignIdMeta));
    } else if (isInserting) {
      context.missing(_feesAssignIdMeta);
    }
    if (data.containsKey('fees_master_id')) {
      context.handle(
          _feesMasterIdMeta,
          feesMasterId.isAcceptableOrUnknown(
              data['fees_master_id']!, _feesMasterIdMeta));
    } else if (isInserting) {
      context.missing(_feesMasterIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    } else if (isInserting) {
      context.missing(_controlNumberMeta);
    }
    if (data.containsKey('fees_amount')) {
      context.handle(
          _feesAmountMeta,
          feesAmount.isAcceptableOrUnknown(
              data['fees_amount']!, _feesAmountMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('remained_amount')) {
      context.handle(
          _remainedAmountMeta,
          remainedAmount.isAcceptableOrUnknown(
              data['remained_amount']!, _remainedAmountMeta));
    }
    if (data.containsKey('quater_amount')) {
      context.handle(
          _quaterAmountMeta,
          quaterAmount.isAcceptableOrUnknown(
              data['quater_amount']!, _quaterAmountMeta));
    }
    if (data.containsKey('quater_one')) {
      context.handle(_quaterOneMeta,
          quaterOne.isAcceptableOrUnknown(data['quater_one']!, _quaterOneMeta));
    }
    if (data.containsKey('quater_two')) {
      context.handle(_quaterTwoMeta,
          quaterTwo.isAcceptableOrUnknown(data['quater_two']!, _quaterTwoMeta));
    }
    if (data.containsKey('quater_three')) {
      context.handle(
          _quaterThreeMeta,
          quaterThree.isAcceptableOrUnknown(
              data['quater_three']!, _quaterThreeMeta));
    }
    if (data.containsKey('quater_four')) {
      context.handle(
          _quaterFourMeta,
          quaterFour.isAcceptableOrUnknown(
              data['quater_four']!, _quaterFourMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('outstandingbalance')) {
      context.handle(
          _outstandingbalanceMeta,
          outstandingbalance.isAcceptableOrUnknown(
              data['outstandingbalance']!, _outstandingbalanceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeesAssignChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeesAssignChildrenData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      feesAssignId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fees_assign_id'])!,
      feesMasterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fees_master_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number'])!,
      feesAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fees_amount'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paid_amount'])!,
      remainedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remained_amount'])!,
      quaterAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quater_amount']),
      quaterOne: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_one']),
      quaterTwo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_two']),
      quaterThree: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_three']),
      quaterFour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quater_four']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      outstandingbalance: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}outstandingbalance']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FeesAssignChildrenTable createAlias(String alias) {
    return $FeesAssignChildrenTable(attachedDatabase, alias);
  }
}

class FeesAssignChildrenData extends DataClass
    implements Insertable<FeesAssignChildrenData> {
  final int id;
  final int feesAssignId;
  final int feesMasterId;
  final int studentId;
  final String controlNumber;
  final String feesAmount;
  final String paidAmount;
  final String remainedAmount;
  final String? quaterAmount;
  final int? quaterOne;
  final int? quaterTwo;
  final int? quaterThree;
  final int? quaterFour;
  final String? comment;
  final String? outstandingbalance;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FeesAssignChildrenData(
      {required this.id,
      required this.feesAssignId,
      required this.feesMasterId,
      required this.studentId,
      required this.controlNumber,
      required this.feesAmount,
      required this.paidAmount,
      required this.remainedAmount,
      this.quaterAmount,
      this.quaterOne,
      this.quaterTwo,
      this.quaterThree,
      this.quaterFour,
      this.comment,
      this.outstandingbalance,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fees_assign_id'] = Variable<int>(feesAssignId);
    map['fees_master_id'] = Variable<int>(feesMasterId);
    map['student_id'] = Variable<int>(studentId);
    map['control_number'] = Variable<String>(controlNumber);
    map['fees_amount'] = Variable<String>(feesAmount);
    map['paid_amount'] = Variable<String>(paidAmount);
    map['remained_amount'] = Variable<String>(remainedAmount);
    if (!nullToAbsent || quaterAmount != null) {
      map['quater_amount'] = Variable<String>(quaterAmount);
    }
    if (!nullToAbsent || quaterOne != null) {
      map['quater_one'] = Variable<int>(quaterOne);
    }
    if (!nullToAbsent || quaterTwo != null) {
      map['quater_two'] = Variable<int>(quaterTwo);
    }
    if (!nullToAbsent || quaterThree != null) {
      map['quater_three'] = Variable<int>(quaterThree);
    }
    if (!nullToAbsent || quaterFour != null) {
      map['quater_four'] = Variable<int>(quaterFour);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || outstandingbalance != null) {
      map['outstandingbalance'] = Variable<String>(outstandingbalance);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FeesAssignChildrenCompanion toCompanion(bool nullToAbsent) {
    return FeesAssignChildrenCompanion(
      id: Value(id),
      feesAssignId: Value(feesAssignId),
      feesMasterId: Value(feesMasterId),
      studentId: Value(studentId),
      controlNumber: Value(controlNumber),
      feesAmount: Value(feesAmount),
      paidAmount: Value(paidAmount),
      remainedAmount: Value(remainedAmount),
      quaterAmount: quaterAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterAmount),
      quaterOne: quaterOne == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterOne),
      quaterTwo: quaterTwo == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterTwo),
      quaterThree: quaterThree == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterThree),
      quaterFour: quaterFour == null && nullToAbsent
          ? const Value.absent()
          : Value(quaterFour),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      outstandingbalance: outstandingbalance == null && nullToAbsent
          ? const Value.absent()
          : Value(outstandingbalance),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeesAssignChildrenData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeesAssignChildrenData(
      id: serializer.fromJson<int>(json['id']),
      feesAssignId: serializer.fromJson<int>(json['feesAssignId']),
      feesMasterId: serializer.fromJson<int>(json['feesMasterId']),
      studentId: serializer.fromJson<int>(json['studentId']),
      controlNumber: serializer.fromJson<String>(json['controlNumber']),
      feesAmount: serializer.fromJson<String>(json['feesAmount']),
      paidAmount: serializer.fromJson<String>(json['paidAmount']),
      remainedAmount: serializer.fromJson<String>(json['remainedAmount']),
      quaterAmount: serializer.fromJson<String?>(json['quaterAmount']),
      quaterOne: serializer.fromJson<int?>(json['quaterOne']),
      quaterTwo: serializer.fromJson<int?>(json['quaterTwo']),
      quaterThree: serializer.fromJson<int?>(json['quaterThree']),
      quaterFour: serializer.fromJson<int?>(json['quaterFour']),
      comment: serializer.fromJson<String?>(json['comment']),
      outstandingbalance:
          serializer.fromJson<String?>(json['outstandingbalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feesAssignId': serializer.toJson<int>(feesAssignId),
      'feesMasterId': serializer.toJson<int>(feesMasterId),
      'studentId': serializer.toJson<int>(studentId),
      'controlNumber': serializer.toJson<String>(controlNumber),
      'feesAmount': serializer.toJson<String>(feesAmount),
      'paidAmount': serializer.toJson<String>(paidAmount),
      'remainedAmount': serializer.toJson<String>(remainedAmount),
      'quaterAmount': serializer.toJson<String?>(quaterAmount),
      'quaterOne': serializer.toJson<int?>(quaterOne),
      'quaterTwo': serializer.toJson<int?>(quaterTwo),
      'quaterThree': serializer.toJson<int?>(quaterThree),
      'quaterFour': serializer.toJson<int?>(quaterFour),
      'comment': serializer.toJson<String?>(comment),
      'outstandingbalance': serializer.toJson<String?>(outstandingbalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FeesAssignChildrenData copyWith(
          {int? id,
          int? feesAssignId,
          int? feesMasterId,
          int? studentId,
          String? controlNumber,
          String? feesAmount,
          String? paidAmount,
          String? remainedAmount,
          Value<String?> quaterAmount = const Value.absent(),
          Value<int?> quaterOne = const Value.absent(),
          Value<int?> quaterTwo = const Value.absent(),
          Value<int?> quaterThree = const Value.absent(),
          Value<int?> quaterFour = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          Value<String?> outstandingbalance = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FeesAssignChildrenData(
        id: id ?? this.id,
        feesAssignId: feesAssignId ?? this.feesAssignId,
        feesMasterId: feesMasterId ?? this.feesMasterId,
        studentId: studentId ?? this.studentId,
        controlNumber: controlNumber ?? this.controlNumber,
        feesAmount: feesAmount ?? this.feesAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        remainedAmount: remainedAmount ?? this.remainedAmount,
        quaterAmount:
            quaterAmount.present ? quaterAmount.value : this.quaterAmount,
        quaterOne: quaterOne.present ? quaterOne.value : this.quaterOne,
        quaterTwo: quaterTwo.present ? quaterTwo.value : this.quaterTwo,
        quaterThree: quaterThree.present ? quaterThree.value : this.quaterThree,
        quaterFour: quaterFour.present ? quaterFour.value : this.quaterFour,
        comment: comment.present ? comment.value : this.comment,
        outstandingbalance: outstandingbalance.present
            ? outstandingbalance.value
            : this.outstandingbalance,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FeesAssignChildrenData copyWithCompanion(FeesAssignChildrenCompanion data) {
    return FeesAssignChildrenData(
      id: data.id.present ? data.id.value : this.id,
      feesAssignId: data.feesAssignId.present
          ? data.feesAssignId.value
          : this.feesAssignId,
      feesMasterId: data.feesMasterId.present
          ? data.feesMasterId.value
          : this.feesMasterId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      feesAmount:
          data.feesAmount.present ? data.feesAmount.value : this.feesAmount,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      remainedAmount: data.remainedAmount.present
          ? data.remainedAmount.value
          : this.remainedAmount,
      quaterAmount: data.quaterAmount.present
          ? data.quaterAmount.value
          : this.quaterAmount,
      quaterOne: data.quaterOne.present ? data.quaterOne.value : this.quaterOne,
      quaterTwo: data.quaterTwo.present ? data.quaterTwo.value : this.quaterTwo,
      quaterThree:
          data.quaterThree.present ? data.quaterThree.value : this.quaterThree,
      quaterFour:
          data.quaterFour.present ? data.quaterFour.value : this.quaterFour,
      comment: data.comment.present ? data.comment.value : this.comment,
      outstandingbalance: data.outstandingbalance.present
          ? data.outstandingbalance.value
          : this.outstandingbalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeesAssignChildrenData(')
          ..write('id: $id, ')
          ..write('feesAssignId: $feesAssignId, ')
          ..write('feesMasterId: $feesMasterId, ')
          ..write('studentId: $studentId, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('feesAmount: $feesAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('quaterAmount: $quaterAmount, ')
          ..write('quaterOne: $quaterOne, ')
          ..write('quaterTwo: $quaterTwo, ')
          ..write('quaterThree: $quaterThree, ')
          ..write('quaterFour: $quaterFour, ')
          ..write('comment: $comment, ')
          ..write('outstandingbalance: $outstandingbalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      feesAssignId,
      feesMasterId,
      studentId,
      controlNumber,
      feesAmount,
      paidAmount,
      remainedAmount,
      quaterAmount,
      quaterOne,
      quaterTwo,
      quaterThree,
      quaterFour,
      comment,
      outstandingbalance,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeesAssignChildrenData &&
          other.id == this.id &&
          other.feesAssignId == this.feesAssignId &&
          other.feesMasterId == this.feesMasterId &&
          other.studentId == this.studentId &&
          other.controlNumber == this.controlNumber &&
          other.feesAmount == this.feesAmount &&
          other.paidAmount == this.paidAmount &&
          other.remainedAmount == this.remainedAmount &&
          other.quaterAmount == this.quaterAmount &&
          other.quaterOne == this.quaterOne &&
          other.quaterTwo == this.quaterTwo &&
          other.quaterThree == this.quaterThree &&
          other.quaterFour == this.quaterFour &&
          other.comment == this.comment &&
          other.outstandingbalance == this.outstandingbalance &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FeesAssignChildrenCompanion
    extends UpdateCompanion<FeesAssignChildrenData> {
  final Value<int> id;
  final Value<int> feesAssignId;
  final Value<int> feesMasterId;
  final Value<int> studentId;
  final Value<String> controlNumber;
  final Value<String> feesAmount;
  final Value<String> paidAmount;
  final Value<String> remainedAmount;
  final Value<String?> quaterAmount;
  final Value<int?> quaterOne;
  final Value<int?> quaterTwo;
  final Value<int?> quaterThree;
  final Value<int?> quaterFour;
  final Value<String?> comment;
  final Value<String?> outstandingbalance;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FeesAssignChildrenCompanion({
    this.id = const Value.absent(),
    this.feesAssignId = const Value.absent(),
    this.feesMasterId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.feesAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.quaterAmount = const Value.absent(),
    this.quaterOne = const Value.absent(),
    this.quaterTwo = const Value.absent(),
    this.quaterThree = const Value.absent(),
    this.quaterFour = const Value.absent(),
    this.comment = const Value.absent(),
    this.outstandingbalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FeesAssignChildrenCompanion.insert({
    this.id = const Value.absent(),
    required int feesAssignId,
    required int feesMasterId,
    required int studentId,
    required String controlNumber,
    this.feesAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.quaterAmount = const Value.absent(),
    this.quaterOne = const Value.absent(),
    this.quaterTwo = const Value.absent(),
    this.quaterThree = const Value.absent(),
    this.quaterFour = const Value.absent(),
    this.comment = const Value.absent(),
    this.outstandingbalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : feesAssignId = Value(feesAssignId),
        feesMasterId = Value(feesMasterId),
        studentId = Value(studentId),
        controlNumber = Value(controlNumber);
  static Insertable<FeesAssignChildrenData> custom({
    Expression<int>? id,
    Expression<int>? feesAssignId,
    Expression<int>? feesMasterId,
    Expression<int>? studentId,
    Expression<String>? controlNumber,
    Expression<String>? feesAmount,
    Expression<String>? paidAmount,
    Expression<String>? remainedAmount,
    Expression<String>? quaterAmount,
    Expression<int>? quaterOne,
    Expression<int>? quaterTwo,
    Expression<int>? quaterThree,
    Expression<int>? quaterFour,
    Expression<String>? comment,
    Expression<String>? outstandingbalance,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feesAssignId != null) 'fees_assign_id': feesAssignId,
      if (feesMasterId != null) 'fees_master_id': feesMasterId,
      if (studentId != null) 'student_id': studentId,
      if (controlNumber != null) 'control_number': controlNumber,
      if (feesAmount != null) 'fees_amount': feesAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainedAmount != null) 'remained_amount': remainedAmount,
      if (quaterAmount != null) 'quater_amount': quaterAmount,
      if (quaterOne != null) 'quater_one': quaterOne,
      if (quaterTwo != null) 'quater_two': quaterTwo,
      if (quaterThree != null) 'quater_three': quaterThree,
      if (quaterFour != null) 'quater_four': quaterFour,
      if (comment != null) 'comment': comment,
      if (outstandingbalance != null) 'outstandingbalance': outstandingbalance,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FeesAssignChildrenCompanion copyWith(
      {Value<int>? id,
      Value<int>? feesAssignId,
      Value<int>? feesMasterId,
      Value<int>? studentId,
      Value<String>? controlNumber,
      Value<String>? feesAmount,
      Value<String>? paidAmount,
      Value<String>? remainedAmount,
      Value<String?>? quaterAmount,
      Value<int?>? quaterOne,
      Value<int?>? quaterTwo,
      Value<int?>? quaterThree,
      Value<int?>? quaterFour,
      Value<String?>? comment,
      Value<String?>? outstandingbalance,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return FeesAssignChildrenCompanion(
      id: id ?? this.id,
      feesAssignId: feesAssignId ?? this.feesAssignId,
      feesMasterId: feesMasterId ?? this.feesMasterId,
      studentId: studentId ?? this.studentId,
      controlNumber: controlNumber ?? this.controlNumber,
      feesAmount: feesAmount ?? this.feesAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainedAmount: remainedAmount ?? this.remainedAmount,
      quaterAmount: quaterAmount ?? this.quaterAmount,
      quaterOne: quaterOne ?? this.quaterOne,
      quaterTwo: quaterTwo ?? this.quaterTwo,
      quaterThree: quaterThree ?? this.quaterThree,
      quaterFour: quaterFour ?? this.quaterFour,
      comment: comment ?? this.comment,
      outstandingbalance: outstandingbalance ?? this.outstandingbalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feesAssignId.present) {
      map['fees_assign_id'] = Variable<int>(feesAssignId.value);
    }
    if (feesMasterId.present) {
      map['fees_master_id'] = Variable<int>(feesMasterId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (feesAmount.present) {
      map['fees_amount'] = Variable<String>(feesAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<String>(paidAmount.value);
    }
    if (remainedAmount.present) {
      map['remained_amount'] = Variable<String>(remainedAmount.value);
    }
    if (quaterAmount.present) {
      map['quater_amount'] = Variable<String>(quaterAmount.value);
    }
    if (quaterOne.present) {
      map['quater_one'] = Variable<int>(quaterOne.value);
    }
    if (quaterTwo.present) {
      map['quater_two'] = Variable<int>(quaterTwo.value);
    }
    if (quaterThree.present) {
      map['quater_three'] = Variable<int>(quaterThree.value);
    }
    if (quaterFour.present) {
      map['quater_four'] = Variable<int>(quaterFour.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (outstandingbalance.present) {
      map['outstandingbalance'] = Variable<String>(outstandingbalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeesAssignChildrenCompanion(')
          ..write('id: $id, ')
          ..write('feesAssignId: $feesAssignId, ')
          ..write('feesMasterId: $feesMasterId, ')
          ..write('studentId: $studentId, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('feesAmount: $feesAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('quaterAmount: $quaterAmount, ')
          ..write('quaterOne: $quaterOne, ')
          ..write('quaterTwo: $quaterTwo, ')
          ..write('quaterThree: $quaterThree, ')
          ..write('quaterFour: $quaterFour, ')
          ..write('comment: $comment, ')
          ..write('outstandingbalance: $outstandingbalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExamTypesTable extends ExamTypes
    with TableInfo<$ExamTypesTable, ExamType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_types';
  @override
  VerificationContext validateIntegrity(Insertable<ExamType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ExamTypesTable createAlias(String alias) {
    return $ExamTypesTable(attachedDatabase, alias);
  }
}

class ExamType extends DataClass implements Insertable<ExamType> {
  final int id;
  final String? name;
  final String? type;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  const ExamType(
      {required this.id,
      this.name,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  ExamTypesCompanion toCompanion(bool nullToAbsent) {
    return ExamTypesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExamType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      status: serializer.fromJson<int?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<String?>(type),
      'status': serializer.toJson<int?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  ExamType copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<int?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      ExamType(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        type: type.present ? type.value : this.type,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ExamType copyWithCompanion(ExamTypesCompanion data) {
    return ExamType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamType &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExamTypesCompanion extends UpdateCompanion<ExamType> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> type;
  final Value<int?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const ExamTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExamTypesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<ExamType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExamTypesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? type,
      Value<int?>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return ExamTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ClassesTable extends Classes with TableInfo<$ClassesTable, ClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ordersMeta = const VerificationMeta('orders');
  @override
  late final GeneratedColumn<int> orders = GeneratedColumn<int>(
      'orders', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classTranMeta =
      const VerificationMeta('classTran');
  @override
  late final GeneratedColumn<String> classTran = GeneratedColumn<String>(
      'class_tran', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, status, orders, createdAt, updatedAt, classTran];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classes';
  @override
  VerificationContext validateIntegrity(Insertable<ClassesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('orders')) {
      context.handle(_ordersMeta,
          orders.isAcceptableOrUnknown(data['orders']!, _ordersMeta));
    } else if (isInserting) {
      context.missing(_ordersMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('class_tran')) {
      context.handle(_classTranMeta,
          classTran.isAcceptableOrUnknown(data['class_tran']!, _classTranMeta));
    } else if (isInserting) {
      context.missing(_classTranMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      orders: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orders'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      classTran: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_tran'])!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class ClassesData extends DataClass implements Insertable<ClassesData> {
  final int id;
  final String name;
  final int status;
  final int orders;
  final String createdAt;
  final String updatedAt;
  final String classTran;
  const ClassesData(
      {required this.id,
      required this.name,
      required this.status,
      required this.orders,
      required this.createdAt,
      required this.updatedAt,
      required this.classTran});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<int>(status);
    map['orders'] = Variable<int>(orders);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['class_tran'] = Variable<String>(classTran);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      orders: Value(orders),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      classTran: Value(classTran),
    );
  }

  factory ClassesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<int>(json['status']),
      orders: serializer.fromJson<int>(json['orders']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      classTran: serializer.fromJson<String>(json['classTran']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<int>(status),
      'orders': serializer.toJson<int>(orders),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'classTran': serializer.toJson<String>(classTran),
    };
  }

  ClassesData copyWith(
          {int? id,
          String? name,
          int? status,
          int? orders,
          String? createdAt,
          String? updatedAt,
          String? classTran}) =>
      ClassesData(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        orders: orders ?? this.orders,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        classTran: classTran ?? this.classTran,
      );
  ClassesData copyWithCompanion(ClassesCompanion data) {
    return ClassesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      orders: data.orders.present ? data.orders.value : this.orders,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      classTran: data.classTran.present ? data.classTran.value : this.classTran,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('orders: $orders, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('classTran: $classTran')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, status, orders, createdAt, updatedAt, classTran);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.orders == this.orders &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.classTran == this.classTran);
}

class ClassesCompanion extends UpdateCompanion<ClassesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> status;
  final Value<int> orders;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> classTran;
  const ClassesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.orders = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.classTran = const Value.absent(),
  });
  ClassesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int status,
    required int orders,
    required String createdAt,
    required String updatedAt,
    required String classTran,
  })  : name = Value(name),
        status = Value(status),
        orders = Value(orders),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        classTran = Value(classTran);
  static Insertable<ClassesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? status,
    Expression<int>? orders,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? classTran,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (orders != null) 'orders': orders,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (classTran != null) 'class_tran': classTran,
    });
  }

  ClassesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? status,
      Value<int>? orders,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? classTran}) {
    return ClassesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      orders: orders ?? this.orders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      classTran: classTran ?? this.classTran,
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
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (orders.present) {
      map['orders'] = Variable<int>(orders.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (classTran.present) {
      map['class_tran'] = Variable<String>(classTran.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('orders: $orders, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('classTran: $classTran')
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
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _msisdnMeta = const VerificationMeta('msisdn');
  @override
  late final GeneratedColumn<String> msisdn = GeneratedColumn<String>(
      'msisdn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mechantIdMeta =
      const VerificationMeta('mechantId');
  @override
  late final GeneratedColumn<int> mechantId = GeneratedColumn<int>(
      'mechant_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _settlementStatusMeta =
      const VerificationMeta('settlementStatus');
  @override
  late final GeneratedColumn<String> settlementStatus = GeneratedColumn<String>(
      'settlement_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chargeMeta = const VerificationMeta('charge');
  @override
  late final GeneratedColumn<String> charge = GeneratedColumn<String>(
      'charge', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receivingAccountIdMeta =
      const VerificationMeta('receivingAccountId');
  @override
  late final GeneratedColumn<String> receivingAccountId =
      GeneratedColumn<String>('receiving_account_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<String> totalAmount = GeneratedColumn<String>(
      'total_amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _settlementIdMeta =
      const VerificationMeta('settlementId');
  @override
  late final GeneratedColumn<String> settlementId = GeneratedColumn<String>(
      'settlement_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _settlementDateMeta =
      const VerificationMeta('settlementDate');
  @override
  late final GeneratedColumn<String> settlementDate = GeneratedColumn<String>(
      'settlement_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        msisdn,
        amount,
        reference,
        type,
        status,
        mechantId,
        settlementStatus,
        charge,
        receivingAccountId,
        totalAmount,
        settlementId,
        settlementDate,
        transactionId,
        createdAt,
        updatedAt,
        description
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('msisdn')) {
      context.handle(_msisdnMeta,
          msisdn.isAcceptableOrUnknown(data['msisdn']!, _msisdnMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('mechant_id')) {
      context.handle(_mechantIdMeta,
          mechantId.isAcceptableOrUnknown(data['mechant_id']!, _mechantIdMeta));
    }
    if (data.containsKey('settlement_status')) {
      context.handle(
          _settlementStatusMeta,
          settlementStatus.isAcceptableOrUnknown(
              data['settlement_status']!, _settlementStatusMeta));
    }
    if (data.containsKey('charge')) {
      context.handle(_chargeMeta,
          charge.isAcceptableOrUnknown(data['charge']!, _chargeMeta));
    }
    if (data.containsKey('receiving_account_id')) {
      context.handle(
          _receivingAccountIdMeta,
          receivingAccountId.isAcceptableOrUnknown(
              data['receiving_account_id']!, _receivingAccountIdMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('settlement_id')) {
      context.handle(
          _settlementIdMeta,
          settlementId.isAcceptableOrUnknown(
              data['settlement_id']!, _settlementIdMeta));
    }
    if (data.containsKey('settlement_date')) {
      context.handle(
          _settlementDateMeta,
          settlementDate.isAcceptableOrUnknown(
              data['settlement_date']!, _settlementDateMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      msisdn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}msisdn']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      mechantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mechant_id']),
      settlementStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}settlement_status']),
      charge: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}charge']),
      receivingAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receiving_account_id']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}total_amount']),
      settlementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settlement_id']),
      settlementDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settlement_date']),
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String? msisdn;
  final double? amount;
  final String? reference;
  final String? type;
  final String? status;
  final int? mechantId;
  final String? settlementStatus;
  final String? charge;
  final String? receivingAccountId;
  final String? totalAmount;
  final String? settlementId;
  final String? settlementDate;
  final String? transactionId;
  final String? createdAt;
  final String? updatedAt;
  final String? description;
  const Transaction(
      {required this.id,
      this.msisdn,
      this.amount,
      this.reference,
      this.type,
      this.status,
      this.mechantId,
      this.settlementStatus,
      this.charge,
      this.receivingAccountId,
      this.totalAmount,
      this.settlementId,
      this.settlementDate,
      this.transactionId,
      this.createdAt,
      this.updatedAt,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || msisdn != null) {
      map['msisdn'] = Variable<String>(msisdn);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || mechantId != null) {
      map['mechant_id'] = Variable<int>(mechantId);
    }
    if (!nullToAbsent || settlementStatus != null) {
      map['settlement_status'] = Variable<String>(settlementStatus);
    }
    if (!nullToAbsent || charge != null) {
      map['charge'] = Variable<String>(charge);
    }
    if (!nullToAbsent || receivingAccountId != null) {
      map['receiving_account_id'] = Variable<String>(receivingAccountId);
    }
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<String>(totalAmount);
    }
    if (!nullToAbsent || settlementId != null) {
      map['settlement_id'] = Variable<String>(settlementId);
    }
    if (!nullToAbsent || settlementDate != null) {
      map['settlement_date'] = Variable<String>(settlementDate);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      msisdn:
          msisdn == null && nullToAbsent ? const Value.absent() : Value(msisdn),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      mechantId: mechantId == null && nullToAbsent
          ? const Value.absent()
          : Value(mechantId),
      settlementStatus: settlementStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(settlementStatus),
      charge:
          charge == null && nullToAbsent ? const Value.absent() : Value(charge),
      receivingAccountId: receivingAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(receivingAccountId),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      settlementId: settlementId == null && nullToAbsent
          ? const Value.absent()
          : Value(settlementId),
      settlementDate: settlementDate == null && nullToAbsent
          ? const Value.absent()
          : Value(settlementDate),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      msisdn: serializer.fromJson<String?>(json['msisdn']),
      amount: serializer.fromJson<double?>(json['amount']),
      reference: serializer.fromJson<String?>(json['reference']),
      type: serializer.fromJson<String?>(json['type']),
      status: serializer.fromJson<String?>(json['status']),
      mechantId: serializer.fromJson<int?>(json['mechantId']),
      settlementStatus: serializer.fromJson<String?>(json['settlementStatus']),
      charge: serializer.fromJson<String?>(json['charge']),
      receivingAccountId:
          serializer.fromJson<String?>(json['receivingAccountId']),
      totalAmount: serializer.fromJson<String?>(json['totalAmount']),
      settlementId: serializer.fromJson<String?>(json['settlementId']),
      settlementDate: serializer.fromJson<String?>(json['settlementDate']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'msisdn': serializer.toJson<String?>(msisdn),
      'amount': serializer.toJson<double?>(amount),
      'reference': serializer.toJson<String?>(reference),
      'type': serializer.toJson<String?>(type),
      'status': serializer.toJson<String?>(status),
      'mechantId': serializer.toJson<int?>(mechantId),
      'settlementStatus': serializer.toJson<String?>(settlementStatus),
      'charge': serializer.toJson<String?>(charge),
      'receivingAccountId': serializer.toJson<String?>(receivingAccountId),
      'totalAmount': serializer.toJson<String?>(totalAmount),
      'settlementId': serializer.toJson<String?>(settlementId),
      'settlementDate': serializer.toJson<String?>(settlementDate),
      'transactionId': serializer.toJson<String?>(transactionId),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'description': serializer.toJson<String?>(description),
    };
  }

  Transaction copyWith(
          {int? id,
          Value<String?> msisdn = const Value.absent(),
          Value<double?> amount = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<int?> mechantId = const Value.absent(),
          Value<String?> settlementStatus = const Value.absent(),
          Value<String?> charge = const Value.absent(),
          Value<String?> receivingAccountId = const Value.absent(),
          Value<String?> totalAmount = const Value.absent(),
          Value<String?> settlementId = const Value.absent(),
          Value<String?> settlementDate = const Value.absent(),
          Value<String?> transactionId = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> description = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        msisdn: msisdn.present ? msisdn.value : this.msisdn,
        amount: amount.present ? amount.value : this.amount,
        reference: reference.present ? reference.value : this.reference,
        type: type.present ? type.value : this.type,
        status: status.present ? status.value : this.status,
        mechantId: mechantId.present ? mechantId.value : this.mechantId,
        settlementStatus: settlementStatus.present
            ? settlementStatus.value
            : this.settlementStatus,
        charge: charge.present ? charge.value : this.charge,
        receivingAccountId: receivingAccountId.present
            ? receivingAccountId.value
            : this.receivingAccountId,
        totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
        settlementId:
            settlementId.present ? settlementId.value : this.settlementId,
        settlementDate:
            settlementDate.present ? settlementDate.value : this.settlementDate,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        description: description.present ? description.value : this.description,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      msisdn: data.msisdn.present ? data.msisdn.value : this.msisdn,
      amount: data.amount.present ? data.amount.value : this.amount,
      reference: data.reference.present ? data.reference.value : this.reference,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      mechantId: data.mechantId.present ? data.mechantId.value : this.mechantId,
      settlementStatus: data.settlementStatus.present
          ? data.settlementStatus.value
          : this.settlementStatus,
      charge: data.charge.present ? data.charge.value : this.charge,
      receivingAccountId: data.receivingAccountId.present
          ? data.receivingAccountId.value
          : this.receivingAccountId,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      settlementId: data.settlementId.present
          ? data.settlementId.value
          : this.settlementId,
      settlementDate: data.settlementDate.present
          ? data.settlementDate.value
          : this.settlementDate,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('msisdn: $msisdn, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('mechantId: $mechantId, ')
          ..write('settlementStatus: $settlementStatus, ')
          ..write('charge: $charge, ')
          ..write('receivingAccountId: $receivingAccountId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('settlementId: $settlementId, ')
          ..write('settlementDate: $settlementDate, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      msisdn,
      amount,
      reference,
      type,
      status,
      mechantId,
      settlementStatus,
      charge,
      receivingAccountId,
      totalAmount,
      settlementId,
      settlementDate,
      transactionId,
      createdAt,
      updatedAt,
      description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.msisdn == this.msisdn &&
          other.amount == this.amount &&
          other.reference == this.reference &&
          other.type == this.type &&
          other.status == this.status &&
          other.mechantId == this.mechantId &&
          other.settlementStatus == this.settlementStatus &&
          other.charge == this.charge &&
          other.receivingAccountId == this.receivingAccountId &&
          other.totalAmount == this.totalAmount &&
          other.settlementId == this.settlementId &&
          other.settlementDate == this.settlementDate &&
          other.transactionId == this.transactionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.description == this.description);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String?> msisdn;
  final Value<double?> amount;
  final Value<String?> reference;
  final Value<String?> type;
  final Value<String?> status;
  final Value<int?> mechantId;
  final Value<String?> settlementStatus;
  final Value<String?> charge;
  final Value<String?> receivingAccountId;
  final Value<String?> totalAmount;
  final Value<String?> settlementId;
  final Value<String?> settlementDate;
  final Value<String?> transactionId;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String?> description;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.msisdn = const Value.absent(),
    this.amount = const Value.absent(),
    this.reference = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.settlementStatus = const Value.absent(),
    this.charge = const Value.absent(),
    this.receivingAccountId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.settlementId = const Value.absent(),
    this.settlementDate = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.description = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.msisdn = const Value.absent(),
    this.amount = const Value.absent(),
    this.reference = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.mechantId = const Value.absent(),
    this.settlementStatus = const Value.absent(),
    this.charge = const Value.absent(),
    this.receivingAccountId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.settlementId = const Value.absent(),
    this.settlementDate = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.description = const Value.absent(),
  });
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? msisdn,
    Expression<double>? amount,
    Expression<String>? reference,
    Expression<String>? type,
    Expression<String>? status,
    Expression<int>? mechantId,
    Expression<String>? settlementStatus,
    Expression<String>? charge,
    Expression<String>? receivingAccountId,
    Expression<String>? totalAmount,
    Expression<String>? settlementId,
    Expression<String>? settlementDate,
    Expression<String>? transactionId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (msisdn != null) 'msisdn': msisdn,
      if (amount != null) 'amount': amount,
      if (reference != null) 'reference': reference,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (mechantId != null) 'mechant_id': mechantId,
      if (settlementStatus != null) 'settlement_status': settlementStatus,
      if (charge != null) 'charge': charge,
      if (receivingAccountId != null)
        'receiving_account_id': receivingAccountId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (settlementId != null) 'settlement_id': settlementId,
      if (settlementDate != null) 'settlement_date': settlementDate,
      if (transactionId != null) 'transaction_id': transactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (description != null) 'description': description,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? msisdn,
      Value<double?>? amount,
      Value<String?>? reference,
      Value<String?>? type,
      Value<String?>? status,
      Value<int?>? mechantId,
      Value<String?>? settlementStatus,
      Value<String?>? charge,
      Value<String?>? receivingAccountId,
      Value<String?>? totalAmount,
      Value<String?>? settlementId,
      Value<String?>? settlementDate,
      Value<String?>? transactionId,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? description}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      msisdn: msisdn ?? this.msisdn,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      type: type ?? this.type,
      status: status ?? this.status,
      mechantId: mechantId ?? this.mechantId,
      settlementStatus: settlementStatus ?? this.settlementStatus,
      charge: charge ?? this.charge,
      receivingAccountId: receivingAccountId ?? this.receivingAccountId,
      totalAmount: totalAmount ?? this.totalAmount,
      settlementId: settlementId ?? this.settlementId,
      settlementDate: settlementDate ?? this.settlementDate,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (msisdn.present) {
      map['msisdn'] = Variable<String>(msisdn.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (mechantId.present) {
      map['mechant_id'] = Variable<int>(mechantId.value);
    }
    if (settlementStatus.present) {
      map['settlement_status'] = Variable<String>(settlementStatus.value);
    }
    if (charge.present) {
      map['charge'] = Variable<String>(charge.value);
    }
    if (receivingAccountId.present) {
      map['receiving_account_id'] = Variable<String>(receivingAccountId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<String>(totalAmount.value);
    }
    if (settlementId.present) {
      map['settlement_id'] = Variable<String>(settlementId.value);
    }
    if (settlementDate.present) {
      map['settlement_date'] = Variable<String>(settlementDate.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('msisdn: $msisdn, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('mechantId: $mechantId, ')
          ..write('settlementStatus: $settlementStatus, ')
          ..write('charge: $charge, ')
          ..write('receivingAccountId: $receivingAccountId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('settlementId: $settlementId, ')
          ..write('settlementDate: $settlementDate, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $BankAccountsTable extends BankAccounts
    with TableInfo<$BankAccountsTable, BankAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountNameMeta =
      const VerificationMeta('accountName');
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
      'account_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountNumberMeta =
      const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
      'account_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bankName,
        accountName,
        accountNumber,
        accountType,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<BankAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
          _accountNameMeta,
          accountName.isAcceptableOrUnknown(
              data['account_name']!, _accountNameMeta));
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('account_number')) {
      context.handle(
          _accountNumberMeta,
          accountNumber.isAcceptableOrUnknown(
              data['account_number']!, _accountNumberMeta));
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name'])!,
      accountName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_name'])!,
      accountNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_number'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $BankAccountsTable createAlias(String alias) {
    return $BankAccountsTable(attachedDatabase, alias);
  }
}

class BankAccount extends DataClass implements Insertable<BankAccount> {
  final int id;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String? accountType;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  const BankAccount(
      {required this.id,
      required this.bankName,
      required this.accountName,
      required this.accountNumber,
      this.accountType,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['account_name'] = Variable<String>(accountName);
    map['account_number'] = Variable<String>(accountNumber);
    if (!nullToAbsent || accountType != null) {
      map['account_type'] = Variable<String>(accountType);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  BankAccountsCompanion toCompanion(bool nullToAbsent) {
    return BankAccountsCompanion(
      id: Value(id),
      bankName: Value(bankName),
      accountName: Value(accountName),
      accountNumber: Value(accountNumber),
      accountType: accountType == null && nullToAbsent
          ? const Value.absent()
          : Value(accountType),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory BankAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankAccount(
      id: serializer.fromJson<int>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      accountName: serializer.fromJson<String>(json['accountName']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      accountType: serializer.fromJson<String?>(json['accountType']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankName': serializer.toJson<String>(bankName),
      'accountName': serializer.toJson<String>(accountName),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'accountType': serializer.toJson<String?>(accountType),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  BankAccount copyWith(
          {int? id,
          String? bankName,
          String? accountName,
          String? accountNumber,
          Value<String?> accountType = const Value.absent(),
          String? status,
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      BankAccount(
        id: id ?? this.id,
        bankName: bankName ?? this.bankName,
        accountName: accountName ?? this.accountName,
        accountNumber: accountNumber ?? this.accountNumber,
        accountType: accountType.present ? accountType.value : this.accountType,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  BankAccount copyWithCompanion(BankAccountsCompanion data) {
    return BankAccount(
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      accountName:
          data.accountName.present ? data.accountName.value : this.accountName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankAccount(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('accountType: $accountType, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bankName, accountName, accountNumber,
      accountType, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankAccount &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.accountName == this.accountName &&
          other.accountNumber == this.accountNumber &&
          other.accountType == this.accountType &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BankAccountsCompanion extends UpdateCompanion<BankAccount> {
  final Value<int> id;
  final Value<String> bankName;
  final Value<String> accountName;
  final Value<String> accountNumber;
  final Value<String?> accountType;
  final Value<String> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const BankAccountsCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.accountType = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BankAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String bankName,
    required String accountName,
    required String accountNumber,
    this.accountType = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : bankName = Value(bankName),
        accountName = Value(accountName),
        accountNumber = Value(accountNumber);
  static Insertable<BankAccount> custom({
    Expression<int>? id,
    Expression<String>? bankName,
    Expression<String>? accountName,
    Expression<String>? accountNumber,
    Expression<String>? accountType,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (accountName != null) 'account_name': accountName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (accountType != null) 'account_type': accountType,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BankAccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankName,
      Value<String>? accountName,
      Value<String>? accountNumber,
      Value<String?>? accountType,
      Value<String>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return BankAccountsCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankAccountsCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('accountType: $accountType, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubjectAssignChildrensTable extends SubjectAssignChildrens
    with TableInfo<$SubjectAssignChildrensTable, SubjectAssignChildren> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectAssignChildrensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subjectAssignIdMeta =
      const VerificationMeta('subjectAssignId');
  @override
  late final GeneratedColumn<String> subjectAssignId = GeneratedColumn<String>(
      'subject_assign_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectAssignId, subjectId, staffId, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subject_assign_childrens';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubjectAssignChildren> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_assign_id')) {
      context.handle(
          _subjectAssignIdMeta,
          subjectAssignId.isAcceptableOrUnknown(
              data['subject_assign_id']!, _subjectAssignIdMeta));
    } else if (isInserting) {
      context.missing(_subjectAssignIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectAssignChildren map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectAssignChildren(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subjectAssignId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subject_assign_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}staff_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SubjectAssignChildrensTable createAlias(String alias) {
    return $SubjectAssignChildrensTable(attachedDatabase, alias);
  }
}

class SubjectAssignChildren extends DataClass
    implements Insertable<SubjectAssignChildren> {
  final int id;
  final String subjectAssignId;
  final String subjectId;
  final String staffId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  const SubjectAssignChildren(
      {required this.id,
      required this.subjectAssignId,
      required this.subjectId,
      required this.staffId,
      this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_assign_id'] = Variable<String>(subjectAssignId);
    map['subject_id'] = Variable<String>(subjectId);
    map['staff_id'] = Variable<String>(staffId);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  SubjectAssignChildrensCompanion toCompanion(bool nullToAbsent) {
    return SubjectAssignChildrensCompanion(
      id: Value(id),
      subjectAssignId: Value(subjectAssignId),
      subjectId: Value(subjectId),
      staffId: Value(staffId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SubjectAssignChildren.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectAssignChildren(
      id: serializer.fromJson<int>(json['id']),
      subjectAssignId: serializer.fromJson<String>(json['subjectAssignId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      staffId: serializer.fromJson<String>(json['staffId']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectAssignId': serializer.toJson<String>(subjectAssignId),
      'subjectId': serializer.toJson<String>(subjectId),
      'staffId': serializer.toJson<String>(staffId),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  SubjectAssignChildren copyWith(
          {int? id,
          String? subjectAssignId,
          String? subjectId,
          String? staffId,
          Value<String?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      SubjectAssignChildren(
        id: id ?? this.id,
        subjectAssignId: subjectAssignId ?? this.subjectAssignId,
        subjectId: subjectId ?? this.subjectId,
        staffId: staffId ?? this.staffId,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  SubjectAssignChildren copyWithCompanion(
      SubjectAssignChildrensCompanion data) {
    return SubjectAssignChildren(
      id: data.id.present ? data.id.value : this.id,
      subjectAssignId: data.subjectAssignId.present
          ? data.subjectAssignId.value
          : this.subjectAssignId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectAssignChildren(')
          ..write('id: $id, ')
          ..write('subjectAssignId: $subjectAssignId, ')
          ..write('subjectId: $subjectId, ')
          ..write('staffId: $staffId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, subjectAssignId, subjectId, staffId, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectAssignChildren &&
          other.id == this.id &&
          other.subjectAssignId == this.subjectAssignId &&
          other.subjectId == this.subjectId &&
          other.staffId == this.staffId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubjectAssignChildrensCompanion
    extends UpdateCompanion<SubjectAssignChildren> {
  final Value<int> id;
  final Value<String> subjectAssignId;
  final Value<String> subjectId;
  final Value<String> staffId;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const SubjectAssignChildrensCompanion({
    this.id = const Value.absent(),
    this.subjectAssignId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.staffId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubjectAssignChildrensCompanion.insert({
    this.id = const Value.absent(),
    required String subjectAssignId,
    required String subjectId,
    required String staffId,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : subjectAssignId = Value(subjectAssignId),
        subjectId = Value(subjectId),
        staffId = Value(staffId);
  static Insertable<SubjectAssignChildren> custom({
    Expression<int>? id,
    Expression<String>? subjectAssignId,
    Expression<String>? subjectId,
    Expression<String>? staffId,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectAssignId != null) 'subject_assign_id': subjectAssignId,
      if (subjectId != null) 'subject_id': subjectId,
      if (staffId != null) 'staff_id': staffId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubjectAssignChildrensCompanion copyWith(
      {Value<int>? id,
      Value<String>? subjectAssignId,
      Value<String>? subjectId,
      Value<String>? staffId,
      Value<String?>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return SubjectAssignChildrensCompanion(
      id: id ?? this.id,
      subjectAssignId: subjectAssignId ?? this.subjectAssignId,
      subjectId: subjectId ?? this.subjectId,
      staffId: staffId ?? this.staffId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectAssignId.present) {
      map['subject_assign_id'] = Variable<String>(subjectAssignId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectAssignChildrensCompanion(')
          ..write('id: $id, ')
          ..write('subjectAssignId: $subjectAssignId, ')
          ..write('subjectId: $subjectId, ')
          ..write('staffId: $staffId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubjectAssignsTable extends SubjectAssigns
    with TableInfo<$SubjectAssignsTable, SubjectAssign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectAssignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classesIdMeta =
      const VerificationMeta('classesId');
  @override
  late final GeneratedColumn<String> classesId = GeneratedColumn<String>(
      'classes_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
      'section_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, classesId, sectionId, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subject_assigns';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectAssign> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('classes_id')) {
      context.handle(_classesIdMeta,
          classesId.isAcceptableOrUnknown(data['classes_id']!, _classesIdMeta));
    } else if (isInserting) {
      context.missing(_classesIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectAssign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectAssign(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      classesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}classes_id'])!,
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SubjectAssignsTable createAlias(String alias) {
    return $SubjectAssignsTable(attachedDatabase, alias);
  }
}

class SubjectAssign extends DataClass implements Insertable<SubjectAssign> {
  final int id;
  final String sessionId;
  final String classesId;
  final String sectionId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  const SubjectAssign(
      {required this.id,
      required this.sessionId,
      required this.classesId,
      required this.sectionId,
      this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['classes_id'] = Variable<String>(classesId);
    map['section_id'] = Variable<String>(sectionId);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  SubjectAssignsCompanion toCompanion(bool nullToAbsent) {
    return SubjectAssignsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      classesId: Value(classesId),
      sectionId: Value(sectionId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SubjectAssign.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectAssign(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      classesId: serializer.fromJson<String>(json['classesId']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'classesId': serializer.toJson<String>(classesId),
      'sectionId': serializer.toJson<String>(sectionId),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  SubjectAssign copyWith(
          {int? id,
          String? sessionId,
          String? classesId,
          String? sectionId,
          Value<String?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      SubjectAssign(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        classesId: classesId ?? this.classesId,
        sectionId: sectionId ?? this.sectionId,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  SubjectAssign copyWithCompanion(SubjectAssignsCompanion data) {
    return SubjectAssign(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      classesId: data.classesId.present ? data.classesId.value : this.classesId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectAssign(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('classesId: $classesId, ')
          ..write('sectionId: $sectionId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sessionId, classesId, sectionId, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectAssign &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.classesId == this.classesId &&
          other.sectionId == this.sectionId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubjectAssignsCompanion extends UpdateCompanion<SubjectAssign> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<String> classesId;
  final Value<String> sectionId;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const SubjectAssignsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.classesId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubjectAssignsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String classesId,
    required String sectionId,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        classesId = Value(classesId),
        sectionId = Value(sectionId);
  static Insertable<SubjectAssign> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<String>? classesId,
    Expression<String>? sectionId,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (classesId != null) 'classes_id': classesId,
      if (sectionId != null) 'section_id': sectionId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubjectAssignsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionId,
      Value<String>? classesId,
      Value<String>? sectionId,
      Value<String?>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return SubjectAssignsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      classesId: classesId ?? this.classesId,
      sectionId: sectionId ?? this.sectionId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (classesId.present) {
      map['classes_id'] = Variable<String>(classesId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectAssignsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('classesId: $classesId, ')
          ..write('sectionId: $sectionId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserCredentialsTable extends UserCredentials
    with TableInfo<$UserCredentialsTable, UserCredential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCredentialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailVerifiedAtMeta =
      const VerificationMeta('emailVerifiedAt');
  @override
  late final GeneratedColumn<DateTime> emailVerifiedAt =
      GeneratedColumn<DateTime>('email_verified_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rememberTokenMeta =
      const VerificationMeta('rememberToken');
  @override
  late final GeneratedColumn<String> rememberToken = GeneratedColumn<String>(
      'remember_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _otpMeta = const VerificationMeta('otp');
  @override
  late final GeneratedColumn<String> otp = GeneratedColumn<String>(
      'otp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _otpVerifiedMeta =
      const VerificationMeta('otpVerified');
  @override
  late final GeneratedColumn<String> otpVerified = GeneratedColumn<String>(
      'otp_verified', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        phone,
        status,
        emailVerifiedAt,
        password,
        rememberToken,
        otp,
        otpVerified,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_credentials';
  @override
  VerificationContext validateIntegrity(Insertable<UserCredential> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('email_verified_at')) {
      context.handle(
          _emailVerifiedAtMeta,
          emailVerifiedAt.isAcceptableOrUnknown(
              data['email_verified_at']!, _emailVerifiedAtMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('remember_token')) {
      context.handle(
          _rememberTokenMeta,
          rememberToken.isAcceptableOrUnknown(
              data['remember_token']!, _rememberTokenMeta));
    }
    if (data.containsKey('otp')) {
      context.handle(
          _otpMeta, otp.isAcceptableOrUnknown(data['otp']!, _otpMeta));
    }
    if (data.containsKey('otp_verified')) {
      context.handle(
          _otpVerifiedMeta,
          otpVerified.isAcceptableOrUnknown(
              data['otp_verified']!, _otpVerifiedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCredential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCredential(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      emailVerifiedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}email_verified_at']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      rememberToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remember_token']),
      otp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}otp']),
      otpVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}otp_verified']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserCredentialsTable createAlias(String alias) {
    return $UserCredentialsTable(attachedDatabase, alias);
  }
}

class UserCredential extends DataClass implements Insertable<UserCredential> {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String status;
  final DateTime? emailVerifiedAt;
  final String? password;
  final String? rememberToken;
  final String? otp;
  final String? otpVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserCredential(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.status,
      this.emailVerifiedAt,
      this.password,
      this.rememberToken,
      this.otp,
      this.otpVerified,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || emailVerifiedAt != null) {
      map['email_verified_at'] = Variable<DateTime>(emailVerifiedAt);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || rememberToken != null) {
      map['remember_token'] = Variable<String>(rememberToken);
    }
    if (!nullToAbsent || otp != null) {
      map['otp'] = Variable<String>(otp);
    }
    if (!nullToAbsent || otpVerified != null) {
      map['otp_verified'] = Variable<String>(otpVerified);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserCredentialsCompanion toCompanion(bool nullToAbsent) {
    return UserCredentialsCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: Value(phone),
      status: Value(status),
      emailVerifiedAt: emailVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(emailVerifiedAt),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      rememberToken: rememberToken == null && nullToAbsent
          ? const Value.absent()
          : Value(rememberToken),
      otp: otp == null && nullToAbsent ? const Value.absent() : Value(otp),
      otpVerified: otpVerified == null && nullToAbsent
          ? const Value.absent()
          : Value(otpVerified),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserCredential.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCredential(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      status: serializer.fromJson<String>(json['status']),
      emailVerifiedAt: serializer.fromJson<DateTime?>(json['emailVerifiedAt']),
      password: serializer.fromJson<String?>(json['password']),
      rememberToken: serializer.fromJson<String?>(json['rememberToken']),
      otp: serializer.fromJson<String?>(json['otp']),
      otpVerified: serializer.fromJson<String?>(json['otpVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'status': serializer.toJson<String>(status),
      'emailVerifiedAt': serializer.toJson<DateTime?>(emailVerifiedAt),
      'password': serializer.toJson<String?>(password),
      'rememberToken': serializer.toJson<String?>(rememberToken),
      'otp': serializer.toJson<String?>(otp),
      'otpVerified': serializer.toJson<String?>(otpVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserCredential copyWith(
          {int? id,
          String? name,
          String? email,
          String? phone,
          String? status,
          Value<DateTime?> emailVerifiedAt = const Value.absent(),
          Value<String?> password = const Value.absent(),
          Value<String?> rememberToken = const Value.absent(),
          Value<String?> otp = const Value.absent(),
          Value<String?> otpVerified = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserCredential(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        emailVerifiedAt: emailVerifiedAt.present
            ? emailVerifiedAt.value
            : this.emailVerifiedAt,
        password: password.present ? password.value : this.password,
        rememberToken:
            rememberToken.present ? rememberToken.value : this.rememberToken,
        otp: otp.present ? otp.value : this.otp,
        otpVerified: otpVerified.present ? otpVerified.value : this.otpVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserCredential copyWithCompanion(UserCredentialsCompanion data) {
    return UserCredential(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      status: data.status.present ? data.status.value : this.status,
      emailVerifiedAt: data.emailVerifiedAt.present
          ? data.emailVerifiedAt.value
          : this.emailVerifiedAt,
      password: data.password.present ? data.password.value : this.password,
      rememberToken: data.rememberToken.present
          ? data.rememberToken.value
          : this.rememberToken,
      otp: data.otp.present ? data.otp.value : this.otp,
      otpVerified:
          data.otpVerified.present ? data.otpVerified.value : this.otpVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCredential(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('status: $status, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('password: $password, ')
          ..write('rememberToken: $rememberToken, ')
          ..write('otp: $otp, ')
          ..write('otpVerified: $otpVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      email,
      phone,
      status,
      emailVerifiedAt,
      password,
      rememberToken,
      otp,
      otpVerified,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCredential &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.status == this.status &&
          other.emailVerifiedAt == this.emailVerifiedAt &&
          other.password == this.password &&
          other.rememberToken == this.rememberToken &&
          other.otp == this.otp &&
          other.otpVerified == this.otpVerified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserCredentialsCompanion extends UpdateCompanion<UserCredential> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> status;
  final Value<DateTime?> emailVerifiedAt;
  final Value<String?> password;
  final Value<String?> rememberToken;
  final Value<String?> otp;
  final Value<String?> otpVerified;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserCredentialsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.status = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.password = const Value.absent(),
    this.rememberToken = const Value.absent(),
    this.otp = const Value.absent(),
    this.otpVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserCredentialsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String phone,
    required String status,
    this.emailVerifiedAt = const Value.absent(),
    this.password = const Value.absent(),
    this.rememberToken = const Value.absent(),
    this.otp = const Value.absent(),
    this.otpVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        email = Value(email),
        phone = Value(phone),
        status = Value(status);
  static Insertable<UserCredential> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? status,
    Expression<DateTime>? emailVerifiedAt,
    Expression<String>? password,
    Expression<String>? rememberToken,
    Expression<String>? otp,
    Expression<String>? otpVerified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (status != null) 'status': status,
      if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
      if (password != null) 'password': password,
      if (rememberToken != null) 'remember_token': rememberToken,
      if (otp != null) 'otp': otp,
      if (otpVerified != null) 'otp_verified': otpVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserCredentialsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? phone,
      Value<String>? status,
      Value<DateTime?>? emailVerifiedAt,
      Value<String?>? password,
      Value<String?>? rememberToken,
      Value<String?>? otp,
      Value<String?>? otpVerified,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserCredentialsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      password: password ?? this.password,
      rememberToken: rememberToken ?? this.rememberToken,
      otp: otp ?? this.otp,
      otpVerified: otpVerified ?? this.otpVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (emailVerifiedAt.present) {
      map['email_verified_at'] = Variable<DateTime>(emailVerifiedAt.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (rememberToken.present) {
      map['remember_token'] = Variable<String>(rememberToken.value);
    }
    if (otp.present) {
      map['otp'] = Variable<String>(otp.value);
    }
    if (otpVerified.present) {
      map['otp_verified'] = Variable<String>(otpVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCredentialsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('status: $status, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('password: $password, ')
          ..write('rememberToken: $rememberToken, ')
          ..write('otp: $otp, ')
          ..write('otpVerified: $otpVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StaffTable extends Staff with TableInfo<$StaffTable, StaffData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
      'role_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _designationIdMeta =
      const VerificationMeta('designationId');
  @override
  late final GeneratedColumn<String> designationId = GeneratedColumn<String>(
      'designation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _departmentIdMeta =
      const VerificationMeta('departmentId');
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
      'department_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderIdMeta =
      const VerificationMeta('genderId');
  @override
  late final GeneratedColumn<String> genderId = GeneratedColumn<String>(
      'gender_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        staffId,
        roleId,
        designationId,
        departmentId,
        firstName,
        lastName,
        email,
        genderId,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff';
  @override
  VerificationContext validateIntegrity(Insertable<StaffData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta,
          roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('designation_id')) {
      context.handle(
          _designationIdMeta,
          designationId.isAcceptableOrUnknown(
              data['designation_id']!, _designationIdMeta));
    } else if (isInserting) {
      context.missing(_designationIdMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
          _departmentIdMeta,
          departmentId.isAcceptableOrUnknown(
              data['department_id']!, _departmentIdMeta));
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('gender_id')) {
      context.handle(_genderIdMeta,
          genderId.isAcceptableOrUnknown(data['gender_id']!, _genderIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}staff_id'])!,
      roleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_id'])!,
      designationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation_id'])!,
      departmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department_id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      genderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $StaffTable createAlias(String alias) {
    return $StaffTable(attachedDatabase, alias);
  }
}

class StaffData extends DataClass implements Insertable<StaffData> {
  final int id;
  final String userId;
  final String staffId;
  final String roleId;
  final String designationId;
  final String departmentId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? genderId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  const StaffData(
      {required this.id,
      required this.userId,
      required this.staffId,
      required this.roleId,
      required this.designationId,
      required this.departmentId,
      this.firstName,
      this.lastName,
      this.email,
      this.genderId,
      this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['staff_id'] = Variable<String>(staffId);
    map['role_id'] = Variable<String>(roleId);
    map['designation_id'] = Variable<String>(designationId);
    map['department_id'] = Variable<String>(departmentId);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || genderId != null) {
      map['gender_id'] = Variable<String>(genderId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  StaffCompanion toCompanion(bool nullToAbsent) {
    return StaffCompanion(
      id: Value(id),
      userId: Value(userId),
      staffId: Value(staffId),
      roleId: Value(roleId),
      designationId: Value(designationId),
      departmentId: Value(departmentId),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      genderId: genderId == null && nullToAbsent
          ? const Value.absent()
          : Value(genderId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory StaffData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      staffId: serializer.fromJson<String>(json['staffId']),
      roleId: serializer.fromJson<String>(json['roleId']),
      designationId: serializer.fromJson<String>(json['designationId']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      genderId: serializer.fromJson<String?>(json['genderId']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'staffId': serializer.toJson<String>(staffId),
      'roleId': serializer.toJson<String>(roleId),
      'designationId': serializer.toJson<String>(designationId),
      'departmentId': serializer.toJson<String>(departmentId),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'email': serializer.toJson<String?>(email),
      'genderId': serializer.toJson<String?>(genderId),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  StaffData copyWith(
          {int? id,
          String? userId,
          String? staffId,
          String? roleId,
          String? designationId,
          String? departmentId,
          Value<String?> firstName = const Value.absent(),
          Value<String?> lastName = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> genderId = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      StaffData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        staffId: staffId ?? this.staffId,
        roleId: roleId ?? this.roleId,
        designationId: designationId ?? this.designationId,
        departmentId: departmentId ?? this.departmentId,
        firstName: firstName.present ? firstName.value : this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        email: email.present ? email.value : this.email,
        genderId: genderId.present ? genderId.value : this.genderId,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  StaffData copyWithCompanion(StaffCompanion data) {
    return StaffData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      designationId: data.designationId.present
          ? data.designationId.value
          : this.designationId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      genderId: data.genderId.present ? data.genderId.value : this.genderId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('staffId: $staffId, ')
          ..write('roleId: $roleId, ')
          ..write('designationId: $designationId, ')
          ..write('departmentId: $departmentId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('genderId: $genderId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      staffId,
      roleId,
      designationId,
      departmentId,
      firstName,
      lastName,
      email,
      genderId,
      status,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.staffId == this.staffId &&
          other.roleId == this.roleId &&
          other.designationId == this.designationId &&
          other.departmentId == this.departmentId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.genderId == this.genderId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StaffCompanion extends UpdateCompanion<StaffData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> staffId;
  final Value<String> roleId;
  final Value<String> designationId;
  final Value<String> departmentId;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> email;
  final Value<String?> genderId;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const StaffCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.staffId = const Value.absent(),
    this.roleId = const Value.absent(),
    this.designationId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.genderId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StaffCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String staffId,
    required String roleId,
    required String designationId,
    required String departmentId,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.genderId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        staffId = Value(staffId),
        roleId = Value(roleId),
        designationId = Value(designationId),
        departmentId = Value(departmentId);
  static Insertable<StaffData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? staffId,
    Expression<String>? roleId,
    Expression<String>? designationId,
    Expression<String>? departmentId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? genderId,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (staffId != null) 'staff_id': staffId,
      if (roleId != null) 'role_id': roleId,
      if (designationId != null) 'designation_id': designationId,
      if (departmentId != null) 'department_id': departmentId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (genderId != null) 'gender_id': genderId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StaffCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? staffId,
      Value<String>? roleId,
      Value<String>? designationId,
      Value<String>? departmentId,
      Value<String?>? firstName,
      Value<String?>? lastName,
      Value<String?>? email,
      Value<String?>? genderId,
      Value<String?>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return StaffCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      staffId: staffId ?? this.staffId,
      roleId: roleId ?? this.roleId,
      designationId: designationId ?? this.designationId,
      departmentId: departmentId ?? this.departmentId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      genderId: genderId ?? this.genderId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (designationId.present) {
      map['designation_id'] = Variable<String>(designationId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (genderId.present) {
      map['gender_id'] = Variable<String>(genderId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('staffId: $staffId, ')
          ..write('roleId: $roleId, ')
          ..write('designationId: $designationId, ')
          ..write('departmentId: $departmentId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('genderId: $genderId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MarksGradeTable extends MarksGrade
    with TableInfo<$MarksGradeTable, MarksGradeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarksGradeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _percentFromMeta =
      const VerificationMeta('percentFrom');
  @override
  late final GeneratedColumn<double> percentFrom = GeneratedColumn<double>(
      'percent_from', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _percentUptoMeta =
      const VerificationMeta('percentUpto');
  @override
  late final GeneratedColumn<double> percentUpto = GeneratedColumn<double>(
      'percent_upto', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pointMeta = const VerificationMeta('point');
  @override
  late final GeneratedColumn<int> point = GeneratedColumn<int>(
      'point', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        percentFrom,
        percentUpto,
        point,
        remarks,
        sessionId,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'marks_grade';
  @override
  VerificationContext validateIntegrity(Insertable<MarksGradeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('percent_from')) {
      context.handle(
          _percentFromMeta,
          percentFrom.isAcceptableOrUnknown(
              data['percent_from']!, _percentFromMeta));
    } else if (isInserting) {
      context.missing(_percentFromMeta);
    }
    if (data.containsKey('percent_upto')) {
      context.handle(
          _percentUptoMeta,
          percentUpto.isAcceptableOrUnknown(
              data['percent_upto']!, _percentUptoMeta));
    } else if (isInserting) {
      context.missing(_percentUptoMeta);
    }
    if (data.containsKey('point')) {
      context.handle(
          _pointMeta, point.isAcceptableOrUnknown(data['point']!, _pointMeta));
    } else if (isInserting) {
      context.missing(_pointMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MarksGradeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarksGradeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      percentFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent_from'])!,
      percentUpto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent_upto'])!,
      point: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}point'])!,
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $MarksGradeTable createAlias(String alias) {
    return $MarksGradeTable(attachedDatabase, alias);
  }
}

class MarksGradeData extends DataClass implements Insertable<MarksGradeData> {
  final int id;
  final String name;
  final double percentFrom;
  final double percentUpto;
  final int point;
  final String? remarks;
  final int sessionId;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  const MarksGradeData(
      {required this.id,
      required this.name,
      required this.percentFrom,
      required this.percentUpto,
      required this.point,
      this.remarks,
      required this.sessionId,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['percent_from'] = Variable<double>(percentFrom);
    map['percent_upto'] = Variable<double>(percentUpto);
    map['point'] = Variable<int>(point);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['session_id'] = Variable<int>(sessionId);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  MarksGradeCompanion toCompanion(bool nullToAbsent) {
    return MarksGradeCompanion(
      id: Value(id),
      name: Value(name),
      percentFrom: Value(percentFrom),
      percentUpto: Value(percentUpto),
      point: Value(point),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      sessionId: Value(sessionId),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MarksGradeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarksGradeData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      percentFrom: serializer.fromJson<double>(json['percentFrom']),
      percentUpto: serializer.fromJson<double>(json['percentUpto']),
      point: serializer.fromJson<int>(json['point']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      status: serializer.fromJson<int>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'percentFrom': serializer.toJson<double>(percentFrom),
      'percentUpto': serializer.toJson<double>(percentUpto),
      'point': serializer.toJson<int>(point),
      'remarks': serializer.toJson<String?>(remarks),
      'sessionId': serializer.toJson<int>(sessionId),
      'status': serializer.toJson<int>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  MarksGradeData copyWith(
          {int? id,
          String? name,
          double? percentFrom,
          double? percentUpto,
          int? point,
          Value<String?> remarks = const Value.absent(),
          int? sessionId,
          int? status,
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      MarksGradeData(
        id: id ?? this.id,
        name: name ?? this.name,
        percentFrom: percentFrom ?? this.percentFrom,
        percentUpto: percentUpto ?? this.percentUpto,
        point: point ?? this.point,
        remarks: remarks.present ? remarks.value : this.remarks,
        sessionId: sessionId ?? this.sessionId,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  MarksGradeData copyWithCompanion(MarksGradeCompanion data) {
    return MarksGradeData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      percentFrom:
          data.percentFrom.present ? data.percentFrom.value : this.percentFrom,
      percentUpto:
          data.percentUpto.present ? data.percentUpto.value : this.percentUpto,
      point: data.point.present ? data.point.value : this.point,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarksGradeData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('percentFrom: $percentFrom, ')
          ..write('percentUpto: $percentUpto, ')
          ..write('point: $point, ')
          ..write('remarks: $remarks, ')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, percentFrom, percentUpto, point,
      remarks, sessionId, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarksGradeData &&
          other.id == this.id &&
          other.name == this.name &&
          other.percentFrom == this.percentFrom &&
          other.percentUpto == this.percentUpto &&
          other.point == this.point &&
          other.remarks == this.remarks &&
          other.sessionId == this.sessionId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MarksGradeCompanion extends UpdateCompanion<MarksGradeData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> percentFrom;
  final Value<double> percentUpto;
  final Value<int> point;
  final Value<String?> remarks;
  final Value<int> sessionId;
  final Value<int> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const MarksGradeCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.percentFrom = const Value.absent(),
    this.percentUpto = const Value.absent(),
    this.point = const Value.absent(),
    this.remarks = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MarksGradeCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double percentFrom,
    required double percentUpto,
    required int point,
    this.remarks = const Value.absent(),
    required int sessionId,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        percentFrom = Value(percentFrom),
        percentUpto = Value(percentUpto),
        point = Value(point),
        sessionId = Value(sessionId);
  static Insertable<MarksGradeData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? percentFrom,
    Expression<double>? percentUpto,
    Expression<int>? point,
    Expression<String>? remarks,
    Expression<int>? sessionId,
    Expression<int>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (percentFrom != null) 'percent_from': percentFrom,
      if (percentUpto != null) 'percent_upto': percentUpto,
      if (point != null) 'point': point,
      if (remarks != null) 'remarks': remarks,
      if (sessionId != null) 'session_id': sessionId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MarksGradeCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? percentFrom,
      Value<double>? percentUpto,
      Value<int>? point,
      Value<String?>? remarks,
      Value<int>? sessionId,
      Value<int>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return MarksGradeCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      percentFrom: percentFrom ?? this.percentFrom,
      percentUpto: percentUpto ?? this.percentUpto,
      point: point ?? this.point,
      remarks: remarks ?? this.remarks,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (percentFrom.present) {
      map['percent_from'] = Variable<double>(percentFrom.value);
    }
    if (percentUpto.present) {
      map['percent_upto'] = Variable<double>(percentUpto.value);
    }
    if (point.present) {
      map['point'] = Variable<int>(point.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarksGradeCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('percentFrom: $percentFrom, ')
          ..write('percentUpto: $percentUpto, ')
          ..write('point: $point, ')
          ..write('remarks: $remarks, ')
          ..write('sessionId: $sessionId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ParentDetailsTable extends ParentDetails
    with TableInfo<$ParentDetailsTable, ParentDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParentDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fatherNameMeta =
      const VerificationMeta('fatherName');
  @override
  late final GeneratedColumn<String> fatherName = GeneratedColumn<String>(
      'father_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherMobileMeta =
      const VerificationMeta('fatherMobile');
  @override
  late final GeneratedColumn<String> fatherMobile = GeneratedColumn<String>(
      'father_mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherProfessionMeta =
      const VerificationMeta('fatherProfession');
  @override
  late final GeneratedColumn<String> fatherProfession = GeneratedColumn<String>(
      'father_profession', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherImageMeta =
      const VerificationMeta('fatherImage');
  @override
  late final GeneratedColumn<String> fatherImage = GeneratedColumn<String>(
      'father_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherNationalityMeta =
      const VerificationMeta('fatherNationality');
  @override
  late final GeneratedColumn<String> fatherNationality =
      GeneratedColumn<String>('father_nationality', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherNameMeta =
      const VerificationMeta('motherName');
  @override
  late final GeneratedColumn<String> motherName = GeneratedColumn<String>(
      'mother_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherMobileMeta =
      const VerificationMeta('motherMobile');
  @override
  late final GeneratedColumn<String> motherMobile = GeneratedColumn<String>(
      'mother_mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherProfessionMeta =
      const VerificationMeta('motherProfession');
  @override
  late final GeneratedColumn<String> motherProfession = GeneratedColumn<String>(
      'mother_profession', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motherImageMeta =
      const VerificationMeta('motherImage');
  @override
  late final GeneratedColumn<String> motherImage = GeneratedColumn<String>(
      'mother_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianNameMeta =
      const VerificationMeta('guardianName');
  @override
  late final GeneratedColumn<String> guardianName = GeneratedColumn<String>(
      'guardian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianEmailMeta =
      const VerificationMeta('guardianEmail');
  @override
  late final GeneratedColumn<String> guardianEmail = GeneratedColumn<String>(
      'guardian_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianMobileMeta =
      const VerificationMeta('guardianMobile');
  @override
  late final GeneratedColumn<String> guardianMobile = GeneratedColumn<String>(
      'guardian_mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianImageMeta =
      const VerificationMeta('guardianImage');
  @override
  late final GeneratedColumn<String> guardianImage = GeneratedColumn<String>(
      'guardian_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianProfessionMeta =
      const VerificationMeta('guardianProfession');
  @override
  late final GeneratedColumn<String> guardianProfession =
      GeneratedColumn<String>('guardian_profession', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianRelationMeta =
      const VerificationMeta('guardianRelation');
  @override
  late final GeneratedColumn<String> guardianRelation = GeneratedColumn<String>(
      'guardian_relation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guardianAddressMeta =
      const VerificationMeta('guardianAddress');
  @override
  late final GeneratedColumn<String> guardianAddress = GeneratedColumn<String>(
      'guardian_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        fatherName,
        fatherMobile,
        fatherProfession,
        fatherImage,
        fatherNationality,
        motherName,
        motherMobile,
        motherProfession,
        motherImage,
        guardianName,
        guardianEmail,
        guardianMobile,
        guardianImage,
        guardianProfession,
        guardianRelation,
        guardianAddress,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parent_details';
  @override
  VerificationContext validateIntegrity(Insertable<ParentDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('father_name')) {
      context.handle(
          _fatherNameMeta,
          fatherName.isAcceptableOrUnknown(
              data['father_name']!, _fatherNameMeta));
    }
    if (data.containsKey('father_mobile')) {
      context.handle(
          _fatherMobileMeta,
          fatherMobile.isAcceptableOrUnknown(
              data['father_mobile']!, _fatherMobileMeta));
    }
    if (data.containsKey('father_profession')) {
      context.handle(
          _fatherProfessionMeta,
          fatherProfession.isAcceptableOrUnknown(
              data['father_profession']!, _fatherProfessionMeta));
    }
    if (data.containsKey('father_image')) {
      context.handle(
          _fatherImageMeta,
          fatherImage.isAcceptableOrUnknown(
              data['father_image']!, _fatherImageMeta));
    }
    if (data.containsKey('father_nationality')) {
      context.handle(
          _fatherNationalityMeta,
          fatherNationality.isAcceptableOrUnknown(
              data['father_nationality']!, _fatherNationalityMeta));
    }
    if (data.containsKey('mother_name')) {
      context.handle(
          _motherNameMeta,
          motherName.isAcceptableOrUnknown(
              data['mother_name']!, _motherNameMeta));
    }
    if (data.containsKey('mother_mobile')) {
      context.handle(
          _motherMobileMeta,
          motherMobile.isAcceptableOrUnknown(
              data['mother_mobile']!, _motherMobileMeta));
    }
    if (data.containsKey('mother_profession')) {
      context.handle(
          _motherProfessionMeta,
          motherProfession.isAcceptableOrUnknown(
              data['mother_profession']!, _motherProfessionMeta));
    }
    if (data.containsKey('mother_image')) {
      context.handle(
          _motherImageMeta,
          motherImage.isAcceptableOrUnknown(
              data['mother_image']!, _motherImageMeta));
    }
    if (data.containsKey('guardian_name')) {
      context.handle(
          _guardianNameMeta,
          guardianName.isAcceptableOrUnknown(
              data['guardian_name']!, _guardianNameMeta));
    }
    if (data.containsKey('guardian_email')) {
      context.handle(
          _guardianEmailMeta,
          guardianEmail.isAcceptableOrUnknown(
              data['guardian_email']!, _guardianEmailMeta));
    }
    if (data.containsKey('guardian_mobile')) {
      context.handle(
          _guardianMobileMeta,
          guardianMobile.isAcceptableOrUnknown(
              data['guardian_mobile']!, _guardianMobileMeta));
    }
    if (data.containsKey('guardian_image')) {
      context.handle(
          _guardianImageMeta,
          guardianImage.isAcceptableOrUnknown(
              data['guardian_image']!, _guardianImageMeta));
    }
    if (data.containsKey('guardian_profession')) {
      context.handle(
          _guardianProfessionMeta,
          guardianProfession.isAcceptableOrUnknown(
              data['guardian_profession']!, _guardianProfessionMeta));
    }
    if (data.containsKey('guardian_relation')) {
      context.handle(
          _guardianRelationMeta,
          guardianRelation.isAcceptableOrUnknown(
              data['guardian_relation']!, _guardianRelationMeta));
    }
    if (data.containsKey('guardian_address')) {
      context.handle(
          _guardianAddressMeta,
          guardianAddress.isAcceptableOrUnknown(
              data['guardian_address']!, _guardianAddressMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParentDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentDetail(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      fatherName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_name']),
      fatherMobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_mobile']),
      fatherProfession: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_profession']),
      fatherImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_image']),
      fatherNationality: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}father_nationality']),
      motherName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_name']),
      motherMobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_mobile']),
      motherProfession: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mother_profession']),
      motherImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_image']),
      guardianName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_name']),
      guardianEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_email']),
      guardianMobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_mobile']),
      guardianImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_image']),
      guardianProfession: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guardian_profession']),
      guardianRelation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guardian_relation']),
      guardianAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guardian_address']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ParentDetailsTable createAlias(String alias) {
    return $ParentDetailsTable(attachedDatabase, alias);
  }
}

class ParentDetail extends DataClass implements Insertable<ParentDetail> {
  final int id;
  final int userId;
  final String? fatherName;
  final String? fatherMobile;
  final String? fatherProfession;
  final String? fatherImage;
  final String? fatherNationality;
  final String? motherName;
  final String? motherMobile;
  final String? motherProfession;
  final String? motherImage;
  final String? guardianName;
  final String? guardianEmail;
  final String? guardianMobile;
  final String? guardianImage;
  final String? guardianProfession;
  final String? guardianRelation;
  final String? guardianAddress;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  const ParentDetail(
      {required this.id,
      required this.userId,
      this.fatherName,
      this.fatherMobile,
      this.fatherProfession,
      this.fatherImage,
      this.fatherNationality,
      this.motherName,
      this.motherMobile,
      this.motherProfession,
      this.motherImage,
      this.guardianName,
      this.guardianEmail,
      this.guardianMobile,
      this.guardianImage,
      this.guardianProfession,
      this.guardianRelation,
      this.guardianAddress,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || fatherName != null) {
      map['father_name'] = Variable<String>(fatherName);
    }
    if (!nullToAbsent || fatherMobile != null) {
      map['father_mobile'] = Variable<String>(fatherMobile);
    }
    if (!nullToAbsent || fatherProfession != null) {
      map['father_profession'] = Variable<String>(fatherProfession);
    }
    if (!nullToAbsent || fatherImage != null) {
      map['father_image'] = Variable<String>(fatherImage);
    }
    if (!nullToAbsent || fatherNationality != null) {
      map['father_nationality'] = Variable<String>(fatherNationality);
    }
    if (!nullToAbsent || motherName != null) {
      map['mother_name'] = Variable<String>(motherName);
    }
    if (!nullToAbsent || motherMobile != null) {
      map['mother_mobile'] = Variable<String>(motherMobile);
    }
    if (!nullToAbsent || motherProfession != null) {
      map['mother_profession'] = Variable<String>(motherProfession);
    }
    if (!nullToAbsent || motherImage != null) {
      map['mother_image'] = Variable<String>(motherImage);
    }
    if (!nullToAbsent || guardianName != null) {
      map['guardian_name'] = Variable<String>(guardianName);
    }
    if (!nullToAbsent || guardianEmail != null) {
      map['guardian_email'] = Variable<String>(guardianEmail);
    }
    if (!nullToAbsent || guardianMobile != null) {
      map['guardian_mobile'] = Variable<String>(guardianMobile);
    }
    if (!nullToAbsent || guardianImage != null) {
      map['guardian_image'] = Variable<String>(guardianImage);
    }
    if (!nullToAbsent || guardianProfession != null) {
      map['guardian_profession'] = Variable<String>(guardianProfession);
    }
    if (!nullToAbsent || guardianRelation != null) {
      map['guardian_relation'] = Variable<String>(guardianRelation);
    }
    if (!nullToAbsent || guardianAddress != null) {
      map['guardian_address'] = Variable<String>(guardianAddress);
    }
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  ParentDetailsCompanion toCompanion(bool nullToAbsent) {
    return ParentDetailsCompanion(
      id: Value(id),
      userId: Value(userId),
      fatherName: fatherName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherName),
      fatherMobile: fatherMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherMobile),
      fatherProfession: fatherProfession == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherProfession),
      fatherImage: fatherImage == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherImage),
      fatherNationality: fatherNationality == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherNationality),
      motherName: motherName == null && nullToAbsent
          ? const Value.absent()
          : Value(motherName),
      motherMobile: motherMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(motherMobile),
      motherProfession: motherProfession == null && nullToAbsent
          ? const Value.absent()
          : Value(motherProfession),
      motherImage: motherImage == null && nullToAbsent
          ? const Value.absent()
          : Value(motherImage),
      guardianName: guardianName == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianName),
      guardianEmail: guardianEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianEmail),
      guardianMobile: guardianMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianMobile),
      guardianImage: guardianImage == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianImage),
      guardianProfession: guardianProfession == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianProfession),
      guardianRelation: guardianRelation == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianRelation),
      guardianAddress: guardianAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianAddress),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ParentDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentDetail(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      fatherName: serializer.fromJson<String?>(json['fatherName']),
      fatherMobile: serializer.fromJson<String?>(json['fatherMobile']),
      fatherProfession: serializer.fromJson<String?>(json['fatherProfession']),
      fatherImage: serializer.fromJson<String?>(json['fatherImage']),
      fatherNationality:
          serializer.fromJson<String?>(json['fatherNationality']),
      motherName: serializer.fromJson<String?>(json['motherName']),
      motherMobile: serializer.fromJson<String?>(json['motherMobile']),
      motherProfession: serializer.fromJson<String?>(json['motherProfession']),
      motherImage: serializer.fromJson<String?>(json['motherImage']),
      guardianName: serializer.fromJson<String?>(json['guardianName']),
      guardianEmail: serializer.fromJson<String?>(json['guardianEmail']),
      guardianMobile: serializer.fromJson<String?>(json['guardianMobile']),
      guardianImage: serializer.fromJson<String?>(json['guardianImage']),
      guardianProfession:
          serializer.fromJson<String?>(json['guardianProfession']),
      guardianRelation: serializer.fromJson<String?>(json['guardianRelation']),
      guardianAddress: serializer.fromJson<String?>(json['guardianAddress']),
      status: serializer.fromJson<int>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'fatherName': serializer.toJson<String?>(fatherName),
      'fatherMobile': serializer.toJson<String?>(fatherMobile),
      'fatherProfession': serializer.toJson<String?>(fatherProfession),
      'fatherImage': serializer.toJson<String?>(fatherImage),
      'fatherNationality': serializer.toJson<String?>(fatherNationality),
      'motherName': serializer.toJson<String?>(motherName),
      'motherMobile': serializer.toJson<String?>(motherMobile),
      'motherProfession': serializer.toJson<String?>(motherProfession),
      'motherImage': serializer.toJson<String?>(motherImage),
      'guardianName': serializer.toJson<String?>(guardianName),
      'guardianEmail': serializer.toJson<String?>(guardianEmail),
      'guardianMobile': serializer.toJson<String?>(guardianMobile),
      'guardianImage': serializer.toJson<String?>(guardianImage),
      'guardianProfession': serializer.toJson<String?>(guardianProfession),
      'guardianRelation': serializer.toJson<String?>(guardianRelation),
      'guardianAddress': serializer.toJson<String?>(guardianAddress),
      'status': serializer.toJson<int>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  ParentDetail copyWith(
          {int? id,
          int? userId,
          Value<String?> fatherName = const Value.absent(),
          Value<String?> fatherMobile = const Value.absent(),
          Value<String?> fatherProfession = const Value.absent(),
          Value<String?> fatherImage = const Value.absent(),
          Value<String?> fatherNationality = const Value.absent(),
          Value<String?> motherName = const Value.absent(),
          Value<String?> motherMobile = const Value.absent(),
          Value<String?> motherProfession = const Value.absent(),
          Value<String?> motherImage = const Value.absent(),
          Value<String?> guardianName = const Value.absent(),
          Value<String?> guardianEmail = const Value.absent(),
          Value<String?> guardianMobile = const Value.absent(),
          Value<String?> guardianImage = const Value.absent(),
          Value<String?> guardianProfession = const Value.absent(),
          Value<String?> guardianRelation = const Value.absent(),
          Value<String?> guardianAddress = const Value.absent(),
          int? status,
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      ParentDetail(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fatherName: fatherName.present ? fatherName.value : this.fatherName,
        fatherMobile:
            fatherMobile.present ? fatherMobile.value : this.fatherMobile,
        fatherProfession: fatherProfession.present
            ? fatherProfession.value
            : this.fatherProfession,
        fatherImage: fatherImage.present ? fatherImage.value : this.fatherImage,
        fatherNationality: fatherNationality.present
            ? fatherNationality.value
            : this.fatherNationality,
        motherName: motherName.present ? motherName.value : this.motherName,
        motherMobile:
            motherMobile.present ? motherMobile.value : this.motherMobile,
        motherProfession: motherProfession.present
            ? motherProfession.value
            : this.motherProfession,
        motherImage: motherImage.present ? motherImage.value : this.motherImage,
        guardianName:
            guardianName.present ? guardianName.value : this.guardianName,
        guardianEmail:
            guardianEmail.present ? guardianEmail.value : this.guardianEmail,
        guardianMobile:
            guardianMobile.present ? guardianMobile.value : this.guardianMobile,
        guardianImage:
            guardianImage.present ? guardianImage.value : this.guardianImage,
        guardianProfession: guardianProfession.present
            ? guardianProfession.value
            : this.guardianProfession,
        guardianRelation: guardianRelation.present
            ? guardianRelation.value
            : this.guardianRelation,
        guardianAddress: guardianAddress.present
            ? guardianAddress.value
            : this.guardianAddress,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  ParentDetail copyWithCompanion(ParentDetailsCompanion data) {
    return ParentDetail(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      fatherName:
          data.fatherName.present ? data.fatherName.value : this.fatherName,
      fatherMobile: data.fatherMobile.present
          ? data.fatherMobile.value
          : this.fatherMobile,
      fatherProfession: data.fatherProfession.present
          ? data.fatherProfession.value
          : this.fatherProfession,
      fatherImage:
          data.fatherImage.present ? data.fatherImage.value : this.fatherImage,
      fatherNationality: data.fatherNationality.present
          ? data.fatherNationality.value
          : this.fatherNationality,
      motherName:
          data.motherName.present ? data.motherName.value : this.motherName,
      motherMobile: data.motherMobile.present
          ? data.motherMobile.value
          : this.motherMobile,
      motherProfession: data.motherProfession.present
          ? data.motherProfession.value
          : this.motherProfession,
      motherImage:
          data.motherImage.present ? data.motherImage.value : this.motherImage,
      guardianName: data.guardianName.present
          ? data.guardianName.value
          : this.guardianName,
      guardianEmail: data.guardianEmail.present
          ? data.guardianEmail.value
          : this.guardianEmail,
      guardianMobile: data.guardianMobile.present
          ? data.guardianMobile.value
          : this.guardianMobile,
      guardianImage: data.guardianImage.present
          ? data.guardianImage.value
          : this.guardianImage,
      guardianProfession: data.guardianProfession.present
          ? data.guardianProfession.value
          : this.guardianProfession,
      guardianRelation: data.guardianRelation.present
          ? data.guardianRelation.value
          : this.guardianRelation,
      guardianAddress: data.guardianAddress.present
          ? data.guardianAddress.value
          : this.guardianAddress,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentDetail(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fatherName: $fatherName, ')
          ..write('fatherMobile: $fatherMobile, ')
          ..write('fatherProfession: $fatherProfession, ')
          ..write('fatherImage: $fatherImage, ')
          ..write('fatherNationality: $fatherNationality, ')
          ..write('motherName: $motherName, ')
          ..write('motherMobile: $motherMobile, ')
          ..write('motherProfession: $motherProfession, ')
          ..write('motherImage: $motherImage, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianEmail: $guardianEmail, ')
          ..write('guardianMobile: $guardianMobile, ')
          ..write('guardianImage: $guardianImage, ')
          ..write('guardianProfession: $guardianProfession, ')
          ..write('guardianRelation: $guardianRelation, ')
          ..write('guardianAddress: $guardianAddress, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        fatherName,
        fatherMobile,
        fatherProfession,
        fatherImage,
        fatherNationality,
        motherName,
        motherMobile,
        motherProfession,
        motherImage,
        guardianName,
        guardianEmail,
        guardianMobile,
        guardianImage,
        guardianProfession,
        guardianRelation,
        guardianAddress,
        status,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentDetail &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.fatherName == this.fatherName &&
          other.fatherMobile == this.fatherMobile &&
          other.fatherProfession == this.fatherProfession &&
          other.fatherImage == this.fatherImage &&
          other.fatherNationality == this.fatherNationality &&
          other.motherName == this.motherName &&
          other.motherMobile == this.motherMobile &&
          other.motherProfession == this.motherProfession &&
          other.motherImage == this.motherImage &&
          other.guardianName == this.guardianName &&
          other.guardianEmail == this.guardianEmail &&
          other.guardianMobile == this.guardianMobile &&
          other.guardianImage == this.guardianImage &&
          other.guardianProfession == this.guardianProfession &&
          other.guardianRelation == this.guardianRelation &&
          other.guardianAddress == this.guardianAddress &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParentDetailsCompanion extends UpdateCompanion<ParentDetail> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String?> fatherName;
  final Value<String?> fatherMobile;
  final Value<String?> fatherProfession;
  final Value<String?> fatherImage;
  final Value<String?> fatherNationality;
  final Value<String?> motherName;
  final Value<String?> motherMobile;
  final Value<String?> motherProfession;
  final Value<String?> motherImage;
  final Value<String?> guardianName;
  final Value<String?> guardianEmail;
  final Value<String?> guardianMobile;
  final Value<String?> guardianImage;
  final Value<String?> guardianProfession;
  final Value<String?> guardianRelation;
  final Value<String?> guardianAddress;
  final Value<int> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const ParentDetailsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.fatherName = const Value.absent(),
    this.fatherMobile = const Value.absent(),
    this.fatherProfession = const Value.absent(),
    this.fatherImage = const Value.absent(),
    this.fatherNationality = const Value.absent(),
    this.motherName = const Value.absent(),
    this.motherMobile = const Value.absent(),
    this.motherProfession = const Value.absent(),
    this.motherImage = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.guardianEmail = const Value.absent(),
    this.guardianMobile = const Value.absent(),
    this.guardianImage = const Value.absent(),
    this.guardianProfession = const Value.absent(),
    this.guardianRelation = const Value.absent(),
    this.guardianAddress = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ParentDetailsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.fatherName = const Value.absent(),
    this.fatherMobile = const Value.absent(),
    this.fatherProfession = const Value.absent(),
    this.fatherImage = const Value.absent(),
    this.fatherNationality = const Value.absent(),
    this.motherName = const Value.absent(),
    this.motherMobile = const Value.absent(),
    this.motherProfession = const Value.absent(),
    this.motherImage = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.guardianEmail = const Value.absent(),
    this.guardianMobile = const Value.absent(),
    this.guardianImage = const Value.absent(),
    this.guardianProfession = const Value.absent(),
    this.guardianRelation = const Value.absent(),
    this.guardianAddress = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<ParentDetail> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? fatherName,
    Expression<String>? fatherMobile,
    Expression<String>? fatherProfession,
    Expression<String>? fatherImage,
    Expression<String>? fatherNationality,
    Expression<String>? motherName,
    Expression<String>? motherMobile,
    Expression<String>? motherProfession,
    Expression<String>? motherImage,
    Expression<String>? guardianName,
    Expression<String>? guardianEmail,
    Expression<String>? guardianMobile,
    Expression<String>? guardianImage,
    Expression<String>? guardianProfession,
    Expression<String>? guardianRelation,
    Expression<String>? guardianAddress,
    Expression<int>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (fatherName != null) 'father_name': fatherName,
      if (fatherMobile != null) 'father_mobile': fatherMobile,
      if (fatherProfession != null) 'father_profession': fatherProfession,
      if (fatherImage != null) 'father_image': fatherImage,
      if (fatherNationality != null) 'father_nationality': fatherNationality,
      if (motherName != null) 'mother_name': motherName,
      if (motherMobile != null) 'mother_mobile': motherMobile,
      if (motherProfession != null) 'mother_profession': motherProfession,
      if (motherImage != null) 'mother_image': motherImage,
      if (guardianName != null) 'guardian_name': guardianName,
      if (guardianEmail != null) 'guardian_email': guardianEmail,
      if (guardianMobile != null) 'guardian_mobile': guardianMobile,
      if (guardianImage != null) 'guardian_image': guardianImage,
      if (guardianProfession != null) 'guardian_profession': guardianProfession,
      if (guardianRelation != null) 'guardian_relation': guardianRelation,
      if (guardianAddress != null) 'guardian_address': guardianAddress,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ParentDetailsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String?>? fatherName,
      Value<String?>? fatherMobile,
      Value<String?>? fatherProfession,
      Value<String?>? fatherImage,
      Value<String?>? fatherNationality,
      Value<String?>? motherName,
      Value<String?>? motherMobile,
      Value<String?>? motherProfession,
      Value<String?>? motherImage,
      Value<String?>? guardianName,
      Value<String?>? guardianEmail,
      Value<String?>? guardianMobile,
      Value<String?>? guardianImage,
      Value<String?>? guardianProfession,
      Value<String?>? guardianRelation,
      Value<String?>? guardianAddress,
      Value<int>? status,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return ParentDetailsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fatherName: fatherName ?? this.fatherName,
      fatherMobile: fatherMobile ?? this.fatherMobile,
      fatherProfession: fatherProfession ?? this.fatherProfession,
      fatherImage: fatherImage ?? this.fatherImage,
      fatherNationality: fatherNationality ?? this.fatherNationality,
      motherName: motherName ?? this.motherName,
      motherMobile: motherMobile ?? this.motherMobile,
      motherProfession: motherProfession ?? this.motherProfession,
      motherImage: motherImage ?? this.motherImage,
      guardianName: guardianName ?? this.guardianName,
      guardianEmail: guardianEmail ?? this.guardianEmail,
      guardianMobile: guardianMobile ?? this.guardianMobile,
      guardianImage: guardianImage ?? this.guardianImage,
      guardianProfession: guardianProfession ?? this.guardianProfession,
      guardianRelation: guardianRelation ?? this.guardianRelation,
      guardianAddress: guardianAddress ?? this.guardianAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (fatherName.present) {
      map['father_name'] = Variable<String>(fatherName.value);
    }
    if (fatherMobile.present) {
      map['father_mobile'] = Variable<String>(fatherMobile.value);
    }
    if (fatherProfession.present) {
      map['father_profession'] = Variable<String>(fatherProfession.value);
    }
    if (fatherImage.present) {
      map['father_image'] = Variable<String>(fatherImage.value);
    }
    if (fatherNationality.present) {
      map['father_nationality'] = Variable<String>(fatherNationality.value);
    }
    if (motherName.present) {
      map['mother_name'] = Variable<String>(motherName.value);
    }
    if (motherMobile.present) {
      map['mother_mobile'] = Variable<String>(motherMobile.value);
    }
    if (motherProfession.present) {
      map['mother_profession'] = Variable<String>(motherProfession.value);
    }
    if (motherImage.present) {
      map['mother_image'] = Variable<String>(motherImage.value);
    }
    if (guardianName.present) {
      map['guardian_name'] = Variable<String>(guardianName.value);
    }
    if (guardianEmail.present) {
      map['guardian_email'] = Variable<String>(guardianEmail.value);
    }
    if (guardianMobile.present) {
      map['guardian_mobile'] = Variable<String>(guardianMobile.value);
    }
    if (guardianImage.present) {
      map['guardian_image'] = Variable<String>(guardianImage.value);
    }
    if (guardianProfession.present) {
      map['guardian_profession'] = Variable<String>(guardianProfession.value);
    }
    if (guardianRelation.present) {
      map['guardian_relation'] = Variable<String>(guardianRelation.value);
    }
    if (guardianAddress.present) {
      map['guardian_address'] = Variable<String>(guardianAddress.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParentDetailsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fatherName: $fatherName, ')
          ..write('fatherMobile: $fatherMobile, ')
          ..write('fatherProfession: $fatherProfession, ')
          ..write('fatherImage: $fatherImage, ')
          ..write('fatherNationality: $fatherNationality, ')
          ..write('motherName: $motherName, ')
          ..write('motherMobile: $motherMobile, ')
          ..write('motherProfession: $motherProfession, ')
          ..write('motherImage: $motherImage, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianEmail: $guardianEmail, ')
          ..write('guardianMobile: $guardianMobile, ')
          ..write('guardianImage: $guardianImage, ')
          ..write('guardianProfession: $guardianProfession, ')
          ..write('guardianRelation: $guardianRelation, ')
          ..write('guardianAddress: $guardianAddress, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NoticeBoardsTable extends NoticeBoards
    with TableInfo<$NoticeBoardsTable, NoticeBoard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoticeBoardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishDateMeta =
      const VerificationMeta('publishDate');
  @override
  late final GeneratedColumn<String> publishDate = GeneratedColumn<String>(
      'publish_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentMeta =
      const VerificationMeta('attachment');
  @override
  late final GeneratedColumn<String> attachment = GeneratedColumn<String>(
      'attachment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVisibleWebMeta =
      const VerificationMeta('isVisibleWeb');
  @override
  late final GeneratedColumn<int> isVisibleWeb = GeneratedColumn<int>(
      'is_visible_web', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _visibleToMeta =
      const VerificationMeta('visibleTo');
  @override
  late final GeneratedColumn<String> visibleTo = GeneratedColumn<String>(
      'visible_to', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        date,
        publishDate,
        description,
        attachment,
        isVisibleWeb,
        status,
        visibleTo,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notice_boards';
  @override
  VerificationContext validateIntegrity(Insertable<NoticeBoard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('publish_date')) {
      context.handle(
          _publishDateMeta,
          publishDate.isAcceptableOrUnknown(
              data['publish_date']!, _publishDateMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('attachment')) {
      context.handle(
          _attachmentMeta,
          attachment.isAcceptableOrUnknown(
              data['attachment']!, _attachmentMeta));
    }
    if (data.containsKey('is_visible_web')) {
      context.handle(
          _isVisibleWebMeta,
          isVisibleWeb.isAcceptableOrUnknown(
              data['is_visible_web']!, _isVisibleWebMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('visible_to')) {
      context.handle(_visibleToMeta,
          visibleTo.isAcceptableOrUnknown(data['visible_to']!, _visibleToMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoticeBoard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoticeBoard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      publishDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publish_date']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      attachment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachment']),
      isVisibleWeb: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_visible_web']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status']),
      visibleTo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visible_to']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $NoticeBoardsTable createAlias(String alias) {
    return $NoticeBoardsTable(attachedDatabase, alias);
  }
}

class NoticeBoard extends DataClass implements Insertable<NoticeBoard> {
  final int id;
  final String? title;
  final String? date;
  final String? publishDate;
  final String? description;
  final String? attachment;
  final int? isVisibleWeb;
  final int? status;
  final String? visibleTo;
  final String? createdAt;
  final String? updatedAt;
  const NoticeBoard(
      {required this.id,
      this.title,
      this.date,
      this.publishDate,
      this.description,
      this.attachment,
      this.isVisibleWeb,
      this.status,
      this.visibleTo,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || publishDate != null) {
      map['publish_date'] = Variable<String>(publishDate);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || attachment != null) {
      map['attachment'] = Variable<String>(attachment);
    }
    if (!nullToAbsent || isVisibleWeb != null) {
      map['is_visible_web'] = Variable<int>(isVisibleWeb);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || visibleTo != null) {
      map['visible_to'] = Variable<String>(visibleTo);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  NoticeBoardsCompanion toCompanion(bool nullToAbsent) {
    return NoticeBoardsCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      publishDate: publishDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publishDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      attachment: attachment == null && nullToAbsent
          ? const Value.absent()
          : Value(attachment),
      isVisibleWeb: isVisibleWeb == null && nullToAbsent
          ? const Value.absent()
          : Value(isVisibleWeb),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      visibleTo: visibleTo == null && nullToAbsent
          ? const Value.absent()
          : Value(visibleTo),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory NoticeBoard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoticeBoard(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      date: serializer.fromJson<String?>(json['date']),
      publishDate: serializer.fromJson<String?>(json['publishDate']),
      description: serializer.fromJson<String?>(json['description']),
      attachment: serializer.fromJson<String?>(json['attachment']),
      isVisibleWeb: serializer.fromJson<int?>(json['isVisibleWeb']),
      status: serializer.fromJson<int?>(json['status']),
      visibleTo: serializer.fromJson<String?>(json['visibleTo']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'date': serializer.toJson<String?>(date),
      'publishDate': serializer.toJson<String?>(publishDate),
      'description': serializer.toJson<String?>(description),
      'attachment': serializer.toJson<String?>(attachment),
      'isVisibleWeb': serializer.toJson<int?>(isVisibleWeb),
      'status': serializer.toJson<int?>(status),
      'visibleTo': serializer.toJson<String?>(visibleTo),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  NoticeBoard copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          Value<String?> date = const Value.absent(),
          Value<String?> publishDate = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> attachment = const Value.absent(),
          Value<int?> isVisibleWeb = const Value.absent(),
          Value<int?> status = const Value.absent(),
          Value<String?> visibleTo = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      NoticeBoard(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        date: date.present ? date.value : this.date,
        publishDate: publishDate.present ? publishDate.value : this.publishDate,
        description: description.present ? description.value : this.description,
        attachment: attachment.present ? attachment.value : this.attachment,
        isVisibleWeb:
            isVisibleWeb.present ? isVisibleWeb.value : this.isVisibleWeb,
        status: status.present ? status.value : this.status,
        visibleTo: visibleTo.present ? visibleTo.value : this.visibleTo,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  NoticeBoard copyWithCompanion(NoticeBoardsCompanion data) {
    return NoticeBoard(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      publishDate:
          data.publishDate.present ? data.publishDate.value : this.publishDate,
      description:
          data.description.present ? data.description.value : this.description,
      attachment:
          data.attachment.present ? data.attachment.value : this.attachment,
      isVisibleWeb: data.isVisibleWeb.present
          ? data.isVisibleWeb.value
          : this.isVisibleWeb,
      status: data.status.present ? data.status.value : this.status,
      visibleTo: data.visibleTo.present ? data.visibleTo.value : this.visibleTo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoticeBoard(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('publishDate: $publishDate, ')
          ..write('description: $description, ')
          ..write('attachment: $attachment, ')
          ..write('isVisibleWeb: $isVisibleWeb, ')
          ..write('status: $status, ')
          ..write('visibleTo: $visibleTo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, date, publishDate, description,
      attachment, isVisibleWeb, status, visibleTo, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoticeBoard &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date &&
          other.publishDate == this.publishDate &&
          other.description == this.description &&
          other.attachment == this.attachment &&
          other.isVisibleWeb == this.isVisibleWeb &&
          other.status == this.status &&
          other.visibleTo == this.visibleTo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NoticeBoardsCompanion extends UpdateCompanion<NoticeBoard> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> date;
  final Value<String?> publishDate;
  final Value<String?> description;
  final Value<String?> attachment;
  final Value<int?> isVisibleWeb;
  final Value<int?> status;
  final Value<String?> visibleTo;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const NoticeBoardsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.publishDate = const Value.absent(),
    this.description = const Value.absent(),
    this.attachment = const Value.absent(),
    this.isVisibleWeb = const Value.absent(),
    this.status = const Value.absent(),
    this.visibleTo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NoticeBoardsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.publishDate = const Value.absent(),
    this.description = const Value.absent(),
    this.attachment = const Value.absent(),
    this.isVisibleWeb = const Value.absent(),
    this.status = const Value.absent(),
    this.visibleTo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<NoticeBoard> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? date,
    Expression<String>? publishDate,
    Expression<String>? description,
    Expression<String>? attachment,
    Expression<int>? isVisibleWeb,
    Expression<int>? status,
    Expression<String>? visibleTo,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (publishDate != null) 'publish_date': publishDate,
      if (description != null) 'description': description,
      if (attachment != null) 'attachment': attachment,
      if (isVisibleWeb != null) 'is_visible_web': isVisibleWeb,
      if (status != null) 'status': status,
      if (visibleTo != null) 'visible_to': visibleTo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NoticeBoardsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String?>? date,
      Value<String?>? publishDate,
      Value<String?>? description,
      Value<String?>? attachment,
      Value<int?>? isVisibleWeb,
      Value<int?>? status,
      Value<String?>? visibleTo,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return NoticeBoardsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      publishDate: publishDate ?? this.publishDate,
      description: description ?? this.description,
      attachment: attachment ?? this.attachment,
      isVisibleWeb: isVisibleWeb ?? this.isVisibleWeb,
      status: status ?? this.status,
      visibleTo: visibleTo ?? this.visibleTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (publishDate.present) {
      map['publish_date'] = Variable<String>(publishDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (attachment.present) {
      map['attachment'] = Variable<String>(attachment.value);
    }
    if (isVisibleWeb.present) {
      map['is_visible_web'] = Variable<int>(isVisibleWeb.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (visibleTo.present) {
      map['visible_to'] = Variable<String>(visibleTo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoticeBoardsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('publishDate: $publishDate, ')
          ..write('description: $description, ')
          ..write('attachment: $attachment, ')
          ..write('isVisibleWeb: $isVisibleWeb, ')
          ..write('status: $status, ')
          ..write('visibleTo: $visibleTo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StudentsListTable extends StudentsList
    with TableInfo<$StudentsListTable, StudentsListData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsListTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _admissionNoMeta =
      const VerificationMeta('admissionNo');
  @override
  late final GeneratedColumn<String> admissionNo = GeneratedColumn<String>(
      'admission_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rollNoMeta = const VerificationMeta('rollNo');
  @override
  late final GeneratedColumn<int> rollNo = GeneratedColumn<int>(
      'roll_no', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
      'dob', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _admissionDateMeta =
      const VerificationMeta('admissionDate');
  @override
  late final GeneratedColumn<String> admissionDate = GeneratedColumn<String>(
      'admission_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _studentCategoryIdMeta =
      const VerificationMeta('studentCategoryId');
  @override
  late final GeneratedColumn<int> studentCategoryId = GeneratedColumn<int>(
      'student_category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _religionIdMeta =
      const VerificationMeta('religionId');
  @override
  late final GeneratedColumn<int> religionId = GeneratedColumn<int>(
      'religion_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bloodGroupIdMeta =
      const VerificationMeta('bloodGroupId');
  @override
  late final GeneratedColumn<int> bloodGroupId = GeneratedColumn<int>(
      'blood_group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _genderIdMeta =
      const VerificationMeta('genderId');
  @override
  late final GeneratedColumn<int> genderId = GeneratedColumn<int>(
      'gender_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _imageIdMeta =
      const VerificationMeta('imageId');
  @override
  late final GeneratedColumn<int> imageId = GeneratedColumn<int>(
      'image_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _parentGuardianIdMeta =
      const VerificationMeta('parentGuardianId');
  @override
  late final GeneratedColumn<int> parentGuardianId = GeneratedColumn<int>(
      'parent_guardian_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uploadDocumentsMeta =
      const VerificationMeta('uploadDocuments');
  @override
  late final GeneratedColumn<String> uploadDocuments = GeneratedColumn<String>(
      'upload_documents', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolMeta =
      const VerificationMeta('previousSchool');
  @override
  late final GeneratedColumn<int> previousSchool = GeneratedColumn<int>(
      'previous_school', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolInfoMeta =
      const VerificationMeta('previousSchoolInfo');
  @override
  late final GeneratedColumn<String> previousSchoolInfo =
      GeneratedColumn<String>('previous_school_info', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previousSchoolImageIdMeta =
      const VerificationMeta('previousSchoolImageId');
  @override
  late final GeneratedColumn<int> previousSchoolImageId = GeneratedColumn<int>(
      'previous_school_image_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _placeOfBirthMeta =
      const VerificationMeta('placeOfBirth');
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
      'place_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nationalityMeta =
      const VerificationMeta('nationality');
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
      'nationality', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cprNoMeta = const VerificationMeta('cprNo');
  @override
  late final GeneratedColumn<String> cprNo = GeneratedColumn<String>(
      'cpr_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _spokenLangAtHomeMeta =
      const VerificationMeta('spokenLangAtHome');
  @override
  late final GeneratedColumn<String> spokenLangAtHome = GeneratedColumn<String>(
      'spoken_lang_at_home', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _residanceAddressMeta =
      const VerificationMeta('residanceAddress');
  @override
  late final GeneratedColumn<String> residanceAddress = GeneratedColumn<String>(
      'residance_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _controlNumberMeta =
      const VerificationMeta('controlNumber');
  @override
  late final GeneratedColumn<String> controlNumber = GeneratedColumn<String>(
      'control_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _availableMeta =
      const VerificationMeta('available');
  @override
  late final GeneratedColumn<String> available = GeneratedColumn<String>(
      'available', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        admissionNo,
        rollNo,
        firstName,
        lastName,
        mobile,
        email,
        dob,
        admissionDate,
        studentCategoryId,
        religionId,
        bloodGroupId,
        genderId,
        categoryId,
        imageId,
        parentGuardianId,
        userId,
        uploadDocuments,
        status,
        previousSchool,
        previousSchoolInfo,
        previousSchoolImageId,
        placeOfBirth,
        nationality,
        cprNo,
        spokenLangAtHome,
        residanceAddress,
        controlNumber,
        available,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students_list';
  @override
  VerificationContext validateIntegrity(Insertable<StudentsListData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_no')) {
      context.handle(
          _admissionNoMeta,
          admissionNo.isAcceptableOrUnknown(
              data['admission_no']!, _admissionNoMeta));
    }
    if (data.containsKey('roll_no')) {
      context.handle(_rollNoMeta,
          rollNo.isAcceptableOrUnknown(data['roll_no']!, _rollNoMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('dob')) {
      context.handle(
          _dobMeta, dob.isAcceptableOrUnknown(data['dob']!, _dobMeta));
    }
    if (data.containsKey('admission_date')) {
      context.handle(
          _admissionDateMeta,
          admissionDate.isAcceptableOrUnknown(
              data['admission_date']!, _admissionDateMeta));
    }
    if (data.containsKey('student_category_id')) {
      context.handle(
          _studentCategoryIdMeta,
          studentCategoryId.isAcceptableOrUnknown(
              data['student_category_id']!, _studentCategoryIdMeta));
    }
    if (data.containsKey('religion_id')) {
      context.handle(
          _religionIdMeta,
          religionId.isAcceptableOrUnknown(
              data['religion_id']!, _religionIdMeta));
    }
    if (data.containsKey('blood_group_id')) {
      context.handle(
          _bloodGroupIdMeta,
          bloodGroupId.isAcceptableOrUnknown(
              data['blood_group_id']!, _bloodGroupIdMeta));
    }
    if (data.containsKey('gender_id')) {
      context.handle(_genderIdMeta,
          genderId.isAcceptableOrUnknown(data['gender_id']!, _genderIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('image_id')) {
      context.handle(_imageIdMeta,
          imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta));
    }
    if (data.containsKey('parent_guardian_id')) {
      context.handle(
          _parentGuardianIdMeta,
          parentGuardianId.isAcceptableOrUnknown(
              data['parent_guardian_id']!, _parentGuardianIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('upload_documents')) {
      context.handle(
          _uploadDocumentsMeta,
          uploadDocuments.isAcceptableOrUnknown(
              data['upload_documents']!, _uploadDocumentsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('previous_school')) {
      context.handle(
          _previousSchoolMeta,
          previousSchool.isAcceptableOrUnknown(
              data['previous_school']!, _previousSchoolMeta));
    }
    if (data.containsKey('previous_school_info')) {
      context.handle(
          _previousSchoolInfoMeta,
          previousSchoolInfo.isAcceptableOrUnknown(
              data['previous_school_info']!, _previousSchoolInfoMeta));
    }
    if (data.containsKey('previous_school_image_id')) {
      context.handle(
          _previousSchoolImageIdMeta,
          previousSchoolImageId.isAcceptableOrUnknown(
              data['previous_school_image_id']!, _previousSchoolImageIdMeta));
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
          _placeOfBirthMeta,
          placeOfBirth.isAcceptableOrUnknown(
              data['place_of_birth']!, _placeOfBirthMeta));
    }
    if (data.containsKey('nationality')) {
      context.handle(
          _nationalityMeta,
          nationality.isAcceptableOrUnknown(
              data['nationality']!, _nationalityMeta));
    }
    if (data.containsKey('cpr_no')) {
      context.handle(
          _cprNoMeta, cprNo.isAcceptableOrUnknown(data['cpr_no']!, _cprNoMeta));
    }
    if (data.containsKey('spoken_lang_at_home')) {
      context.handle(
          _spokenLangAtHomeMeta,
          spokenLangAtHome.isAcceptableOrUnknown(
              data['spoken_lang_at_home']!, _spokenLangAtHomeMeta));
    }
    if (data.containsKey('residance_address')) {
      context.handle(
          _residanceAddressMeta,
          residanceAddress.isAcceptableOrUnknown(
              data['residance_address']!, _residanceAddressMeta));
    }
    if (data.containsKey('control_number')) {
      context.handle(
          _controlNumberMeta,
          controlNumber.isAcceptableOrUnknown(
              data['control_number']!, _controlNumberMeta));
    }
    if (data.containsKey('available')) {
      context.handle(_availableMeta,
          available.isAcceptableOrUnknown(data['available']!, _availableMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentsListData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentsListData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      admissionNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}admission_no']),
      rollNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}roll_no']),
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      dob: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dob']),
      admissionDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}admission_date']),
      studentCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}student_category_id']),
      religionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}religion_id']),
      bloodGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}blood_group_id']),
      genderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      imageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}image_id']),
      parentGuardianId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_guardian_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      uploadDocuments: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}upload_documents']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status']),
      previousSchool: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}previous_school']),
      previousSchoolInfo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}previous_school_info']),
      previousSchoolImageId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}previous_school_image_id']),
      placeOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_of_birth']),
      nationality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nationality']),
      cprNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpr_no']),
      spokenLangAtHome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}spoken_lang_at_home']),
      residanceAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}residance_address']),
      controlNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}control_number']),
      available: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}available']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $StudentsListTable createAlias(String alias) {
    return $StudentsListTable(attachedDatabase, alias);
  }
}

class StudentsListData extends DataClass
    implements Insertable<StudentsListData> {
  final int id;
  final String? admissionNo;
  final int? rollNo;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? dob;
  final String? admissionDate;
  final int? studentCategoryId;
  final int? religionId;
  final int? bloodGroupId;
  final int? genderId;
  final int? categoryId;
  final int? imageId;
  final int? parentGuardianId;
  final int? userId;
  final String? uploadDocuments;
  final int? status;
  final int? previousSchool;
  final String? previousSchoolInfo;
  final int? previousSchoolImageId;
  final String? placeOfBirth;
  final String? nationality;
  final String? cprNo;
  final String? spokenLangAtHome;
  final String? residanceAddress;
  final String? controlNumber;
  final String? available;
  final String? createdAt;
  final String? updatedAt;
  const StudentsListData(
      {required this.id,
      this.admissionNo,
      this.rollNo,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.dob,
      this.admissionDate,
      this.studentCategoryId,
      this.religionId,
      this.bloodGroupId,
      this.genderId,
      this.categoryId,
      this.imageId,
      this.parentGuardianId,
      this.userId,
      this.uploadDocuments,
      this.status,
      this.previousSchool,
      this.previousSchoolInfo,
      this.previousSchoolImageId,
      this.placeOfBirth,
      this.nationality,
      this.cprNo,
      this.spokenLangAtHome,
      this.residanceAddress,
      this.controlNumber,
      this.available,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || admissionNo != null) {
      map['admission_no'] = Variable<String>(admissionNo);
    }
    if (!nullToAbsent || rollNo != null) {
      map['roll_no'] = Variable<int>(rollNo);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<String>(dob);
    }
    if (!nullToAbsent || admissionDate != null) {
      map['admission_date'] = Variable<String>(admissionDate);
    }
    if (!nullToAbsent || studentCategoryId != null) {
      map['student_category_id'] = Variable<int>(studentCategoryId);
    }
    if (!nullToAbsent || religionId != null) {
      map['religion_id'] = Variable<int>(religionId);
    }
    if (!nullToAbsent || bloodGroupId != null) {
      map['blood_group_id'] = Variable<int>(bloodGroupId);
    }
    if (!nullToAbsent || genderId != null) {
      map['gender_id'] = Variable<int>(genderId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || imageId != null) {
      map['image_id'] = Variable<int>(imageId);
    }
    if (!nullToAbsent || parentGuardianId != null) {
      map['parent_guardian_id'] = Variable<int>(parentGuardianId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || uploadDocuments != null) {
      map['upload_documents'] = Variable<String>(uploadDocuments);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    if (!nullToAbsent || previousSchool != null) {
      map['previous_school'] = Variable<int>(previousSchool);
    }
    if (!nullToAbsent || previousSchoolInfo != null) {
      map['previous_school_info'] = Variable<String>(previousSchoolInfo);
    }
    if (!nullToAbsent || previousSchoolImageId != null) {
      map['previous_school_image_id'] = Variable<int>(previousSchoolImageId);
    }
    if (!nullToAbsent || placeOfBirth != null) {
      map['place_of_birth'] = Variable<String>(placeOfBirth);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || cprNo != null) {
      map['cpr_no'] = Variable<String>(cprNo);
    }
    if (!nullToAbsent || spokenLangAtHome != null) {
      map['spoken_lang_at_home'] = Variable<String>(spokenLangAtHome);
    }
    if (!nullToAbsent || residanceAddress != null) {
      map['residance_address'] = Variable<String>(residanceAddress);
    }
    if (!nullToAbsent || controlNumber != null) {
      map['control_number'] = Variable<String>(controlNumber);
    }
    if (!nullToAbsent || available != null) {
      map['available'] = Variable<String>(available);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  StudentsListCompanion toCompanion(bool nullToAbsent) {
    return StudentsListCompanion(
      id: Value(id),
      admissionNo: admissionNo == null && nullToAbsent
          ? const Value.absent()
          : Value(admissionNo),
      rollNo:
          rollNo == null && nullToAbsent ? const Value.absent() : Value(rollNo),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      admissionDate: admissionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(admissionDate),
      studentCategoryId: studentCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentCategoryId),
      religionId: religionId == null && nullToAbsent
          ? const Value.absent()
          : Value(religionId),
      bloodGroupId: bloodGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroupId),
      genderId: genderId == null && nullToAbsent
          ? const Value.absent()
          : Value(genderId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageId: imageId == null && nullToAbsent
          ? const Value.absent()
          : Value(imageId),
      parentGuardianId: parentGuardianId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentGuardianId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      uploadDocuments: uploadDocuments == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadDocuments),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      previousSchool: previousSchool == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchool),
      previousSchoolInfo: previousSchoolInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchoolInfo),
      previousSchoolImageId: previousSchoolImageId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousSchoolImageId),
      placeOfBirth: placeOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfBirth),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      cprNo:
          cprNo == null && nullToAbsent ? const Value.absent() : Value(cprNo),
      spokenLangAtHome: spokenLangAtHome == null && nullToAbsent
          ? const Value.absent()
          : Value(spokenLangAtHome),
      residanceAddress: residanceAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(residanceAddress),
      controlNumber: controlNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(controlNumber),
      available: available == null && nullToAbsent
          ? const Value.absent()
          : Value(available),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory StudentsListData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentsListData(
      id: serializer.fromJson<int>(json['id']),
      admissionNo: serializer.fromJson<String?>(json['admissionNo']),
      rollNo: serializer.fromJson<int?>(json['rollNo']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      dob: serializer.fromJson<String?>(json['dob']),
      admissionDate: serializer.fromJson<String?>(json['admissionDate']),
      studentCategoryId: serializer.fromJson<int?>(json['studentCategoryId']),
      religionId: serializer.fromJson<int?>(json['religionId']),
      bloodGroupId: serializer.fromJson<int?>(json['bloodGroupId']),
      genderId: serializer.fromJson<int?>(json['genderId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      imageId: serializer.fromJson<int?>(json['imageId']),
      parentGuardianId: serializer.fromJson<int?>(json['parentGuardianId']),
      userId: serializer.fromJson<int?>(json['userId']),
      uploadDocuments: serializer.fromJson<String?>(json['uploadDocuments']),
      status: serializer.fromJson<int?>(json['status']),
      previousSchool: serializer.fromJson<int?>(json['previousSchool']),
      previousSchoolInfo:
          serializer.fromJson<String?>(json['previousSchoolInfo']),
      previousSchoolImageId:
          serializer.fromJson<int?>(json['previousSchoolImageId']),
      placeOfBirth: serializer.fromJson<String?>(json['placeOfBirth']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      cprNo: serializer.fromJson<String?>(json['cprNo']),
      spokenLangAtHome: serializer.fromJson<String?>(json['spokenLangAtHome']),
      residanceAddress: serializer.fromJson<String?>(json['residanceAddress']),
      controlNumber: serializer.fromJson<String?>(json['controlNumber']),
      available: serializer.fromJson<String?>(json['available']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionNo': serializer.toJson<String?>(admissionNo),
      'rollNo': serializer.toJson<int?>(rollNo),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'dob': serializer.toJson<String?>(dob),
      'admissionDate': serializer.toJson<String?>(admissionDate),
      'studentCategoryId': serializer.toJson<int?>(studentCategoryId),
      'religionId': serializer.toJson<int?>(religionId),
      'bloodGroupId': serializer.toJson<int?>(bloodGroupId),
      'genderId': serializer.toJson<int?>(genderId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'imageId': serializer.toJson<int?>(imageId),
      'parentGuardianId': serializer.toJson<int?>(parentGuardianId),
      'userId': serializer.toJson<int?>(userId),
      'uploadDocuments': serializer.toJson<String?>(uploadDocuments),
      'status': serializer.toJson<int?>(status),
      'previousSchool': serializer.toJson<int?>(previousSchool),
      'previousSchoolInfo': serializer.toJson<String?>(previousSchoolInfo),
      'previousSchoolImageId': serializer.toJson<int?>(previousSchoolImageId),
      'placeOfBirth': serializer.toJson<String?>(placeOfBirth),
      'nationality': serializer.toJson<String?>(nationality),
      'cprNo': serializer.toJson<String?>(cprNo),
      'spokenLangAtHome': serializer.toJson<String?>(spokenLangAtHome),
      'residanceAddress': serializer.toJson<String?>(residanceAddress),
      'controlNumber': serializer.toJson<String?>(controlNumber),
      'available': serializer.toJson<String?>(available),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  StudentsListData copyWith(
          {int? id,
          Value<String?> admissionNo = const Value.absent(),
          Value<int?> rollNo = const Value.absent(),
          Value<String?> firstName = const Value.absent(),
          Value<String?> lastName = const Value.absent(),
          Value<String?> mobile = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> dob = const Value.absent(),
          Value<String?> admissionDate = const Value.absent(),
          Value<int?> studentCategoryId = const Value.absent(),
          Value<int?> religionId = const Value.absent(),
          Value<int?> bloodGroupId = const Value.absent(),
          Value<int?> genderId = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          Value<int?> imageId = const Value.absent(),
          Value<int?> parentGuardianId = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          Value<String?> uploadDocuments = const Value.absent(),
          Value<int?> status = const Value.absent(),
          Value<int?> previousSchool = const Value.absent(),
          Value<String?> previousSchoolInfo = const Value.absent(),
          Value<int?> previousSchoolImageId = const Value.absent(),
          Value<String?> placeOfBirth = const Value.absent(),
          Value<String?> nationality = const Value.absent(),
          Value<String?> cprNo = const Value.absent(),
          Value<String?> spokenLangAtHome = const Value.absent(),
          Value<String?> residanceAddress = const Value.absent(),
          Value<String?> controlNumber = const Value.absent(),
          Value<String?> available = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      StudentsListData(
        id: id ?? this.id,
        admissionNo: admissionNo.present ? admissionNo.value : this.admissionNo,
        rollNo: rollNo.present ? rollNo.value : this.rollNo,
        firstName: firstName.present ? firstName.value : this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        mobile: mobile.present ? mobile.value : this.mobile,
        email: email.present ? email.value : this.email,
        dob: dob.present ? dob.value : this.dob,
        admissionDate:
            admissionDate.present ? admissionDate.value : this.admissionDate,
        studentCategoryId: studentCategoryId.present
            ? studentCategoryId.value
            : this.studentCategoryId,
        religionId: religionId.present ? religionId.value : this.religionId,
        bloodGroupId:
            bloodGroupId.present ? bloodGroupId.value : this.bloodGroupId,
        genderId: genderId.present ? genderId.value : this.genderId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        imageId: imageId.present ? imageId.value : this.imageId,
        parentGuardianId: parentGuardianId.present
            ? parentGuardianId.value
            : this.parentGuardianId,
        userId: userId.present ? userId.value : this.userId,
        uploadDocuments: uploadDocuments.present
            ? uploadDocuments.value
            : this.uploadDocuments,
        status: status.present ? status.value : this.status,
        previousSchool:
            previousSchool.present ? previousSchool.value : this.previousSchool,
        previousSchoolInfo: previousSchoolInfo.present
            ? previousSchoolInfo.value
            : this.previousSchoolInfo,
        previousSchoolImageId: previousSchoolImageId.present
            ? previousSchoolImageId.value
            : this.previousSchoolImageId,
        placeOfBirth:
            placeOfBirth.present ? placeOfBirth.value : this.placeOfBirth,
        nationality: nationality.present ? nationality.value : this.nationality,
        cprNo: cprNo.present ? cprNo.value : this.cprNo,
        spokenLangAtHome: spokenLangAtHome.present
            ? spokenLangAtHome.value
            : this.spokenLangAtHome,
        residanceAddress: residanceAddress.present
            ? residanceAddress.value
            : this.residanceAddress,
        controlNumber:
            controlNumber.present ? controlNumber.value : this.controlNumber,
        available: available.present ? available.value : this.available,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  StudentsListData copyWithCompanion(StudentsListCompanion data) {
    return StudentsListData(
      id: data.id.present ? data.id.value : this.id,
      admissionNo:
          data.admissionNo.present ? data.admissionNo.value : this.admissionNo,
      rollNo: data.rollNo.present ? data.rollNo.value : this.rollNo,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      dob: data.dob.present ? data.dob.value : this.dob,
      admissionDate: data.admissionDate.present
          ? data.admissionDate.value
          : this.admissionDate,
      studentCategoryId: data.studentCategoryId.present
          ? data.studentCategoryId.value
          : this.studentCategoryId,
      religionId:
          data.religionId.present ? data.religionId.value : this.religionId,
      bloodGroupId: data.bloodGroupId.present
          ? data.bloodGroupId.value
          : this.bloodGroupId,
      genderId: data.genderId.present ? data.genderId.value : this.genderId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      parentGuardianId: data.parentGuardianId.present
          ? data.parentGuardianId.value
          : this.parentGuardianId,
      userId: data.userId.present ? data.userId.value : this.userId,
      uploadDocuments: data.uploadDocuments.present
          ? data.uploadDocuments.value
          : this.uploadDocuments,
      status: data.status.present ? data.status.value : this.status,
      previousSchool: data.previousSchool.present
          ? data.previousSchool.value
          : this.previousSchool,
      previousSchoolInfo: data.previousSchoolInfo.present
          ? data.previousSchoolInfo.value
          : this.previousSchoolInfo,
      previousSchoolImageId: data.previousSchoolImageId.present
          ? data.previousSchoolImageId.value
          : this.previousSchoolImageId,
      placeOfBirth: data.placeOfBirth.present
          ? data.placeOfBirth.value
          : this.placeOfBirth,
      nationality:
          data.nationality.present ? data.nationality.value : this.nationality,
      cprNo: data.cprNo.present ? data.cprNo.value : this.cprNo,
      spokenLangAtHome: data.spokenLangAtHome.present
          ? data.spokenLangAtHome.value
          : this.spokenLangAtHome,
      residanceAddress: data.residanceAddress.present
          ? data.residanceAddress.value
          : this.residanceAddress,
      controlNumber: data.controlNumber.present
          ? data.controlNumber.value
          : this.controlNumber,
      available: data.available.present ? data.available.value : this.available,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentsListData(')
          ..write('id: $id, ')
          ..write('admissionNo: $admissionNo, ')
          ..write('rollNo: $rollNo, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('dob: $dob, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('studentCategoryId: $studentCategoryId, ')
          ..write('religionId: $religionId, ')
          ..write('bloodGroupId: $bloodGroupId, ')
          ..write('genderId: $genderId, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageId: $imageId, ')
          ..write('parentGuardianId: $parentGuardianId, ')
          ..write('userId: $userId, ')
          ..write('uploadDocuments: $uploadDocuments, ')
          ..write('status: $status, ')
          ..write('previousSchool: $previousSchool, ')
          ..write('previousSchoolInfo: $previousSchoolInfo, ')
          ..write('previousSchoolImageId: $previousSchoolImageId, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('cprNo: $cprNo, ')
          ..write('spokenLangAtHome: $spokenLangAtHome, ')
          ..write('residanceAddress: $residanceAddress, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('available: $available, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        admissionNo,
        rollNo,
        firstName,
        lastName,
        mobile,
        email,
        dob,
        admissionDate,
        studentCategoryId,
        religionId,
        bloodGroupId,
        genderId,
        categoryId,
        imageId,
        parentGuardianId,
        userId,
        uploadDocuments,
        status,
        previousSchool,
        previousSchoolInfo,
        previousSchoolImageId,
        placeOfBirth,
        nationality,
        cprNo,
        spokenLangAtHome,
        residanceAddress,
        controlNumber,
        available,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentsListData &&
          other.id == this.id &&
          other.admissionNo == this.admissionNo &&
          other.rollNo == this.rollNo &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.dob == this.dob &&
          other.admissionDate == this.admissionDate &&
          other.studentCategoryId == this.studentCategoryId &&
          other.religionId == this.religionId &&
          other.bloodGroupId == this.bloodGroupId &&
          other.genderId == this.genderId &&
          other.categoryId == this.categoryId &&
          other.imageId == this.imageId &&
          other.parentGuardianId == this.parentGuardianId &&
          other.userId == this.userId &&
          other.uploadDocuments == this.uploadDocuments &&
          other.status == this.status &&
          other.previousSchool == this.previousSchool &&
          other.previousSchoolInfo == this.previousSchoolInfo &&
          other.previousSchoolImageId == this.previousSchoolImageId &&
          other.placeOfBirth == this.placeOfBirth &&
          other.nationality == this.nationality &&
          other.cprNo == this.cprNo &&
          other.spokenLangAtHome == this.spokenLangAtHome &&
          other.residanceAddress == this.residanceAddress &&
          other.controlNumber == this.controlNumber &&
          other.available == this.available &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StudentsListCompanion extends UpdateCompanion<StudentsListData> {
  final Value<int> id;
  final Value<String?> admissionNo;
  final Value<int?> rollNo;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> dob;
  final Value<String?> admissionDate;
  final Value<int?> studentCategoryId;
  final Value<int?> religionId;
  final Value<int?> bloodGroupId;
  final Value<int?> genderId;
  final Value<int?> categoryId;
  final Value<int?> imageId;
  final Value<int?> parentGuardianId;
  final Value<int?> userId;
  final Value<String?> uploadDocuments;
  final Value<int?> status;
  final Value<int?> previousSchool;
  final Value<String?> previousSchoolInfo;
  final Value<int?> previousSchoolImageId;
  final Value<String?> placeOfBirth;
  final Value<String?> nationality;
  final Value<String?> cprNo;
  final Value<String?> spokenLangAtHome;
  final Value<String?> residanceAddress;
  final Value<String?> controlNumber;
  final Value<String?> available;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const StudentsListCompanion({
    this.id = const Value.absent(),
    this.admissionNo = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.dob = const Value.absent(),
    this.admissionDate = const Value.absent(),
    this.studentCategoryId = const Value.absent(),
    this.religionId = const Value.absent(),
    this.bloodGroupId = const Value.absent(),
    this.genderId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageId = const Value.absent(),
    this.parentGuardianId = const Value.absent(),
    this.userId = const Value.absent(),
    this.uploadDocuments = const Value.absent(),
    this.status = const Value.absent(),
    this.previousSchool = const Value.absent(),
    this.previousSchoolInfo = const Value.absent(),
    this.previousSchoolImageId = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.cprNo = const Value.absent(),
    this.spokenLangAtHome = const Value.absent(),
    this.residanceAddress = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.available = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StudentsListCompanion.insert({
    this.id = const Value.absent(),
    this.admissionNo = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.dob = const Value.absent(),
    this.admissionDate = const Value.absent(),
    this.studentCategoryId = const Value.absent(),
    this.religionId = const Value.absent(),
    this.bloodGroupId = const Value.absent(),
    this.genderId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageId = const Value.absent(),
    this.parentGuardianId = const Value.absent(),
    this.userId = const Value.absent(),
    this.uploadDocuments = const Value.absent(),
    this.status = const Value.absent(),
    this.previousSchool = const Value.absent(),
    this.previousSchoolInfo = const Value.absent(),
    this.previousSchoolImageId = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.nationality = const Value.absent(),
    this.cprNo = const Value.absent(),
    this.spokenLangAtHome = const Value.absent(),
    this.residanceAddress = const Value.absent(),
    this.controlNumber = const Value.absent(),
    this.available = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<StudentsListData> custom({
    Expression<int>? id,
    Expression<String>? admissionNo,
    Expression<int>? rollNo,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? dob,
    Expression<String>? admissionDate,
    Expression<int>? studentCategoryId,
    Expression<int>? religionId,
    Expression<int>? bloodGroupId,
    Expression<int>? genderId,
    Expression<int>? categoryId,
    Expression<int>? imageId,
    Expression<int>? parentGuardianId,
    Expression<int>? userId,
    Expression<String>? uploadDocuments,
    Expression<int>? status,
    Expression<int>? previousSchool,
    Expression<String>? previousSchoolInfo,
    Expression<int>? previousSchoolImageId,
    Expression<String>? placeOfBirth,
    Expression<String>? nationality,
    Expression<String>? cprNo,
    Expression<String>? spokenLangAtHome,
    Expression<String>? residanceAddress,
    Expression<String>? controlNumber,
    Expression<String>? available,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionNo != null) 'admission_no': admissionNo,
      if (rollNo != null) 'roll_no': rollNo,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (dob != null) 'dob': dob,
      if (admissionDate != null) 'admission_date': admissionDate,
      if (studentCategoryId != null) 'student_category_id': studentCategoryId,
      if (religionId != null) 'religion_id': religionId,
      if (bloodGroupId != null) 'blood_group_id': bloodGroupId,
      if (genderId != null) 'gender_id': genderId,
      if (categoryId != null) 'category_id': categoryId,
      if (imageId != null) 'image_id': imageId,
      if (parentGuardianId != null) 'parent_guardian_id': parentGuardianId,
      if (userId != null) 'user_id': userId,
      if (uploadDocuments != null) 'upload_documents': uploadDocuments,
      if (status != null) 'status': status,
      if (previousSchool != null) 'previous_school': previousSchool,
      if (previousSchoolInfo != null)
        'previous_school_info': previousSchoolInfo,
      if (previousSchoolImageId != null)
        'previous_school_image_id': previousSchoolImageId,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (nationality != null) 'nationality': nationality,
      if (cprNo != null) 'cpr_no': cprNo,
      if (spokenLangAtHome != null) 'spoken_lang_at_home': spokenLangAtHome,
      if (residanceAddress != null) 'residance_address': residanceAddress,
      if (controlNumber != null) 'control_number': controlNumber,
      if (available != null) 'available': available,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StudentsListCompanion copyWith(
      {Value<int>? id,
      Value<String?>? admissionNo,
      Value<int?>? rollNo,
      Value<String?>? firstName,
      Value<String?>? lastName,
      Value<String?>? mobile,
      Value<String?>? email,
      Value<String?>? dob,
      Value<String?>? admissionDate,
      Value<int?>? studentCategoryId,
      Value<int?>? religionId,
      Value<int?>? bloodGroupId,
      Value<int?>? genderId,
      Value<int?>? categoryId,
      Value<int?>? imageId,
      Value<int?>? parentGuardianId,
      Value<int?>? userId,
      Value<String?>? uploadDocuments,
      Value<int?>? status,
      Value<int?>? previousSchool,
      Value<String?>? previousSchoolInfo,
      Value<int?>? previousSchoolImageId,
      Value<String?>? placeOfBirth,
      Value<String?>? nationality,
      Value<String?>? cprNo,
      Value<String?>? spokenLangAtHome,
      Value<String?>? residanceAddress,
      Value<String?>? controlNumber,
      Value<String?>? available,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return StudentsListCompanion(
      id: id ?? this.id,
      admissionNo: admissionNo ?? this.admissionNo,
      rollNo: rollNo ?? this.rollNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      admissionDate: admissionDate ?? this.admissionDate,
      studentCategoryId: studentCategoryId ?? this.studentCategoryId,
      religionId: religionId ?? this.religionId,
      bloodGroupId: bloodGroupId ?? this.bloodGroupId,
      genderId: genderId ?? this.genderId,
      categoryId: categoryId ?? this.categoryId,
      imageId: imageId ?? this.imageId,
      parentGuardianId: parentGuardianId ?? this.parentGuardianId,
      userId: userId ?? this.userId,
      uploadDocuments: uploadDocuments ?? this.uploadDocuments,
      status: status ?? this.status,
      previousSchool: previousSchool ?? this.previousSchool,
      previousSchoolInfo: previousSchoolInfo ?? this.previousSchoolInfo,
      previousSchoolImageId:
          previousSchoolImageId ?? this.previousSchoolImageId,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      nationality: nationality ?? this.nationality,
      cprNo: cprNo ?? this.cprNo,
      spokenLangAtHome: spokenLangAtHome ?? this.spokenLangAtHome,
      residanceAddress: residanceAddress ?? this.residanceAddress,
      controlNumber: controlNumber ?? this.controlNumber,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionNo.present) {
      map['admission_no'] = Variable<String>(admissionNo.value);
    }
    if (rollNo.present) {
      map['roll_no'] = Variable<int>(rollNo.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (admissionDate.present) {
      map['admission_date'] = Variable<String>(admissionDate.value);
    }
    if (studentCategoryId.present) {
      map['student_category_id'] = Variable<int>(studentCategoryId.value);
    }
    if (religionId.present) {
      map['religion_id'] = Variable<int>(religionId.value);
    }
    if (bloodGroupId.present) {
      map['blood_group_id'] = Variable<int>(bloodGroupId.value);
    }
    if (genderId.present) {
      map['gender_id'] = Variable<int>(genderId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (parentGuardianId.present) {
      map['parent_guardian_id'] = Variable<int>(parentGuardianId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (uploadDocuments.present) {
      map['upload_documents'] = Variable<String>(uploadDocuments.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (previousSchool.present) {
      map['previous_school'] = Variable<int>(previousSchool.value);
    }
    if (previousSchoolInfo.present) {
      map['previous_school_info'] = Variable<String>(previousSchoolInfo.value);
    }
    if (previousSchoolImageId.present) {
      map['previous_school_image_id'] =
          Variable<int>(previousSchoolImageId.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (cprNo.present) {
      map['cpr_no'] = Variable<String>(cprNo.value);
    }
    if (spokenLangAtHome.present) {
      map['spoken_lang_at_home'] = Variable<String>(spokenLangAtHome.value);
    }
    if (residanceAddress.present) {
      map['residance_address'] = Variable<String>(residanceAddress.value);
    }
    if (controlNumber.present) {
      map['control_number'] = Variable<String>(controlNumber.value);
    }
    if (available.present) {
      map['available'] = Variable<String>(available.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsListCompanion(')
          ..write('id: $id, ')
          ..write('admissionNo: $admissionNo, ')
          ..write('rollNo: $rollNo, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('dob: $dob, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('studentCategoryId: $studentCategoryId, ')
          ..write('religionId: $religionId, ')
          ..write('bloodGroupId: $bloodGroupId, ')
          ..write('genderId: $genderId, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageId: $imageId, ')
          ..write('parentGuardianId: $parentGuardianId, ')
          ..write('userId: $userId, ')
          ..write('uploadDocuments: $uploadDocuments, ')
          ..write('status: $status, ')
          ..write('previousSchool: $previousSchool, ')
          ..write('previousSchoolInfo: $previousSchoolInfo, ')
          ..write('previousSchoolImageId: $previousSchoolImageId, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('nationality: $nationality, ')
          ..write('cprNo: $cprNo, ')
          ..write('spokenLangAtHome: $spokenLangAtHome, ')
          ..write('residanceAddress: $residanceAddress, ')
          ..write('controlNumber: $controlNumber, ')
          ..write('available: $available, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StatusTable extends Status with TableInfo<$StatusTable, StatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'status';
  @override
  VerificationContext validateIntegrity(Insertable<StatusData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatusData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $StatusTable createAlias(String alias) {
    return $StatusTable(attachedDatabase, alias);
  }
}

class StatusData extends DataClass implements Insertable<StatusData> {
  final int id;
  final String name;
  final String? createdAt;
  final String? updatedAt;
  const StatusData(
      {required this.id, required this.name, this.createdAt, this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  StatusCompanion toCompanion(bool nullToAbsent) {
    return StatusCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory StatusData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatusData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  StatusData copyWith(
          {int? id,
          String? name,
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      StatusData(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  StatusData copyWithCompanion(StatusCompanion data) {
    return StatusData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatusData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StatusCompanion extends UpdateCompanion<StatusData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const StatusCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StatusCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<StatusData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StatusCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return StatusCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatusCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LoanStatusTable extends LoanStatus
    with TableInfo<$LoanStatusTable, LoanStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<String> loanId = GeneratedColumn<String>(
      'loan_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientNameMeta =
      const VerificationMeta('clientName');
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
      'client_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, loanId, status, description, clientName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_status';
  @override
  VerificationContext validateIntegrity(Insertable<LoanStatusData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(_loanIdMeta,
          loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('client_name')) {
      context.handle(
          _clientNameMeta,
          clientName.isAcceptableOrUnknown(
              data['client_name']!, _clientNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanStatusData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      loanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loan_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      clientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $LoanStatusTable createAlias(String alias) {
    return $LoanStatusTable(attachedDatabase, alias);
  }
}

class LoanStatusData extends DataClass implements Insertable<LoanStatusData> {
  final int id;
  final String? loanId;
  final String? status;
  final String? description;
  final String? clientName;
  final String? createdAt;
  final String? updatedAt;
  const LoanStatusData(
      {required this.id,
      this.loanId,
      this.status,
      this.description,
      this.clientName,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || loanId != null) {
      map['loan_id'] = Variable<String>(loanId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  LoanStatusCompanion toCompanion(bool nullToAbsent) {
    return LoanStatusCompanion(
      id: Value(id),
      loanId:
          loanId == null && nullToAbsent ? const Value.absent() : Value(loanId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LoanStatusData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanStatusData(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<String?>(json['loanId']),
      status: serializer.fromJson<String?>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<String?>(loanId),
      'status': serializer.toJson<String?>(status),
      'description': serializer.toJson<String?>(description),
      'clientName': serializer.toJson<String?>(clientName),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  LoanStatusData copyWith(
          {int? id,
          Value<String?> loanId = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> clientName = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      LoanStatusData(
        id: id ?? this.id,
        loanId: loanId.present ? loanId.value : this.loanId,
        status: status.present ? status.value : this.status,
        description: description.present ? description.value : this.description,
        clientName: clientName.present ? clientName.value : this.clientName,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  LoanStatusData copyWithCompanion(LoanStatusCompanion data) {
    return LoanStatusData(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      status: data.status.present ? data.status.value : this.status,
      description:
          data.description.present ? data.description.value : this.description,
      clientName:
          data.clientName.present ? data.clientName.value : this.clientName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanStatusData(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('clientName: $clientName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, loanId, status, description, clientName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanStatusData &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.status == this.status &&
          other.description == this.description &&
          other.clientName == this.clientName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LoanStatusCompanion extends UpdateCompanion<LoanStatusData> {
  final Value<int> id;
  final Value<String?> loanId;
  final Value<String?> status;
  final Value<String?> description;
  final Value<String?> clientName;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const LoanStatusCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.clientName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LoanStatusCompanion.insert({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.clientName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<LoanStatusData> custom({
    Expression<int>? id,
    Expression<String>? loanId,
    Expression<String>? status,
    Expression<String>? description,
    Expression<String>? clientName,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (clientName != null) 'client_name': clientName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LoanStatusCompanion copyWith(
      {Value<int>? id,
      Value<String?>? loanId,
      Value<String?>? status,
      Value<String?>? description,
      Value<String?>? clientName,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return LoanStatusCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      status: status ?? this.status,
      description: description ?? this.description,
      clientName: clientName ?? this.clientName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<String>(loanId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanStatusCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('clientName: $clientName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LoanScheduleTable extends LoanSchedule
    with TableInfo<$LoanScheduleTable, LoanScheduleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanScheduleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
      'loan_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fromDateMeta =
      const VerificationMeta('fromDate');
  @override
  late final GeneratedColumn<String> fromDate = GeneratedColumn<String>(
      'fromdate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'duedate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _installmentMeta =
      const VerificationMeta('installment');
  @override
  late final GeneratedColumn<int> installment = GeneratedColumn<int>(
      'installment', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountToBePaidMeta =
      const VerificationMeta('totalAmountToBePaid');
  @override
  late final GeneratedColumn<double> totalAmountToBePaid =
      GeneratedColumn<double>('total_amount_to_be_paid', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _remainedAmountMeta =
      const VerificationMeta('remainedAmount');
  @override
  late final GeneratedColumn<double> remainedAmount = GeneratedColumn<double>(
      'remained_amount', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _completedDerivedMeta =
      const VerificationMeta('completedDerived');
  @override
  late final GeneratedColumn<int> completedDerived = GeneratedColumn<int>(
      'completed_derived', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        loanId,
        fromDate,
        dueDate,
        installment,
        totalAmountToBePaid,
        totalAmount,
        paidAmount,
        remainedAmount,
        completedDerived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_schedule';
  @override
  VerificationContext validateIntegrity(Insertable<LoanScheduleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(_loanIdMeta,
          loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta));
    }
    if (data.containsKey('fromdate')) {
      context.handle(_fromDateMeta,
          fromDate.isAcceptableOrUnknown(data['fromdate']!, _fromDateMeta));
    }
    if (data.containsKey('duedate')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['duedate']!, _dueDateMeta));
    }
    if (data.containsKey('installment')) {
      context.handle(
          _installmentMeta,
          installment.isAcceptableOrUnknown(
              data['installment']!, _installmentMeta));
    }
    if (data.containsKey('total_amount_to_be_paid')) {
      context.handle(
          _totalAmountToBePaidMeta,
          totalAmountToBePaid.isAcceptableOrUnknown(
              data['total_amount_to_be_paid']!, _totalAmountToBePaidMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('remained_amount')) {
      context.handle(
          _remainedAmountMeta,
          remainedAmount.isAcceptableOrUnknown(
              data['remained_amount']!, _remainedAmountMeta));
    }
    if (data.containsKey('completed_derived')) {
      context.handle(
          _completedDerivedMeta,
          completedDerived.isAcceptableOrUnknown(
              data['completed_derived']!, _completedDerivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanScheduleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanScheduleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      loanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}loan_id']),
      fromDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fromdate']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duedate']),
      installment: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installment']),
      totalAmountToBePaid: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}total_amount_to_be_paid']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount']),
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount']),
      remainedAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}remained_amount']),
      completedDerived: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_derived']),
    );
  }

  @override
  $LoanScheduleTable createAlias(String alias) {
    return $LoanScheduleTable(attachedDatabase, alias);
  }
}

class LoanScheduleData extends DataClass
    implements Insertable<LoanScheduleData> {
  final int id;
  final int? loanId;
  final String? fromDate;
  final String? dueDate;
  final int? installment;
  final double? totalAmountToBePaid;
  final double? totalAmount;
  final double? paidAmount;
  final double? remainedAmount;
  final int? completedDerived;
  const LoanScheduleData(
      {required this.id,
      this.loanId,
      this.fromDate,
      this.dueDate,
      this.installment,
      this.totalAmountToBePaid,
      this.totalAmount,
      this.paidAmount,
      this.remainedAmount,
      this.completedDerived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || loanId != null) {
      map['loan_id'] = Variable<int>(loanId);
    }
    if (!nullToAbsent || fromDate != null) {
      map['fromdate'] = Variable<String>(fromDate);
    }
    if (!nullToAbsent || dueDate != null) {
      map['duedate'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || installment != null) {
      map['installment'] = Variable<int>(installment);
    }
    if (!nullToAbsent || totalAmountToBePaid != null) {
      map['total_amount_to_be_paid'] = Variable<double>(totalAmountToBePaid);
    }
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    if (!nullToAbsent || paidAmount != null) {
      map['paid_amount'] = Variable<double>(paidAmount);
    }
    if (!nullToAbsent || remainedAmount != null) {
      map['remained_amount'] = Variable<double>(remainedAmount);
    }
    if (!nullToAbsent || completedDerived != null) {
      map['completed_derived'] = Variable<int>(completedDerived);
    }
    return map;
  }

  LoanScheduleCompanion toCompanion(bool nullToAbsent) {
    return LoanScheduleCompanion(
      id: Value(id),
      loanId:
          loanId == null && nullToAbsent ? const Value.absent() : Value(loanId),
      fromDate: fromDate == null && nullToAbsent
          ? const Value.absent()
          : Value(fromDate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      installment: installment == null && nullToAbsent
          ? const Value.absent()
          : Value(installment),
      totalAmountToBePaid: totalAmountToBePaid == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmountToBePaid),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      paidAmount: paidAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAmount),
      remainedAmount: remainedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(remainedAmount),
      completedDerived: completedDerived == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDerived),
    );
  }

  factory LoanScheduleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanScheduleData(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int?>(json['loanId']),
      fromDate: serializer.fromJson<String?>(json['fromDate']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      installment: serializer.fromJson<int?>(json['installment']),
      totalAmountToBePaid:
          serializer.fromJson<double?>(json['totalAmountToBePaid']),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      paidAmount: serializer.fromJson<double?>(json['paidAmount']),
      remainedAmount: serializer.fromJson<double?>(json['remainedAmount']),
      completedDerived: serializer.fromJson<int?>(json['completedDerived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int?>(loanId),
      'fromDate': serializer.toJson<String?>(fromDate),
      'dueDate': serializer.toJson<String?>(dueDate),
      'installment': serializer.toJson<int?>(installment),
      'totalAmountToBePaid': serializer.toJson<double?>(totalAmountToBePaid),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'paidAmount': serializer.toJson<double?>(paidAmount),
      'remainedAmount': serializer.toJson<double?>(remainedAmount),
      'completedDerived': serializer.toJson<int?>(completedDerived),
    };
  }

  LoanScheduleData copyWith(
          {int? id,
          Value<int?> loanId = const Value.absent(),
          Value<String?> fromDate = const Value.absent(),
          Value<String?> dueDate = const Value.absent(),
          Value<int?> installment = const Value.absent(),
          Value<double?> totalAmountToBePaid = const Value.absent(),
          Value<double?> totalAmount = const Value.absent(),
          Value<double?> paidAmount = const Value.absent(),
          Value<double?> remainedAmount = const Value.absent(),
          Value<int?> completedDerived = const Value.absent()}) =>
      LoanScheduleData(
        id: id ?? this.id,
        loanId: loanId.present ? loanId.value : this.loanId,
        fromDate: fromDate.present ? fromDate.value : this.fromDate,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        installment: installment.present ? installment.value : this.installment,
        totalAmountToBePaid: totalAmountToBePaid.present
            ? totalAmountToBePaid.value
            : this.totalAmountToBePaid,
        totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
        paidAmount: paidAmount.present ? paidAmount.value : this.paidAmount,
        remainedAmount:
            remainedAmount.present ? remainedAmount.value : this.remainedAmount,
        completedDerived: completedDerived.present
            ? completedDerived.value
            : this.completedDerived,
      );
  LoanScheduleData copyWithCompanion(LoanScheduleCompanion data) {
    return LoanScheduleData(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      installment:
          data.installment.present ? data.installment.value : this.installment,
      totalAmountToBePaid: data.totalAmountToBePaid.present
          ? data.totalAmountToBePaid.value
          : this.totalAmountToBePaid,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      remainedAmount: data.remainedAmount.present
          ? data.remainedAmount.value
          : this.remainedAmount,
      completedDerived: data.completedDerived.present
          ? data.completedDerived.value
          : this.completedDerived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanScheduleData(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('fromDate: $fromDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('installment: $installment, ')
          ..write('totalAmountToBePaid: $totalAmountToBePaid, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('completedDerived: $completedDerived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      loanId,
      fromDate,
      dueDate,
      installment,
      totalAmountToBePaid,
      totalAmount,
      paidAmount,
      remainedAmount,
      completedDerived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanScheduleData &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.fromDate == this.fromDate &&
          other.dueDate == this.dueDate &&
          other.installment == this.installment &&
          other.totalAmountToBePaid == this.totalAmountToBePaid &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.remainedAmount == this.remainedAmount &&
          other.completedDerived == this.completedDerived);
}

class LoanScheduleCompanion extends UpdateCompanion<LoanScheduleData> {
  final Value<int> id;
  final Value<int?> loanId;
  final Value<String?> fromDate;
  final Value<String?> dueDate;
  final Value<int?> installment;
  final Value<double?> totalAmountToBePaid;
  final Value<double?> totalAmount;
  final Value<double?> paidAmount;
  final Value<double?> remainedAmount;
  final Value<int?> completedDerived;
  const LoanScheduleCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.installment = const Value.absent(),
    this.totalAmountToBePaid = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.completedDerived = const Value.absent(),
  });
  LoanScheduleCompanion.insert({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.installment = const Value.absent(),
    this.totalAmountToBePaid = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainedAmount = const Value.absent(),
    this.completedDerived = const Value.absent(),
  });
  static Insertable<LoanScheduleData> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<String>? fromDate,
    Expression<String>? dueDate,
    Expression<int>? installment,
    Expression<double>? totalAmountToBePaid,
    Expression<double>? totalAmount,
    Expression<double>? paidAmount,
    Expression<double>? remainedAmount,
    Expression<int>? completedDerived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (fromDate != null) 'fromdate': fromDate,
      if (dueDate != null) 'duedate': dueDate,
      if (installment != null) 'installment': installment,
      if (totalAmountToBePaid != null)
        'total_amount_to_be_paid': totalAmountToBePaid,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainedAmount != null) 'remained_amount': remainedAmount,
      if (completedDerived != null) 'completed_derived': completedDerived,
    });
  }

  LoanScheduleCompanion copyWith(
      {Value<int>? id,
      Value<int?>? loanId,
      Value<String?>? fromDate,
      Value<String?>? dueDate,
      Value<int?>? installment,
      Value<double?>? totalAmountToBePaid,
      Value<double?>? totalAmount,
      Value<double?>? paidAmount,
      Value<double?>? remainedAmount,
      Value<int?>? completedDerived}) {
    return LoanScheduleCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      fromDate: fromDate ?? this.fromDate,
      dueDate: dueDate ?? this.dueDate,
      installment: installment ?? this.installment,
      totalAmountToBePaid: totalAmountToBePaid ?? this.totalAmountToBePaid,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainedAmount: remainedAmount ?? this.remainedAmount,
      completedDerived: completedDerived ?? this.completedDerived,
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
    if (fromDate.present) {
      map['fromdate'] = Variable<String>(fromDate.value);
    }
    if (dueDate.present) {
      map['duedate'] = Variable<String>(dueDate.value);
    }
    if (installment.present) {
      map['installment'] = Variable<int>(installment.value);
    }
    if (totalAmountToBePaid.present) {
      map['total_amount_to_be_paid'] =
          Variable<double>(totalAmountToBePaid.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (remainedAmount.present) {
      map['remained_amount'] = Variable<double>(remainedAmount.value);
    }
    if (completedDerived.present) {
      map['completed_derived'] = Variable<int>(completedDerived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanScheduleCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('fromDate: $fromDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('installment: $installment, ')
          ..write('totalAmountToBePaid: $totalAmountToBePaid, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainedAmount: $remainedAmount, ')
          ..write('completedDerived: $completedDerived')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AppTransactionTable appTransaction = $AppTransactionTable(this);
  late final $BalanceTable balance = $BalanceTable(this);
  late final $CustomerTable customer = $CustomerTable(this);
  late final $LoanTable loan = $LoanTable(this);
  late final $MechantChargeConfigurationsTable mechantChargeConfigurations =
      $MechantChargeConfigurationsTable(this);
  late final $AccountSetupTable accountSetup = $AccountSetupTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $FeesAssignmentsTable feesAssignments =
      $FeesAssignmentsTable(this);
  late final $FeesAssignChildrenTable feesAssignChildren =
      $FeesAssignChildrenTable(this);
  late final $ExamTypesTable examTypes = $ExamTypesTable(this);
  late final $ClassesTable classes = $ClassesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BankAccountsTable bankAccounts = $BankAccountsTable(this);
  late final $SubjectAssignChildrensTable subjectAssignChildrens =
      $SubjectAssignChildrensTable(this);
  late final $SubjectAssignsTable subjectAssigns = $SubjectAssignsTable(this);
  late final $UserCredentialsTable userCredentials =
      $UserCredentialsTable(this);
  late final $StaffTable staff = $StaffTable(this);
  late final $MarksGradeTable marksGrade = $MarksGradeTable(this);
  late final $ParentDetailsTable parentDetails = $ParentDetailsTable(this);
  late final $NoticeBoardsTable noticeBoards = $NoticeBoardsTable(this);
  late final $StudentsListTable studentsList = $StudentsListTable(this);
  late final $StatusTable status = $StatusTable(this);
  late final $LoanStatusTable loanStatus = $LoanStatusTable(this);
  late final $LoanScheduleTable loanSchedule = $LoanScheduleTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        appTransaction,
        balance,
        customer,
        loan,
        mechantChargeConfigurations,
        accountSetup,
        students,
        feesAssignments,
        feesAssignChildren,
        examTypes,
        classes,
        transactions,
        bankAccounts,
        subjectAssignChildrens,
        subjectAssigns,
        userCredentials,
        staff,
        marksGrade,
        parentDetails,
        noticeBoards,
        studentsList,
        status,
        loanStatus,
        loanSchedule
      ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String?> mechantCode,
  Value<String?> name,
  Value<String?> phone,
  Value<String?> password,
  Value<String?> email,
  Value<String?> identificationNumber,
  Value<String?> licenceNumber,
  Value<String?> documentRefenceId,
  Value<String?> status,
  Value<int?> agentId,
  Value<int?> userId,
  Value<String?> otp,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String?> mechantCode,
  Value<String?> name,
  Value<String?> phone,
  Value<String?> password,
  Value<String?> email,
  Value<String?> identificationNumber,
  Value<String?> licenceNumber,
  Value<String?> documentRefenceId,
  Value<String?> status,
  Value<int?> agentId,
  Value<int?> userId,
  Value<String?> otp,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mechantCode => $composableBuilder(
      column: $table.mechantCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get identificationNumber => $composableBuilder(
      column: $table.identificationNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licenceNumber => $composableBuilder(
      column: $table.licenceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentRefenceId => $composableBuilder(
      column: $table.documentRefenceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mechantCode => $composableBuilder(
      column: $table.mechantCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get identificationNumber => $composableBuilder(
      column: $table.identificationNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenceNumber => $composableBuilder(
      column: $table.licenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentRefenceId => $composableBuilder(
      column: $table.documentRefenceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mechantCode => $composableBuilder(
      column: $table.mechantCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get identificationNumber => $composableBuilder(
      column: $table.identificationNumber, builder: (column) => column);

  GeneratedColumn<String> get licenceNumber => $composableBuilder(
      column: $table.licenceNumber, builder: (column) => column);

  GeneratedColumn<String> get documentRefenceId => $composableBuilder(
      column: $table.documentRefenceId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get otp =>
      $composableBuilder(column: $table.otp, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> mechantCode = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> identificationNumber = const Value.absent(),
            Value<String?> licenceNumber = const Value.absent(),
            Value<String?> documentRefenceId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int?> agentId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            mechantCode: mechantCode,
            name: name,
            phone: phone,
            password: password,
            email: email,
            identificationNumber: identificationNumber,
            licenceNumber: licenceNumber,
            documentRefenceId: documentRefenceId,
            status: status,
            agentId: agentId,
            userId: userId,
            otp: otp,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> mechantCode = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> identificationNumber = const Value.absent(),
            Value<String?> licenceNumber = const Value.absent(),
            Value<String?> documentRefenceId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int?> agentId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            mechantCode: mechantCode,
            name: name,
            phone: phone,
            password: password,
            email: email,
            identificationNumber: identificationNumber,
            licenceNumber: licenceNumber,
            documentRefenceId: documentRefenceId,
            status: status,
            agentId: agentId,
            userId: userId,
            otp: otp,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$AppTransactionTableCreateCompanionBuilder = AppTransactionCompanion
    Function({
  Value<int> id,
  required String userId,
  Value<String?> receiverAccount,
  Value<String?> senderAccount,
  required String amount,
  required String status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AppTransactionTableUpdateCompanionBuilder = AppTransactionCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  Value<String?> receiverAccount,
  Value<String?> senderAccount,
  Value<String> amount,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$AppTransactionTableFilterComposer
    extends Composer<_$AppDatabase, $AppTransactionTable> {
  $$AppTransactionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiverAccount => $composableBuilder(
      column: $table.receiverAccount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderAccount => $composableBuilder(
      column: $table.senderAccount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppTransactionTableOrderingComposer
    extends Composer<_$AppDatabase, $AppTransactionTable> {
  $$AppTransactionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiverAccount => $composableBuilder(
      column: $table.receiverAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderAccount => $composableBuilder(
      column: $table.senderAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppTransactionTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppTransactionTable> {
  $$AppTransactionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get receiverAccount => $composableBuilder(
      column: $table.receiverAccount, builder: (column) => column);

  GeneratedColumn<String> get senderAccount => $composableBuilder(
      column: $table.senderAccount, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppTransactionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppTransactionTable,
    AppTransactionData,
    $$AppTransactionTableFilterComposer,
    $$AppTransactionTableOrderingComposer,
    $$AppTransactionTableAnnotationComposer,
    $$AppTransactionTableCreateCompanionBuilder,
    $$AppTransactionTableUpdateCompanionBuilder,
    (
      AppTransactionData,
      BaseReferences<_$AppDatabase, $AppTransactionTable, AppTransactionData>
    ),
    AppTransactionData,
    PrefetchHooks Function()> {
  $$AppTransactionTableTableManager(
      _$AppDatabase db, $AppTransactionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppTransactionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppTransactionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppTransactionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> receiverAccount = const Value.absent(),
            Value<String?> senderAccount = const Value.absent(),
            Value<String> amount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppTransactionCompanion(
            id: id,
            userId: userId,
            receiverAccount: receiverAccount,
            senderAccount: senderAccount,
            amount: amount,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            Value<String?> receiverAccount = const Value.absent(),
            Value<String?> senderAccount = const Value.absent(),
            required String amount,
            required String status,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppTransactionCompanion.insert(
            id: id,
            userId: userId,
            receiverAccount: receiverAccount,
            senderAccount: senderAccount,
            amount: amount,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppTransactionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppTransactionTable,
    AppTransactionData,
    $$AppTransactionTableFilterComposer,
    $$AppTransactionTableOrderingComposer,
    $$AppTransactionTableAnnotationComposer,
    $$AppTransactionTableCreateCompanionBuilder,
    $$AppTransactionTableUpdateCompanionBuilder,
    (
      AppTransactionData,
      BaseReferences<_$AppDatabase, $AppTransactionTable, AppTransactionData>
    ),
    AppTransactionData,
    PrefetchHooks Function()>;
typedef $$BalanceTableCreateCompanionBuilder = BalanceCompanion Function({
  Value<int> id,
  required String userId,
  Value<String?> amount,
  Value<DateTime> date,
});
typedef $$BalanceTableUpdateCompanionBuilder = BalanceCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String?> amount,
  Value<DateTime> date,
});

class $$BalanceTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceTable> {
  $$BalanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$BalanceTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceTable> {
  $$BalanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$BalanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceTable> {
  $$BalanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$BalanceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BalanceTable,
    BalanceData,
    $$BalanceTableFilterComposer,
    $$BalanceTableOrderingComposer,
    $$BalanceTableAnnotationComposer,
    $$BalanceTableCreateCompanionBuilder,
    $$BalanceTableUpdateCompanionBuilder,
    (BalanceData, BaseReferences<_$AppDatabase, $BalanceTable, BalanceData>),
    BalanceData,
    PrefetchHooks Function()> {
  $$BalanceTableTableManager(_$AppDatabase db, $BalanceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              BalanceCompanion(
            id: id,
            userId: userId,
            amount: amount,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            Value<String?> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              BalanceCompanion.insert(
            id: id,
            userId: userId,
            amount: amount,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BalanceTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BalanceTable,
    BalanceData,
    $$BalanceTableFilterComposer,
    $$BalanceTableOrderingComposer,
    $$BalanceTableAnnotationComposer,
    $$BalanceTableCreateCompanionBuilder,
    $$BalanceTableUpdateCompanionBuilder,
    (BalanceData, BaseReferences<_$AppDatabase, $BalanceTable, BalanceData>),
    BalanceData,
    PrefetchHooks Function()>;
typedef $$CustomerTableCreateCompanionBuilder = CustomerCompanion Function({
  Value<int> id,
  Value<String?> displayName,
  Value<String?> externalId,
  Value<String?> accountNo,
  Value<String?> mobileNo,
  Value<String?> otp,
  Value<String?> loanAmount,
  Value<String?> remainLoanAmount,
});
typedef $$CustomerTableUpdateCompanionBuilder = CustomerCompanion Function({
  Value<int> id,
  Value<String?> displayName,
  Value<String?> externalId,
  Value<String?> accountNo,
  Value<String?> mobileNo,
  Value<String?> otp,
  Value<String?> loanAmount,
  Value<String?> remainLoanAmount,
});

class $$CustomerTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerTable> {
  $$CustomerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobileNo => $composableBuilder(
      column: $table.mobileNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remainLoanAmount => $composableBuilder(
      column: $table.remainLoanAmount,
      builder: (column) => ColumnFilters(column));
}

class $$CustomerTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerTable> {
  $$CustomerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobileNo => $composableBuilder(
      column: $table.mobileNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remainLoanAmount => $composableBuilder(
      column: $table.remainLoanAmount,
      builder: (column) => ColumnOrderings(column));
}

class $$CustomerTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerTable> {
  $$CustomerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => column);

  GeneratedColumn<String> get accountNo =>
      $composableBuilder(column: $table.accountNo, builder: (column) => column);

  GeneratedColumn<String> get mobileNo =>
      $composableBuilder(column: $table.mobileNo, builder: (column) => column);

  GeneratedColumn<String> get otp =>
      $composableBuilder(column: $table.otp, builder: (column) => column);

  GeneratedColumn<String> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => column);

  GeneratedColumn<String> get remainLoanAmount => $composableBuilder(
      column: $table.remainLoanAmount, builder: (column) => column);
}

class $$CustomerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomerTable,
    CustomerData,
    $$CustomerTableFilterComposer,
    $$CustomerTableOrderingComposer,
    $$CustomerTableAnnotationComposer,
    $$CustomerTableCreateCompanionBuilder,
    $$CustomerTableUpdateCompanionBuilder,
    (CustomerData, BaseReferences<_$AppDatabase, $CustomerTable, CustomerData>),
    CustomerData,
    PrefetchHooks Function()> {
  $$CustomerTableTableManager(_$AppDatabase db, $CustomerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
            Value<String?> mobileNo = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> loanAmount = const Value.absent(),
            Value<String?> remainLoanAmount = const Value.absent(),
          }) =>
              CustomerCompanion(
            id: id,
            displayName: displayName,
            externalId: externalId,
            accountNo: accountNo,
            mobileNo: mobileNo,
            otp: otp,
            loanAmount: loanAmount,
            remainLoanAmount: remainLoanAmount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
            Value<String?> mobileNo = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> loanAmount = const Value.absent(),
            Value<String?> remainLoanAmount = const Value.absent(),
          }) =>
              CustomerCompanion.insert(
            id: id,
            displayName: displayName,
            externalId: externalId,
            accountNo: accountNo,
            mobileNo: mobileNo,
            otp: otp,
            loanAmount: loanAmount,
            remainLoanAmount: remainLoanAmount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomerTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomerTable,
    CustomerData,
    $$CustomerTableFilterComposer,
    $$CustomerTableOrderingComposer,
    $$CustomerTableAnnotationComposer,
    $$CustomerTableCreateCompanionBuilder,
    $$CustomerTableUpdateCompanionBuilder,
    (CustomerData, BaseReferences<_$AppDatabase, $CustomerTable, CustomerData>),
    CustomerData,
    PrefetchHooks Function()>;
typedef $$LoanTableCreateCompanionBuilder = LoanCompanion Function({
  Value<int> id,
  Value<String?> totalRepaymentDerived,
  Value<String?> totalExpectedRepaymentDerived,
  Value<String?> principalRepaidDerived,
  Value<String?> principalAmount,
  Value<String?> clientId,
});
typedef $$LoanTableUpdateCompanionBuilder = LoanCompanion Function({
  Value<int> id,
  Value<String?> totalRepaymentDerived,
  Value<String?> totalExpectedRepaymentDerived,
  Value<String?> principalRepaidDerived,
  Value<String?> principalAmount,
  Value<String?> clientId,
});

class $$LoanTableFilterComposer extends Composer<_$AppDatabase, $LoanTable> {
  $$LoanTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalRepaymentDerived => $composableBuilder(
      column: $table.totalRepaymentDerived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalExpectedRepaymentDerived => $composableBuilder(
      column: $table.totalExpectedRepaymentDerived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get principalRepaidDerived => $composableBuilder(
      column: $table.principalRepaidDerived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));
}

class $$LoanTableOrderingComposer extends Composer<_$AppDatabase, $LoanTable> {
  $$LoanTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalRepaymentDerived => $composableBuilder(
      column: $table.totalRepaymentDerived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalExpectedRepaymentDerived =>
      $composableBuilder(
          column: $table.totalExpectedRepaymentDerived,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get principalRepaidDerived => $composableBuilder(
      column: $table.principalRepaidDerived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));
}

class $$LoanTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanTable> {
  $$LoanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get totalRepaymentDerived => $composableBuilder(
      column: $table.totalRepaymentDerived, builder: (column) => column);

  GeneratedColumn<String> get totalExpectedRepaymentDerived =>
      $composableBuilder(
          column: $table.totalExpectedRepaymentDerived,
          builder: (column) => column);

  GeneratedColumn<String> get principalRepaidDerived => $composableBuilder(
      column: $table.principalRepaidDerived, builder: (column) => column);

  GeneratedColumn<String> get principalAmount => $composableBuilder(
      column: $table.principalAmount, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);
}

class $$LoanTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanTable,
    LoanData,
    $$LoanTableFilterComposer,
    $$LoanTableOrderingComposer,
    $$LoanTableAnnotationComposer,
    $$LoanTableCreateCompanionBuilder,
    $$LoanTableUpdateCompanionBuilder,
    (LoanData, BaseReferences<_$AppDatabase, $LoanTable, LoanData>),
    LoanData,
    PrefetchHooks Function()> {
  $$LoanTableTableManager(_$AppDatabase db, $LoanTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> totalRepaymentDerived = const Value.absent(),
            Value<String?> totalExpectedRepaymentDerived = const Value.absent(),
            Value<String?> principalRepaidDerived = const Value.absent(),
            Value<String?> principalAmount = const Value.absent(),
            Value<String?> clientId = const Value.absent(),
          }) =>
              LoanCompanion(
            id: id,
            totalRepaymentDerived: totalRepaymentDerived,
            totalExpectedRepaymentDerived: totalExpectedRepaymentDerived,
            principalRepaidDerived: principalRepaidDerived,
            principalAmount: principalAmount,
            clientId: clientId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> totalRepaymentDerived = const Value.absent(),
            Value<String?> totalExpectedRepaymentDerived = const Value.absent(),
            Value<String?> principalRepaidDerived = const Value.absent(),
            Value<String?> principalAmount = const Value.absent(),
            Value<String?> clientId = const Value.absent(),
          }) =>
              LoanCompanion.insert(
            id: id,
            totalRepaymentDerived: totalRepaymentDerived,
            totalExpectedRepaymentDerived: totalExpectedRepaymentDerived,
            principalRepaidDerived: principalRepaidDerived,
            principalAmount: principalAmount,
            clientId: clientId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoanTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanTable,
    LoanData,
    $$LoanTableFilterComposer,
    $$LoanTableOrderingComposer,
    $$LoanTableAnnotationComposer,
    $$LoanTableCreateCompanionBuilder,
    $$LoanTableUpdateCompanionBuilder,
    (LoanData, BaseReferences<_$AppDatabase, $LoanTable, LoanData>),
    LoanData,
    PrefetchHooks Function()>;
typedef $$MechantChargeConfigurationsTableCreateCompanionBuilder
    = MechantChargeConfigurationsCompanion Function({
  Value<int> id,
  Value<String?> mechantId,
  Value<String?> chargeId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$MechantChargeConfigurationsTableUpdateCompanionBuilder
    = MechantChargeConfigurationsCompanion Function({
  Value<int> id,
  Value<String?> mechantId,
  Value<String?> chargeId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$MechantChargeConfigurationsTableFilterComposer
    extends Composer<_$AppDatabase, $MechantChargeConfigurationsTable> {
  $$MechantChargeConfigurationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chargeId => $composableBuilder(
      column: $table.chargeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MechantChargeConfigurationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MechantChargeConfigurationsTable> {
  $$MechantChargeConfigurationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chargeId => $composableBuilder(
      column: $table.chargeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MechantChargeConfigurationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MechantChargeConfigurationsTable> {
  $$MechantChargeConfigurationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mechantId =>
      $composableBuilder(column: $table.mechantId, builder: (column) => column);

  GeneratedColumn<String> get chargeId =>
      $composableBuilder(column: $table.chargeId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MechantChargeConfigurationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MechantChargeConfigurationsTable,
    MechantChargeConfiguration,
    $$MechantChargeConfigurationsTableFilterComposer,
    $$MechantChargeConfigurationsTableOrderingComposer,
    $$MechantChargeConfigurationsTableAnnotationComposer,
    $$MechantChargeConfigurationsTableCreateCompanionBuilder,
    $$MechantChargeConfigurationsTableUpdateCompanionBuilder,
    (
      MechantChargeConfiguration,
      BaseReferences<_$AppDatabase, $MechantChargeConfigurationsTable,
          MechantChargeConfiguration>
    ),
    MechantChargeConfiguration,
    PrefetchHooks Function()> {
  $$MechantChargeConfigurationsTableTableManager(
      _$AppDatabase db, $MechantChargeConfigurationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MechantChargeConfigurationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MechantChargeConfigurationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MechantChargeConfigurationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> mechantId = const Value.absent(),
            Value<String?> chargeId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              MechantChargeConfigurationsCompanion(
            id: id,
            mechantId: mechantId,
            chargeId: chargeId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> mechantId = const Value.absent(),
            Value<String?> chargeId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              MechantChargeConfigurationsCompanion.insert(
            id: id,
            mechantId: mechantId,
            chargeId: chargeId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MechantChargeConfigurationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MechantChargeConfigurationsTable,
        MechantChargeConfiguration,
        $$MechantChargeConfigurationsTableFilterComposer,
        $$MechantChargeConfigurationsTableOrderingComposer,
        $$MechantChargeConfigurationsTableAnnotationComposer,
        $$MechantChargeConfigurationsTableCreateCompanionBuilder,
        $$MechantChargeConfigurationsTableUpdateCompanionBuilder,
        (
          MechantChargeConfiguration,
          BaseReferences<_$AppDatabase, $MechantChargeConfigurationsTable,
              MechantChargeConfiguration>
        ),
        MechantChargeConfiguration,
        PrefetchHooks Function()>;
typedef $$AccountSetupTableCreateCompanionBuilder = AccountSetupCompanion
    Function({
  Value<int> id,
  Value<int?> mechantId,
  Value<String?> paymentType,
  Value<String?> institutionName,
  Value<String?> receivingNumber,
  Value<String?> status,
  Value<String?> verified,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$AccountSetupTableUpdateCompanionBuilder = AccountSetupCompanion
    Function({
  Value<int> id,
  Value<int?> mechantId,
  Value<String?> paymentType,
  Value<String?> institutionName,
  Value<String?> receivingNumber,
  Value<String?> status,
  Value<String?> verified,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$AccountSetupTableFilterComposer
    extends Composer<_$AppDatabase, $AccountSetupTable> {
  $$AccountSetupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institutionName => $composableBuilder(
      column: $table.institutionName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receivingNumber => $composableBuilder(
      column: $table.receivingNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verified => $composableBuilder(
      column: $table.verified, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AccountSetupTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountSetupTable> {
  $$AccountSetupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institutionName => $composableBuilder(
      column: $table.institutionName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receivingNumber => $composableBuilder(
      column: $table.receivingNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verified => $composableBuilder(
      column: $table.verified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountSetupTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountSetupTable> {
  $$AccountSetupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mechantId =>
      $composableBuilder(column: $table.mechantId, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => column);

  GeneratedColumn<String> get institutionName => $composableBuilder(
      column: $table.institutionName, builder: (column) => column);

  GeneratedColumn<String> get receivingNumber => $composableBuilder(
      column: $table.receivingNumber, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountSetupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountSetupTable,
    AccountSetupData,
    $$AccountSetupTableFilterComposer,
    $$AccountSetupTableOrderingComposer,
    $$AccountSetupTableAnnotationComposer,
    $$AccountSetupTableCreateCompanionBuilder,
    $$AccountSetupTableUpdateCompanionBuilder,
    (
      AccountSetupData,
      BaseReferences<_$AppDatabase, $AccountSetupTable, AccountSetupData>
    ),
    AccountSetupData,
    PrefetchHooks Function()> {
  $$AccountSetupTableTableManager(_$AppDatabase db, $AccountSetupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountSetupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountSetupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountSetupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> mechantId = const Value.absent(),
            Value<String?> paymentType = const Value.absent(),
            Value<String?> institutionName = const Value.absent(),
            Value<String?> receivingNumber = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> verified = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              AccountSetupCompanion(
            id: id,
            mechantId: mechantId,
            paymentType: paymentType,
            institutionName: institutionName,
            receivingNumber: receivingNumber,
            status: status,
            verified: verified,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> mechantId = const Value.absent(),
            Value<String?> paymentType = const Value.absent(),
            Value<String?> institutionName = const Value.absent(),
            Value<String?> receivingNumber = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> verified = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              AccountSetupCompanion.insert(
            id: id,
            mechantId: mechantId,
            paymentType: paymentType,
            institutionName: institutionName,
            receivingNumber: receivingNumber,
            status: status,
            verified: verified,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountSetupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountSetupTable,
    AccountSetupData,
    $$AccountSetupTableFilterComposer,
    $$AccountSetupTableOrderingComposer,
    $$AccountSetupTableAnnotationComposer,
    $$AccountSetupTableCreateCompanionBuilder,
    $$AccountSetupTableUpdateCompanionBuilder,
    (
      AccountSetupData,
      BaseReferences<_$AppDatabase, $AccountSetupTable, AccountSetupData>
    ),
    AccountSetupData,
    PrefetchHooks Function()>;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  Value<String?> admissionNo,
  Value<String?> rollNo,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> dob,
  Value<String?> admissionDate,
  Value<int?> studentCategoryId,
  Value<int?> religionId,
  Value<int?> bloodGroupId,
  Value<int?> genderId,
  Value<int?> categoryId,
  Value<int?> imageId,
  Value<int?> parentGuardianId,
  Value<int?> userId,
  Value<String?> uploadDocuments,
  Value<int?> status,
  Value<int?> previousSchool,
  Value<String?> previousSchoolInfo,
  Value<int?> previousSchoolImageId,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> cprNo,
  Value<String?> spokenLangAtHome,
  Value<String?> residanceAddress,
  Value<String?> controlNumber,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> fullName,
  Value<String?> className,
  Value<String?> sectionName,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  Value<String?> admissionNo,
  Value<String?> rollNo,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> dob,
  Value<String?> admissionDate,
  Value<int?> studentCategoryId,
  Value<int?> religionId,
  Value<int?> bloodGroupId,
  Value<int?> genderId,
  Value<int?> categoryId,
  Value<int?> imageId,
  Value<int?> parentGuardianId,
  Value<int?> userId,
  Value<String?> uploadDocuments,
  Value<int?> status,
  Value<int?> previousSchool,
  Value<String?> previousSchoolInfo,
  Value<int?> previousSchoolImageId,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> cprNo,
  Value<String?> spokenLangAtHome,
  Value<String?> residanceAddress,
  Value<String?> controlNumber,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> fullName,
  Value<String?> className,
  Value<String?> sectionName,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cprNo => $composableBuilder(
      column: $table.cprNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cprNo => $composableBuilder(
      column: $table.cprNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => column);

  GeneratedColumn<String> get rollNo =>
      $composableBuilder(column: $table.rollNo, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate, builder: (column) => column);

  GeneratedColumn<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId, builder: (column) => column);

  GeneratedColumn<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => column);

  GeneratedColumn<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId, builder: (column) => column);

  GeneratedColumn<int> get genderId =>
      $composableBuilder(column: $table.genderId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool, builder: (column) => column);

  GeneratedColumn<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo, builder: (column) => column);

  GeneratedColumn<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId, builder: (column) => column);

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => column);

  GeneratedColumn<String> get cprNo =>
      $composableBuilder(column: $table.cprNo, builder: (column) => column);

  GeneratedColumn<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome, builder: (column) => column);

  GeneratedColumn<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> admissionNo = const Value.absent(),
            Value<String?> rollNo = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> dob = const Value.absent(),
            Value<String?> admissionDate = const Value.absent(),
            Value<int?> studentCategoryId = const Value.absent(),
            Value<int?> religionId = const Value.absent(),
            Value<int?> bloodGroupId = const Value.absent(),
            Value<int?> genderId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> imageId = const Value.absent(),
            Value<int?> parentGuardianId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> uploadDocuments = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<int?> previousSchool = const Value.absent(),
            Value<String?> previousSchoolInfo = const Value.absent(),
            Value<int?> previousSchoolImageId = const Value.absent(),
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> cprNo = const Value.absent(),
            Value<String?> spokenLangAtHome = const Value.absent(),
            Value<String?> residanceAddress = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String?> className = const Value.absent(),
            Value<String?> sectionName = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            admissionNo: admissionNo,
            rollNo: rollNo,
            firstName: firstName,
            lastName: lastName,
            mobile: mobile,
            email: email,
            dob: dob,
            admissionDate: admissionDate,
            studentCategoryId: studentCategoryId,
            religionId: religionId,
            bloodGroupId: bloodGroupId,
            genderId: genderId,
            categoryId: categoryId,
            imageId: imageId,
            parentGuardianId: parentGuardianId,
            userId: userId,
            uploadDocuments: uploadDocuments,
            status: status,
            previousSchool: previousSchool,
            previousSchoolInfo: previousSchoolInfo,
            previousSchoolImageId: previousSchoolImageId,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            cprNo: cprNo,
            spokenLangAtHome: spokenLangAtHome,
            residanceAddress: residanceAddress,
            controlNumber: controlNumber,
            createdAt: createdAt,
            updatedAt: updatedAt,
            fullName: fullName,
            className: className,
            sectionName: sectionName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> admissionNo = const Value.absent(),
            Value<String?> rollNo = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> dob = const Value.absent(),
            Value<String?> admissionDate = const Value.absent(),
            Value<int?> studentCategoryId = const Value.absent(),
            Value<int?> religionId = const Value.absent(),
            Value<int?> bloodGroupId = const Value.absent(),
            Value<int?> genderId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> imageId = const Value.absent(),
            Value<int?> parentGuardianId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> uploadDocuments = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<int?> previousSchool = const Value.absent(),
            Value<String?> previousSchoolInfo = const Value.absent(),
            Value<int?> previousSchoolImageId = const Value.absent(),
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> cprNo = const Value.absent(),
            Value<String?> spokenLangAtHome = const Value.absent(),
            Value<String?> residanceAddress = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String?> className = const Value.absent(),
            Value<String?> sectionName = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            admissionNo: admissionNo,
            rollNo: rollNo,
            firstName: firstName,
            lastName: lastName,
            mobile: mobile,
            email: email,
            dob: dob,
            admissionDate: admissionDate,
            studentCategoryId: studentCategoryId,
            religionId: religionId,
            bloodGroupId: bloodGroupId,
            genderId: genderId,
            categoryId: categoryId,
            imageId: imageId,
            parentGuardianId: parentGuardianId,
            userId: userId,
            uploadDocuments: uploadDocuments,
            status: status,
            previousSchool: previousSchool,
            previousSchoolInfo: previousSchoolInfo,
            previousSchoolImageId: previousSchoolImageId,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            cprNo: cprNo,
            spokenLangAtHome: spokenLangAtHome,
            residanceAddress: residanceAddress,
            controlNumber: controlNumber,
            createdAt: createdAt,
            updatedAt: updatedAt,
            fullName: fullName,
            className: className,
            sectionName: sectionName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$FeesAssignmentsTableCreateCompanionBuilder = FeesAssignmentsCompanion
    Function({
  Value<int> id,
  required int feesAssignId,
  required int feesMasterId,
  required int studentId,
  required String controlNumber,
  Value<String> feesAmount,
  Value<String> paidAmount,
  Value<String> remainedAmount,
  Value<String?> quaterAmount,
  Value<int?> quaterOne,
  Value<int?> quaterTwo,
  Value<int?> quaterThree,
  Value<int?> quaterFour,
  Value<String?> comment,
  Value<String?> outstandingbalance,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$FeesAssignmentsTableUpdateCompanionBuilder = FeesAssignmentsCompanion
    Function({
  Value<int> id,
  Value<int> feesAssignId,
  Value<int> feesMasterId,
  Value<int> studentId,
  Value<String> controlNumber,
  Value<String> feesAmount,
  Value<String> paidAmount,
  Value<String> remainedAmount,
  Value<String?> quaterAmount,
  Value<int?> quaterOne,
  Value<int?> quaterTwo,
  Value<int?> quaterThree,
  Value<int?> quaterFour,
  Value<String?> comment,
  Value<String?> outstandingbalance,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$FeesAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $FeesAssignmentsTable> {
  $$FeesAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterOne => $composableBuilder(
      column: $table.quaterOne, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterTwo => $composableBuilder(
      column: $table.quaterTwo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FeesAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeesAssignmentsTable> {
  $$FeesAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterOne => $composableBuilder(
      column: $table.quaterOne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterTwo => $composableBuilder(
      column: $table.quaterTwo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FeesAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeesAssignmentsTable> {
  $$FeesAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId, builder: (column) => column);

  GeneratedColumn<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  GeneratedColumn<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => column);

  GeneratedColumn<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount, builder: (column) => column);

  GeneratedColumn<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount, builder: (column) => column);

  GeneratedColumn<int> get quaterOne =>
      $composableBuilder(column: $table.quaterOne, builder: (column) => column);

  GeneratedColumn<int> get quaterTwo =>
      $composableBuilder(column: $table.quaterTwo, builder: (column) => column);

  GeneratedColumn<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => column);

  GeneratedColumn<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeesAssignmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeesAssignmentsTable,
    FeesAssignment,
    $$FeesAssignmentsTableFilterComposer,
    $$FeesAssignmentsTableOrderingComposer,
    $$FeesAssignmentsTableAnnotationComposer,
    $$FeesAssignmentsTableCreateCompanionBuilder,
    $$FeesAssignmentsTableUpdateCompanionBuilder,
    (
      FeesAssignment,
      BaseReferences<_$AppDatabase, $FeesAssignmentsTable, FeesAssignment>
    ),
    FeesAssignment,
    PrefetchHooks Function()> {
  $$FeesAssignmentsTableTableManager(
      _$AppDatabase db, $FeesAssignmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeesAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeesAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeesAssignmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> feesAssignId = const Value.absent(),
            Value<int> feesMasterId = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<String> controlNumber = const Value.absent(),
            Value<String> feesAmount = const Value.absent(),
            Value<String> paidAmount = const Value.absent(),
            Value<String> remainedAmount = const Value.absent(),
            Value<String?> quaterAmount = const Value.absent(),
            Value<int?> quaterOne = const Value.absent(),
            Value<int?> quaterTwo = const Value.absent(),
            Value<int?> quaterThree = const Value.absent(),
            Value<int?> quaterFour = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> outstandingbalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FeesAssignmentsCompanion(
            id: id,
            feesAssignId: feesAssignId,
            feesMasterId: feesMasterId,
            studentId: studentId,
            controlNumber: controlNumber,
            feesAmount: feesAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            quaterAmount: quaterAmount,
            quaterOne: quaterOne,
            quaterTwo: quaterTwo,
            quaterThree: quaterThree,
            quaterFour: quaterFour,
            comment: comment,
            outstandingbalance: outstandingbalance,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int feesAssignId,
            required int feesMasterId,
            required int studentId,
            required String controlNumber,
            Value<String> feesAmount = const Value.absent(),
            Value<String> paidAmount = const Value.absent(),
            Value<String> remainedAmount = const Value.absent(),
            Value<String?> quaterAmount = const Value.absent(),
            Value<int?> quaterOne = const Value.absent(),
            Value<int?> quaterTwo = const Value.absent(),
            Value<int?> quaterThree = const Value.absent(),
            Value<int?> quaterFour = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> outstandingbalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FeesAssignmentsCompanion.insert(
            id: id,
            feesAssignId: feesAssignId,
            feesMasterId: feesMasterId,
            studentId: studentId,
            controlNumber: controlNumber,
            feesAmount: feesAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            quaterAmount: quaterAmount,
            quaterOne: quaterOne,
            quaterTwo: quaterTwo,
            quaterThree: quaterThree,
            quaterFour: quaterFour,
            comment: comment,
            outstandingbalance: outstandingbalance,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeesAssignmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeesAssignmentsTable,
    FeesAssignment,
    $$FeesAssignmentsTableFilterComposer,
    $$FeesAssignmentsTableOrderingComposer,
    $$FeesAssignmentsTableAnnotationComposer,
    $$FeesAssignmentsTableCreateCompanionBuilder,
    $$FeesAssignmentsTableUpdateCompanionBuilder,
    (
      FeesAssignment,
      BaseReferences<_$AppDatabase, $FeesAssignmentsTable, FeesAssignment>
    ),
    FeesAssignment,
    PrefetchHooks Function()>;
typedef $$FeesAssignChildrenTableCreateCompanionBuilder
    = FeesAssignChildrenCompanion Function({
  Value<int> id,
  required int feesAssignId,
  required int feesMasterId,
  required int studentId,
  required String controlNumber,
  Value<String> feesAmount,
  Value<String> paidAmount,
  Value<String> remainedAmount,
  Value<String?> quaterAmount,
  Value<int?> quaterOne,
  Value<int?> quaterTwo,
  Value<int?> quaterThree,
  Value<int?> quaterFour,
  Value<String?> comment,
  Value<String?> outstandingbalance,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$FeesAssignChildrenTableUpdateCompanionBuilder
    = FeesAssignChildrenCompanion Function({
  Value<int> id,
  Value<int> feesAssignId,
  Value<int> feesMasterId,
  Value<int> studentId,
  Value<String> controlNumber,
  Value<String> feesAmount,
  Value<String> paidAmount,
  Value<String> remainedAmount,
  Value<String?> quaterAmount,
  Value<int?> quaterOne,
  Value<int?> quaterTwo,
  Value<int?> quaterThree,
  Value<int?> quaterFour,
  Value<String?> comment,
  Value<String?> outstandingbalance,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$FeesAssignChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $FeesAssignChildrenTable> {
  $$FeesAssignChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterOne => $composableBuilder(
      column: $table.quaterOne, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterTwo => $composableBuilder(
      column: $table.quaterTwo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FeesAssignChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $FeesAssignChildrenTable> {
  $$FeesAssignChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterOne => $composableBuilder(
      column: $table.quaterOne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterTwo => $composableBuilder(
      column: $table.quaterTwo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FeesAssignChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeesAssignChildrenTable> {
  $$FeesAssignChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get feesAssignId => $composableBuilder(
      column: $table.feesAssignId, builder: (column) => column);

  GeneratedColumn<int> get feesMasterId => $composableBuilder(
      column: $table.feesMasterId, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  GeneratedColumn<String> get feesAmount => $composableBuilder(
      column: $table.feesAmount, builder: (column) => column);

  GeneratedColumn<String> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<String> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount, builder: (column) => column);

  GeneratedColumn<String> get quaterAmount => $composableBuilder(
      column: $table.quaterAmount, builder: (column) => column);

  GeneratedColumn<int> get quaterOne =>
      $composableBuilder(column: $table.quaterOne, builder: (column) => column);

  GeneratedColumn<int> get quaterTwo =>
      $composableBuilder(column: $table.quaterTwo, builder: (column) => column);

  GeneratedColumn<int> get quaterThree => $composableBuilder(
      column: $table.quaterThree, builder: (column) => column);

  GeneratedColumn<int> get quaterFour => $composableBuilder(
      column: $table.quaterFour, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get outstandingbalance => $composableBuilder(
      column: $table.outstandingbalance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeesAssignChildrenTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeesAssignChildrenTable,
    FeesAssignChildrenData,
    $$FeesAssignChildrenTableFilterComposer,
    $$FeesAssignChildrenTableOrderingComposer,
    $$FeesAssignChildrenTableAnnotationComposer,
    $$FeesAssignChildrenTableCreateCompanionBuilder,
    $$FeesAssignChildrenTableUpdateCompanionBuilder,
    (
      FeesAssignChildrenData,
      BaseReferences<_$AppDatabase, $FeesAssignChildrenTable,
          FeesAssignChildrenData>
    ),
    FeesAssignChildrenData,
    PrefetchHooks Function()> {
  $$FeesAssignChildrenTableTableManager(
      _$AppDatabase db, $FeesAssignChildrenTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeesAssignChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeesAssignChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeesAssignChildrenTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> feesAssignId = const Value.absent(),
            Value<int> feesMasterId = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<String> controlNumber = const Value.absent(),
            Value<String> feesAmount = const Value.absent(),
            Value<String> paidAmount = const Value.absent(),
            Value<String> remainedAmount = const Value.absent(),
            Value<String?> quaterAmount = const Value.absent(),
            Value<int?> quaterOne = const Value.absent(),
            Value<int?> quaterTwo = const Value.absent(),
            Value<int?> quaterThree = const Value.absent(),
            Value<int?> quaterFour = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> outstandingbalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FeesAssignChildrenCompanion(
            id: id,
            feesAssignId: feesAssignId,
            feesMasterId: feesMasterId,
            studentId: studentId,
            controlNumber: controlNumber,
            feesAmount: feesAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            quaterAmount: quaterAmount,
            quaterOne: quaterOne,
            quaterTwo: quaterTwo,
            quaterThree: quaterThree,
            quaterFour: quaterFour,
            comment: comment,
            outstandingbalance: outstandingbalance,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int feesAssignId,
            required int feesMasterId,
            required int studentId,
            required String controlNumber,
            Value<String> feesAmount = const Value.absent(),
            Value<String> paidAmount = const Value.absent(),
            Value<String> remainedAmount = const Value.absent(),
            Value<String?> quaterAmount = const Value.absent(),
            Value<int?> quaterOne = const Value.absent(),
            Value<int?> quaterTwo = const Value.absent(),
            Value<int?> quaterThree = const Value.absent(),
            Value<int?> quaterFour = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> outstandingbalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FeesAssignChildrenCompanion.insert(
            id: id,
            feesAssignId: feesAssignId,
            feesMasterId: feesMasterId,
            studentId: studentId,
            controlNumber: controlNumber,
            feesAmount: feesAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            quaterAmount: quaterAmount,
            quaterOne: quaterOne,
            quaterTwo: quaterTwo,
            quaterThree: quaterThree,
            quaterFour: quaterFour,
            comment: comment,
            outstandingbalance: outstandingbalance,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeesAssignChildrenTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeesAssignChildrenTable,
    FeesAssignChildrenData,
    $$FeesAssignChildrenTableFilterComposer,
    $$FeesAssignChildrenTableOrderingComposer,
    $$FeesAssignChildrenTableAnnotationComposer,
    $$FeesAssignChildrenTableCreateCompanionBuilder,
    $$FeesAssignChildrenTableUpdateCompanionBuilder,
    (
      FeesAssignChildrenData,
      BaseReferences<_$AppDatabase, $FeesAssignChildrenTable,
          FeesAssignChildrenData>
    ),
    FeesAssignChildrenData,
    PrefetchHooks Function()>;
typedef $$ExamTypesTableCreateCompanionBuilder = ExamTypesCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> type,
  Value<int?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$ExamTypesTableUpdateCompanionBuilder = ExamTypesCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> type,
  Value<int?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$ExamTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamTypesTable> {
  $$ExamTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExamTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamTypesTable> {
  $$ExamTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExamTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamTypesTable> {
  $$ExamTypesTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExamTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamTypesTable,
    ExamType,
    $$ExamTypesTableFilterComposer,
    $$ExamTypesTableOrderingComposer,
    $$ExamTypesTableAnnotationComposer,
    $$ExamTypesTableCreateCompanionBuilder,
    $$ExamTypesTableUpdateCompanionBuilder,
    (ExamType, BaseReferences<_$AppDatabase, $ExamTypesTable, ExamType>),
    ExamType,
    PrefetchHooks Function()> {
  $$ExamTypesTableTableManager(_$AppDatabase db, $ExamTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              ExamTypesCompanion(
            id: id,
            name: name,
            type: type,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              ExamTypesCompanion.insert(
            id: id,
            name: name,
            type: type,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExamTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamTypesTable,
    ExamType,
    $$ExamTypesTableFilterComposer,
    $$ExamTypesTableOrderingComposer,
    $$ExamTypesTableAnnotationComposer,
    $$ExamTypesTableCreateCompanionBuilder,
    $$ExamTypesTableUpdateCompanionBuilder,
    (ExamType, BaseReferences<_$AppDatabase, $ExamTypesTable, ExamType>),
    ExamType,
    PrefetchHooks Function()>;
typedef $$ClassesTableCreateCompanionBuilder = ClassesCompanion Function({
  Value<int> id,
  required String name,
  required int status,
  required int orders,
  required String createdAt,
  required String updatedAt,
  required String classTran,
});
typedef $$ClassesTableUpdateCompanionBuilder = ClassesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> status,
  Value<int> orders,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String> classTran,
});

class $$ClassesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orders => $composableBuilder(
      column: $table.orders, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classTran => $composableBuilder(
      column: $table.classTran, builder: (column) => ColumnFilters(column));
}

class $$ClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orders => $composableBuilder(
      column: $table.orders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classTran => $composableBuilder(
      column: $table.classTran, builder: (column) => ColumnOrderings(column));
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
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

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get orders =>
      $composableBuilder(column: $table.orders, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get classTran =>
      $composableBuilder(column: $table.classTran, builder: (column) => column);
}

class $$ClassesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassesData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassesData, BaseReferences<_$AppDatabase, $ClassesTable, ClassesData>),
    ClassesData,
    PrefetchHooks Function()> {
  $$ClassesTableTableManager(_$AppDatabase db, $ClassesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> orders = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String> classTran = const Value.absent(),
          }) =>
              ClassesCompanion(
            id: id,
            name: name,
            status: status,
            orders: orders,
            createdAt: createdAt,
            updatedAt: updatedAt,
            classTran: classTran,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int status,
            required int orders,
            required String createdAt,
            required String updatedAt,
            required String classTran,
          }) =>
              ClassesCompanion.insert(
            id: id,
            name: name,
            status: status,
            orders: orders,
            createdAt: createdAt,
            updatedAt: updatedAt,
            classTran: classTran,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClassesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassesData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassesData, BaseReferences<_$AppDatabase, $ClassesTable, ClassesData>),
    ClassesData,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String?> msisdn,
  Value<double?> amount,
  Value<String?> reference,
  Value<String?> type,
  Value<String?> status,
  Value<int?> mechantId,
  Value<String?> settlementStatus,
  Value<String?> charge,
  Value<String?> receivingAccountId,
  Value<String?> totalAmount,
  Value<String?> settlementId,
  Value<String?> settlementDate,
  Value<String?> transactionId,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> description,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String?> msisdn,
  Value<double?> amount,
  Value<String?> reference,
  Value<String?> type,
  Value<String?> status,
  Value<int?> mechantId,
  Value<String?> settlementStatus,
  Value<String?> charge,
  Value<String?> receivingAccountId,
  Value<String?> totalAmount,
  Value<String?> settlementId,
  Value<String?> settlementDate,
  Value<String?> transactionId,
  Value<String?> createdAt,
  Value<String?> updatedAt,
  Value<String?> description,
});

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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get msisdn => $composableBuilder(
      column: $table.msisdn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settlementStatus => $composableBuilder(
      column: $table.settlementStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get charge => $composableBuilder(
      column: $table.charge, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receivingAccountId => $composableBuilder(
      column: $table.receivingAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settlementId => $composableBuilder(
      column: $table.settlementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settlementDate => $composableBuilder(
      column: $table.settlementDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get msisdn => $composableBuilder(
      column: $table.msisdn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mechantId => $composableBuilder(
      column: $table.mechantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settlementStatus => $composableBuilder(
      column: $table.settlementStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get charge => $composableBuilder(
      column: $table.charge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receivingAccountId => $composableBuilder(
      column: $table.receivingAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settlementId => $composableBuilder(
      column: $table.settlementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settlementDate => $composableBuilder(
      column: $table.settlementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get msisdn =>
      $composableBuilder(column: $table.msisdn, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get mechantId =>
      $composableBuilder(column: $table.mechantId, builder: (column) => column);

  GeneratedColumn<String> get settlementStatus => $composableBuilder(
      column: $table.settlementStatus, builder: (column) => column);

  GeneratedColumn<String> get charge =>
      $composableBuilder(column: $table.charge, builder: (column) => column);

  GeneratedColumn<String> get receivingAccountId => $composableBuilder(
      column: $table.receivingAccountId, builder: (column) => column);

  GeneratedColumn<String> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get settlementId => $composableBuilder(
      column: $table.settlementId, builder: (column) => column);

  GeneratedColumn<String> get settlementDate => $composableBuilder(
      column: $table.settlementDate, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> msisdn = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int?> mechantId = const Value.absent(),
            Value<String?> settlementStatus = const Value.absent(),
            Value<String?> charge = const Value.absent(),
            Value<String?> receivingAccountId = const Value.absent(),
            Value<String?> totalAmount = const Value.absent(),
            Value<String?> settlementId = const Value.absent(),
            Value<String?> settlementDate = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            msisdn: msisdn,
            amount: amount,
            reference: reference,
            type: type,
            status: status,
            mechantId: mechantId,
            settlementStatus: settlementStatus,
            charge: charge,
            receivingAccountId: receivingAccountId,
            totalAmount: totalAmount,
            settlementId: settlementId,
            settlementDate: settlementDate,
            transactionId: transactionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> msisdn = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int?> mechantId = const Value.absent(),
            Value<String?> settlementStatus = const Value.absent(),
            Value<String?> charge = const Value.absent(),
            Value<String?> receivingAccountId = const Value.absent(),
            Value<String?> totalAmount = const Value.absent(),
            Value<String?> settlementId = const Value.absent(),
            Value<String?> settlementDate = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            msisdn: msisdn,
            amount: amount,
            reference: reference,
            type: type,
            status: status,
            mechantId: mechantId,
            settlementStatus: settlementStatus,
            charge: charge,
            receivingAccountId: receivingAccountId,
            totalAmount: totalAmount,
            settlementId: settlementId,
            settlementDate: settlementDate,
            transactionId: transactionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$BankAccountsTableCreateCompanionBuilder = BankAccountsCompanion
    Function({
  Value<int> id,
  required String bankName,
  required String accountName,
  required String accountNumber,
  Value<String?> accountType,
  Value<String> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$BankAccountsTableUpdateCompanionBuilder = BankAccountsCompanion
    Function({
  Value<int> id,
  Value<String> bankName,
  Value<String> accountName,
  Value<String> accountNumber,
  Value<String?> accountType,
  Value<String> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$BankAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BankAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BankAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BankAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BankAccountsTable,
    BankAccount,
    $$BankAccountsTableFilterComposer,
    $$BankAccountsTableOrderingComposer,
    $$BankAccountsTableAnnotationComposer,
    $$BankAccountsTableCreateCompanionBuilder,
    $$BankAccountsTableUpdateCompanionBuilder,
    (
      BankAccount,
      BaseReferences<_$AppDatabase, $BankAccountsTable, BankAccount>
    ),
    BankAccount,
    PrefetchHooks Function()> {
  $$BankAccountsTableTableManager(_$AppDatabase db, $BankAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bankName = const Value.absent(),
            Value<String> accountName = const Value.absent(),
            Value<String> accountNumber = const Value.absent(),
            Value<String?> accountType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              BankAccountsCompanion(
            id: id,
            bankName: bankName,
            accountName: accountName,
            accountNumber: accountNumber,
            accountType: accountType,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bankName,
            required String accountName,
            required String accountNumber,
            Value<String?> accountType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              BankAccountsCompanion.insert(
            id: id,
            bankName: bankName,
            accountName: accountName,
            accountNumber: accountNumber,
            accountType: accountType,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BankAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BankAccountsTable,
    BankAccount,
    $$BankAccountsTableFilterComposer,
    $$BankAccountsTableOrderingComposer,
    $$BankAccountsTableAnnotationComposer,
    $$BankAccountsTableCreateCompanionBuilder,
    $$BankAccountsTableUpdateCompanionBuilder,
    (
      BankAccount,
      BaseReferences<_$AppDatabase, $BankAccountsTable, BankAccount>
    ),
    BankAccount,
    PrefetchHooks Function()>;
typedef $$SubjectAssignChildrensTableCreateCompanionBuilder
    = SubjectAssignChildrensCompanion Function({
  Value<int> id,
  required String subjectAssignId,
  required String subjectId,
  required String staffId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$SubjectAssignChildrensTableUpdateCompanionBuilder
    = SubjectAssignChildrensCompanion Function({
  Value<int> id,
  Value<String> subjectAssignId,
  Value<String> subjectId,
  Value<String> staffId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$SubjectAssignChildrensTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectAssignChildrensTable> {
  $$SubjectAssignChildrensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectAssignId => $composableBuilder(
      column: $table.subjectAssignId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get staffId => $composableBuilder(
      column: $table.staffId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubjectAssignChildrensTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectAssignChildrensTable> {
  $$SubjectAssignChildrensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectAssignId => $composableBuilder(
      column: $table.subjectAssignId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get staffId => $composableBuilder(
      column: $table.staffId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubjectAssignChildrensTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectAssignChildrensTable> {
  $$SubjectAssignChildrensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectAssignId => $composableBuilder(
      column: $table.subjectAssignId, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get staffId =>
      $composableBuilder(column: $table.staffId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubjectAssignChildrensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectAssignChildrensTable,
    SubjectAssignChildren,
    $$SubjectAssignChildrensTableFilterComposer,
    $$SubjectAssignChildrensTableOrderingComposer,
    $$SubjectAssignChildrensTableAnnotationComposer,
    $$SubjectAssignChildrensTableCreateCompanionBuilder,
    $$SubjectAssignChildrensTableUpdateCompanionBuilder,
    (
      SubjectAssignChildren,
      BaseReferences<_$AppDatabase, $SubjectAssignChildrensTable,
          SubjectAssignChildren>
    ),
    SubjectAssignChildren,
    PrefetchHooks Function()> {
  $$SubjectAssignChildrensTableTableManager(
      _$AppDatabase db, $SubjectAssignChildrensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectAssignChildrensTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectAssignChildrensTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectAssignChildrensTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> subjectAssignId = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> staffId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SubjectAssignChildrensCompanion(
            id: id,
            subjectAssignId: subjectAssignId,
            subjectId: subjectId,
            staffId: staffId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String subjectAssignId,
            required String subjectId,
            required String staffId,
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SubjectAssignChildrensCompanion.insert(
            id: id,
            subjectAssignId: subjectAssignId,
            subjectId: subjectId,
            staffId: staffId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubjectAssignChildrensTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SubjectAssignChildrensTable,
        SubjectAssignChildren,
        $$SubjectAssignChildrensTableFilterComposer,
        $$SubjectAssignChildrensTableOrderingComposer,
        $$SubjectAssignChildrensTableAnnotationComposer,
        $$SubjectAssignChildrensTableCreateCompanionBuilder,
        $$SubjectAssignChildrensTableUpdateCompanionBuilder,
        (
          SubjectAssignChildren,
          BaseReferences<_$AppDatabase, $SubjectAssignChildrensTable,
              SubjectAssignChildren>
        ),
        SubjectAssignChildren,
        PrefetchHooks Function()>;
typedef $$SubjectAssignsTableCreateCompanionBuilder = SubjectAssignsCompanion
    Function({
  Value<int> id,
  required String sessionId,
  required String classesId,
  required String sectionId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$SubjectAssignsTableUpdateCompanionBuilder = SubjectAssignsCompanion
    Function({
  Value<int> id,
  Value<String> sessionId,
  Value<String> classesId,
  Value<String> sectionId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$SubjectAssignsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectAssignsTable> {
  $$SubjectAssignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classesId => $composableBuilder(
      column: $table.classesId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubjectAssignsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectAssignsTable> {
  $$SubjectAssignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classesId => $composableBuilder(
      column: $table.classesId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubjectAssignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectAssignsTable> {
  $$SubjectAssignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get classesId =>
      $composableBuilder(column: $table.classesId, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubjectAssignsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectAssignsTable,
    SubjectAssign,
    $$SubjectAssignsTableFilterComposer,
    $$SubjectAssignsTableOrderingComposer,
    $$SubjectAssignsTableAnnotationComposer,
    $$SubjectAssignsTableCreateCompanionBuilder,
    $$SubjectAssignsTableUpdateCompanionBuilder,
    (
      SubjectAssign,
      BaseReferences<_$AppDatabase, $SubjectAssignsTable, SubjectAssign>
    ),
    SubjectAssign,
    PrefetchHooks Function()> {
  $$SubjectAssignsTableTableManager(
      _$AppDatabase db, $SubjectAssignsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectAssignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectAssignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectAssignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> classesId = const Value.absent(),
            Value<String> sectionId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SubjectAssignsCompanion(
            id: id,
            sessionId: sessionId,
            classesId: classesId,
            sectionId: sectionId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionId,
            required String classesId,
            required String sectionId,
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SubjectAssignsCompanion.insert(
            id: id,
            sessionId: sessionId,
            classesId: classesId,
            sectionId: sectionId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubjectAssignsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectAssignsTable,
    SubjectAssign,
    $$SubjectAssignsTableFilterComposer,
    $$SubjectAssignsTableOrderingComposer,
    $$SubjectAssignsTableAnnotationComposer,
    $$SubjectAssignsTableCreateCompanionBuilder,
    $$SubjectAssignsTableUpdateCompanionBuilder,
    (
      SubjectAssign,
      BaseReferences<_$AppDatabase, $SubjectAssignsTable, SubjectAssign>
    ),
    SubjectAssign,
    PrefetchHooks Function()>;
typedef $$UserCredentialsTableCreateCompanionBuilder = UserCredentialsCompanion
    Function({
  Value<int> id,
  required String name,
  required String email,
  required String phone,
  required String status,
  Value<DateTime?> emailVerifiedAt,
  Value<String?> password,
  Value<String?> rememberToken,
  Value<String?> otp,
  Value<String?> otpVerified,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UserCredentialsTableUpdateCompanionBuilder = UserCredentialsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> phone,
  Value<String> status,
  Value<DateTime?> emailVerifiedAt,
  Value<String?> password,
  Value<String?> rememberToken,
  Value<String?> otp,
  Value<String?> otpVerified,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$UserCredentialsTableFilterComposer
    extends Composer<_$AppDatabase, $UserCredentialsTable> {
  $$UserCredentialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get emailVerifiedAt => $composableBuilder(
      column: $table.emailVerifiedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rememberToken => $composableBuilder(
      column: $table.rememberToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otpVerified => $composableBuilder(
      column: $table.otpVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserCredentialsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCredentialsTable> {
  $$UserCredentialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get emailVerifiedAt => $composableBuilder(
      column: $table.emailVerifiedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rememberToken => $composableBuilder(
      column: $table.rememberToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otp => $composableBuilder(
      column: $table.otp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otpVerified => $composableBuilder(
      column: $table.otpVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserCredentialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCredentialsTable> {
  $$UserCredentialsTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get emailVerifiedAt => $composableBuilder(
      column: $table.emailVerifiedAt, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get rememberToken => $composableBuilder(
      column: $table.rememberToken, builder: (column) => column);

  GeneratedColumn<String> get otp =>
      $composableBuilder(column: $table.otp, builder: (column) => column);

  GeneratedColumn<String> get otpVerified => $composableBuilder(
      column: $table.otpVerified, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserCredentialsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserCredentialsTable,
    UserCredential,
    $$UserCredentialsTableFilterComposer,
    $$UserCredentialsTableOrderingComposer,
    $$UserCredentialsTableAnnotationComposer,
    $$UserCredentialsTableCreateCompanionBuilder,
    $$UserCredentialsTableUpdateCompanionBuilder,
    (
      UserCredential,
      BaseReferences<_$AppDatabase, $UserCredentialsTable, UserCredential>
    ),
    UserCredential,
    PrefetchHooks Function()> {
  $$UserCredentialsTableTableManager(
      _$AppDatabase db, $UserCredentialsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCredentialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCredentialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCredentialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> emailVerifiedAt = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> rememberToken = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> otpVerified = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserCredentialsCompanion(
            id: id,
            name: name,
            email: email,
            phone: phone,
            status: status,
            emailVerifiedAt: emailVerifiedAt,
            password: password,
            rememberToken: rememberToken,
            otp: otp,
            otpVerified: otpVerified,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            required String phone,
            required String status,
            Value<DateTime?> emailVerifiedAt = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> rememberToken = const Value.absent(),
            Value<String?> otp = const Value.absent(),
            Value<String?> otpVerified = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserCredentialsCompanion.insert(
            id: id,
            name: name,
            email: email,
            phone: phone,
            status: status,
            emailVerifiedAt: emailVerifiedAt,
            password: password,
            rememberToken: rememberToken,
            otp: otp,
            otpVerified: otpVerified,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserCredentialsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserCredentialsTable,
    UserCredential,
    $$UserCredentialsTableFilterComposer,
    $$UserCredentialsTableOrderingComposer,
    $$UserCredentialsTableAnnotationComposer,
    $$UserCredentialsTableCreateCompanionBuilder,
    $$UserCredentialsTableUpdateCompanionBuilder,
    (
      UserCredential,
      BaseReferences<_$AppDatabase, $UserCredentialsTable, UserCredential>
    ),
    UserCredential,
    PrefetchHooks Function()>;
typedef $$StaffTableCreateCompanionBuilder = StaffCompanion Function({
  Value<int> id,
  required String userId,
  required String staffId,
  required String roleId,
  required String designationId,
  required String departmentId,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> email,
  Value<String?> genderId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$StaffTableUpdateCompanionBuilder = StaffCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String> staffId,
  Value<String> roleId,
  Value<String> designationId,
  Value<String> departmentId,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> email,
  Value<String?> genderId,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$StaffTableFilterComposer extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get staffId => $composableBuilder(
      column: $table.staffId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designationId => $composableBuilder(
      column: $table.designationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StaffTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get staffId => $composableBuilder(
      column: $table.staffId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designationId => $composableBuilder(
      column: $table.designationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get departmentId => $composableBuilder(
      column: $table.departmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StaffTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get staffId =>
      $composableBuilder(column: $table.staffId, builder: (column) => column);

  GeneratedColumn<String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<String> get designationId => $composableBuilder(
      column: $table.designationId, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get genderId =>
      $composableBuilder(column: $table.genderId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StaffTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaffTable,
    StaffData,
    $$StaffTableFilterComposer,
    $$StaffTableOrderingComposer,
    $$StaffTableAnnotationComposer,
    $$StaffTableCreateCompanionBuilder,
    $$StaffTableUpdateCompanionBuilder,
    (StaffData, BaseReferences<_$AppDatabase, $StaffTable, StaffData>),
    StaffData,
    PrefetchHooks Function()> {
  $$StaffTableTableManager(_$AppDatabase db, $StaffTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> staffId = const Value.absent(),
            Value<String> roleId = const Value.absent(),
            Value<String> designationId = const Value.absent(),
            Value<String> departmentId = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> genderId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StaffCompanion(
            id: id,
            userId: userId,
            staffId: staffId,
            roleId: roleId,
            designationId: designationId,
            departmentId: departmentId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            genderId: genderId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required String staffId,
            required String roleId,
            required String designationId,
            required String departmentId,
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> genderId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StaffCompanion.insert(
            id: id,
            userId: userId,
            staffId: staffId,
            roleId: roleId,
            designationId: designationId,
            departmentId: departmentId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            genderId: genderId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StaffTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaffTable,
    StaffData,
    $$StaffTableFilterComposer,
    $$StaffTableOrderingComposer,
    $$StaffTableAnnotationComposer,
    $$StaffTableCreateCompanionBuilder,
    $$StaffTableUpdateCompanionBuilder,
    (StaffData, BaseReferences<_$AppDatabase, $StaffTable, StaffData>),
    StaffData,
    PrefetchHooks Function()>;
typedef $$MarksGradeTableCreateCompanionBuilder = MarksGradeCompanion Function({
  Value<int> id,
  required String name,
  required double percentFrom,
  required double percentUpto,
  required int point,
  Value<String?> remarks,
  required int sessionId,
  Value<int> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$MarksGradeTableUpdateCompanionBuilder = MarksGradeCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> percentFrom,
  Value<double> percentUpto,
  Value<int> point,
  Value<String?> remarks,
  Value<int> sessionId,
  Value<int> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$MarksGradeTableFilterComposer
    extends Composer<_$AppDatabase, $MarksGradeTable> {
  $$MarksGradeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentFrom => $composableBuilder(
      column: $table.percentFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentUpto => $composableBuilder(
      column: $table.percentUpto, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get point => $composableBuilder(
      column: $table.point, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MarksGradeTableOrderingComposer
    extends Composer<_$AppDatabase, $MarksGradeTable> {
  $$MarksGradeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentFrom => $composableBuilder(
      column: $table.percentFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentUpto => $composableBuilder(
      column: $table.percentUpto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get point => $composableBuilder(
      column: $table.point, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MarksGradeTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarksGradeTable> {
  $$MarksGradeTableAnnotationComposer({
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

  GeneratedColumn<double> get percentFrom => $composableBuilder(
      column: $table.percentFrom, builder: (column) => column);

  GeneratedColumn<double> get percentUpto => $composableBuilder(
      column: $table.percentUpto, builder: (column) => column);

  GeneratedColumn<int> get point =>
      $composableBuilder(column: $table.point, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MarksGradeTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarksGradeTable,
    MarksGradeData,
    $$MarksGradeTableFilterComposer,
    $$MarksGradeTableOrderingComposer,
    $$MarksGradeTableAnnotationComposer,
    $$MarksGradeTableCreateCompanionBuilder,
    $$MarksGradeTableUpdateCompanionBuilder,
    (
      MarksGradeData,
      BaseReferences<_$AppDatabase, $MarksGradeTable, MarksGradeData>
    ),
    MarksGradeData,
    PrefetchHooks Function()> {
  $$MarksGradeTableTableManager(_$AppDatabase db, $MarksGradeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarksGradeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarksGradeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarksGradeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> percentFrom = const Value.absent(),
            Value<double> percentUpto = const Value.absent(),
            Value<int> point = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              MarksGradeCompanion(
            id: id,
            name: name,
            percentFrom: percentFrom,
            percentUpto: percentUpto,
            point: point,
            remarks: remarks,
            sessionId: sessionId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double percentFrom,
            required double percentUpto,
            required int point,
            Value<String?> remarks = const Value.absent(),
            required int sessionId,
            Value<int> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              MarksGradeCompanion.insert(
            id: id,
            name: name,
            percentFrom: percentFrom,
            percentUpto: percentUpto,
            point: point,
            remarks: remarks,
            sessionId: sessionId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarksGradeTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarksGradeTable,
    MarksGradeData,
    $$MarksGradeTableFilterComposer,
    $$MarksGradeTableOrderingComposer,
    $$MarksGradeTableAnnotationComposer,
    $$MarksGradeTableCreateCompanionBuilder,
    $$MarksGradeTableUpdateCompanionBuilder,
    (
      MarksGradeData,
      BaseReferences<_$AppDatabase, $MarksGradeTable, MarksGradeData>
    ),
    MarksGradeData,
    PrefetchHooks Function()>;
typedef $$ParentDetailsTableCreateCompanionBuilder = ParentDetailsCompanion
    Function({
  Value<int> id,
  required int userId,
  Value<String?> fatherName,
  Value<String?> fatherMobile,
  Value<String?> fatherProfession,
  Value<String?> fatherImage,
  Value<String?> fatherNationality,
  Value<String?> motherName,
  Value<String?> motherMobile,
  Value<String?> motherProfession,
  Value<String?> motherImage,
  Value<String?> guardianName,
  Value<String?> guardianEmail,
  Value<String?> guardianMobile,
  Value<String?> guardianImage,
  Value<String?> guardianProfession,
  Value<String?> guardianRelation,
  Value<String?> guardianAddress,
  Value<int> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$ParentDetailsTableUpdateCompanionBuilder = ParentDetailsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<String?> fatherName,
  Value<String?> fatherMobile,
  Value<String?> fatherProfession,
  Value<String?> fatherImage,
  Value<String?> fatherNationality,
  Value<String?> motherName,
  Value<String?> motherMobile,
  Value<String?> motherProfession,
  Value<String?> motherImage,
  Value<String?> guardianName,
  Value<String?> guardianEmail,
  Value<String?> guardianMobile,
  Value<String?> guardianImage,
  Value<String?> guardianProfession,
  Value<String?> guardianRelation,
  Value<String?> guardianAddress,
  Value<int> status,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$ParentDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $ParentDetailsTable> {
  $$ParentDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherMobile => $composableBuilder(
      column: $table.fatherMobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherProfession => $composableBuilder(
      column: $table.fatherProfession,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherImage => $composableBuilder(
      column: $table.fatherImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherNationality => $composableBuilder(
      column: $table.fatherNationality,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherName => $composableBuilder(
      column: $table.motherName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherMobile => $composableBuilder(
      column: $table.motherMobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherProfession => $composableBuilder(
      column: $table.motherProfession,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherImage => $composableBuilder(
      column: $table.motherImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianName => $composableBuilder(
      column: $table.guardianName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianEmail => $composableBuilder(
      column: $table.guardianEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianMobile => $composableBuilder(
      column: $table.guardianMobile,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianImage => $composableBuilder(
      column: $table.guardianImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianProfession => $composableBuilder(
      column: $table.guardianProfession,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianRelation => $composableBuilder(
      column: $table.guardianRelation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guardianAddress => $composableBuilder(
      column: $table.guardianAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ParentDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParentDetailsTable> {
  $$ParentDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherMobile => $composableBuilder(
      column: $table.fatherMobile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherProfession => $composableBuilder(
      column: $table.fatherProfession,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherImage => $composableBuilder(
      column: $table.fatherImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherNationality => $composableBuilder(
      column: $table.fatherNationality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherName => $composableBuilder(
      column: $table.motherName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherMobile => $composableBuilder(
      column: $table.motherMobile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherProfession => $composableBuilder(
      column: $table.motherProfession,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherImage => $composableBuilder(
      column: $table.motherImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianName => $composableBuilder(
      column: $table.guardianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianEmail => $composableBuilder(
      column: $table.guardianEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianMobile => $composableBuilder(
      column: $table.guardianMobile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianImage => $composableBuilder(
      column: $table.guardianImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianProfession => $composableBuilder(
      column: $table.guardianProfession,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianRelation => $composableBuilder(
      column: $table.guardianRelation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guardianAddress => $composableBuilder(
      column: $table.guardianAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ParentDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParentDetailsTable> {
  $$ParentDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => column);

  GeneratedColumn<String> get fatherMobile => $composableBuilder(
      column: $table.fatherMobile, builder: (column) => column);

  GeneratedColumn<String> get fatherProfession => $composableBuilder(
      column: $table.fatherProfession, builder: (column) => column);

  GeneratedColumn<String> get fatherImage => $composableBuilder(
      column: $table.fatherImage, builder: (column) => column);

  GeneratedColumn<String> get fatherNationality => $composableBuilder(
      column: $table.fatherNationality, builder: (column) => column);

  GeneratedColumn<String> get motherName => $composableBuilder(
      column: $table.motherName, builder: (column) => column);

  GeneratedColumn<String> get motherMobile => $composableBuilder(
      column: $table.motherMobile, builder: (column) => column);

  GeneratedColumn<String> get motherProfession => $composableBuilder(
      column: $table.motherProfession, builder: (column) => column);

  GeneratedColumn<String> get motherImage => $composableBuilder(
      column: $table.motherImage, builder: (column) => column);

  GeneratedColumn<String> get guardianName => $composableBuilder(
      column: $table.guardianName, builder: (column) => column);

  GeneratedColumn<String> get guardianEmail => $composableBuilder(
      column: $table.guardianEmail, builder: (column) => column);

  GeneratedColumn<String> get guardianMobile => $composableBuilder(
      column: $table.guardianMobile, builder: (column) => column);

  GeneratedColumn<String> get guardianImage => $composableBuilder(
      column: $table.guardianImage, builder: (column) => column);

  GeneratedColumn<String> get guardianProfession => $composableBuilder(
      column: $table.guardianProfession, builder: (column) => column);

  GeneratedColumn<String> get guardianRelation => $composableBuilder(
      column: $table.guardianRelation, builder: (column) => column);

  GeneratedColumn<String> get guardianAddress => $composableBuilder(
      column: $table.guardianAddress, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParentDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ParentDetailsTable,
    ParentDetail,
    $$ParentDetailsTableFilterComposer,
    $$ParentDetailsTableOrderingComposer,
    $$ParentDetailsTableAnnotationComposer,
    $$ParentDetailsTableCreateCompanionBuilder,
    $$ParentDetailsTableUpdateCompanionBuilder,
    (
      ParentDetail,
      BaseReferences<_$AppDatabase, $ParentDetailsTable, ParentDetail>
    ),
    ParentDetail,
    PrefetchHooks Function()> {
  $$ParentDetailsTableTableManager(_$AppDatabase db, $ParentDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParentDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParentDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParentDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String?> fatherName = const Value.absent(),
            Value<String?> fatherMobile = const Value.absent(),
            Value<String?> fatherProfession = const Value.absent(),
            Value<String?> fatherImage = const Value.absent(),
            Value<String?> fatherNationality = const Value.absent(),
            Value<String?> motherName = const Value.absent(),
            Value<String?> motherMobile = const Value.absent(),
            Value<String?> motherProfession = const Value.absent(),
            Value<String?> motherImage = const Value.absent(),
            Value<String?> guardianName = const Value.absent(),
            Value<String?> guardianEmail = const Value.absent(),
            Value<String?> guardianMobile = const Value.absent(),
            Value<String?> guardianImage = const Value.absent(),
            Value<String?> guardianProfession = const Value.absent(),
            Value<String?> guardianRelation = const Value.absent(),
            Value<String?> guardianAddress = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              ParentDetailsCompanion(
            id: id,
            userId: userId,
            fatherName: fatherName,
            fatherMobile: fatherMobile,
            fatherProfession: fatherProfession,
            fatherImage: fatherImage,
            fatherNationality: fatherNationality,
            motherName: motherName,
            motherMobile: motherMobile,
            motherProfession: motherProfession,
            motherImage: motherImage,
            guardianName: guardianName,
            guardianEmail: guardianEmail,
            guardianMobile: guardianMobile,
            guardianImage: guardianImage,
            guardianProfession: guardianProfession,
            guardianRelation: guardianRelation,
            guardianAddress: guardianAddress,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<String?> fatherName = const Value.absent(),
            Value<String?> fatherMobile = const Value.absent(),
            Value<String?> fatherProfession = const Value.absent(),
            Value<String?> fatherImage = const Value.absent(),
            Value<String?> fatherNationality = const Value.absent(),
            Value<String?> motherName = const Value.absent(),
            Value<String?> motherMobile = const Value.absent(),
            Value<String?> motherProfession = const Value.absent(),
            Value<String?> motherImage = const Value.absent(),
            Value<String?> guardianName = const Value.absent(),
            Value<String?> guardianEmail = const Value.absent(),
            Value<String?> guardianMobile = const Value.absent(),
            Value<String?> guardianImage = const Value.absent(),
            Value<String?> guardianProfession = const Value.absent(),
            Value<String?> guardianRelation = const Value.absent(),
            Value<String?> guardianAddress = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              ParentDetailsCompanion.insert(
            id: id,
            userId: userId,
            fatherName: fatherName,
            fatherMobile: fatherMobile,
            fatherProfession: fatherProfession,
            fatherImage: fatherImage,
            fatherNationality: fatherNationality,
            motherName: motherName,
            motherMobile: motherMobile,
            motherProfession: motherProfession,
            motherImage: motherImage,
            guardianName: guardianName,
            guardianEmail: guardianEmail,
            guardianMobile: guardianMobile,
            guardianImage: guardianImage,
            guardianProfession: guardianProfession,
            guardianRelation: guardianRelation,
            guardianAddress: guardianAddress,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ParentDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ParentDetailsTable,
    ParentDetail,
    $$ParentDetailsTableFilterComposer,
    $$ParentDetailsTableOrderingComposer,
    $$ParentDetailsTableAnnotationComposer,
    $$ParentDetailsTableCreateCompanionBuilder,
    $$ParentDetailsTableUpdateCompanionBuilder,
    (
      ParentDetail,
      BaseReferences<_$AppDatabase, $ParentDetailsTable, ParentDetail>
    ),
    ParentDetail,
    PrefetchHooks Function()>;
typedef $$NoticeBoardsTableCreateCompanionBuilder = NoticeBoardsCompanion
    Function({
  Value<int> id,
  Value<String?> title,
  Value<String?> date,
  Value<String?> publishDate,
  Value<String?> description,
  Value<String?> attachment,
  Value<int?> isVisibleWeb,
  Value<int?> status,
  Value<String?> visibleTo,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$NoticeBoardsTableUpdateCompanionBuilder = NoticeBoardsCompanion
    Function({
  Value<int> id,
  Value<String?> title,
  Value<String?> date,
  Value<String?> publishDate,
  Value<String?> description,
  Value<String?> attachment,
  Value<int?> isVisibleWeb,
  Value<int?> status,
  Value<String?> visibleTo,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$NoticeBoardsTableFilterComposer
    extends Composer<_$AppDatabase, $NoticeBoardsTable> {
  $$NoticeBoardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publishDate => $composableBuilder(
      column: $table.publishDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachment => $composableBuilder(
      column: $table.attachment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isVisibleWeb => $composableBuilder(
      column: $table.isVisibleWeb, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visibleTo => $composableBuilder(
      column: $table.visibleTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NoticeBoardsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoticeBoardsTable> {
  $$NoticeBoardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publishDate => $composableBuilder(
      column: $table.publishDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachment => $composableBuilder(
      column: $table.attachment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isVisibleWeb => $composableBuilder(
      column: $table.isVisibleWeb,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visibleTo => $composableBuilder(
      column: $table.visibleTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NoticeBoardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoticeBoardsTable> {
  $$NoticeBoardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get publishDate => $composableBuilder(
      column: $table.publishDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get attachment => $composableBuilder(
      column: $table.attachment, builder: (column) => column);

  GeneratedColumn<int> get isVisibleWeb => $composableBuilder(
      column: $table.isVisibleWeb, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get visibleTo =>
      $composableBuilder(column: $table.visibleTo, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NoticeBoardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoticeBoardsTable,
    NoticeBoard,
    $$NoticeBoardsTableFilterComposer,
    $$NoticeBoardsTableOrderingComposer,
    $$NoticeBoardsTableAnnotationComposer,
    $$NoticeBoardsTableCreateCompanionBuilder,
    $$NoticeBoardsTableUpdateCompanionBuilder,
    (
      NoticeBoard,
      BaseReferences<_$AppDatabase, $NoticeBoardsTable, NoticeBoard>
    ),
    NoticeBoard,
    PrefetchHooks Function()> {
  $$NoticeBoardsTableTableManager(_$AppDatabase db, $NoticeBoardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoticeBoardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoticeBoardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoticeBoardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<String?> publishDate = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> attachment = const Value.absent(),
            Value<int?> isVisibleWeb = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<String?> visibleTo = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              NoticeBoardsCompanion(
            id: id,
            title: title,
            date: date,
            publishDate: publishDate,
            description: description,
            attachment: attachment,
            isVisibleWeb: isVisibleWeb,
            status: status,
            visibleTo: visibleTo,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<String?> publishDate = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> attachment = const Value.absent(),
            Value<int?> isVisibleWeb = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<String?> visibleTo = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              NoticeBoardsCompanion.insert(
            id: id,
            title: title,
            date: date,
            publishDate: publishDate,
            description: description,
            attachment: attachment,
            isVisibleWeb: isVisibleWeb,
            status: status,
            visibleTo: visibleTo,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoticeBoardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoticeBoardsTable,
    NoticeBoard,
    $$NoticeBoardsTableFilterComposer,
    $$NoticeBoardsTableOrderingComposer,
    $$NoticeBoardsTableAnnotationComposer,
    $$NoticeBoardsTableCreateCompanionBuilder,
    $$NoticeBoardsTableUpdateCompanionBuilder,
    (
      NoticeBoard,
      BaseReferences<_$AppDatabase, $NoticeBoardsTable, NoticeBoard>
    ),
    NoticeBoard,
    PrefetchHooks Function()>;
typedef $$StudentsListTableCreateCompanionBuilder = StudentsListCompanion
    Function({
  Value<int> id,
  Value<String?> admissionNo,
  Value<int?> rollNo,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> dob,
  Value<String?> admissionDate,
  Value<int?> studentCategoryId,
  Value<int?> religionId,
  Value<int?> bloodGroupId,
  Value<int?> genderId,
  Value<int?> categoryId,
  Value<int?> imageId,
  Value<int?> parentGuardianId,
  Value<int?> userId,
  Value<String?> uploadDocuments,
  Value<int?> status,
  Value<int?> previousSchool,
  Value<String?> previousSchoolInfo,
  Value<int?> previousSchoolImageId,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> cprNo,
  Value<String?> spokenLangAtHome,
  Value<String?> residanceAddress,
  Value<String?> controlNumber,
  Value<String?> available,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$StudentsListTableUpdateCompanionBuilder = StudentsListCompanion
    Function({
  Value<int> id,
  Value<String?> admissionNo,
  Value<int?> rollNo,
  Value<String?> firstName,
  Value<String?> lastName,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> dob,
  Value<String?> admissionDate,
  Value<int?> studentCategoryId,
  Value<int?> religionId,
  Value<int?> bloodGroupId,
  Value<int?> genderId,
  Value<int?> categoryId,
  Value<int?> imageId,
  Value<int?> parentGuardianId,
  Value<int?> userId,
  Value<String?> uploadDocuments,
  Value<int?> status,
  Value<int?> previousSchool,
  Value<String?> previousSchoolInfo,
  Value<int?> previousSchoolImageId,
  Value<String?> placeOfBirth,
  Value<String?> nationality,
  Value<String?> cprNo,
  Value<String?> spokenLangAtHome,
  Value<String?> residanceAddress,
  Value<String?> controlNumber,
  Value<String?> available,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$StudentsListTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsListTable> {
  $$StudentsListTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cprNo => $composableBuilder(
      column: $table.cprNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get available => $composableBuilder(
      column: $table.available, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StudentsListTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsListTable> {
  $$StudentsListTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get genderId => $composableBuilder(
      column: $table.genderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get imageId => $composableBuilder(
      column: $table.imageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cprNo => $composableBuilder(
      column: $table.cprNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get available => $composableBuilder(
      column: $table.available, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StudentsListTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsListTable> {
  $$StudentsListTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get admissionNo => $composableBuilder(
      column: $table.admissionNo, builder: (column) => column);

  GeneratedColumn<int> get rollNo =>
      $composableBuilder(column: $table.rollNo, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get admissionDate => $composableBuilder(
      column: $table.admissionDate, builder: (column) => column);

  GeneratedColumn<int> get studentCategoryId => $composableBuilder(
      column: $table.studentCategoryId, builder: (column) => column);

  GeneratedColumn<int> get religionId => $composableBuilder(
      column: $table.religionId, builder: (column) => column);

  GeneratedColumn<int> get bloodGroupId => $composableBuilder(
      column: $table.bloodGroupId, builder: (column) => column);

  GeneratedColumn<int> get genderId =>
      $composableBuilder(column: $table.genderId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<int> get parentGuardianId => $composableBuilder(
      column: $table.parentGuardianId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get uploadDocuments => $composableBuilder(
      column: $table.uploadDocuments, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get previousSchool => $composableBuilder(
      column: $table.previousSchool, builder: (column) => column);

  GeneratedColumn<String> get previousSchoolInfo => $composableBuilder(
      column: $table.previousSchoolInfo, builder: (column) => column);

  GeneratedColumn<int> get previousSchoolImageId => $composableBuilder(
      column: $table.previousSchoolImageId, builder: (column) => column);

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
      column: $table.placeOfBirth, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
      column: $table.nationality, builder: (column) => column);

  GeneratedColumn<String> get cprNo =>
      $composableBuilder(column: $table.cprNo, builder: (column) => column);

  GeneratedColumn<String> get spokenLangAtHome => $composableBuilder(
      column: $table.spokenLangAtHome, builder: (column) => column);

  GeneratedColumn<String> get residanceAddress => $composableBuilder(
      column: $table.residanceAddress, builder: (column) => column);

  GeneratedColumn<String> get controlNumber => $composableBuilder(
      column: $table.controlNumber, builder: (column) => column);

  GeneratedColumn<String> get available =>
      $composableBuilder(column: $table.available, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudentsListTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsListTable,
    StudentsListData,
    $$StudentsListTableFilterComposer,
    $$StudentsListTableOrderingComposer,
    $$StudentsListTableAnnotationComposer,
    $$StudentsListTableCreateCompanionBuilder,
    $$StudentsListTableUpdateCompanionBuilder,
    (
      StudentsListData,
      BaseReferences<_$AppDatabase, $StudentsListTable, StudentsListData>
    ),
    StudentsListData,
    PrefetchHooks Function()> {
  $$StudentsListTableTableManager(_$AppDatabase db, $StudentsListTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsListTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsListTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsListTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> admissionNo = const Value.absent(),
            Value<int?> rollNo = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> dob = const Value.absent(),
            Value<String?> admissionDate = const Value.absent(),
            Value<int?> studentCategoryId = const Value.absent(),
            Value<int?> religionId = const Value.absent(),
            Value<int?> bloodGroupId = const Value.absent(),
            Value<int?> genderId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> imageId = const Value.absent(),
            Value<int?> parentGuardianId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> uploadDocuments = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<int?> previousSchool = const Value.absent(),
            Value<String?> previousSchoolInfo = const Value.absent(),
            Value<int?> previousSchoolImageId = const Value.absent(),
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> cprNo = const Value.absent(),
            Value<String?> spokenLangAtHome = const Value.absent(),
            Value<String?> residanceAddress = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            Value<String?> available = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StudentsListCompanion(
            id: id,
            admissionNo: admissionNo,
            rollNo: rollNo,
            firstName: firstName,
            lastName: lastName,
            mobile: mobile,
            email: email,
            dob: dob,
            admissionDate: admissionDate,
            studentCategoryId: studentCategoryId,
            religionId: religionId,
            bloodGroupId: bloodGroupId,
            genderId: genderId,
            categoryId: categoryId,
            imageId: imageId,
            parentGuardianId: parentGuardianId,
            userId: userId,
            uploadDocuments: uploadDocuments,
            status: status,
            previousSchool: previousSchool,
            previousSchoolInfo: previousSchoolInfo,
            previousSchoolImageId: previousSchoolImageId,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            cprNo: cprNo,
            spokenLangAtHome: spokenLangAtHome,
            residanceAddress: residanceAddress,
            controlNumber: controlNumber,
            available: available,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> admissionNo = const Value.absent(),
            Value<int?> rollNo = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String?> lastName = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> dob = const Value.absent(),
            Value<String?> admissionDate = const Value.absent(),
            Value<int?> studentCategoryId = const Value.absent(),
            Value<int?> religionId = const Value.absent(),
            Value<int?> bloodGroupId = const Value.absent(),
            Value<int?> genderId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> imageId = const Value.absent(),
            Value<int?> parentGuardianId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> uploadDocuments = const Value.absent(),
            Value<int?> status = const Value.absent(),
            Value<int?> previousSchool = const Value.absent(),
            Value<String?> previousSchoolInfo = const Value.absent(),
            Value<int?> previousSchoolImageId = const Value.absent(),
            Value<String?> placeOfBirth = const Value.absent(),
            Value<String?> nationality = const Value.absent(),
            Value<String?> cprNo = const Value.absent(),
            Value<String?> spokenLangAtHome = const Value.absent(),
            Value<String?> residanceAddress = const Value.absent(),
            Value<String?> controlNumber = const Value.absent(),
            Value<String?> available = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StudentsListCompanion.insert(
            id: id,
            admissionNo: admissionNo,
            rollNo: rollNo,
            firstName: firstName,
            lastName: lastName,
            mobile: mobile,
            email: email,
            dob: dob,
            admissionDate: admissionDate,
            studentCategoryId: studentCategoryId,
            religionId: religionId,
            bloodGroupId: bloodGroupId,
            genderId: genderId,
            categoryId: categoryId,
            imageId: imageId,
            parentGuardianId: parentGuardianId,
            userId: userId,
            uploadDocuments: uploadDocuments,
            status: status,
            previousSchool: previousSchool,
            previousSchoolInfo: previousSchoolInfo,
            previousSchoolImageId: previousSchoolImageId,
            placeOfBirth: placeOfBirth,
            nationality: nationality,
            cprNo: cprNo,
            spokenLangAtHome: spokenLangAtHome,
            residanceAddress: residanceAddress,
            controlNumber: controlNumber,
            available: available,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsListTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsListTable,
    StudentsListData,
    $$StudentsListTableFilterComposer,
    $$StudentsListTableOrderingComposer,
    $$StudentsListTableAnnotationComposer,
    $$StudentsListTableCreateCompanionBuilder,
    $$StudentsListTableUpdateCompanionBuilder,
    (
      StudentsListData,
      BaseReferences<_$AppDatabase, $StudentsListTable, StudentsListData>
    ),
    StudentsListData,
    PrefetchHooks Function()>;
typedef $$StatusTableCreateCompanionBuilder = StatusCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$StatusTableUpdateCompanionBuilder = StatusCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$StatusTableFilterComposer
    extends Composer<_$AppDatabase, $StatusTable> {
  $$StatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StatusTableOrderingComposer
    extends Composer<_$AppDatabase, $StatusTable> {
  $$StatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatusTable> {
  $$StatusTableAnnotationComposer({
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StatusTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StatusTable,
    StatusData,
    $$StatusTableFilterComposer,
    $$StatusTableOrderingComposer,
    $$StatusTableAnnotationComposer,
    $$StatusTableCreateCompanionBuilder,
    $$StatusTableUpdateCompanionBuilder,
    (StatusData, BaseReferences<_$AppDatabase, $StatusTable, StatusData>),
    StatusData,
    PrefetchHooks Function()> {
  $$StatusTableTableManager(_$AppDatabase db, $StatusTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StatusCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              StatusCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StatusTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StatusTable,
    StatusData,
    $$StatusTableFilterComposer,
    $$StatusTableOrderingComposer,
    $$StatusTableAnnotationComposer,
    $$StatusTableCreateCompanionBuilder,
    $$StatusTableUpdateCompanionBuilder,
    (StatusData, BaseReferences<_$AppDatabase, $StatusTable, StatusData>),
    StatusData,
    PrefetchHooks Function()>;
typedef $$LoanStatusTableCreateCompanionBuilder = LoanStatusCompanion Function({
  Value<int> id,
  Value<String?> loanId,
  Value<String?> status,
  Value<String?> description,
  Value<String?> clientName,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$LoanStatusTableUpdateCompanionBuilder = LoanStatusCompanion Function({
  Value<int> id,
  Value<String?> loanId,
  Value<String?> status,
  Value<String?> description,
  Value<String?> clientName,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

class $$LoanStatusTableFilterComposer
    extends Composer<_$AppDatabase, $LoanStatusTable> {
  $$LoanStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LoanStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanStatusTable> {
  $$LoanStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LoanStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanStatusTable> {
  $$LoanStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loanId =>
      $composableBuilder(column: $table.loanId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LoanStatusTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanStatusTable,
    LoanStatusData,
    $$LoanStatusTableFilterComposer,
    $$LoanStatusTableOrderingComposer,
    $$LoanStatusTableAnnotationComposer,
    $$LoanStatusTableCreateCompanionBuilder,
    $$LoanStatusTableUpdateCompanionBuilder,
    (
      LoanStatusData,
      BaseReferences<_$AppDatabase, $LoanStatusTable, LoanStatusData>
    ),
    LoanStatusData,
    PrefetchHooks Function()> {
  $$LoanStatusTableTableManager(_$AppDatabase db, $LoanStatusTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> loanId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> clientName = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              LoanStatusCompanion(
            id: id,
            loanId: loanId,
            status: status,
            description: description,
            clientName: clientName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> loanId = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> clientName = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              LoanStatusCompanion.insert(
            id: id,
            loanId: loanId,
            status: status,
            description: description,
            clientName: clientName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoanStatusTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanStatusTable,
    LoanStatusData,
    $$LoanStatusTableFilterComposer,
    $$LoanStatusTableOrderingComposer,
    $$LoanStatusTableAnnotationComposer,
    $$LoanStatusTableCreateCompanionBuilder,
    $$LoanStatusTableUpdateCompanionBuilder,
    (
      LoanStatusData,
      BaseReferences<_$AppDatabase, $LoanStatusTable, LoanStatusData>
    ),
    LoanStatusData,
    PrefetchHooks Function()>;
typedef $$LoanScheduleTableCreateCompanionBuilder = LoanScheduleCompanion
    Function({
  Value<int> id,
  Value<int?> loanId,
  Value<String?> fromDate,
  Value<String?> dueDate,
  Value<int?> installment,
  Value<double?> totalAmountToBePaid,
  Value<double?> totalAmount,
  Value<double?> paidAmount,
  Value<double?> remainedAmount,
  Value<int?> completedDerived,
});
typedef $$LoanScheduleTableUpdateCompanionBuilder = LoanScheduleCompanion
    Function({
  Value<int> id,
  Value<int?> loanId,
  Value<String?> fromDate,
  Value<String?> dueDate,
  Value<int?> installment,
  Value<double?> totalAmountToBePaid,
  Value<double?> totalAmount,
  Value<double?> paidAmount,
  Value<double?> remainedAmount,
  Value<int?> completedDerived,
});

class $$LoanScheduleTableFilterComposer
    extends Composer<_$AppDatabase, $LoanScheduleTable> {
  $$LoanScheduleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromDate => $composableBuilder(
      column: $table.fromDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installment => $composableBuilder(
      column: $table.installment, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmountToBePaid => $composableBuilder(
      column: $table.totalAmountToBePaid,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedDerived => $composableBuilder(
      column: $table.completedDerived,
      builder: (column) => ColumnFilters(column));
}

class $$LoanScheduleTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanScheduleTable> {
  $$LoanScheduleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromDate => $composableBuilder(
      column: $table.fromDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installment => $composableBuilder(
      column: $table.installment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmountToBePaid => $composableBuilder(
      column: $table.totalAmountToBePaid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedDerived => $composableBuilder(
      column: $table.completedDerived,
      builder: (column) => ColumnOrderings(column));
}

class $$LoanScheduleTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanScheduleTable> {
  $$LoanScheduleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get loanId =>
      $composableBuilder(column: $table.loanId, builder: (column) => column);

  GeneratedColumn<String> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get installment => $composableBuilder(
      column: $table.installment, builder: (column) => column);

  GeneratedColumn<double> get totalAmountToBePaid => $composableBuilder(
      column: $table.totalAmountToBePaid, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<double> get remainedAmount => $composableBuilder(
      column: $table.remainedAmount, builder: (column) => column);

  GeneratedColumn<int> get completedDerived => $composableBuilder(
      column: $table.completedDerived, builder: (column) => column);
}

class $$LoanScheduleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanScheduleTable,
    LoanScheduleData,
    $$LoanScheduleTableFilterComposer,
    $$LoanScheduleTableOrderingComposer,
    $$LoanScheduleTableAnnotationComposer,
    $$LoanScheduleTableCreateCompanionBuilder,
    $$LoanScheduleTableUpdateCompanionBuilder,
    (
      LoanScheduleData,
      BaseReferences<_$AppDatabase, $LoanScheduleTable, LoanScheduleData>
    ),
    LoanScheduleData,
    PrefetchHooks Function()> {
  $$LoanScheduleTableTableManager(_$AppDatabase db, $LoanScheduleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanScheduleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanScheduleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanScheduleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> loanId = const Value.absent(),
            Value<String?> fromDate = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int?> installment = const Value.absent(),
            Value<double?> totalAmountToBePaid = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            Value<double?> paidAmount = const Value.absent(),
            Value<double?> remainedAmount = const Value.absent(),
            Value<int?> completedDerived = const Value.absent(),
          }) =>
              LoanScheduleCompanion(
            id: id,
            loanId: loanId,
            fromDate: fromDate,
            dueDate: dueDate,
            installment: installment,
            totalAmountToBePaid: totalAmountToBePaid,
            totalAmount: totalAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            completedDerived: completedDerived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> loanId = const Value.absent(),
            Value<String?> fromDate = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int?> installment = const Value.absent(),
            Value<double?> totalAmountToBePaid = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            Value<double?> paidAmount = const Value.absent(),
            Value<double?> remainedAmount = const Value.absent(),
            Value<int?> completedDerived = const Value.absent(),
          }) =>
              LoanScheduleCompanion.insert(
            id: id,
            loanId: loanId,
            fromDate: fromDate,
            dueDate: dueDate,
            installment: installment,
            totalAmountToBePaid: totalAmountToBePaid,
            totalAmount: totalAmount,
            paidAmount: paidAmount,
            remainedAmount: remainedAmount,
            completedDerived: completedDerived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoanScheduleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanScheduleTable,
    LoanScheduleData,
    $$LoanScheduleTableFilterComposer,
    $$LoanScheduleTableOrderingComposer,
    $$LoanScheduleTableAnnotationComposer,
    $$LoanScheduleTableCreateCompanionBuilder,
    $$LoanScheduleTableUpdateCompanionBuilder,
    (
      LoanScheduleData,
      BaseReferences<_$AppDatabase, $LoanScheduleTable, LoanScheduleData>
    ),
    LoanScheduleData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AppTransactionTableTableManager get appTransaction =>
      $$AppTransactionTableTableManager(_db, _db.appTransaction);
  $$BalanceTableTableManager get balance =>
      $$BalanceTableTableManager(_db, _db.balance);
  $$CustomerTableTableManager get customer =>
      $$CustomerTableTableManager(_db, _db.customer);
  $$LoanTableTableManager get loan => $$LoanTableTableManager(_db, _db.loan);
  $$MechantChargeConfigurationsTableTableManager
      get mechantChargeConfigurations =>
          $$MechantChargeConfigurationsTableTableManager(
              _db, _db.mechantChargeConfigurations);
  $$AccountSetupTableTableManager get accountSetup =>
      $$AccountSetupTableTableManager(_db, _db.accountSetup);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$FeesAssignmentsTableTableManager get feesAssignments =>
      $$FeesAssignmentsTableTableManager(_db, _db.feesAssignments);
  $$FeesAssignChildrenTableTableManager get feesAssignChildren =>
      $$FeesAssignChildrenTableTableManager(_db, _db.feesAssignChildren);
  $$ExamTypesTableTableManager get examTypes =>
      $$ExamTypesTableTableManager(_db, _db.examTypes);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BankAccountsTableTableManager get bankAccounts =>
      $$BankAccountsTableTableManager(_db, _db.bankAccounts);
  $$SubjectAssignChildrensTableTableManager get subjectAssignChildrens =>
      $$SubjectAssignChildrensTableTableManager(
          _db, _db.subjectAssignChildrens);
  $$SubjectAssignsTableTableManager get subjectAssigns =>
      $$SubjectAssignsTableTableManager(_db, _db.subjectAssigns);
  $$UserCredentialsTableTableManager get userCredentials =>
      $$UserCredentialsTableTableManager(_db, _db.userCredentials);
  $$StaffTableTableManager get staff =>
      $$StaffTableTableManager(_db, _db.staff);
  $$MarksGradeTableTableManager get marksGrade =>
      $$MarksGradeTableTableManager(_db, _db.marksGrade);
  $$ParentDetailsTableTableManager get parentDetails =>
      $$ParentDetailsTableTableManager(_db, _db.parentDetails);
  $$NoticeBoardsTableTableManager get noticeBoards =>
      $$NoticeBoardsTableTableManager(_db, _db.noticeBoards);
  $$StudentsListTableTableManager get studentsList =>
      $$StudentsListTableTableManager(_db, _db.studentsList);
  $$StatusTableTableManager get status =>
      $$StatusTableTableManager(_db, _db.status);
  $$LoanStatusTableTableManager get loanStatus =>
      $$LoanStatusTableTableManager(_db, _db.loanStatus);
  $$LoanScheduleTableTableManager get loanSchedule =>
      $$LoanScheduleTableTableManager(_db, _db.loanSchedule);
}
