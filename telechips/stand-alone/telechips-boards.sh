#!/bin/bash

# written by steve.jeong <steve.jeong@telechips.com>

. telechips-common.sh

board=$1
prefix=$(set_prefix ${board})

check_version

for path in ${prefix[@]}; do
  if [ -d ${path} ]; then
    rm -rf ${path}
  fi
  mkdir -p ${path}
done

pre_process ${board} k_vers
setup_bootfirmware ${board} k_vers
setup_prev_bl3n ${board}
setup_bl3n prefix k_vers
post_process ${board} k_vers

# copy ps1 script to window power shell dir
echo ""
echo ""
echo ""
echo "########################################"
echo "# Finish format workspace for ${board} #"
echo "########################################"
echo "Finish format workspace for ${board}"
echo "Copy FlashData_${board}.ps1 to your Windows PowerShell exec path"
