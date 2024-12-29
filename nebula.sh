#!/bin/bash

RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

show_progress() {
    local percent=$1
    local message=$2

    if [ "$percent" -le 40 ]; then
        COLOR=$RED
    elif [ "$percent" -le 70 ]; then
        COLOR=$ORANGE
    else
        COLOR=$GREEN
    fi

    clear
    echo -e "${CYAN}Nebulla Theme${RESET}"
    sleep 2
}

clear
echo -e "${CYAN}Lets Start${RESET}"
sleep 3

show_progress 1 "Memeriksa Files Theme Nebula"
cd /var/www

NEBULA_FILES="/var/www/pterodactyl/nebula.blueprint"

if [ ! -f "$NEBULA_FILES" ]; then
    echo "𝗡𝗘𝗕𝗨𝗟𝗔 𝗙𝗜𝗟𝗘𝗦 𝗧𝗜𝗗𝗔𝗞 𝗧𝗘𝗥𝗜𝗡𝗦𝗧𝗔𝗟"
    exit 1
fi

show_progress 10 "Masuk ke direktori Pterodactyl..."
cd /var/www/pterodactyl
php artisan down > /dev/null 2>&1

show_progress 20 "Mengunduh dan mengekstrak file panel terbaru..."
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv > /dev/null 2>&1

show_progress 30 "Mengatur izin folder penting..."
chmod -R 755 storage/* bootstrap/cache > ©

show_progress 40 "Menginstal dependensi"
composer install --no-dev --optimize-autoloader --no-interaction > /dev/null 2>&1
yarn add cross-env > /dev/null 2>&1
yarn add react-feather > /dev/null 2>&1 

show_progress 50 "Membersihkan cache..."
php artisan view:clear > /dev/null 2>&1
php artisan config:clear > /dev/null 2>&1

show_progress 60 "Menjalankan migrasi database..."
php artisan migrate --seed --force > /dev/null 2>&1

show_progress 70 "Mengatur hak milik folder..."
chown -R www-data:www-data /var/www/pterodactyl/* > /dev/null 2>&1
php artisan up > /dev/null 2>&1

show_progress 80 "Memasang dependensi Nebula..."
apt-get install -y nodejs > /dev/null 2>&1
npm i -g yarn > /dev/null 2>&1

show_progress 90 "Menyesuaikan konfigurasi Nebula..."
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip > /dev/null 2>&1
cd /var/www/pterodactyl
unzip -o release.zip > /dev/null 2>&1
chmod +x blueprint.sh
bash /var/www/pterodactyl/blueprint.sh < <(yes "y") > /dev/null 2>&1
cd /var/www/pterodactyl

show_progress 99 "Menginstal Nebula Theme"
blueprint -install nebula < /dev/null

show_progress 100 "Instalasi Nebula Theme Selesai!"
clear
