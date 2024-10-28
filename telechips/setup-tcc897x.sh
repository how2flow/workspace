#!/bin/bash

. telechips-common.sh

board=tcc897x
target=TCC897X
prefix=${prefix}/${board}

if [ -d ${prefix} ]; then
	rm -rf ${prefix}
fi

mkdir -p ${prefix}
mkdir -p ${prefix}/main

# set boot-firmware
git clone ssh://git@bitbucket.telechips.com:7999/firmware/boot-firmware.git -b ${board} ${prefix}/boot-firmware
cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca7_a:2048k@${prefix}/main/u-boot/ca7_bl3.rom
bl3_ca7_b:2048k@${prefix}/main/u-boot/ca7_bl3.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm/boot/dts/telechips/${board}/tcc8971-lcn.dtb
misc:1024k@
env:1024k@
data:0k@
__EOF

setup_bootloader ${prefix} ${board}
setup_kernel ${prefix} ${board}
setup_initramfs ${prefix} ${board}
setup_mkmmc ${prefix}/boot-firmware ${board}

# copy ps1 script to window power shell dir
echo ""
echo ""
echo ""
echo "########################################"
echo "# Finish format workspace for ${board} #"
echo "########################################"
echo "Finish format workspace for ${board}"
echo "Copy FlashData_${board}.ps1 to your Windows PowerShell exec path"
