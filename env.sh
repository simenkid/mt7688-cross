export PATH=`pwd`/depot_tools:"$PATH"
export BASEDIR=$(pwd)
export STAGING_DIR=${BASEDIR}/mt7688sdk/staging_dir
export PREFIX=${STAGING_DIR}/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mipsel-openwrt-linux-

# MIPS cross-compile exports
export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export AR=${PREFIX}ar
export RANLIB=${PREFIX}ranlib
export LINK=$CXX
export CPP="${PREFIX}gcc -E"
export STRIP=${PREFIX}strip
export OBJCOPY=${PREFIX}objcopy
#export LD=${PREFIX}g++

# extras for convenience.
export OBJD=${PREFIX}objdump
export GDB=${PREFIX}gdb
export RDE=${PREFIX}readelf

export NM=${PREFIX}nm
export AS=${PREFIX}as
export PS1="[${PREFIX}] \w$ "
export LIBPATH=${STAGING_DIR}/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/lib/
export LDFLAGS='-Wl,-rpath-link '${LIBPATH}
export GYPFLAGS="-Dv8_use_mips_abi_hardfloat=false -Dv8_can_use_fpu_instructions=false"

export V8SOURCE=${BASEDIR}/v8
export TARGET_PATH=${BASEDIR}/linkit/opt
