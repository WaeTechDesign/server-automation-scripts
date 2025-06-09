EN
# Server Automation Script

This script is designed to simplify the automatic setup of Ubuntu/Debian servers, from repository configuration, system updates, installation of essential services, CasaOS and Samba setup, to static IP address setup.

---

## Key Features

- Add or modify the `sources.list` repository according to user input
- Automatic system updates and upgrades
- Installs basic packages such as `neofetch`, `curl`, `git`, `nano`, `net-tools`, and `wget`
- Installs and configures ZeroTier for VPN (join network based on Network ID)
- Installs Speedtest CLI from Ookla for internet speed testing
- Installs CasaOS with a single command
- Sets up Samba with easy-to-configure user and password settings
- Check and configure the IP interface to be a static IP based on user input
- Display active Samba user info and connected network interfaces
- Informative progress and time estimates for each step
- Color-coded output based on process status for easy monitoring

---

## How to Use

Run the script on the server with the following command

curl -fsSL https://raw.githubusercontent.com/WaeTechDesign/server-automation-scripts/refs/heads/main/setup-server-x86-64_arm64.sh

wget -qO- https://raw.githubusercontent.com/WaeTechDesign/server-automation-scripts/refs/heads/main/setup-server-x86-64_arm64.sh

or 

bash <(curl -fsSL https://raw.githubusercontent.com/WaeTechDesign/server-automation-scripts/refs/heads/main/setup-server-x86-64_arm64.sh)

bash <(wget -qO- https://raw.githubusercontent.com/WaeTechDesign/server-automation-scripts/refs/heads/main/setup-server-x86-64_arm64.sh)


! Tips

Ensure you have access to your ZeroTier account to obtain the correct Network ID

Store your Samba password securely

After configuring the static IP, restart the network service or reboot the server

License
MIT License

Contact
If you encounter any issues or have suggestions, please open an issue in the GitHub repository or contact:

Email: hackwae3@gmail.com

GitHub: https://github.com/WaeTechDesign

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID 
# Server Automation Script

Script ini dirancang untuk memudahkan setup server Ubuntu/Debian secara otomatis, mulai dari konfigurasi repository, update sistem, instalasi layanan penting, setup CasaOS dan Samba sampai setup ip address static.

---

## Fitur Utama

- Menambah atau mengubah repository `sources.list` sesuai input user
- Update dan upgrade sistem secara otomatis
- Instalasi paket dasar seperti `neofetch`, `curl`, `git`, `nano`, `net-tools`, dan `wget`
- Instalasi dan konfigurasi ZeroTier untuk VPN (join network berdasarkan Network ID)
- Instalasi Speedtest CLI dari Ookla untuk tes kecepatan internet
- Instalasi CasaOS dengan satu perintah
- Setup Samba dengan konfigurasi user dan password yang mudah
- Cek dan konfigurasi IP interface agar menjadi static IP berdasarkan input user
- Menampilkan info user Samba aktif dan interface jaringan yang terpasang
- Progress dan estimasi waktu yang informatif untuk setiap langkah
- Output berwarna sesuai status proses agar mudah dipantau

---

## Cara Menggunakan

Jalankan script di server dengan perintah berikut

curl -fsSL https://raw.githubusercontent.com/<username>/<repo>/main/install-casaos.sh | bash

wget -qO- https://raw.githubusercontent.com/<username>/<repo>/main/install-casaos.sh | bash

atau 

bash <(curl -fsSL https://raw.githubusercontent.com/<username>/<repo>/master/install-casaos.sh)

bash <(wget -qO- https://raw.githubusercontent.com/<username>/<repo>/master/install-casaos.sh)


! Tips

Pastikan Anda memiliki akses ke akun ZeroTier untuk mendapatkan Network ID yang benar

Simpan password Samba dengan aman

Setelah konfigurasi IP static, restart network service atau reboot server

License
MIT License

Contact
Jika ada masalah atau saran, silakan buka issue di GitHub repo atau hubungi:

Email: hackwae3@gmail.com

GitHub: https://github.com/WaeTechDesign