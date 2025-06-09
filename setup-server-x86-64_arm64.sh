#!/bin/bash

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

start_time=$(date +%s)

function timer() {
  local start=$1
  local end=$(date +%s)
  local elapsed=$(( end - start ))
  echo -e "${CYAN}⏱️  Time taken: ${elapsed}s${NC}"
}

function step() {
  echo -e "${YELLOW}▶️  $1${NC}"
  local step_start=$(date +%s)
}

function done_step() {
  echo -e "${GREEN}✅ Done${NC}"
  timer $1
  echo ""
}

# 1. Tambah repository
step "1. Menambahkan repository ke sources.list"
read -p "Masukkan baris repository (misalnya: deb http://deb.debian.org/debian bookworm main): " user_repo
echo "$user_repo" | sudo tee -a /etc/apt/sources.list > /dev/null
step1_start=$(date +%s)
sleep 1
done_step $step1_start

# 2. Update dan upgrade
step "2. Update & Upgrade system"
step2_start=$(date +%s)
sudo apt update -y > /dev/null && sudo apt upgrade -y > /dev/null
done_step $step2_start

# 3. Install tools dasar
step "3. Install neofetch, curl, git, nano, net-tools, wget"
step3_start=$(date +%s)
sudo apt install -y neofetch curl git nano net-tools wget > /dev/null
done_step $step3_start

# 4. Tambahan Service
read -p "Masukkan service tambahan yang ingin di-install (pisahkan dengan spasi): " extra_services
if [ ! -z "$extra_services" ]; then
  step "Install service tambahan: $extra_services"
  step4_start=$(date +%s)
  sudo apt install -y $extra_services > /dev/null
  done_step $step4_start
fi

# 5. Install Zerotier
step "5. Install ZeroTier"
step5_start=$(date +%s)
curl -s https://install.zerotier.com | sudo bash > /dev/null
read -p "Masukkan Network ID ZeroTier: " zt_network
sudo zerotier-cli join $zt_network
done_step $step5_start

# 6. Install Speedtest
step "6. Install Ookla Speedtest"
step6_start=$(date +%s)
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash > /dev/null
sudo apt-get install -y speedtest > /dev/null
done_step $step6_start

# 7. Install CasaOS
step "7. Install CasaOS"
step7_start=$(date +%s)
curl -fsSL https://get.casaos.io | sudo bash > /dev/null
done_step $step7_start

# 8. Cek user aktif
step "8. Cek user aktif Samba"
step8_start=$(date +%s)
sudo pdbedit -L
done_step $step8_start

# 9. Tambah user root dan user baru
step "9. Tambah user root untuk Samba"
step9_start=$(date +%s)
sudo useradd root
echo -e "${YELLOW}Set password untuk root SMB:${NC}"
sudo smbpasswd -a root
echo -e "${GREEN}User root SMB berhasil ditambahkan${NC}"

read -p "Masukkan nama user tambahan: " newuser
sudo useradd $newuser
echo -e "${YELLOW}Set password untuk user $newuser SMB:${NC}"
sudo smbpasswd -a $newuser
echo -e "${GREEN}User $newuser SMB berhasil ditambahkan${NC}"
done_step $step9_start

# 10. Cek interface
step "10. Cek interface jaringan & IP"
step10_start=$(date +%s)
ifconfig
done_step $step10_start

# 11. Konfigurasi IP statik
step "11. Konfigurasi IP statik"
read -p "Masukkan nama interface (cth: eth0): " iface
read -p "Masukkan IP statik: " ipaddr
read -p "Masukkan netmask: " netmask
read -p "Masukkan gateway: " gateway
read -p "Masukkan DNS (pisah spasi): " dns
step11_start=$(date +%s)

echo -e "\nauto $iface\niface $iface inet static\n    address $ipaddr\n    netmask $netmask\n    gateway $gateway\n    dns-nameservers $dns" | sudo tee -a /etc/network/interfaces > /dev/null
done_step $step11_start

# Total waktu
end_time=$(date +%s)
total=$(( end_time - start_time ))
echo -e "${CYAN}🚀 Total waktu instalasi: ${total}s${NC}"
