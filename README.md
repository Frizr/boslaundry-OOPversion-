# Boss Laundry Management System 🧺

Sistem Informasi Manajemen Laundry berbasis Web (Point of Sales) yang dibangun menggunakan Java Servlet, JSP, dan MySQL.

## 🚀 Fitur Utama

### 1. Hak Akses (Role-Based Access Control)

- **Admin**: Akses penuh ke seluruh sistem system.
  - Dashboard Statistik (Total Pesanan, Pendapatan, dll).
  - Manajemen Layanan (Tambah, Edit, Hapus Layanan Laundry).
  - Manajemen Pesanan (Buat, Update Status, Hapus Pesanan).
  - Admin Panel (Manajemen User, Reset Password, Monitoring).
- **Karyawan**: Akses terbatas.
  - Hanya dapat mengakses halaman **Pesanan**.
  - Dapat membuat pesanan baru dan memproses pembayaran.
  - Tidak dapat mengakses Dashboard utama atau mengubah data layanan.

### 2. Manajemen Pesanan

- Pencatatan pesanan baru dengan pilihan pelanggan dan layanan.
- Status Order: **Pending** ➝ **Process** ➝ **Done** ➝ **Paid**.
- Filter pesanan berdasarkan status dan tanggal.
- Pencarian pesanan Real-time.

### 3. Admin Panel

- **Manajemen User**: Menambah/Mengubah role user (Admin/Karyawan).
- **Reset Password**: Admin dapat mereset password karyawan jika lupa.
- **Monitoring**: Melihat aktivitas order per karyawan.

## 🛠️ Teknologi yang Digunakan

- **Backend**: Java Web (Jakarta EE), Servlet, JDBC
- **Frontend**: JSP (JavaServer Pages), Bootstrap 5, FontAwesome
- **Database**: MySQL
- **Tools**: Apache NetBeans IDE, XAMPP (Apache Tomcat & MySQL)

## 📦 Instalasi & Cara Menjalankan

1. **Clone Repository**

   ```bash
   git clone https://github.com/Frizr/boslaundry-OOPversion-.git
   ```

2. **Setup Database**

   - Buat database baru di phpMyAdmin bernama `poslaundry`.
   - Import file SQL (jika ada) atau pastikan koneksi database di `src/java/util/DatabaseConnection.java` sesuai dengan konfigurasi XAMPP kamu.

3. **Buka di NetBeans**

   - Buka NetBeans IDE.
   - File > Open Project > Pilih folder `BossLaundry`.

4. **Run Project**
   - Klik kanan pada project > **Run** (atau tekan F6).
   - Browser akan otomatis membuka `http://localhost:8080/BossLaundry`.

## 🔒 Akun Demo (Default)

Tergantung data yang ada di database Anda. Format user biasanya:

- **Admin**: Full Access
- **Karyawan**: Restricted Access

---

_Dibuat untuk memenuhi tugas Pemrograman Berorientasi Objek (PBO)._
