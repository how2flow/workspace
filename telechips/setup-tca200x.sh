#!/bin/bash

. telechips-common.sh

board=tca200x
target=TCA200X
prefix=${prefix}/${board}

if [ -d ${prefix} ]; then
	rm -rf ${prefix}
fi

mkdir -p ${prefix}
mkdir -p ${prefix}/main

# set boot-firmware
git clone ssh://git@bitbucket.telechips.com:7999/firmware/boot-firmware.git -b ${board} ${prefix}/boot-firmware
cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_main_a:2048k@${prefix}/main/u-boot/u-boot.rom
bl3_main_b:2048k@${prefix}/main/u-boot/u-boot.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tca2000-lpd4x321.dtb
misc:1024k@
env:16k@
data:0k@
__EOF

setup_bootloader ${prefix} ${board}
setup_kernel ${prefix} ${board}
setup_initramfs ${prefix} ${board}
setup_mkufs ${prefix}/boot-firmware ${board}
setup_tf-a ${prefix} ${board}

# copy ps1 script to window power shell dir
echo ""
echo ""
echo ""
echo "########################################"
echo "# Finish format workspace for ${board} #"
echo "########################################"
echo "Finish format workspace for ${board}"
echo "Copy FlashData_${board}.ps1 to your Windows PowerShell exec path"
