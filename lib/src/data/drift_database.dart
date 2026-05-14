import 'package:drift/drift.dart';
import 'drift_database_connection.dart';

part 'drift_database.g.dart';

// Users table
class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get mechantCode => text().named('mechant_code').nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get identificationNumber => text().named('identification_number').nullable()();
  TextColumn get licenceNumber => text().named('licence_number').nullable()();
  TextColumn get documentRefenceId => text().named('document_refence_id').nullable()();
  TextColumn get status => text().nullable()();
  IntColumn get agentId => integer().named('agent_id').nullable()();
  IntColumn get userId => integer().named('user_id').nullable()();
  TextColumn get otp => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// App Transaction table
class AppTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get receiverAccount => text().named('receiver_account').nullable()();
  TextColumn get senderAccount => text().named('sender_account').nullable()();
  TextColumn get amount => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

// Balance table
class Balance extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get amount => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}

// Customer table
class Customer extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get displayName => text().named('display_name').nullable()();
  TextColumn get externalId => text().named('external_id').nullable()();
  TextColumn get accountNo => text().named('account_no').nullable()();
  TextColumn get mobileNo => text().named('mobile_no').nullable()();
  TextColumn get otp => text().nullable()();
  TextColumn get loanAmount => text().named('loan_amount').nullable()();
  TextColumn get remainLoanAmount => text().named('remain_loan_amount').nullable()();
}

// Loan table
class Loan extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get totalRepaymentDerived => text().named('total_repayment_derived').nullable()();
  TextColumn get totalExpectedRepaymentDerived => text().named('total_expected_repayment_derived').nullable()();
  TextColumn get principalRepaidDerived => text().named('principal_repaid_derived').nullable()();
  TextColumn get principalAmount => text().named('principal_amount').nullable()();
  TextColumn get clientId => text().named('client_id').nullable()();
}

// Merchant Charge Configurations table
class MechantChargeConfigurations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mechantId => text().named('mechant_id').nullable()();
  TextColumn get chargeId => text().named('charge_id').nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
}

// Account Setup table
class AccountSetup extends Table {
  IntColumn get id => integer()();
  IntColumn get mechantId => integer().named('mechant_id').nullable()();
  TextColumn get paymentType => text().named('payment_type').nullable()();
  TextColumn get institutionName => text().named('institution_name').nullable()();
  TextColumn get receivingNumber => text().named('receiving_number').nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get verified => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Students table
class Students extends Table {
  IntColumn get id => integer()();
  TextColumn get admissionNo => text().named('admission_no').nullable()();
  TextColumn get rollNo => text().named('roll_no').nullable()();
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get dob => text().nullable()();
  TextColumn get admissionDate => text().named('admission_date').nullable()();
  IntColumn get studentCategoryId => integer().named('student_category_id').nullable()();
  IntColumn get religionId => integer().named('religion_id').nullable()();
  IntColumn get bloodGroupId => integer().named('blood_group_id').nullable()();
  IntColumn get genderId => integer().named('gender_id').nullable()();
  IntColumn get categoryId => integer().named('category_id').nullable()();
  IntColumn get imageId => integer().named('image_id').nullable()();
  IntColumn get parentGuardianId => integer().named('parent_guardian_id').nullable()();
  IntColumn get userId => integer().named('user_id').nullable()();
  TextColumn get uploadDocuments => text().named('upload_documents').nullable()();
  IntColumn get status => integer().nullable()();
  IntColumn get previousSchool => integer().named('previous_school').nullable()();
  TextColumn get previousSchoolInfo => text().named('previous_school_info').nullable()();
  IntColumn get previousSchoolImageId => integer().named('previous_school_image_id').nullable()();
  TextColumn get placeOfBirth => text().named('place_of_birth').nullable()();
  TextColumn get nationality => text().nullable()();
  TextColumn get cprNo => text().named('cpr_no').nullable()();
  TextColumn get spokenLangAtHome => text().named('spoken_lang_at_home').nullable()();
  TextColumn get residanceAddress => text().named('residance_address').nullable()();
  TextColumn get controlNumber => text().named('control_number').nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
  TextColumn get fullName => text().named('full_name').nullable()();
  TextColumn get className => text().named('class_name').nullable()();
  TextColumn get sectionName => text().named('section_name').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Fees Assignments table
class FeesAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feesAssignId => integer().named('fees_assign_id')();
  IntColumn get feesMasterId => integer().named('fees_master_id')();
  IntColumn get studentId => integer().named('student_id')();
  TextColumn get controlNumber => text().named('control_number')();
  TextColumn get feesAmount => text().named('fees_amount').withDefault(const Constant('0'))();
  TextColumn get paidAmount => text().named('paid_amount').withDefault(const Constant('0'))();
  TextColumn get remainedAmount => text().named('remained_amount').withDefault(const Constant('0'))();
  TextColumn get quaterAmount => text().named('quater_amount').nullable()();
  IntColumn get quaterOne => integer().named('quater_one').nullable()();
  IntColumn get quaterTwo => integer().named('quater_two').nullable()();
  IntColumn get quaterThree => integer().named('quater_three').nullable()();
  IntColumn get quaterFour => integer().named('quater_four').nullable()();
  TextColumn get comment => text().nullable()();
  TextColumn get outstandingbalance => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

// Fees Assign Children table
class FeesAssignChildren extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feesAssignId => integer().named('fees_assign_id')();
  IntColumn get feesMasterId => integer().named('fees_master_id')();
  IntColumn get studentId => integer().named('student_id')();
  TextColumn get controlNumber => text().named('control_number')();
  TextColumn get feesAmount => text().named('fees_amount').withDefault(const Constant('0'))();
  TextColumn get paidAmount => text().named('paid_amount').withDefault(const Constant('0'))();
  TextColumn get remainedAmount => text().named('remained_amount').withDefault(const Constant('0'))();
  TextColumn get quaterAmount => text().named('quater_amount').nullable()();
  IntColumn get quaterOne => integer().named('quater_one').nullable()();
  IntColumn get quaterTwo => integer().named('quater_two').nullable()();
  IntColumn get quaterThree => integer().named('quater_three').nullable()();
  IntColumn get quaterFour => integer().named('quater_four').nullable()();
  TextColumn get comment => text().nullable()();
  TextColumn get outstandingbalance => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

// Exam Types table
class ExamTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get type => text().nullable()();
  IntColumn get status => integer().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Classes table
class Classes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get status => integer()();
  IntColumn get orders => integer()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
  TextColumn get classTran => text().named('class_tran')();

