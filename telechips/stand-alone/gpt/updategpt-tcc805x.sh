#!/bin/bash

# written by steve.jeong <steve.jeong@telechips.com>

board=tcc805x
target=TCC805X
prefix=$(set_prefix ${board})

IFS=' ' read -r -a prefix <<< "${prefix}"

cat << __EOF > ${top}/${board}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca72_a:2048k@${prefix[0]}/u-boot/ca72_bl3.rom
bl3_ca72_b:2048k@${prefix[0]}/u-boot/ca72_bl3.rom
bl3_ca53_a:2048k@${prefix[1]}/u-boot/ca53_bl3.rom
bl3_ca53_b:2048k@${prefix[1]}/u-boot/ca53_bl3.rom
boot:40960k@${prefix[0]}/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix[0]}/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8050-lpd4x322-sv0.1.dtb
env:1024k@
misc:1024k@
subcore_boot:40960k@${prefix[1]}/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
subcore_dtb:1024k@${prefix[1]}/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8050-subcore-lpd4x322-sv0.1.dtb
subcore_env:1024k@
data:0k@
__EOF
