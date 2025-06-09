#!/bin/bash

# Warna ANSI
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Memulai setup server otomatis...${NC}"

# Fungsi untuk menampilkan progress bar
show_progress() {
    local p=$1
    local msg=$2
    local width=50
    local num_hashes=$((p * width / 100))
    local num_spaces=$((width - num_hashes))
    printf "${GREEN}[%-${width}s]${NC} %3d%% ${YELLOW}%s${NC}\r" "$(printf '#%.0s' $(seq 1 $num_hashes))" "$p" "$msg"
}

# ---
## 1. Tambah/Edit Repository ke sources.list
# ---
echo -e "\n---"
echo -e "${BLUE}1. Menambahkan/Mengedit Repository ke sources.list${NC}"
echo "---"
read -p "$(echo -e "${YELLOW}Masukkan baris repository yang ingin ditambahkan (contoh: deb http://deb.debian.org/debian stable main contrib non-free) atau biarkan kosong jika tidak ada: ${NC}")" REPO_LINE
if [ -n "$REPO_LINE" ]; then
    echo "$REPO_LINE" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo -e "${GREEN}Repository berhasil ditambahkan.${NC}"
else
    echo -e "${RED}Tidak ada repository yang ditambahkan.${NC}" # Merah jika tidak ditambahkan
fi
echo "Isi /etc/apt/sources.list setelah perubahan:"
cat /etc/apt/sources.list
show_progress 10 "Repository dikonfigurasi"

# ---
## 2. Update Repository dan Upgrade Sistem
# ---
echo -e "\n---"
echo -e "${BLUE}2. Melakukan Update Repository dan Upgrade Sistem${NC}"
echo "---"
sudo apt update && sudo apt upgrade -y
echo -e "${GREEN}Update dan upgrade sistem selesai.${NC}"
show_progress 20 "Sistem terupdate"

# ---
## 3. Install Service yang Diperlukan
# ---
echo -e "\n---"
echo -e "${BLUE}3. Menginstal Service Dasar${NC}"
echo "---"
sudo apt install -y neofetch curl git nano net-tools wget
echo -e "${GREEN}Instalasi service dasar selesai.${NC}"
show_progress 30 "Service dasar terinstal"

read -p "$(echo -e "${YELLOW}Apakah Anda ingin menambahkan service lain? (y/n): ${NC}")" CONFIRM_ADD_SERVICES
if [[ "$CONFIRM_ADD_SERVICES" =~ ^[Yy]$ ]]; then
    read -p "$(echo -e "${YELLOW}Masukkan service lain yang ingin diinstal (pisahkan dengan spasi, contoh: htop ncdu): ${NC}")" ADDITIONAL_SERVICES
    if [ -n "$ADDITIONAL_SERVICES" ]; then
        sudo apt install -y $ADDITIONAL_SERVICES
        echo -e "${GREEN}Instalasi service tambahan selesai.${NC}"
    else
        echo -e "${RED}Tidak ada service tambahan yang dimasukkan.${NC}" # Merah jika input kosong
    fi
else
    echo -e "${RED}Instalasi service tambahan dibatalkan.${NC}" # Merah jika ditolak
fi
show_progress 40 "Instalasi service selesai"

# ---
## 4. Install ZeroTier
# ---
echo -e "\n---"
echo -e "${BLUE}4. Menginstal ZeroTier${NC}"
echo "---"
curl -s https://install.zerotier.com | sudo bash
echo -e "${GREEN}Instalasi ZeroTier selesai.${NC}"
show_progress 50 "ZeroTier terinstal"

echo -e "\n---"
echo -e "${BLUE}5. Join Jaringan ZeroTier${NC}"
echo "---"
read -p "$(echo -e "${YELLOW}Masukkan Network ID ZeroTier Anda untuk bergabung: ${NC}")" ZT_NETWORK_ID
if [ -n "$ZT_NETWORK_ID" ]; then
    sudo zerotier-cli join "$ZT_NETWORK_ID"
    echo -e "${GREEN}Berhasil bergabung ke jaringan ZeroTier dengan ID: ${ZT_NETWORK_ID}${NC}"
else
    echo -e "${RED}Network ID ZeroTier kosong. Gagal bergabung ke jaringan.${NC}" # Merah jika input kosong
fi
show_progress 60 "ZeroTier terkonfigurasi"

# ---
## 6. Install Service Speedtest dari Ookla
# ---
echo -e "\n---"
echo -e "${BLUE}6. Menginstal Speedtest CLI dari Ookla${NC}"
echo "---"
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest -y
echo -e "${GREEN}Instalasi Speedtest CLI selesai.${NC}"
show_progress 70 "Speedtest CLI terinstal"

# ---
## 7. Install CasaOS
# ---
echo -e "\n---"
echo -e "${BLUE}7. Menginstal CasaOS${NC}"
echo "---"
curl -fsSL https://get.casaos.io | sudo bash
echo -e "${GREEN}Instalasi CasaOS selesai. Akses CasaOS melalui browser setelah instalasi selesai.${NC}"
show_progress 80 "CasaOS terinstal"

# ---
## 8. Setup Samba (Sudah Include di CasaOS)
# ---
echo -e "\n---"
echo -e "${BLUE}8. Setup Samba (Samba sudah terintegrasi dengan CasaOS)${NC}"
echo "---"
echo "CasaOS sudah memiliki fitur Samba terintegrasi. Anda bisa mengelola share Samba dari antarmuka web CasaOS."

echo -e "\n---"
echo -e "${BLUE}Mengecek user Samba yang ada:${NC}"
ACTIVE_SAMBA_USERS=$(sudo pdbedit -L | grep -c '^')
echo "Jumlah user Samba yang aktif: ${ACTIVE_SAMBA_USERS}"
echo "Daftar user Samba:"
sudo pdbedit -L

echo -e "\n---"
echo -e "${BLUE}Menambahkan user 'root' ke Samba${NC}"
sudo useradd -M -s /sbin/nologin root 2>/dev/null
echo -e "${GREEN}User 'root' berhasil ditambahkan (jika belum ada).${NC}"
echo "Setting password untuk user 'root' Samba..."
sudo smbpasswd -a root
echo -e "${GREEN}User Samba: root, Password: yang baru Anda masukkan.${NC}"

read -p "$(echo -e "${YELLOW}Apakah Anda ingin menambahkan user Samba lain? (y/n): ${NC}")" ADD_OTHER_SAMBA_USER
if [[ "$ADD_OTHER_SAMBA_USER" =~ ^[Yy]$ ]]; then
    read -p "$(echo -e "${YELLOW}Masukkan username Samba baru: ${NC}")" NEW_SAMBA_USERNAME
    if [ -n "$NEW_SAMBA_USERNAME" ]; then
        sudo useradd -M -s /sbin/nologin "$NEW_SAMBA_USERNAME" 2>/dev/null
        echo -e "${GREEN}User '$NEW_SAMBA_USERNAME' berhasil ditambahkan (jika belum ada).${NC}"
        echo "Setting password untuk user '$NEW_SAMBA_USERNAME' Samba..."
        sudo smbpasswd -a "$NEW_SAMBA_USERNAME"
        echo -e "${GREEN}User Samba: ${NEW_SAMBA_USERNAME}, Password: yang baru Anda masukkan.${NC}"
    else
        echo -e "${RED}Username Samba baru kosong. Gagal menambahkan user.${NC}" # Merah jika input kosong
    fi
else
    echo -e "${RED}Penambahan user Samba lain dibatalkan.${NC}" # Merah jika ditolak
fi
show_progress 90 "Samba terkonfigurasi"

# ---
## 9. Cek Interface dan IP
# ---
echo -e "\n---"
echo -e "${BLUE}9. Mengecek Interface Jaringan dan IP Address${NC}"
echo "---"
echo -e "${YELLOW}Catat nama interface yang akan Anda gunakan untuk IP statik (contoh: eth0, enp0s3, ens18):${NC}"
ifconfig
read -p "$(echo -e "${YELLOW}Masukkan nama interface yang akan diatur IP statik: ${NC}")" NETWORK_INTERFACE

# ---
## 10. Konfigurasi IP Statik
# ---
echo -e "\n---"
echo -e "${BLUE}10. Mengkonfigurasi IP Statik${NC}"
echo "---"
read -p "$(echo -e "${YELLOW}Masukkan IP statik (contoh: 192.168.1.100): ${NC}")" STATIC_IP
read -p "$(echo -e "${YELLOW}Masukkan Netmask (contoh: 255.255.255.0): ${NC}")" NETMASK
read -p "$(echo -e "${YELLOW}Masukkan Gateway Internet (contoh: 192.168.1.1): ${NC}")" GATEWAY
read -p "$(echo -e "${YELLOW}Masukkan DNS Nameservers (pisahkan dengan spasi jika lebih dari satu, contoh: 8.8.8.8 8.8.4.4): ${NC}")" DNS_NAMESERVERS

# Backup konfigurasi jaringan yang ada
sudo cp /etc/network/interfaces /etc/network/interfaces.bak_"$(date +%Y%m%d%H%M%S)"
echo -e "${GREEN}File /etc/network/interfaces telah dibackup ke /etc/network/interfaces.bak_$(date +%Y%m%d%H%M%S)${NC}"

# Validasi input untuk IP statik
if [ -n "$NETWORK_INTERFACE" ] && [ -n "$STATIC_IP" ] && [ -n "$NETMASK" ] && [ -n "$GATEWAY" ] && [ -n "$DNS_NAMESERVERS" ]; then
    echo -e "\nauto $NETWORK_INTERFACE
iface $NETWORK_INTERFACE inet static
          address $STATIC_IP
          netmask $NETMASK
          gateway $GATEWAY
          dns-nameservers $DNS_NAMESERVERS" | sudo tee /etc/network/interfaces > /dev/null

    echo -e "${GREEN}Konfigurasi IP statik untuk ${NETWORK_INTERFACE} selesai.${NC}"
else
    echo -e "${RED}Beberapa input untuk konfigurasi IP statik kosong. Konfigurasi IP statik tidak diterapkan.${NC}" # Merah jika input kosong
fi
show_progress 100 "IP Statik terkonfigurasi"

echo -e "\n---"
echo -e "${GREEN}Setup server otomatis selesai!${NC}"
echo "---"

echo -e "\n${YELLOW}Penting:${NC} Beberapa perubahan jaringan mungkin memerlukan restart layanan atau reboot sistem."

echo -e "\n${BLUE}Instruksi Setelah Setup:${NC}"
echo "1. ${GREEN}Melakukan Speedtest CLI:${NC}"
echo "   Setelah setup selesai, Anda bisa melakukan tes kecepatan internet dengan perintah:"
echo "   ${YELLOW}speedtest${NC}"
echo "   atau untuk melihat daftar server terdekat dan memilih server tertentu:"
echo "   ${YELLOW}speedtest --list${NC}"
echo "   ${YELLOW}speedtest --server [ID_SERVER]${NC}"

echo "2. ${GREEN}Me-restart Layanan Jaringan:${NC}"
echo "   Untuk menerapkan perubahan IP statik, Anda mungkin perlu me-restart layanan jaringan. Perintahnya bisa berbeda tergantung distro Anda:"
echo "   ${YELLOW}sudo systemctl restart networking${NC}"
echo "   atau"
echo "   ${YELLOW}sudo /etc/init.d/networking restart${NC}"

echo "3. ${GREEN}Reboot Sistem:${NC}"
echo "   Disarankan untuk melakukan reboot penuh setelah semua setup selesai untuk memastikan semua konfigurasi diterapkan dengan benar dan sistem beroperasi dengan IP statik yang baru."
echo "   ${RED}sudo reboot${NC}"

echo "4. ${GREEN}Login dengan IP Statik yang Baru:${NC}"
echo "   Setelah reboot, Anda harus login kembali ke server menggunakan IP statik yang sudah Anda atur tadi (${STATIC_IP}). Pastikan Anda mencatat IP ini."
echo "   Jika menggunakan SSH, gunakan perintah:"
echo "   ${YELLOW}ssh user_anda@${STATIC_IP}${NC}"
echo "   (Ganti 'user_anda' dengan username Anda)"

echo -e "\n${BLUE}Jika ada masalah, pastikan konfigurasi IP statik Anda benar dan cek kabel jaringan.${NC}"