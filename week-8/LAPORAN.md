# Laporan Praktikum 8 – Model User & Model Admin

**Nama:** Muhammad Amizola Rahmandani
**NIM:** 20240801083
**Link GitHub:** (isi link repository kamu)

## 1. Perhitungan ID dari NIM
- Tiga digit terakhir NIM: 083
- Angka tengah dipindah ke belakang: N = 038 (38)
- ID User = 1499 + 38 = **1537**
- ID Admin = 792 + 38 = **830**

Nilai ini disimpan di `lib/config.dart` (`idUser` dan `idAdmin`).

## 2. Struktur File
```
lib/
├── main.dart                   # Aplikasi: tab User dan Admin, ganti bahasa, reset data
├── config.dart                 # NIM, N, ID User (1537), ID Admin (830)
├── utils.dart                  # Fungsi bantu (snackbar, teks error)
├── models/
│   ├── user_model.dart         # Model User (id, name, email, city)
│   └── admin.dart              # Model Admin (id, name, email, department)
├── services/
│   ├── api_service.dart        # Service User: GET, POST, PUT, PATCH, DELETE
│   └── admin_service.dart      # Service Admin: getAdmins, getAdmin, deleteAdmin
├── screens/
│   ├── user_tab.dart           # Daftar User + halaman detail User
│   └── admin_tab.dart          # Daftar Admin + halaman detail Admin + hapus
└── l10n/                       # Teks Bahasa Indonesia dan Inggris
```
File Model dan Service untuk User dan Admin dipisah supaya kode rapi.

## 3. Implementasi Model
- **User**: properti `id`, `name`, `email`, `city`. `User.fromJson()` membaca `city` dari `address.city` (format JSONPlaceholder) atau dari `city` langsung.
- **Admin**: properti `id`, `name`, `email`, `department`. `Admin.fromJson()` mengubah data JSON menjadi objek Admin.

## 4. Proses GET
- `ApiService.getUsers()` dan `AdminService.getAdmins()` membaca seluruh data dari penyimpanan JSON lokal (file di HP/PC, SharedPreferences di Web).
- Data awal User diambil dari JSONPlaceholder (`/users`). JSONPlaceholder tidak punya data admin, jadi data awal Admin dibuat di `admin_service.dart` (termasuk Admin ID 830).
- `getUser(id)` dan `getAdmin(id)` mengambil satu data berdasarkan ID, dipakai di halaman detail.
- Hasilnya ditampilkan dengan `FutureBuilder` dan `ListView`.

## 5. Tambah, Ubah, dan Hapus User
- **POST** (`createUser`): menambah User baru dengan ID dari NIM = 1537. Jika ID sudah ada, muncul pesan error.
- **PUT** (`updateUser`): mengubah `name` dan `email` User, data lain tetap.
- **PATCH** (`patchUser`): mengubah `name` saja dengan menambahkan teks " - Flutter Developer".
- **DELETE** (`deleteUser`): menghapus User berdasarkan ID, lalu kembali ke daftar.

## 6. Hapus Admin
`AdminService.deleteAdmin(id)` menghapus Admin berdasarkan ID. Sebelum dihapus, muncul dialog konfirmasi. Bisa dilakukan dari daftar (ikon tempat sampah) atau halaman detail. Admin yang diuji: ID 830.

## 7. Tampilan Akhir dan Hasil Pengujian
| Fitur | Cara uji | Hasil | Screenshot |
|---|---|---|---|
| Daftar User (GET) | Buka tab Pengguna | (isi) | (tempel) |
| Daftar Admin (GET) | Buka tab Admin | (isi) | (tempel) |
| Tambah User ID 1537 (POST) | Tombol "Tambah User (POST) ID 1537" | (isi) | (tempel) |
| Detail User ID 1537 | Tombol "Lihat Detail ID 1537" | (isi) | (tempel) |
| Ubah User (PUT) | Tombol PUT di halaman detail | (isi) | (tempel) |
| Ubah nama (PATCH) | Tombol PATCH di halaman detail | (isi) | (tempel) |
| Hapus User (DELETE) | Tombol DELETE di halaman detail | (isi) | (tempel) |
| Detail Admin ID 830 | Tombol "Lihat Detail Admin ID 830" | (isi) | (tempel) |
| Hapus Admin ID 830 | Tombol DELETE / ikon sampah | (isi) | (tempel) |

Tombol "Reset Data" di pojok kanan atas mengembalikan data ke kondisi awal supaya pengujian bisa diulang.

## 8. Kesimpulan
Aplikasi menjalankan CRUD untuk User (GET, POST, PUT, PATCH, DELETE) dan GET serta DELETE untuk Admin. Dengan memisahkan Model dan Service, kode lebih terstruktur dan mudah dikembangkan.
