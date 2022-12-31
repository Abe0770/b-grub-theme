#! /usr/bin/env bash

sudo echo

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
LGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

GRUB_THEME='b-grub'
GRUB_DIR='grub'
UPDATE_GRUB=''
BOOT_MODE='legacy'

if [[ -d /boot/efi && -d /sys/firmware/efi ]]; then
    BOOT_MODE='UEFI'
fi

echo -e "${LGREEN}Boot mode: ${BOOT_MODE}${NC}"

if [[ -e /etc/os-release ]]; 
then
    ID=""
    ID_LIKE=""
    source /etc/os-release

    if [[ "$ID" =~ (debian|ubuntu|solus|void) || \
          "$ID_LIKE" =~ (debian|ubuntu|void) ]]; 
        then
        UPDATE_GRUB='update-grub'

    elif [[ "$ID" =~ (arch|gentoo) || \
            "$ID_LIKE" =~ (archlinux|gentoo) ]]; 
        then
        UPDATE_GRUB='grub-mkconfig -o /boot/grub/grub.cfg'

    elif [[ "$ID" =~ (centos|fedora|opensuse) || \
            "$ID_LIKE" =~ (fedora|rhel|suse) ]]; 
        then
        GRUB_DIR='grub2'
        GRUB_CFG='/boot/grub2/grub.cfg'

        if [[ "$BOOT_MODE" = "UEFI" ]]; then
            GRUB_CFG="/boot/efi/EFI/${ID}/grub.cfg"
        fi

        UPDATE_GRUB="grub2-mkconfig -o ${GRUB_CFG}"

        if [[ -d /boot/loader/entries && -e icons/${ID}.png ]]; then
            cp icons/${ID}.png icons/kernel.png
        fi
    fi
fi

echo -e "${YELLOW}Creating b-grub directory"
sudo mkdir -p /boot/${GRUB_DIR}/themes/${GRUB_THEME}

echo -e "${WHITE}Copying theme to b-grub directory"
sudo cp ./background.jpg /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./grub_background.sh /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp -r ./icons /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./item_c.png /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./select_c.png /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./select_e.png /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./select_w.png /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./theme.txt /boot/${GRUB_DIR}/themes/${GRUB_THEME}
sudo cp ./unifont-regular-16.pf2 /boot/${GRUB_DIR}/themes/${GRUB_THEME}

echo -e "Removing other themes from GRUB config"
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub

echo -e 'Making sure GRUB uses graphical output'
sudo sed -i 's/^\(GRUB_TERMINAL\w*=.*\)/#\1/' /etc/default/grub

echo -e 'Removing empty lines at the end of GRUB config'
sudo sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/default/grub

echo -e 'Adding new line to GRUB config just in case'
echo | sudo tee -a /etc/default/grub

echo -e 'Adding path to GRUB config'
echo "GRUB_THEME=/boot/${GRUB_DIR}/themes/${GRUB_THEME}/theme.txt" | sudo tee -a /etc/default/grub

echo -e 'Updating GRUB'
if [[ $UPDATE_GRUB ]]; then
    eval sudo "$UPDATE_GRUB"
else
    echo -e "${YELLOW}--------------------------------------------------------------------------------"
    echo -e "${RED}Failed to detect your distro, you will need to run `grub-mkconfig` (as root) manually."
    echo -e "Common ways:"
    echo -e "- Debian, Ubuntu, Solus and derivatives: `update-grub` or `grub-mkconfig -o /boot/grub/grub.cfg`"
    echo -e "- RHEL, CentOS, Fedora, SUSE and derivatives: `grub2-mkconfig -o /boot/grub2/grub.cfg`"
    echo -e "- Arch, Gentoo and derivatives: `grub-mkconfig -o /boot/grub/grub.cfg`"
    echo -e "${YELLOW}--------------------------------------------------------------------------------"
fi
