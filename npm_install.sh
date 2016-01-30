. $(pwd)/env.sh

export npm_config_arch=mips
export npm_config_nodedir=${BASEDIR}/node-v0.12.7-mips
echo $npm_config_nodedir

if [ ! -d $(pwd)/node_modules_mips ]; then
    mkdir $(pwd)/node_modules_mips
fi

cd node_modules_mips/

version=`npm view "$1" version`

npm install --prefix ${BASEDIR} --target_arch=mipsel "$1"

if [ $? -eq 1 ]
then
    echo " "
    echo "Building node module for MT7688(mipsel) failed!"
    echo " "
    exit 0
else
    echo " "
    echo "Archiving "$1"...."
    echo " "
 
    if [ -f ${BASEDIR}/node_modules_mips/"$1"-"$version"_mips.tar.gz ]; then
        rm ${BASEDIR}/node_modules_mips/"$1"-"$version"_mips.tar.gz
    fi

    cd ${BASEDIR}/node_modules
    tar -cvf "$1"-"$version"_mips.tar.gz "$1"/ > /dev/null
    mv "$1"-"$version"_mips.tar.gz ${BASEDIR}/node_modules_mips
    rm -rf *
    echo " "
    echo "Building node module for MT7688(mipsel) finished!"
    echo " "
fi