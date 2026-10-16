import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController(text: 'M');
  final _tanggalMasukController = TextEditingController();
  final _tanggalKeluarController = TextEditingController();
  final _kodeBarangController = TextEditingController();
  final _jumlahStokController = TextEditingController();

  @override
  void dispose() {
    _namaBarangController.dispose();
    _tanggalMasukController.dispose();
    _tanggalKeluarController.dispose();
    _kodeBarangController.dispose();
    _jumlahStokController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('stok_barang').add({
        'nama_barang': _namaBarangController.text.trim(),
        'tanggal_masuk_barang': _tanggalMasukController.text.trim(),
        'tanggal_keluar_barang': _tanggalKeluarController.text.trim(),
        'kode_barang': num.parse(_kodeBarangController.text.trim()),
        'jumlah_stok': int.parse(_jumlahStokController.text.trim()),
        'waktu': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menyimpan data stok barang')),
      );

      _formKey.currentState!.reset();
      _namaBarangController.clear();
      _tanggalMasukController.clear();
      _tanggalKeluarController.clear();
      _kodeBarangController.clear();
      _jumlahStokController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaBarangController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama Barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalMasukController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Masuk Barang',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal Masuk Barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalKeluarController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Keluar Barang',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal Keluar Barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kodeBarangController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode Barang wajib diisi';
                  }
                  final trimmed = value.trim();
                  if (num.tryParse(trimmed) == null) {
                    return 'Kode Barang harus berupa angka';
                  }
                  if (trimmed.length < 6) {
                    return 'Kode Barang minimal 6 digit';
                  }
                  if (!trimmed.endsWith('083')) {
                    return 'Kode Barang harus diakhiri 083';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahStokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah Stok wajib diisi';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) {
                    return 'Jumlah Stok harus berupa integer';
                  }
                  if (parsed < 0) {
                    return 'Jumlah Stok tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
