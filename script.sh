#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

function __get_github_release(){
    repo=$1
    filter=$2
    basedir=${3:-.}
    mkdir -p $basedir
    files=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep -E "$filter")
#    echo $files
    for i in $files ; do
        wget --quiet  --no-check-certificate $i -O $basedir/$(basename $i)
    done
}
mkdir -p bin
mkdir -p sh


#echo "chisel"
##__get_github_release jpillora/chisel 'linux_(386|amd64)'
#eget jpillora/chisel -s linux/amd64 --download-only --upgrade-only --to ./bin
#eget jpillora/chisel -s linux/386 --download-only  --upgrade-only --to ./bin
#
#
##echo "nmap"
##__get_github_release opsec-infosec/nmap-static-binaries 'nmap-x86_64.tar.gz' 
#eget opsec-infosec/nmap-static-binaries -a nmap-x86_64 --download-only  --to ./bin
#
#
##echo "pspy"
#__get_github_release DominicBreuker/pspy "pspy" 
#mv pspy* bin
##eget  DominicBreuker/pspy  --download-only --upgrade-only --to ./bin
#
##echo "lineas"
##__get_github_release peass-ng/PEASS-ng "(linpeas_linux_amd64|linpeas_linux_386|linpeas.sh)"
#eget  peass-ng/PEASS-ng -a linpeas.sh --download-only --upgrade-only --to ./sh
#eget  peass-ng/PEASS-ng -s linux/amd64 --download-only  --upgrade-only --to ./bin
#eget  peass-ng/PEASS-ng -s linux/386 --download-only --upgrade-only --to ./bin

cp ./OffensivePythonPipeline/Makefile ./OffensivePythonPipeline/Makefile-tmp
sed -i "s/^PYTHON_BUILD_VERSION=.*/PYTHON_BUILD_VERSION=3.8.10/g" ./OffensivePythonPipeline/Makefile-tmp
sed -i "/^PROJECT_PATH_LINUX=/c\PROJECT_PATH_LINUX=$(pwd)/OffensivePythonPipeline" ./OffensivePythonPipeline/Makefile-tmp
#PROJECT_PATH_LINUX=/home/jubeaz/dev/OffensivePython
cd OffensivePythonPipeline 
make --file Makefile-tmp linux_responder
cd ..
mv ./OffensivePythonPipeline/binaries_3.8.10/* bin