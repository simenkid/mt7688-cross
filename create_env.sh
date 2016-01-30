#!/bin/bash

echo "****************************************************************"
echo "* MT7688 Linkit Smart cross-environment for build node modules *"
echo "* Tested on:                                                   *"
echo "*     Host: Ubuntu 14.04LTS x64                                *"
echo "*     Target: MT7688 MIPS24KEc little endian, OpenWRT          *"
echo "*                                                              *"
echo "* Author: Simen Li (simenkid@gmail.com)                        *"
echo "* GitHub: https://github.com/simenkid/mt7688-cross             *"
echo "* License: MIT                                                 *"
echo "****************************************************************"

echo "Please make sure you have installed the following packages on you host: "
echo "  subversion, build-essential, gcc-multilib, g++-multilib"
echo " "
read -n1 -p "Are you sure to create the cross environment? [Y/n]" sure
echo " "

sure=${sure:-y}
if [ "${sure}" != "y" ]; then
    exit 0
fi

node_ver=`node -v`
npm_ver=`npm -v`

# Check version of node and npm
if [ ${node_ver} != 'v0.12.7' ]; then
    echo "Node version on host should be v0.12.7, yours is ${node_ver}."
    exit 0
else
    echo "node version: ${node_ver}, ok!"
fi

if [ ${npm_ver} != '2.11.3' ]; then
    echo "Npm version on host should be 2.11.3, yours is ${npm_ver}."
    exit 0
else
    echo "npm version: ${npm_ver}, ok!"
    # if [ ! -d $(pwd)/node_modules ] || [ ! -d $(pwd)/node_modules/node-gyp ]; then
    #     echo "Install node-gyp..."
    #     sudo npm install --prefix $(pwd) node-gyp
    # fi
fi

echo "Create target folder..."
if [ ! -d $(pwd)/linkit ]; then
    mkdir $(pwd)/linkit
    if [ ! -d $(pwd)/linkit/opt ]; then
        mkdir $(pwd)/linkit/opt
    fi
fi

echo "Get MT7688 OpenWrt SDK and decompress it into /mt7688sdk..."
if [ ! -f OpenWrt-SDK-ramips-mt7688_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2 ]; then
    wget http://download.labs.mediatek.com/MediaTek_LinkIt_Smart_7688_Openwrt_sdk_Linux -O OpenWrt-SDK-ramips-mt7688_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
fi

if [ ! -d mt7688sdk ]; then
    tar xjvf OpenWrt-SDK-ramips-mt7688_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
    mv OpenWrt-SDK-ramips-mt7688_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64/ mt7688sdk
fi

echo "Get node source and decompress it into /node-v0.12.7-mips..."
if [ ! -f node-v0.12.7.tar.gz ]; then
    wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
fi

if [ ! -d node-v0.12.7-mips ]; then
    tar xzvf node-v0.12.7.tar.gz
    mv node-v0.12.7/ node-v0.12.7-mips
fi

echo "Get depot tools for google chromium repository..."
if [ ! -d depot_tools ]; then
    if [ -f .gclient ]; then
        rm .gclient
    fi
    if [ -f .gclient_entries ]; then
        rm .gclient_entries
    fi
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

# source env.sh to export environment varaible for cross-toolchain
. $(pwd)/env.sh

echo "Get v8 source into /v8"
echo "Takes few minutes, please wait..."
echo " "
# Fetch and build V8
if [ ! -d v8 ]; then
    if [ -f .gclient ]; then
        rm .gclient
    fi
    if [ -f .gclient_entries ]; then
        rm .gclient_entries
    fi
    fetch v8
    cd v8
    git fetch origin
    # checkout to v8 version: 3.28.71 (patch 19)
    git checkout -b 3.28.71.19 4dbc223b1e4d
    git branch
    gclient sync
    cd ..
fi

echo "Build v8 for mips platform..."
echo "Takes around 10 minutes, please wait..."
echo " "

cd v8/
# make clean
# make distclean
# make dependencies

# make mipsel.release werror=no library=shared snapshot=off -j4
# cp ${BASEDIR}/v8/out/mipsel.release/lib.target/libicui18n.so ${LIBPATH}
# cp ${BASEDIR}/v8/out/mipsel.release/lib.target/libicuuc.so ${LIBPATH}
cd ..

# Build Node.js
echo "Build node.js for mips platform..."
echo "Takes few minutes, please wait..."
echo " "

cd node-v0.12.7-mips/
# make clean
# make distclean

# ./configure --prefix=${TARGET_PATH} --dest-cpu=mipsel --dest-os=linux --without-snapshot --shared-v8 --shared-v8-includes=${V8SOURCE}/include/ --shared-v8-libpath=${V8SOURCE}/out/mipsel.release/lib.target/
# make snapshot=off -j4
# make install

echo "*********************************************"
echo "* Cross-environment done!                   *"
echo "*                                           *"
echo "* Use ./npm_install.sh module_name          *"
echo "* Or  ./npm_install.sh module_name@version  *"
echo "* to compile the node module                *"
echo "*********************************************"
