#!/bin/bash

. telechips-common.sh

board=tcn100x
target=TCN100X
prefix=${prefix}/${board}

cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_main_a:2048k@${prefix}/main/u-boot/u-boot.rom
bl3_main_b:2048k@${prefix}/main/u-boot/u-boot.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcn1000-lpd4x321.dtb
misc:1024k@
env:16k@
data:0k@
__EOF
