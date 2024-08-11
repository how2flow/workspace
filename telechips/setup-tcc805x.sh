#!/bin/bash

. telechips-common.sh

board=tcc805x
target=TCC805X
prefix=${prefix}/${board}

if [ -d ${prefix} ]; then
	rm -rf ${prefix}
fi

mkdir -p ${prefix}
mkdir -p ${prefix}/main ${prefix}/sub

# set boot-firmware
git clone ssh://git@bitbucket.telechips.com:7999/firmware/boot-firmware.git -b ${board} ${prefix}/boot-firmware
cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca72_a:2048k@${prefix}/main/u-boot/ca72_bl3.rom
bl3_ca72_b:2048k@${prefix}/main/u-boot/ca72_bl3.rom
bl3_ca53_a:2048k@${prefix}/sub/u-boot/ca53_bl3.rom
bl3_ca53_b:2048k@${prefix}/sub/u-boot/ca53_bl3.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8050-lpd4x322-sv0.1.dtb
env:1024k@
misc:1024k@
subcore_boot:40960k@${prefix}/sub/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
subcore_dtb:1024k@${prefix}/sub/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8050-subcore-lpd4x322-sv0.1.dtb
subcore_env:1024k@
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
