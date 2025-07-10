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
<img width="250" height="514" alt="login" src="https://github.com/user-attachments/assets/11326b32-ba1b-47da-898e-c6d93685126f" />
<img width="248" height="514" alt="register" src="https://github.com/user-attachments/assets/c38ab171-f7b7-462e-ac4a-8fad5bde6e85" />
<img width="250" height="519" alt="account" src="https://github.com/user-attachments/assets/c088098b-6367-4277-b5de-d706678c794e" />
<img width="250" height="518" alt="home" src="https://github.com/user-attachments/assets/e3637ca5-bb8c-4d52-8b57-07a6dc83abf1" />
<img width="235" height="518" alt="detailproduk" src="https://github.com/user-attachments/assets/c92fb5a8-eab8-4916-b9fd-71f4e7ba97d7" />
<img width="251" height="514" alt="checkout" src="https://github.com/user-attachments/assets/55394108-ac7b-4bc7-9820-70b69645672c" />
<img width="250" height="515" alt="konfirmasibayar" src="https://github.com/user-attachments/assets/de109402-de8b-421d-acc9-020cdf646d12" />
<img width="233" height="520" alt="formpembelian" src="https://github.com/user-attachments/assets/cf566f0d-3533-4cbe-b66c-1942edbd8290" />
<img width="236" height="521" alt="animasisukses" src="https://github.com/user-attachments/assets/334629c1-164f-4ddd-b2a0-202e6ea3a6a8" />







