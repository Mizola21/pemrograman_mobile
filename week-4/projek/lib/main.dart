import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Profile Card',
      theme: AppTheme.light,
      home: const ProfilePage(),
    );
  }
}

// ============================================================================
// Catatan: Kode Google Map sebelumnya dikomentari sesuai instruksi:
// ============================================================================
/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Universitas Esa Unggul',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('Tekan tombol di bawah untuk melihat lokasi kampus.'),
            SizedBox(height: 24),
            AppButton(
              label: 'Pergi ke GMAPS',
              icon: Icons.location_on,
              url: 'https://maps.google.com/?q=Universitas+Esa+Unggul',
              height: 48,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
*/

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // --------------------------------------------------------------------------
  // Perhitungan ukuran berdasarkan digit terakhir NIM:
  // NIM: 20240801083 -> Digit terakhir (d) = 3
  // --------------------------------------------------------------------------
  static const double d = 3;
  static const double cardPadding = 16 + d; // 19 px
  static const double cardRadius = 8 + d; // 11 px
  static const double buttonHeight = 40 + d; // 43 px
  static const double buttonRadius = 4 + d; // 7 px
  static const double avatarSize = 40 + (2 * d); // 46 px
  static const double avatarRadius = avatarSize / 2; // 23 px
  static const double nameNimSpacing = 8 + d; // 11 px

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile Card'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(cardPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    // 1. Foto profil / ikon avatar (ukuran: 46 px)
                    SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: AssetImage('assets/avatar.jpg'),
                      ),
                    ),
                    SizedBox(height: 12),

                    // 2. Nama lengkap
                    Text('Muhammad Amizola Rahmandani'),

                    // Jarak antara nama dan NIM: 8 + d = 11 px
                    SizedBox(height: nameNimSpacing),

                    // 3. NIM
                    Text('20240801083'),
                    SizedBox(height: 8),

                    // 4. Program studi
                    Text('Teknik Informatika'),
                    SizedBox(height: 12),

                    // 5. Deskripsi singkat diri
                    Text(
                      'Mahasiswa yang tertarik dengan web development pada ui/ux dan frontend',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),

                    // 6. Tombol GitHub
                    AppButton(
                      label: 'Kunjungi GitHub Saya',
                      icon: Icons.code,
                      url: 'https://github.com/Mizola21',
                      height: buttonHeight,
                      borderRadius: buttonRadius,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
