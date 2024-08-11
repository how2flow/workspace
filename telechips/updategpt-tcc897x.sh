#!/bin/bash

. telechips-common.sh

board=tcc897x
target=TCC897X
prefix=${prefix}/${board}

cat << __EOF > ${prefix}/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ca7_a:2048k@${prefix}/main/u-boot/ca7_bl3.rom
bl3_ca7_b:2048k@${prefix}/main/u-boot/ca7_bl3.rom
boot:40960k@${prefix}/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@${prefix}/main/kernel-@@VERSION@@/arch/arm/boot/dts/telechips/${board}/tcc8971-lcn.dtb
misc:1024k@
env:1024k@
data:0k@
__EOF
