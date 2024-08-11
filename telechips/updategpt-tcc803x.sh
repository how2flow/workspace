#!/bin/bash

. telechips-common.sh

board=tcc803x
target=TCC803X
prefix=${prefix}/${board}

cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca53_a:2048k@${prefix}/main/u-boot/u-boot.rom
bl3_ca53_b:2048k@${prefix}/main/u-boot/u-boot.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8030-lpd4321.dtb
system:1048576k@
recovery:20480k@
misc:1024k@
snapshot:102400k@
splash:4096k@
home:512000k@
a7s_boot:8192k@${prefix}/sub/kernel-@@VERSION@@/arch/arm/boot/Image
a7s_dtb:200k@${prefix}/sub/kernel-@@VERSION@@/arch/arm/boot/dts/telechips/${board}/tcc8030-subcore-lpd4321.dtb
a7s_root:20480k@${prefix}/sub/kernel-@@VERSION@@/initramfs.cpio.lzo
data:0k@
__EOF
