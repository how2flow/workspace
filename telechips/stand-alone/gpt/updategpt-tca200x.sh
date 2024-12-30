#!/bin/bash

# written by steve.jeong <steve.jeong@telechips.com>

board=tca200x
target=TCA200X
prefix=$(set_prefix ${board})

IFS=' ' read -r -a prefix <<< "${prefix}"

cat << __EOF > ${top}/${board}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_main_a:2048k@${prefix[0]}/u-boot/u-boot.rom
bl3_main_b:2048k@${prefix[0]}/u-boot/u-boot.rom
boot:40960k@${prefix[0]}/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix[0]}/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tca2000-lpd5642322.dtb
misc:1024k@
env:16k@
data:0k@
__EOF
