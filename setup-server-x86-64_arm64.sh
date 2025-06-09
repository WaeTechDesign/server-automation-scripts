#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

total_start=$(date +%s)

echo -e "${CYAN}▶️  1. Menambahkan repository ke sources.list${NC}"
read -p "Apakah ingin menambahkan repository baru? (y/n): " repo_add
if [[ $repo_add =~ ^[Yy]$ ]]; then
  read -p "Masukkan baris repository (misal: deb http://deb.debian.org/debian bookworm main): " repo_line
  echo "$repo_line" | sudo tee -a /etc/apt/sources.list > /dev/null
  echo -e "${GREEN}✅ Repository berhasil ditambahkan.${NC}"
else
  echo -e "${YELLOW}ℹ️  Lewati penambahan repository.${NC}"
fi
repo_time=$(( $(date +%s) - total_start ))
echo -e "⏱️  Time taken: ${repo_time}s"
echo ""

echo -e "${CYAN}▶️  2. Update & Upgrade system${NC}"
sudo apt update && sudo apt upgrade -y
update_time=$(( $(date +%s) - total_start - repo_time ))
echo -e "${GREEN}✅ Update & Upgrade selesai.${NC}"
echo -e "⏱️  Time taken: ${update_time}s"
echo ""

echo -e "${CYAN}▶️  3. Install paket dasar: neofetch, curl, git, nano, net-tools, wget${NC}"
sudo apt install -y neofetch curl git nano net-tools wget

read -p "Apakah ingin menambahkan service tambahan yang ingin diinstall? (y/n): " service_add
if [[ $service_add =~ ^[Yy]$ ]]; then
  read -p "Masukkan nama service tambahan (pisahkan dengan spasi): " extra_services
  sudo apt install -y $extra_services
  echo -e "${GREEN}✅ Service tambahan berhasil diinstall.${NC}"
else
  echo -e "${YELLOW}ℹ️  Lewati instalasi service tambahan.${NC}"
fi
service_time=$(( $(date +%s) - total_start - repo_time - update_time ))
echo -e "⏱️  Time taken: ${service_time}s"
echo ""

echo -e "${CYAN}▶️  4. Install ZeroTier${NC}"
curl -s https://install.zerotier.com | sudo bash
read -p "Masukkan Network ID ZeroTier yang akan di-join: " zt_network
sudo zerotier-cli join $zt_network
zerotier_time=$(( $(date +%s) - total_start - repo_time - update_time - service_time ))
echo -e "${GREEN}✅ ZeroTier berhasil diinstall dan bergabung ke network.${NC}"
echo -e "⏱️  Time taken: ${zerotier_time}s"
echo ""

echo -e "${CYAN}▶️  5. Install Ookla Speedtest${NC}"
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install -y speedtest
speedtest_time=$(( $(date +%s) - total_start - repo_time - update_time - service_time - zerotier_time ))
echo -e "${GREEN}✅ Speedtest berhasil diinstall.${NC}"
echo -e "⏱️  Time taken: ${speedtest_time}s"
echo ""

echo -e "${CYAN}▶️  6. Install CasaOS${NC}"
curl -fsSL https://get.casaos.io | sudo bash
casaos_time=$(( $(date +%s) - total_start - repo_time - update_time - service_time - zerotier_time - speedtest_time ))
echo -e "${GREEN}✅ CasaOS berhasil diinstall.${NC}"
echo -e "⏱️  Time taken: ${casaos_time}s"
echo ""

echo -e "${CYAN}▶️  7. Setup Samba User${NC}"
echo "Daftar user Samba yang sudah ada:"
sudo pdbedit -L

while true; do
  read -p "Apakah ingin menambah user Samba baru? (y/n): " add_smb_user
  if [[ $add_smb_user =~ ^[Yy]$ ]]; then
    read -p "Masukkan username Samba: " smb_user

    # Cek apakah user sudah ada
    if sudo pdbedit -L | grep -qw "^$smb_user:"; then
      echo -e "${YELLOW}⚠️  User $smb_user sudah ada.${NC}"
      read -p "Ingin skip (s) atau replace (r) password user $smb_user? (s/r): " choice
      if [[ $choice =~ ^[Rr]$ ]]; then
        sudo smbpasswd -a $smb_user
        echo -e "${GREEN}✅ Password user $smb_user berhasil diubah.${NC}"
      else
        echo -e "${YELLOW}ℹ️  Skip pengubahan password user $smb_user.${NC}"
      fi
    else
      sudo useradd $smb_user
      sudo smbpasswd -a $smb_user
      echo -e "${GREEN}✅ User Samba $smb_user berhasil ditambahkan.${NC}"
    fi
  else
    break
  fi
done
samba_time=$(( $(date +%s) - total_start - repo_time - update_time - service_time - zerotier_time - speedtest_time - casaos_time ))
echo -e "⏱️  Time taken: ${samba_time}s"
echo ""

echo -e "${CYAN}▶️  8. Cek interface jaringan yang tersedia${NC}"
echo -e "${YELLOW}Daftar interface yang tersedia:${NC}"
ip -o link show | awk -F': ' '{print $2}'
echo ""

echo -e "Untuk konfigurasi IP static, silakan isi data berikut:"
read -p "Nama interface (misal eth0): " intf
read -p "IP statik yang diinginkan: " ip_static
read -p "Netmask (misal 255.255.255.0): " netmask
read -p "Gateway internet: " gateway
read -p "DNS nameserver (misal 8.8.8.8): " dns

echo -e "${CYAN}▶️  9. Menulis konfigurasi static IP ke /etc/network/interfaces${NC}"
sudo bash -c "cat >> /etc/network/interfaces" <<EOF

auto $intf
iface $intf inet static
    address $ip_static
    netmask $netmask
    gateway $gateway
    dns-nameservers $dns
EOF
echo -e "${GREEN}✅ Konfigurasi IP static sudah ditulis.${NC}"
ip_time=$(( $(date +%s) - total_start - repo_time - update_time - service_time - zerotier_time - speedtest_time - casaos_time - samba_time ))
echo -e "⏱️  Time taken: ${ip_time}s"
echo ""

total_end=$(date +%s)
total_duration=$(( total_end - total_start ))

echo -e "${GREEN}✔️  Semua proses selesai dalam ${total_duration} detik.${NC}"
echo ""
echo -e "${CYAN}=== Informasi Penting Setelah Script Ini ===${NC}"
echo -e "▶️ Gunakan perintah berikut untuk cek speed internet:\n${YELLOW}speedtest${NC}"
echo -e "▶️ Restart jaringan setelah konfigurasi IP static dengan:\n${YELLOW}sudo systemctl restart networking${NC} atau reboot server"
echo -e "▶️ Akses CasaOS di web browser dengan alamat:\n${YELLOW}http://$ip_static${NC}"
echo -e "▶️ Akses SSH ke server dengan:\n${YELLOW}ssh <user>@$ip_static${NC}"
echo -e "▶️ Jangan lupa lakukan reboot setelah selesai menjalankan script ini agar konfigurasi diterapkan sepenuhnya.${NC}"
echo ""

exit 0