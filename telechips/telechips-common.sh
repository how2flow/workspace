#!/bin/bash

prefix=${HOME}/work1
k_vers=("5.10" "6.1")

return_major() {
  local major=$(echo ${1} | cut -d. -f1)

  echo ${major}
}

setup_bootloader() {
  local pref=$1
  local board=$2

  git clone ssh://git@bitbucket.telechips.com:7999/bootloader/u-boot-core.git -b dev ${pref}/main/u-boot
  case ${board} in
    tcc805x|tcc807x)
      git clone ssh://git@bitbucket.telechips.com:7999/bootloader/u-boot-core.git -b dev ${pref}/sub/u-boot
      ;;
  esac
}

setup_initramfs() {
  local pref=$1
  local board=$2

  # set initramfs64 #
  if [ -f ${HOME}/initramfs64.cpio.lzo ]; then
    for ver in ${k_vers[@]}; do
      if [[ $(return_major ${ver}) -gt 5 && ${board} == "tcc897x" ]]; then
        continue
      fi
      ln -s ${HOME}/initramfs64.cpio.lzo ${pref}/main/kernel-${ver}/
      case ${board} in
        tcc805x|tcc807x)
          ln -s ${HOME}/initramfs64.cpio.lzo ${pref}/sub/kernel-${ver}/
          ;;
      esac
    done
  else
    echo "Install initramfs64.cpio.lzo to ${HOME} in global telechips Wiki"
  fi

  # set initramfs #
  if [ -f ${HOME}/initramfs32.cpio.lzo ]; then
    for ver in ${k_vers[@]}; do
      if [[ ${ver} != "5.10" && ${board} == "tcc897x" ]]; then
        continue
      fi
      ln -s ${HOME}/initramfs32.cpio.lzo ${pref}/main/kernel-${ver}/
      case ${board} in
        tcc803x)
          ln -s ${HOME}/initramfs32.cpio.lzo ${pref}/sub/kernel-${ver}/
          ;;
      esac
    done
  else
  	echo "Install initramfs64.cpio.lzo to ${HOME} in global telechips Wiki"
  fi
}

setup_kernel() {
  local pref=$1
  local board=$2

  for ver in ${k_vers[@]}; do
    if [[ ${ver} != "5.10" && ${board} == "tcc897x" ]]; then
      continue
    fi
    git clone ssh://git@bitbucket.telechips.com:7999/linux/kernel-${ver}-core.git -b dev ${pref}/main/kernel-${ver}
    case ${board} in
      tcc803x|tcc805x|tcc807x)
        git clone ssh://git@bitbucket.telechips.com:7999/linux/kernel-${ver}-core.git -b dev ${pref}/sub/kernel-${ver}
        ;;
    esac
# setup envsetup.sh for kernel #
    case ${board} in
    tcc897x)
      cat << __EOF > ${pref}/main/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf-
echo "====================================================="
echo "ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf-"
echo "NEED: make ${board}_defconfig"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_32bit.sh"
echo "====================================================="
__EOF
      cat << __EOF > ${pref}/sub/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf-
echo "====================================================="
echo "ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabihf-"
echo "NEED: make ${board}_subcore_defconfig"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_64bit.sh"
echo "====================================================="
__EOF
      ;;
    tcc803x)
      cat << __EOF > ${pref}/main/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
echo "====================================================="
echo "ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-"
echo "NEED: make ${board}_defconfig"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_64bit.sh"
echo "====================================================="
__EOF
      cat << __EOF > ${pref}/sub/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm64 CROSS_COMPILE=arm-none-linux-gnueabihf-
echo "====================================================="
echo "ARCH=arm64 CROSS_COMPILE=arm-none-linux-gnueabihf-"
echo "NEED: make ${board}_subcore_defconfig"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_32bit.sh"
echo "====================================================="
__EOF
      ;;
    tcc805x|tcc807x)
      cat << __EOF > ${pref}/main/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
echo "====================================================="
echo "ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-"
echo "NEED: make ${board}_defconfig telechips_mmc_boot.config"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_64bit.sh"
echo "====================================================="
__EOF
      cat << __EOF > ${pref}/sub/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
