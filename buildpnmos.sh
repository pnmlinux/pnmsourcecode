sudo rm -rf base._cleanup_pacstrap_dir base._make_bootmode_bios.syslinux.eltorito base._make_bootmode_bios.syslinux.mbr base._make_bootmode_uefi-ia32.grub.eltorito base._make_bootmode_uefi-ia32.grub.esp base._make_bootmode_uefi-x64.grub.eltorito base._make_bootmode_uefi-x64.grub.esp base._make_boot_on_iso9660 base._make_custom_airootfs base._make_customize_airootfs base._make_efibootimg_grubcfg base._make_packages base._make_pacman_conf base._make_pkglist base._make_version base._mkairootfs_squashfs base._prepare_airootfs_image BOOTIA32.EFI BOOTx64.EFI build._build_buildmode_iso build_date efiboot.img grub.cfg grub-embed.cfg iso iso._build_iso_image iso.pacman.conf x86_64/

sudo mkarchiso -v -w ~/Documents/newpnmiso/ ~/Documents/newpnmiso/ -o ~/Documents/newpnmiso/
