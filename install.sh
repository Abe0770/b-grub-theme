#! /usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

GRUB_THEME='b-grub'

sudo echo

GRUB_DIR='grub'
UPDATE_GRUB=''
BOOT_MODE='legacy'

if [[ -d /boot/efi && -d /sys/firmware/efi ]]; then
    BOOT_MODE='UEFI'
fi

echo "Boot mode: ${BOOT_MODE}"

if [[ -e /etc/os-release ]]; then

    ID=""
    ID_LIKE=""
    source /etc/os-release

    if [[ "$ID" =~ (debian|ubuntu|solus|void) || \
          "$ID_LIKE" =~ (debian|ubuntu|void) ]]; then

        UPDATE_GRUB='update-grub'

    elif [[ "$ID" =~ (arch|gentoo) || \
            "$ID_LIKE" =~ (archlinux|gentoo) ]]; then

        UPDATE_GRUB='grub-mkconfig -o /boot/grub/grub.cfg'

    elif [[ "$ID" =~ (centos|fedora|opensuse) || \
            "$ID_LIKE" =~ (fedora|rhel|suse) ]]; then

        GRUB_DIR='grub2'
        GRUB_CFG='/boot/grub2/grub.cfg'

        if [[ "$BOOT_MODE" = "UEFI" ]]; then
            GRUB_CFG="/boot/efi/EFI/${ID}/grub.cfg"
        fi

        UPDATE_GRUB="grub2-mkconfig -o ${GRUB_CFG}"

        # BLS etries have 'kernel' class, copy corresponding icon
        if [[ -d /boot/loader/entries && -e icons/${ID}.png ]]; then
            cp icons/${ID}.png icons/kernel.png
        fi
    fi
fi

echo 'Creating GRUB themes directory'
sudo mkdir -p /boot/${GRUB_DIR}/themes/${GRUB_THEME}

echo 'Copying theme to GRUB themes directory'
sudo cp -r * /boot/${GRUB_DIR}/themes/${GRUB_THEME}

echo 'Removing other themes from GRUB config'
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub

echo 'Making sure GRUB uses graphical output'
sudo sed -i 's/^\(GRUB_TERMINAL\w*=.*\)/#\1/' /etc/default/grub

echo 'Removing empty lines at the end of GRUB config'
sudo sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/default/grub

echo 'Adding new line to GRUB config just in case'
echo | sudo tee -a /etc/default/grub

echo 'Adding theme to GRUB config'
echo "GRUB_THEME=/boot/${GRUB_DIR}/themes/${GRUB_THEME}/theme.txt" | sudo tee -a /etc/default/grub

echo 'Updating GRUB'
if [[ $UPDATE_GRUB ]]; then
    eval sudo "$UPDATE_GRUB"
else
    cat << '    EOF'
    --------------------------------------------------------------------------------
    Cannot detect your distro, you will need to run `grub-mkconfig` (as root) manually.
    Common ways:
    - Debian, Ubuntu, Solus and derivatives: `update-grub` or `grub-mkconfig -o /boot/grub/grub.cfg`
    - RHEL, CentOS, Fedora, SUSE and derivatives: `grub2-mkconfig -o /boot/grub2/grub.cfg`
    - Arch, Gentoo and derivatives: `grub-mkconfig -o /boot/grub/grub.cfg`
    --------------------------------------------------------------------------------
    EOF
fi
