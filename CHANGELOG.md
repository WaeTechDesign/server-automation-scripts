# 📝 Changelog - Server Automation Script

Semua perubahan penting pada project ini akan didokumentasikan di sini.

---

## [v1.1.0] - 2025-06-09

### ✨ Fitur Baru (Bahasa Indonesia)
- Konfirmasi sebelum menambahkan repository tambahan.
- Konfirmasi sebelum menginstall service tambahan.
- Jika user Samba sudah ada, user dapat memilih untuk:
  - Melewati (`skip`) user tersebut.
  - Mengganti (`replace`) user dengan password baru.
- Menampilkan semua interface jaringan saat `ifconfig`.
- Menambahkan instruksi akhir:
  - Cara menjalankan speedtest dari Ookla.
  - Cara me-restart jaringan.
  - Cara mengakses CasaOS melalui web browser.
  - Cara mengakses SSH ke server.
  - Pengingat untuk melakukan reboot setelah eksekusi script.

---

### ✨ New Features (English)
- Confirmation prompt before adding custom repositories.
- Confirmation prompt before installing extra services.
- When a Samba user already exists, the user can choose to:
  - Skip the user.
  - Replace the user with a new password.
- Show all available network interfaces during `ifconfig`.
- Added final instructions:
  - How to run speedtest using Ookla CLI.
  - How to restart networking services.
  - How to access CasaOS via web browser.
  - How to SSH into the server.
  - Reminder to reboot system after script execution.

---

## [v1.0.0] - 2025-06-08

### 🚀 Versi Awal (Bahasa Indonesia)
- Menambahkan repository dari input user.
- Menjalankan update & upgrade sistem.
- Install neofetch, curl, git, nano, net-tools, wget.
- Install ZeroTier dan join ke network.
- Install speedtest dari Ookla.
- Install CasaOS.
- Setup user untuk Samba.
- Konfigurasi IP statik via `interfaces`.

---

### 🚀 Initial Version (English)
- Add user-defined repository to sources.list.
- Run system update & upgrade.
- Install neofetch, curl, git, nano, net-tools, wget.
- Install ZeroTier and join network.
- Install speedtest from Ookla.
- Install CasaOS.
- Configure Samba users.
- Set static IP address via `/etc/network/interfaces`.

---