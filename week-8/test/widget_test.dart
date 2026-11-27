import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum8/config.dart';
import 'package:praktikum8/models/admin.dart';
import 'package:praktikum8/models/user_model.dart';

void main() {
  test('ID User dan ID Admin dihitung dari NIM (N = 38)', () {
    expect(idUser, 1537);
    expect(idAdmin, 830);
  });

  test('Admin.fromJson membaca semua properti', () {
    final admin = Admin.fromJson({
      'id': 830,
      'name': 'Admin Contoh',
      'email': 'admin@contoh.id',
      'department': 'Teknologi Informasi',
    });
    expect(admin.id, 830);
    expect(admin.name, 'Admin Contoh');
    expect(admin.email, 'admin@contoh.id');
    expect(admin.department, 'Teknologi Informasi');
  });

  test('User.fromJson membaca city dari address', () {
    final user = User.fromJson({
      'id': 1537,
      'name': 'Contoh',
      'email': 'contoh@mail.com',
      'address': {'city': 'Jakarta'},
    });
    expect(user.id, 1537);
    expect(user.city, 'Jakarta');
  });
}
