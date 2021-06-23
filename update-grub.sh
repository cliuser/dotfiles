#!/bin/bash
#	fix artix, only once.

artix=ucode.img			# artix/arch have sep ucode.img
cfg=/boot/grub/grub.cfg		# grub cfg
img=initramfs-linux.img		# artix/arch boot ramdisk

sudo fgrep ucode.img $cfg	# show cfg
if [[ $? == 0 ]]; then
	# update & show change
	sudo sed -i -e "/ucode.img/s/$/ \/boot\/$img/" $cfg
	sudo fgrep ucode.img $cfg
fi

#	end