  @override
  Set<Column> get primaryKey => {id};
}

// Transactions table
class Transactions extends Table {
  IntColumn get id => integer()();
  TextColumn get msisdn => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get status => text().nullable()();
  IntColumn get mechantId => integer().named('mechant_id').nullable()();
  TextColumn get settlementStatus => text().named('settlement_status').nullable()();
  TextColumn get charge => text().nullable()();
  TextColumn get receivingAccountId => text().named('receiving_account_id').nullable()();
  TextColumn get totalAmount => text().named('total_amount').nullable()();
  TextColumn get settlementId => text().named('settlement_id').nullable()();
  TextColumn get settlementDate => text().named('settlement_date').nullable()();
  TextColumn get transactionId => text().named('transaction_id').nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Bank Accounts table
class BankAccounts extends Table {
  IntColumn get id => integer()();
  TextColumn get bankName => text().named('bank_name')();
  TextColumn get accountName => text().named('account_name')();
  TextColumn get accountNumber => text().named('account_number')();
  TextColumn get accountType => text().named('account_type').nullable()();
  TextColumn get status => text().withDefault(const Constant('1'))();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Subject Assign Childrens table
class SubjectAssignChildrens extends Table {
  IntColumn get id => integer()();
  TextColumn get subjectAssignId => text().named('subject_assign_id')();
  TextColumn get subjectId => text().named('subject_id')();
  TextColumn get staffId => text().named('staff_id')();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Subject Assigns table
class SubjectAssigns extends Table {
  IntColumn get id => integer()();
  TextColumn get sessionId => text().named('session_id')();
  TextColumn get classesId => text().named('classes_id')();
  TextColumn get sectionId => text().named('section_id')();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// User Credentials table
class UserCredentials extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get status => text()();
  DateTimeColumn get emailVerifiedAt => dateTime().named('email_verified_at').nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get rememberToken => text().named('remember_token').nullable()();
  TextColumn get otp => text().nullable()();
  TextColumn get otpVerified => text().named('otp_verified').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

// Staff table
class Staff extends Table {
  IntColumn get id => integer()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get staffId => text().named('staff_id')();
  TextColumn get roleId => text().named('role_id')();
  TextColumn get designationId => text().named('designation_id')();
  TextColumn get departmentId => text().named('department_id')();
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get genderId => text().named('gender_id').nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Marks Grade table
class MarksGrade extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get percentFrom => real().named('percent_from')();
  RealColumn get percentUpto => real().named('percent_upto')();
  IntColumn get point => integer()();
  TextColumn get remarks => text().nullable()();
  IntColumn get sessionId => integer().named('session_id')();
  IntColumn get status => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
}

// Parent Details table
class ParentDetails extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().named('user_id')();
  TextColumn get fatherName => text().named('father_name').nullable()();
  TextColumn get fatherMobile => text().named('father_mobile').nullable()();
  TextColumn get fatherProfession => text().named('father_profession').nullable()();
  TextColumn get fatherImage => text().named('father_image').nullable()();
  TextColumn get fatherNationality => text().named('father_nationality').nullable()();
  TextColumn get motherName => text().named('mother_name').nullable()();
  TextColumn get motherMobile => text().named('mother_mobile').nullable()();
  TextColumn get motherProfession => text().named('mother_profession').nullable()();
  TextColumn get motherImage => text().named('mother_image').nullable()();
  TextColumn get guardianName => text().named('guardian_name').nullable()();
  TextColumn get guardianEmail => text().named('guardian_email').nullable()();
  TextColumn get guardianMobile => text().named('guardian_mobile').nullable()();
  TextColumn get guardianImage => text().named('guardian_image').nullable()();
  TextColumn get guardianProfession => text().named('guardian_profession').nullable()();
  TextColumn get guardianRelation => text().named('guardian_relation').nullable()();
  TextColumn get guardianAddress => text().named('guardian_address').nullable()();
  IntColumn get status => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
}

// Notice Boards table
class NoticeBoards extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text().nullable()();
  TextColumn get date => text().nullable()();
  TextColumn get publishDate => text().named('publish_date').nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get attachment => text().nullable()();
  IntColumn get isVisibleWeb => integer().named('is_visible_web').nullable()();
  IntColumn get status => integer().nullable()();
  TextColumn get visibleTo => text().named('visible_to').nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Students List table
class StudentsList extends Table {
  IntColumn get id => integer()();
  TextColumn get admissionNo => text().named('admission_no').nullable()();
  IntColumn get rollNo => integer().named('roll_no').nullable()();
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get dob => text().nullable()();
  TextColumn get admissionDate => text().named('admission_date').nullable()();
  IntColumn get studentCategoryId => integer().named('student_category_id').nullable()();
  IntColumn get religionId => integer().named('religion_id').nullable()();
  IntColumn get bloodGroupId => integer().named('blood_group_id').nullable()();
  IntColumn get genderId => integer().named('gender_id').nullable()();
  IntColumn get categoryId => integer().named('category_id').nullable()();
  IntColumn get imageId => integer().named('image_id').nullable()();
  IntColumn get parentGuardianId => integer().named('parent_guardian_id').nullable()();
  IntColumn get userId => integer().named('user_id').nullable()();
  TextColumn get uploadDocuments => text().named('upload_documents').nullable()();
  IntColumn get status => integer().nullable()();
  IntColumn get previousSchool => integer().named('previous_school').nullable()();
  TextColumn get previousSchoolInfo => text().named('previous_school_info').nullable()();
  IntColumn get previousSchoolImageId => integer().named('previous_school_image_id').nullable()();
  TextColumn get placeOfBirth => text().named('place_of_birth').nullable()();
  TextColumn get nationality => text().nullable()();
  TextColumn get cprNo => text().named('cpr_no').nullable()();
  TextColumn get spokenLangAtHome => text().named('spoken_lang_at_home').nullable()();
  TextColumn get residanceAddress => text().named('residance_address').nullable()();
  TextColumn get controlNumber => text().named('control_number').nullable()();
  TextColumn get available => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Status table
class Status extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Loan Status table
class LoanStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get loanId => text().named('loan_id').nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get clientName => text().named('client_name').nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();
}

// Loan Schedule table
class LoanSchedule extends Table {
  IntColumn get id => integer()();
  IntColumn get loanId => integer().named('loan_id').nullable()();
  TextColumn get fromDate => text().named('fromdate').nullable()();
  TextColumn get dueDate => text().named('duedate').nullable()();
  IntColumn get installment => integer().nullable()();
  RealColumn get totalAmountToBePaid => real().named('total_amount_to_be_paid').nullable()();
  RealColumn get totalAmount => real().named('total_amount').nullable()();
  RealColumn get paidAmount => real().named('paid_amount').nullable().withDefault(const Constant(0.0))();
  RealColumn get remainedAmount => real().named('remained_amount').nullable().withDefault(const Constant(0.0))();
  IntColumn get completedDerived => integer().named('completed_derived').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  AppTransaction,
  Balance,
  Customer,
  Loan,
  MechantChargeConfigurations,
  AccountSetup,
  Students,
  FeesAssignments,
  FeesAssignChildren,
  ExamTypes,
  Classes,
  Transactions,
  BankAccounts,
  SubjectAssignChildrens,
  SubjectAssigns,
  UserCredentials,
  Staff,
  MarksGrade,
  ParentDetails,
  NoticeBoards,
  StudentsList,
  Status,
  LoanStatus,
  LoanSchedule,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createDriftConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 6) {
            await customStatement('DROP TABLE IF EXISTS processed_sms;');
          }
        },
      );
}
