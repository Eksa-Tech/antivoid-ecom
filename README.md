# Antivoid E-Commerce Premium

Antivoid adalah aplikasi e-commerce modern berbasis Ruby yang dirancang dengan estetika **Glassmorphism** dan fitur lengkap untuk kebutuhan bisnis online masa kini. Aplikasi ini menggunakan framework minimalis (Rack) untuk performa maksimal dan kemudahan kustomisasi.

## ✨ Fitur Utama

- **Premium Design**: Tema Glassmorphism modern dengan animasi halus (Animate.css) dan ikon Lucide.
- **Katalog Produk & Kategori**: Penjelajahan produk yang mudah dengan filter kategori.
- **Sistem Keranjang Belanja**: Pembaruan unit barang reaktif (AJAX) dan perhitungan total otomatis.
- **Panel Admin (CMS)**:
  - Manajemen Produk (Tambah/Edit/Hapus) dengan integrasi Cloudinary.
  - Manajemen Kategori.
  - Kelola Pesanan & Generasi Nomor Resi otomatis.
  - Dashboard Analitik Penjualan.
- **Paginasi Efisien**: Menggunakan server-side pagination untuk performa cepat pada data besar.
- **Cloudinary Integration**: Pembersihan otomatis aset gambar saat produk dihapus atau diperbarui.
- **Mobile Responsive**: Pengalaman navigasi yang mulus di perangkat mobile dengan menu hamburger.

## 🚀 Teknologi

- **Bahasa**: [Ruby 3.3+](https://www.ruby-lang.org/)
- **Server**: [Puma](https://puma.io/) via [Rack](https://github.com/rack/rack)
- **Database**: [MongoDB Atlas](https://www.mongodb.com/atlas)
- **Gambar**: [Cloudinary](https://cloudinary.com/)
- **Frontend**: [Tailwind CSS](https://tailwindcss.com/), [Animate.css](https://animate.style/), [Lucide Icons](https://lucide.dev/)
- **Templating**: ERB (Embedded Ruby)

## 📦 Instalasi

1. **Clone repositori**:
   ```bash
   git clone https://github.com/Eksa-Tech/antivoid-ecom.git
   cd antivoid-ecom
   ```

2. **Instal dependensi**:
   ```bash
   bundle install
   ```

3. **Konfigurasi Environment**:
   Salin `.env.example` menjadi `.env` dan isi kredensial Anda:
   ```bash
   cp .env.example .env
   ```
   Pastikan Anda mengisi:
   - `MONGODB_URI`=mongodb+srv://admin:admin@cluster0.mongodb.net/e-commerce?retryWrites=true&w=majority
   - `CLOUDINARY_URL`=cloudinary://API_KEY:API_SECRET@CLOUD_NAME
   - `JWT_SECRET`=d2cdf94c99822261cf4e91a9cb37eeb9da5fb70baa013444f48eb829e94f99c5
   - `ADMIN_EMAIL`=admin@example.com
   - `ADMIN_PASSWORD`=password123
   - `PORT`=9292

4. **Jalankan Aplikasi**:
   ```bash
   rackup
   ```

## 🛠️ Struktur Proyek

- `app/models/`: Logika data (Product, Category, Order, User).
- `app/views/`: Template HTML dengan ERB.
- `app/router.rb`: Pengatur rute aplikasi dan logika kontroler.
- `app/utils/`: Helper fungsional (Database, Auth, Cloudinary).
- `public/`: Aset statis (CSS, JS, Gambar).

## 📄 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).