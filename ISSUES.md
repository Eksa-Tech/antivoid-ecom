# Daftar Isu & Pengembangan (Roadmap)

Dokumen ini mencantumkan rencana pengembangan fitur, perbaikan bug, dan peningkatan teknis untuk Antivoid Shop.

## 🛠️ Prioritas Tinggi (Mendesak)
- [x] **Integrasi Payment Gateway Asli**: Mengganti sistem manual dengan Midtrans atau Xendit untuk pembayaran otomatis (VA, E-Wallet, QRIS).
- [] **Email Notifikasi Admin**: Kirim notifikasi email ke admin setiap kali ada pesanan baru masuk agar respons lebih cepat.
- [] **Validasi Stok Real-time**: Memastikan stok dikunci (reserve) saat pengguna masuk ke halaman checkout untuk menghindari *overselling*.
- [] **Automated Testing**: Implementasi unit testing (RSpec) untuk model dan integrasi testing untuk alur checkout.

## ✨ Peningkatan Fitur (User Experience)
- [] **Akun Pelanggan**: Izinkan pelanggan membuat akun untuk melacak riwayat pesanan dan menyimpan alamat pengiriman.
- [] **Ulasan & Rating Produk**: Fitur bagi pembeli untuk memberikan testimoni dan bintang pada produk yang telah dibeli.
- [] **Wishlist**: Fitur "Simpan untuk Nanti" bagi produk yang diminati pelanggan.
- [] **Pencarian Global**: Kotak pencarian di navbar yang bisa mencari produk dari semua kategori di halaman mana pun.

## 📊 Admin & Operasional
- [] **Laporan Penjualan (PDF/Excel)**: Fitur untuk mengekspor data penjualan bulanan ke format dokumen.
- [] **Notifikasi Stok Rendah**: Berikan peringatan di dashboard jika stok produk tertentu hampir habis (misal: di bawah 5 unit).
- [] **Manajemen Banner Promo**: Kelola gambar slider/banner di halaman beranda langsung via panel admin.
- [] **Analitik Grafik**: Visualisasi data penjualan menggunakan chart (Chart.js) untuk melihat tren harian/mingguan.

## ⚙️ Teknis & Performa
- [x] **Image Optimization**: Implementasi kompresi gambar otomatis sebelum diunggah ke Cloudinary untuk menghemat bandwidth.
- [x] **Pembersihan Kode (Refactoring)**: Memisahkan logika di `router.rb` ke dalam kontroler yang lebih spesifik jika proyek semakin besar.
- [x] **Caching**: Implementasi caching sederhana untuk data katalog yang jarang berubah guna mempercepat waktu muat.
- [x] **CI/CD Pipeline**: Konfigurasi deployment otomatis ke Railway setiap kali ada push ke branch `main`.

---
*Ingin menambahkan ide? Silakan buka Issue baru atau kirim Pull Request sesuai dengan [Panduan Kontribusi](CONTRIBUTING.md).*
