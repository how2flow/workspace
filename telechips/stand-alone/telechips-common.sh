#!/bin/bash

# written by steve.jeong <steve.jeong@telechips.com>

. telechips-params.sh

shopt -s extglob

# Variable references using the '-n'
# option are only available in bash 4.3 and later.
check_version() {
  if (( BASH_VERSINFO[0] < 4 )) || \
    { (( BASH_VERSINFO[0] == 4 )) && (( BASH_VERSINFO[1] < 3 )); }; then
    echo "Error: Bash version 4.3 or higher is required. Current version: ${BASH_VERSION}" >&2
    exit 1
  fi
}

make_mksh_mmc() {
  local path=$1
  local target=$2
  local size=$3

  echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${path}/tools/mktcimg/gpt_partition.list" > ${path}/${target}
  echo "sed -i -e 's,@@VERSION@@,${ver},g' ${path}/tools/mktcimg/gpt_partition.list" >> ${path}/${target}
  echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size ${size} --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt" >> ${path}/${target}
  echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${path}/tools/mktcimg/gpt_partition.list" >> ${path}/${target}
}

make_mksh_ufs() {
  local path=$1
  local target=$2
  local size=$3
  local sector_size=$4

  echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${path}/tools/mktcimg/gpt_partition.list" > ${path}/${target}
  echo "sed -i -e 's,@@VERSION@@,${ver},g' ${path}/tools/mktcimg/gpt_partition.list" >> ${path}/${target}
  echo "./tools/mktcimg/mktcimg --parttype gpt --storage_size ${size} --fplist tools/mktcimg/gpt_partition.list --outfile SD_Data.fai --area_name 'SD Data' --gptfile SD_Data.gpt --sector_size ${sector_size}" >> ${path}/${target}
  echo "sed -i -e 's,kernel-[0-9]\+\.[0-9]\+,kernel-@@VERSION@@,g' ${path}/tools/mktcimg/gpt_partition.list" >> ${path}/${target}
}

parse_board() {
  local path=$1
  local segment=""
  local ret=""

  for segment in $(echo ${path} | tr '/' ' '); do
    if [[ ${segment} =~ ^tc.*x$ ]]; then
    ret=${segment}
    break
    fi
  done

  echo ${ret}
}

parse_subcore() {
  local path=$1
  local segment=""
  local ret=""

  for segment in $(echo ${path} | tr '/' ' '); do
    if [[ ${segment} =~ ^sub$ ]]; then
    ret=${segment}
    break
    fi
  done

  echo ${ret}
}

post_process() {
  local board=$1
  local -n kernels=$2

  case ${board} in
  tcc803x)
    rm -rf ${top}/${board}/sub/u-boot
    ;;
  *)
    ;;
  esac
}

pre_process() {
  local board=$1
  local -n kernels=$2

  case ${board} in
  tcc897x)
    for idx in ${!kernels[@]}; do
      major=$(return_major ${kernels[${idx}]})
      if [ ${major} -ge 6 ]; then
        unset 'kernels[idx]'
      fi
    done
    k_vers=(${kernels[@]})
    ;;
  tca200x)
    for idx in ${!kernels[@]}; do
      major=$(return_major ${kernels[${idx}]})
      if [ ${major} -le 5 ]; then
        unset 'kernels[idx]'
      fi
    done
    k_vers=(${kernels[@]})
    ;;
  *)
    ;;
  esac
}

return_major() {
  local major=$(echo ${1} | cut -d. -f1)

  echo ${major}
}

set_prefix() {
  local prefix=${top}
  local board=$1

  case ${board} in
    tcc803x|tcc805x|tcc807x)
      prefix=("${top}/${board}/main" "${top}/${board}/sub")
    ;;
    *)
      prefix="${top}/${board}"
    ;;
  esac

  echo ${prefix[@]}
}

setup_fwdn() {
  local git_fwdn="ssh://git@bitbucket.telechips.com:7999/tool/fwdn-v8"

  if [ ! -d ${top}/fwdn-v8 ]; then
    git clone ${git_fwdn}.git -b dev ${top}/fwdn-v8
  fi
}

setup_bootfirmware() {
  local board=$1
  local -n kernels=$2
  local git_bfw="ssh://git@bitbucket.telechips.com:7999/firmware/boot-firmware"

  git clone ${git_bfw}.git -b ${board} ${top}/${board}/boot-firmware
  . gpt/updategpt-${board}.sh
  for ver in ${kernels[@]}; do
    setup_mkmmc ${top}/${board}/boot-firmware ${ver}
    setup_mkufs ${top}/${board}/boot-firmware ${ver}
  done
}

