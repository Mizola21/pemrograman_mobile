import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projek/main.dart';

void main() {
  testWidgets('Form stok barang renders exactly 5 fields and Simpan button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Stok Barang'), findsOneWidget);
    expect(find.text('Nama Barang'), findsOneWidget);
    expect(find.text('Tanggal Masuk Barang'), findsOneWidget);
    expect(find.text('Tanggal Keluar Barang'), findsOneWidget);
    expect(find.text('Kode Barang'), findsOneWidget);
    expect(find.text('Jumlah Stok'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);

    // Initial value Nama Barang harus "M"
    final namaField = tester.widget<TextFormField>(
      find.widgetWithText(TextFormField, 'Nama Barang'),
    );
    expect(namaField.controller?.text, 'M');
  });

  testWidgets('Form validation enforces required, numeric, and NIM rules',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Kosongkan nama barang untuk tes validasi wajib diisi
    final namaField = find.widgetWithText(TextFormField, 'Nama Barang');
    await tester.enterText(namaField, '');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Nama Barang wajib diisi'), findsOneWidget);
    expect(find.text('Tanggal Masuk Barang wajib diisi'), findsOneWidget);
    expect(find.text('Tanggal Keluar Barang wajib diisi'), findsOneWidget);
    expect(find.text('Kode Barang wajib diisi'), findsOneWidget);
    expect(find.text('Jumlah Stok wajib diisi'), findsOneWidget);

    // Tes kode barang: kurang dari 6 digit atau tidak berakhiran 083
    final kodeField = find.widgetWithText(TextFormField, 'Kode Barang');
    await tester.enterText(kodeField, '12083'); // 5 digit
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Kode Barang minimal 6 digit'), findsOneWidget);

    await tester.enterText(kodeField, '123456'); // 6 digit tapi bukan akhiran 083
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Kode Barang harus diakhiri 083'), findsOneWidget);

    // Tes jumlah stok negatif
    final stokField = find.widgetWithText(TextFormField, 'Jumlah Stok');
    await tester.enterText(stokField, '-1');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Jumlah Stok tidak boleh negatif'), findsOneWidget);
  });
}
