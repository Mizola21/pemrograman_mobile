// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Direktori Mahasiswa';

  @override
  String get detailTitle => 'Detail Pengguna';

  @override
  String get email => 'Email';

  @override
  String get city => 'Kota';

  @override
  String get language => 'Bahasa';

  @override
  String get errorMessage => 'Gagal mengambil data.';

  @override
  String get retry => 'Coba lagi';

  @override
  String get noData => 'Data pengguna tidak ditemukan.';

  @override
  String get tabUsers => 'Pengguna';

  @override
  String get tabAdmins => 'Admin';

  @override
  String get department => 'Departemen';

  @override
  String get addUser => 'Tambah User (POST)';

  @override
  String get viewDetail => 'Lihat Detail';

  @override
  String get updatePut => 'PUT: Ubah Nama & Email';

  @override
  String get patchName => 'PATCH: Tambah teks di nama';

  @override
  String get delete => 'Hapus';

  @override
  String get cancel => 'Batal';

  @override
  String get confirmDelete => 'Hapus data ini?';

  @override
  String get userAdded => 'User berhasil ditambahkan.';

  @override
  String get userUpdated => 'User berhasil diubah dengan PUT.';

  @override
  String get userPatched => 'Nama user berhasil diubah dengan PATCH.';

  @override
  String get userDeleted => 'User berhasil dihapus.';

  @override
  String get adminDeleted => 'Admin berhasil dihapus.';

  @override
  String get resetData => 'Reset Data';

  @override
  String get dataReset => 'Data berhasil dikembalikan ke awal.';
}
