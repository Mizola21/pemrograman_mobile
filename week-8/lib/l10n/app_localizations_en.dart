// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Student Directory';

  @override
  String get detailTitle => 'User Details';

  @override
  String get email => 'Email';

  @override
  String get city => 'City';

  @override
  String get language => 'Language';

  @override
  String get errorMessage => 'Failed to retrieve data.';

  @override
  String get retry => 'Try Again';

  @override
  String get noData => 'No user data available.';

  @override
  String get tabUsers => 'Users';

  @override
  String get tabAdmins => 'Admins';

  @override
  String get department => 'Department';

  @override
  String get addUser => 'Add User (POST)';

  @override
  String get viewDetail => 'View Detail';

  @override
  String get updatePut => 'PUT: Update Name & Email';

  @override
  String get patchName => 'PATCH: Add suffix to name';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Delete this data?';

  @override
  String get userAdded => 'User added successfully.';

  @override
  String get userUpdated => 'User updated with PUT.';

  @override
  String get userPatched => 'User name updated with PATCH.';

  @override
  String get userDeleted => 'User deleted.';

  @override
  String get adminDeleted => 'Admin deleted.';

  @override
  String get resetData => 'Reset Data';

  @override
  String get dataReset => 'Data has been reset.';
}
