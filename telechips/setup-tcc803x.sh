#!/bin/bash

. telechips-common.sh

board=tcc803x
target=TCC803X
prefix=${prefix}/${board}

if [ -d ${prefix} ]; then
	rm -rf ${prefix}
fi

mkdir -p ${prefix}
mkdir -p ${prefix}/main ${prefix}/sub

# set boot-firmware
git clone ssh://git@bitbucket.telechips.com:7999/firmware/boot-firmware.git -b ${board} ${prefix}/boot-firmware
cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca53_a:2048k@${prefix}/main/u-boot/u-boot.rom
bl3_ca53_b:2048k@${prefix}/main/u-boot/u-boot.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERISON@@/arch/arm64/boot/dts/telechips/${board}/tcc8030-lpd4321.dtb
system:1048576k@
recovery:20480k@
misc:1024k@
snapshot:102400k@
splash:4096k@
home:512000k@
a7s_boot:8192k@${prefix}/sub/kernel-@@VERISON@@/arch/arm/boot/Image
a7s_dtb:200k@${prefix}/sub/kernel-@@VERISON@@/arch/arm/boot/dts/telechips/${board}/tcc8030-subcore-lpd4321.dtb
a7s_root:20480k@${prefix}/sub/kernel-@@VERISON@@/initramfs.cpio.lzo
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
