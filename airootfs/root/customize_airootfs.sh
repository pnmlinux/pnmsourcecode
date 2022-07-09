#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

OSNAME="GNU/Linux PNM OS"
count=0

function layout() {
    count=$[count+1]
    echo
    echo "¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦"
    tput setaf 1;echo $count. " Function " $1 "has been installed";tput sgr0
    echo "¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦"
    echo
}

function deleteXfceWallpapers() {
    rm -rf /usr/share/backgrounds/xfce
}

function changeMkinitcpioHook() {
    cp -rf /usr/share/mkinitcpio/hook.preset /etc/mkinitcpio.d/linux.preset
    sed -i 's?%PKGBASE%?linux?' /etc/mkinitcpio.d/linux.preset

    cp -rf /etc/mkinitcpio-default.conf /etc/mkinitcpio.conf
}

function renameOSFunc() {
    #Name PNM Linux
    osReleasePath='/etc/os-release'
    rm -rf $osReleasePath
    touch $osReleasePath
    echo 'NAME="'${OSNAME}'"' >> $osReleasePath
    echo 'ID=PNM' >> $osReleasePath
    echo 'BUILD_ID=rolling' >> $osReleasePath
    echo 'PRETTY_NAME="'${OSNAME}'"' >> $osReleasePath
    echo 'ANSI_COLOR="0;31"' >> $osReleasePath
    echo 'HOME_URL="https://suleymanfatih.github.io"' >> $osReleasePath
    echo 'DOCUMENTATION_URL="https://suleymanfatih.github.io"' >> $osReleasePath
    echo 'LOGO=/usr/share/icons/PNMlogopanth.png/' >> $osReleasePath

    arch=`uname -m`
    cat > "/etc/issue" <<- EOL
	PNM Linux \r (\l)
EOL
}

function umaskFunc() {
    set -e -u
    umask 022
}

function localeGenFunc() {
    sed -i 's/^#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    #export LC_ALL=en_US.UTF-8
    locale-gen
}

function setTimeZoneAndClockFunc() {
    # Timezone
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    # Set clock to UTC
    hwclock --systohc --utc
}

function editOrCreateConfigFilesFunc () {

    # Locale
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
    sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
    sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
}

function configRootUserFunc() {
    usermod -s /usr/bin/bash root
    cp -aT /etc/skel/ /root/
    chmod 750 /root
}

function createLiveUserFunc () {
	# add pnmlive
	useradd -m pnmlive -u 500 -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash
	chown -R pnmlive:users /home/pnmlive
	passwd -d pnmlive
	# enable autologin
	groupadd -r autologin
	gpasswd -a pnmlive autologin
	groupadd -r nopasswdlogin
	gpasswd -a pnmlive nopasswdlogin
	echo "The account pnmlive with no password has been created"
}

function LockscreenFunc() {


cat>/etc/lightdm/lightdm.conf<< EOL
[LightDM]
run-directory=/run/lightdm


[Seat:*]

session-wrapper=/etc/lightdm/Xsession
autologin-guest=false
autologin-user=pnmlive
autologin-user-timeout=0
greeter-session = lightdm-gtk-greeter
greeter-show-manual-login=false
greeter-hide-users=true
allow-guest=false
user-session=xfce
[XDMCPServer]
[VNCServer]



EOL
}

function lightdmThemingFunc() {


cat>/etc/lightdm/lightdm-gtk-greeter.conf<< EOL

[greeter]
theme-name = WhiteSur-light
icon-theme-name = WhiteSur-icon
indicators = ~~pnmlinux;~spacer;~clock;~spacer;~session;~a11y;~power
position = 24%,center 45%,center
font-name = System-ui Bold 10
background = /usr/share/backgrounds/pnmwallpaper/nasa-NuE8Nu3otjo-unsplash.jpg



EOL
}


function setDefaultsFunc() {
    export _EDITOR=nano
    echo "EDITOR=${_EDITOR}" >> /etc/environment
    echo "EDITOR=${_EDITOR}" >> /etc/profile
}

function fixHavegedFunc(){
    systemctl enable haveged
}

function fixPermissionsFunc() {
    chmod 755 /etc/sudoers.d
    chmod 440 /etc/sudoers.d/g_wheel
    chown 0 /etc/sudoers.d
    chown 0 /etc/sudoers.d/g_wheel
    chown root:root /etc/sudoers.d
    chown root:root /etc/sudoers.d/g_wheel
    chmod 755 /etc
    chmod 750 /etc/polkit-1/rules.d
    chgrp polkitd /etc/polkit-1/rules.d
    #pkexec chown root:root /etc/sudoers /etc/sudoers.d -R
}

function enableServicesFunc() {
  systemctl enable lightdm.service
  systemctl set-default graphical.target
  systemctl enable NetworkManager.service
  systemctl enable bluetooth.service
  systemctl enable ntpd.service
  #systemctl enable smb.service
  #systemctl enable nmb.service
  #systemctl enable winbind.service
  systemctl enable avahi-daemon.service
  systemctl enable avahi-daemon.socket
  #systemctl enable tlp.service
  #systemctl enable tlp-sleep.service
  #systemctl enable vnstat.service
}

function fixWifiFunc() {
    #https://wiki.archlinux.org/index.php/NetworkManager#Configuring_MAC_Address_Randomization
    su -c 'echo "" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "[device]" >> /etc/NetworkManager/NetworkManager.conf'
    su -c 'echo "wifi.scan-rand-mac-address=no" >> /etc/NetworkManager/NetworkManager.conf'
}

function fixHibernateFunc() {
    sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
    sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
    sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf
}

function initkeysFunc() {
    pacman-key --init
    pacman-key --populate archlinux
    #pacman-key --keyserver hkps://hkps.pool.sks-keyservers.net:443 -r 74F5DE85A506BF64
    #pacman-key --keyserver hkp://pool.sks-keyservers.net:80 -r 74F5DE85A506BF64
    #sudo pacman-key --refresh-keys
}

function getNewMirrorCleanAndUpgrade() {
    pacman -Sc --noconfirm
    pacman -Syyu --noconfirm
}

function deleteprograms () {

    pacman -Rsn xfburn --noconfirm

}


function updategrubconfig () {

  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command grub2-mkconfig; then
    if has_command zypper; then
      grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
  fi

}

function varlibpacmanconf () {

	 rm -rf /var/lib/pacman/sync/*
	 pacman -Syyu
}

varlibpacmanconf
layout varlibpacmanconf
deleteXfceWallpapers
layout deleteXfceWallpapers
changeMkinitcpioHook
layout changeMkinitcpioHook
umaskFunc
layout umaskFunc
localeGenFunc
layout localeGenFunc
setTimeZoneAndClockFunc
layout setTimeZoneAndClockFunc
editOrCreateConfigFilesFunc
layout editOrCreateConfigFilesFunc
configRootUserFunc
layout configRootUserFunc
createLiveUserFunc
layout createLiveUserFunc
LockscreenFunc
layout autoLoginFunc
setDefaultsFunc
lightdmThemingFunc
layout lightdmThemingFunc
layout setDefaultsFunc
fixHavegedFunc
layout fixHavegedFunc
fixPermissionsFunc
layout fixPermissionsFunc
enableServicesFunc
layout enableServicesFunc
fixWifiFunc
layout fixWifiFunc
fixHibernateFunc
layout fixHibernateFunc
initkeysFunc
layout initkeysFunc
getNewMirrorCleanAndUpgrade
layout getNewMirrorCleanAndUpgrade
renameOSFunc
deleteprograms
layout deleteprograms
updategrubconfig
layout updategrubconfig
