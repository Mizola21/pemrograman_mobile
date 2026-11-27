import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/admin.dart';

/// Service Admin. Cara kerjanya sama seperti ApiService (User):
/// data disimpan sebagai JSON lokal (file di HP/PC, SharedPreferences di Web).
/// JSONPlaceholder tidak punya data admin, jadi data awal dibuat di sini.
class AdminService {
  static const String fileName = 'admins.json';
  static const String webStorageKey = 'admins_json';

  static Future<io.File?> _getLocalFile() async {
    if (kIsWeb) return null;
    final directory = await getApplicationDocumentsDirectory();
    return io.File('${directory.path}/$fileName');
  }

  // Membaca data JSON (kompatibel Web & Mobile)
  static Future<List<dynamic>> _readJsonData() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      final cached = prefs.getString(webStorageKey);
      if (cached != null && cached.isNotEmpty) {
        try {
          return jsonDecode(cached) as List<dynamic>;
        } catch (_) {}
      }
      final initial = _defaultAdmins();
      await prefs.setString(webStorageKey, jsonEncode(initial));
      return initial;
    }

    try {
      final file = await _getLocalFile();
      if (file != null && await file.exists()) {
        final contents = await file.readAsString();
        if (contents.trim().isNotEmpty) {
          return jsonDecode(contents) as List<dynamic>;
        }
      }
      final initial = _defaultAdmins();
      if (file != null) {
        await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(initial),
        );
      }
      return initial;
    } catch (_) {
      final cached = prefs.getString(webStorageKey);
      if (cached != null && cached.isNotEmpty) {
        return jsonDecode(cached) as List<dynamic>;
      }
      return _defaultAdmins();
    }
  }

  // Menyimpan seluruh data JSON (kompatibel Web & Mobile)
  static Future<void> _writeJsonData(List<dynamic> admins) async {
    final jsonString = const JsonEncoder.withIndent('  ').convert(admins);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(webStorageKey, jsonString);

    if (!kIsWeb) {
      try {
        final file = await _getLocalFile();
        if (file != null) await file.writeAsString(jsonString);
      } catch (e) {
        debugPrint('Gagal menulis file admin: $e');
      }
    }
  }

  // GET: mengambil seluruh data admin
  static Future<List<Admin>> getAdmins() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final data = await _readJsonData();
    return data
        .map((e) => Admin.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // GET: mengambil satu admin berdasarkan ID
  static Future<Admin> getAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final data = await _readJsonData();
    final found = data.firstWhere(
      (e) => e['id'] == id,
      orElse: () => null,
    );
    if (found != null) {
      return Admin.fromJson(Map<String, dynamic>.from(found));
    }
    throw Exception('Data admin dengan ID $id tidak ditemukan');
  }

  // DELETE: menghapus admin berdasarkan ID
  static Future<bool> deleteAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final data = await _readJsonData();
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;
    data.removeAt(index);
    await _writeJsonData(data);
    return true;
  }

  // Kembalikan data ke kondisi awal
  static Future<void> resetToDefault() async {
    await _writeJsonData(_defaultAdmins());
  }

  // Data awal admin (termasuk ID Admin dari NIM = 830)
  static List<Map<String, dynamic>> _defaultAdmins() => [
        {
          'id': 1,
          'name': 'Budi Santoso',
          'email': 'budi.santoso@kampus.ac.id',
          'department': 'Akademik',
        },
        {
          'id': 2,
          'name': 'Siti Rahayu',
          'email': 'siti.rahayu@kampus.ac.id',
          'department': 'Keuangan',
        },
        {
          'id': 3,
          'name': 'Andi Pratama',
          'email': 'andi.pratama@kampus.ac.id',
          'department': 'Teknologi Informasi',
        },
        {
          'id': idAdmin,
          'name': 'Admin NIM $nim',
          'email': 'admin.$nim@kampus.ac.id',
          'department': 'Teknologi Informasi',
        },
      ];
}
