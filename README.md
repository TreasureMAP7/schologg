# Schologg

Schologg adalah aplikasi blog bertema pendidikan yang dikembangkan sebagai proyek Fullstack ASTS. Aplikasi ini memungkinkan pengguna untuk membaca, mencari, membuat, mengubah, dan menghapus artikel.

Proyek ini terdiri dari dua bagian utama:

* **Backend** — REST API menggunakan Express.js dan MySQL.
* **Frontend** — Aplikasi client menggunakan Flutter.

## Teknologi

### Backend

* Node.js
* Express.js
* TypeScript
* Drizzle ORM
* MySQL
* Cloudinary
* JWT

### Frontend

* Flutter
* Dart
* HTTP
* Flutter Secure Storage
* Image Picker

## Struktur Project

```text
Schologg/
├── client/     # Flutter frontend
└── server/     # Express.js backend
```

## Menjalankan Backend

Masuk ke folder backend:

```bash
cd server
```

Install dependencies:

```bash
npm install
```

Pastikan database MySQL sudah tersedia dan konfigurasi database serta environment variable sudah disiapkan.

Kemudian jalankan server:

```bash
npm run dev
```

Backend akan berjalan pada:

```text
http://localhost:5000
```

Untuk memastikan server berjalan, dapat membuka:

```text
http://localhost:5000/
```

## Menjalankan Frontend

Buka terminal baru, kemudian masuk ke folder frontend:

```bash
cd client
```

Install dependencies Flutter:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Untuk menjalankan melalui browser Chrome:

```bash
flutter run -d chrome
```

Saat menggunakan Flutter Web pada komputer yang sama dengan backend, API menggunakan:

```text
http://localhost:5000
```

Jika menggunakan perangkat Android fisik, koneksi ke backend perlu disesuaikan dengan jaringan atau menggunakan ADB reverse.

Contoh:

```bash
adb reverse tcp:5000 tcp:5000
```

Setelah itu aplikasi dapat menggunakan:

```text
http://localhost:5000
```

## Fitur Utama

Schologg menyediakan beberapa fitur utama:

* Register dan login pengguna
* Autentikasi menggunakan JWT
* Menampilkan artikel
* Melihat detail artikel
* Mencari artikel
* Memfilter artikel berdasarkan kategori
* Membuat artikel
* Mengubah artikel
* Menghapus artikel
* Upload gambar artikel
* Menampilkan profil pengguna
* Menampilkan artikel milik pengguna
* Logout

## API

Backend menyediakan REST API untuk menghubungkan frontend dengan database.

Beberapa endpoint utama:

```text
POST   /api/v1/auth/register
POST   /api/v1/auth/login

GET    /api/v1/posts
GET    /api/v1/posts/:id
POST   /api/v1/posts
PATCH  /api/v1/posts/:id
DELETE /api/v1/posts/:id

GET    /api/v1/posts/categories
GET    /api/v1/users/:id
```

Frontend berkomunikasi dengan backend menggunakan HTTP request dan menerima response dalam format JSON.

## Penutup

Schologg dibuat sebagai proyek pembelajaran Fullstack untuk menerapkan konsep REST API, CRUD, database, autentikasi, validasi data, upload file, serta pengembangan aplikasi menggunakan Flutter.

Melalui proyek ini, backend dan frontend dikembangkan secara terpisah namun saling terhubung melalui REST API sehingga data yang ditampilkan pada aplikasi berasal dari database secara langsung.