setup_envscript() {
  local path=$1
  # for envscript
  local arch=""
  local add_config=""
  local board=""
  local cc=""
  local mklinux=""

  board=$(parse_board ${path})
  subcore=$(parse_subcore ${path})

  case ${board} in
    tcc897x)
      arch=arm
      cc=arm-none-linux-gnueabihf-
      mklinux=mklinuxmtdimg_32bit.sh
      ;;
    tcc803x)
      if [ "${subcore}" == "sub" ]; then
        arch=arm
        cc=arm-none-linux-gnueabihf-
      else
        arch=arm64
        cc=aarch64-none-linux-gnu-
        mklinux=mklinuxmtdimg_64bit.sh
      fi
      ;;
    tcc750x|tcc805x|tcc807x)
      arch=arm64
      cc=aarch64-none-linux-gnu-
      mklinux=mklinuxmtdimg_64bit.sh
      ;;
    *)
      arch=arm64
      cc=aarch64-none-linux-gnu-
      mklinux=mklinuxmtdimg_64bit.sh
      ;;
  esac

  case ${board} in
    tcc805x|tcc807x)
      add_config=telechips_mmc_boot.config
      ;;
    tca200x)
      add_config=telechips_ufs_boot.config
      ;;
  esac

  cat << __EOF > ${path}/scripts/envsetup.sh
#!/bin/bash

export ARCH=${arch} CROSS_COMPILE=${cc}
echo "====================================================="
echo "NEED: make ${board}_${subcore/sub/subcore_}defconfig" ${add_config}
echo "NEED: make -j$(nproc)"
echo "NEED: ./${mklinux}"
echo "====================================================="
__EOF
}

setup_bl3n() {
  local -n pref=$1
  local -n kernels=$2
  local git_uboot="ssh://git@bitbucket.telechips.com:7999/bootloader/u-boot-core"
  local git_kernel="ssh://git@bitbucket.telechips.com:7999/linux/kernel"

  for path in ${pref[@]}; do
    for ver in ${kernels[@]}; do
      if [ ! -d ${path}/u-boot ]; then
        git clone ${git_uboot}.git -b dev ${path}/u-boot
      fi
      if [ ! -d ${path}/kernel-${ver} ]; then
        git clone ${git_kernel}-${ver}-core.git -b dev ${path}/kernel-${ver}
      fi
      if [ -f ${HOME}/initramfs64.cpio.lzo ]; then
        ln -s ${HOME}/initramfs64.cpio.lzo ${path}/kernel-${ver}/
      else
        echo "Install initramfs64.cpio.lzo to ${HOME} in global telechips Wiki"
      fi
      if [ -f ${HOME}/initramfs32.cpio.lzo ]; then
        ln -s ${HOME}/initramfs32.cpio.lzo ${path}/kernel-${ver}/
      else
        echo "Install initramfs32.cpio.lzo to ${HOME} in global telechips Wiki"
      fi
      setup_envscript ${path}/kernel-${ver}
    done
  done
}

setup_prev_bl3n() {
  local board=$1
  local git_fw="ssh://git@bitbucket.telechips.com:7999/firmware"

  if [ ${board} != "tcc897x" ]; then
    git clone ${git_fw}/trusted-firmware-a.git -b ${board} ${top}/${board}/tf-a
  fi

  case ${board} in
  tcc805x)
    git clone ${git_fw}/scfw.git -b ${board} ${top}/${board}/scfw
    ;;
  tcc807x)
    git clone ${git_fw}/scfw.git -b dev/${board} ${top}/${board}/scfw
    ;;
  tcn100x)
    git clone ${git_fw}/sram-boot.git -b BL1-TCN100X ${top}/${board}/sram-boot
    ;;
  tca200x)
    git clone ${git_fw}/sram-boot.git -b BL1-TCA200X ${top}/${board}/sram-boot
    ;;
  *)
    echo "Error: ${board} is not supported!!"
    ;;
  esac
}

setup_mkmmc() {
  local board=""
  local path=$1
  local ver=$2

  board=$(parse_board ${path})

  case ${board} in
    tcc897x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 7818182656
      ;;
    tcc803x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 6744440832
      ;;
    tcc805x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 7818182656
      ;;
    tcc807x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 31268536320
      ;;
    tcc750x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 31268536320
      ;;
    tcn100x)
      make_mksh_mmc ${path} mksh_emmc_${ver}.sh 31268536320
      ;;
    *)
      echo "mmc: ${board} is not supported!!"
      ;;
  esac

  if [ ${EUID} == 0 ]; then
    chmod +x ${path}/mksh_emmc_${ver}.sh
  fi
}

setup_mkufs() {
  local board=""
  local path=$1
  local ver=$2

  board=$(parse_board ${path})

  case ${board} in
    tcc807x)
      make_mksh_ufs ${path} mksh_ufs_${ver}.sh 63988301824 4096
      ;;
    tca200x)
      make_mksh_ufs ${path} mksh_ufs_${ver}.sh 7818182656 4096
      ;;
    *)
      echo "ufs: ${board} is not supported!!"
      ;;
  esac

  if [ ${EUID} == 0 ]; then
    chmod +x ${pref}/mksh_ufs_${ver}.sh
  fi
}
