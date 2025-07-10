# PanShop - Aplikasi E-Commerce Flutter

## Deskripsi Aplikasi  
**PanShop** adalah aplikasi e-commerce berbasis Flutter yang dirancang untuk memudahkan pengguna dalam menjelajahi, melihat detail, dan membeli berbagai produk lucu dan kekinian. Aplikasi ini memiliki antarmuka yang minimalis, feminin, dan user-friendly, cocok untuk pengguna generasi muda.

## Fitur Utama

- 🛍️ **Daftar Produk**  
  Menampilkan produk lengkap dengan gambar, harga, deskripsi, dan rating.

- 🔍 **Pencarian Produk**  
  Fitur search untuk memudahkan pengguna menemukan produk favorit mereka.

- 🧺 **Keranjang Belanja**  
  Pengguna dapat menambahkan produk ke keranjang, menambah/mengurangi jumlah, dan menghapus item.

- 💳 **Checkout Form**   
  Formulir sederhana untuk simulasi proses pembelian.

- 👤 **Autentikasi Login/Register**  
  Menggunakan Firebase Authentication (email & password).

- 🧾 **Manajemen User**  
  Data tambahan pengguna seperti nama lengkap & username disimpan di `db.json` dan ditampilkan di halaman profil.

- 🛠️ **Edit Alamat**  
  Pengguna dapat mengisi dan menyimpan alamat mereka untuk kebutuhan pengiriman.

## Teknologi yang Digunakan

- Flutter SDK
- Firebase Authentication
- REST API (`json-server` untuk `db.json`)
- SharedPreferences (untuk sesi login & data lokal)
- HTTP Package
- Local JSON Storage (mock database)

## Struktur Layar Aplikasi

- `login_screen.dart` – Login pengguna (Firebase)
- `register_screen.dart` – Registrasi pengguna (Firebase + db.json)
- `home_screen.dart` – Daftar produk, pencarian, dan tombol keranjang
- `cart_screen.dart` – Daftar produk dalam keranjang & stepper kuantitas
- `product_detail_screen.dart` – Detail produk + tombol beli sekarang
- `checkout_form_screen.dart` – Form checkout sederhana
- `account_screen.dart` – Profil pengguna, info akun, dan tombol logout

## Tampilan Aplikasi
<img width="261" height="529" alt="login_screen" src="https://github.com/user-attachments/assets/235f0ada-e893-432a-8553-f84ebe73ce67" />






