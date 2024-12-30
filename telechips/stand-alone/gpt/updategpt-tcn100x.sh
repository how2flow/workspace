#!/bin/bash

# written by steve.jeong <steve.jeong@telechips.com>

board=tcn100x
target=TCN100X
prefix=$(set_prefix ${board})

IFS=' ' read -r -a prefix <<< "${prefix}"

cat << __EOF > ${top}/${board}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_main_a:2048k@${prefix[0]}/u-boot/u-boot.rom
bl3_main_b:2048k@${prefix[0]}/u-boot/u-boot.rom
boot:40960k@${prefix[0]}/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix[0]}/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcn1000-lpd4x321.dtb
misc:1024k@
env:16k@
data:0k@
__EOF
