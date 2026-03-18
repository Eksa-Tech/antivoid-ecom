# Antivoid E-Commerce Premium

Antivoid adalah aplikasi e-commerce modern berbasis Ruby yang dirancang dengan estetika **Glassmorphism** dan fitur lengkap untuk kebutuhan bisnis online masa kini. Aplikasi ini menggunakan framework minimalis (Rack) untuk performa maksimal dan kemudahan kustomisasi.

## ✨ Fitur Utama

- **Premium Design**: Tema Glassmorphism modern dengan animasi halus (Animate.css) dan ikon Lucide.
- **Email Receipt (Brevo)**: Pengiriman struk belanja otomatis ke email pelanggan setelah checkout.
- **Katalog Produk & Kategori**: Penjelajahan produk yang mudah dengan filter kategori.
- **Sistem Keranjang Belanja**: Pembaruan unit barang reaktif (AJAX) dan perhitungan total otomatis.
- **Profil Perusahaan**: Halaman statis "Tentang Kami", "Kontak", dan "Syarat & Ketentuan".
- **Panel Admin (CMS)**:
  - Dashboard Analitik Penjualan dengan statistik real-time.
  - Manajemen Produk (Tambah/Edit/Hapus) dengan integrasi Cloudinary.
  - Manajemen Kategori.
  - Kelola Pesanan & Generasi Nomor Resi otomatis.
- **Performa & Kompatibilitas**:
  - Paginasi Efisien pada katalog dan data admin.
  - Full support untuk Ruby 3.4+ dan Rack 3.
  - Cloudinary Cleanup: Pembersihan otomatis aset gambar yang tidak terpakai.
- **Mobile Responsive**: Pengalaman navigasi yang mulus di perangkat mobile dengan menu hamburger.

## 🚀 Teknologi

- **Bahasa**: [Ruby 3.3+](https://www.ruby-lang.org/)
- **Server**: [Puma](https://puma.io/) via [Rack](https://github.com/rack/rack)
- **Database**: [MongoDB Atlas](https://www.mongodb.com/atlas)
- **Email**: [Brevo API](https://www.brevo.com/)
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
   - `MONGODB_URI`: Koneksi MongoDB Atlas.
   - `CLOUDINARY_URL`: API Cloudinary Environment.
   - `BREVO_API_KEY`: API Key untuk pengiriman email.
   - `SENDER_EMAIL`: Email pengirim yang terverifikasi.
   - `JWT_SECRET`: Secret key untuk enkripsi session.
   - `ADMIN_EMAIL`: Email untuk login admin.
   - `ADMIN_PASSWORD`: Password untuk login admin.
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