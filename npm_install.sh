# source the environment variables
. $(pwd)/env.sh

export npm_config_arch=mips
export npm_config_nodedir=${BASEDIR}/node-v0.12.7-mips
echo $npm_config_nodedir

if [ ! -d $(pwd)/node_modules_mips ]; then
    mkdir $(pwd)/node_modules_mips
fi

cd node_modules_mips/

version=`npm view "$1" version`
module_name=${1%%@*}
echo "> module name: ${module_name}"
echo "> version: ${version}"

npm install --prefix ${BASEDIR} --target_arch=mipsel "$1"

if [ $? -eq 1 ]; then
    echo " "
    echo "Building node module for MT7688(mipsel) failed!"
    echo " "
    exit 0
else
    echo " "
    echo "Archiving "$1"...."
    echo " "
 
    if [ -f ${BASEDIR}/node_modules_mips/"${module_name}"-"${version}"_mips.tar.gz ]; then
        rm ${BASEDIR}/node_modules_mips/"${module_name}"-"${version}"_mips.tar.gz
    fi

    cd ${BASEDIR}/node_modules
    tar -cvf "${module_name}"-"${version}"_mips.tar.gz "${module_name}"/ > /dev/null

    mv "${module_name}"-"${version}"_mips.tar.gz ${BASEDIR}/node_modules_mips
    rm -rf *

    echo " "
    echo "Building node module for MT7688(mipsel) finished!"
    echo " "
fi