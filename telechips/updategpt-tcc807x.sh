#!/bin/bash

. telechips-common.sh

board=tcc807x
target=TCC807X
prefix=./${board}

cat << __EOF > ~/boot-firmware/tools/mktcimg/gpt_partition.list
bl3_ap0_a:2048k@~/main/u-boot/ap0_bl3.rom
bl3_ap0_b:2048k@~/main/u-boot/ap0_bl3.rom
bl3_ap1_a:2048k@~/sub/u-boot/ap1_bl3.rom
bl3_ap1_b:2048k@~/sub/u-boot/ap1_bl3.rom
boot:40960k@~/main/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
dtb:1024k@~/main/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8070-lpd4x322.dtb
misc:1024k@
env:16k@
subcore_boot:40960k@~/sub/kernel-@@VERSION@@/BUILD_${target}/${target}_boot.img
subcore_dtb:1024k@~/sub/kernel-@@VERSION@@/arch/arm64/boot/dts/telechips/${board}/tcc8070-subcore-lpd4x322.dtb
subcore_misc:1024k@
subcore_env:16k@
data:0k@
__EOF