echo "====================================================="
echo "ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-"
echo "NEED: make ${board}_subcore_defconfig telechips_mmc_boot.config"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_64bit.sh"
echo "====================================================="
__EOF
      ;;
    tcn100x)
      cat << __EOF > ${pref}/main/kernel-${ver}/scripts/envsetup.sh
#!/bin/bash

export ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
echo "====================================================="
echo "ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-"
echo "NEED: make ${board}_defconfig"
echo "NEED: make -j$(nproc)"
echo "NEED: ./mklinuxmtdimg_64bit.sh"
echo "====================================================="
__EOF
      ;;
    *)
      echo "${board} is not supported!!"
      ;;
    esac
    if [ ${EUID} == 0 ]; then
      chmod +x ${pref}/main/kernel-${ver}/scripts/envsetup.sh
    fi
  done
}

setup_mkmmc() {
  local pref=$1
  local board=$2

  for ver in ${k_vers[@]}; do
    if [[ ${ver} != "5.10" && ${board} == "tcc897x" ]]; then
      continue
    fi
    echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${pref}/tools/mktcimg/gpt_partition.list" > ${pref}/mksh_emmc_${ver}.sh
    echo "sed -i -e 's,@@VERSION@@,${ver},g' ${pref}/tools/mktcimg/gpt_partition.list" >> ${pref}/mksh_emmc_${ver}.sh
    case ${board} in
    tcc897x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 7818182656 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${pref}/mksh_emmc_${ver}.sh
      ;;
    tcc803x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 7818182656 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${pref}/mksh_emmc_${ver}.sh
      ;;
    tcc805x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 7818182656 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${pref}/mksh_emmc_${ver}.sh
      ;;
    tcc807x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 31268536320 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${pref}/mksh_emmc_${ver}.sh
      ;;
    tcn100x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 31268536320 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${pref}/mksh_emmc_${ver}.sh
      ;;
    *)
      echo "${board} is not supported!!"
      ;;
    esac
    echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${pref}/tools/mktcimg/gpt_partition.list" >> ${pref}/mksh_emmc_${ver}.sh
    if [ ${EUID} == 0 ]; then
      chmod +x ${pref}/mksh_emmc_${ver}.sh
    fi
  done
}

setup_mkufs() {
  local pref=$1
  local board=$2

  for ver in ${k_vers[@]}; do
    echo "sed -i -e \'s,kernel-[0-9]\+\.[0-9]\+,kernel-@@KERNEL_VERSION@@,g\' ${pref}/tools/mktcimg/gpt_partition.list" > ${pref}/mksh_ufs_${ver}.sh
    echo "sed -i -e \'s,@@KERNEL_VERSION@@,${ver},g\' ${pref}/tools/mktcimg/gpt_partition.list" >> ${pref}/mksh_ufs_${ver}.sh
    case ${board} in
    tcc807x)
      echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size 63988301824 --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name "SD Data" --gptfile SD_Data.gpt --sector_size 4096" >> ${pref}/mksh_ufs_${ver}.sh
      ;;
    *)
      echo "${board} is not supported!!"
      ;;
    esac
    echo "sed -i -e \'s,kernel-[0-9]\+\.[0-9]\+,kernel-@@KERNEL_VERSION@@,g\' ${pref}/tools/mktcimg/gpt_partition.list" >> ${pref}/mksh_ufs_${ver}.sh
    if [ ${EUID} == 0 ]; then
      chmod +x ${pref}/mksh_ufs_${ver}.sh
    fi
  done
}

setup_scfw() {
  local pref=$1
  local board=$2

  git clone ssh://git@bitbucket.telechips.com:7999/firmware/scfw.git -b dev/${board} ${pref}/scfw
}

setup_tf-a() {
  local pref=$1
  local board=$2

  git clone ssh://git@bitbucket.telechips.com:7999/firmware/trusted-firmware-a.git -b ${board} ${pref}/tf-a
}
