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

if [[ -n "$GITHUB_TOKEN_PATH" && -f "$GITHUB_TOKEN_PATH" ]]; then
    export GITHUB_TOKEN=$(cat $GITHUB_TOKEN_PATH)
else 
    echo "Error: GITHUB_TOKEN_PATH is not set or the file does not exist." >&2
    exit 1
fi

mkdir -p bin
mkdir -p sh


echo "chisel"
eget jpillora/chisel -s linux/amd64 --download-only --upgrade-only --to ./bin
eget jpillora/chisel -s linux/386 --download-only  --upgrade-only --to ./bin


echo "nmap"
eget opsec-infosec/nmap-static-binaries -a nmap-x86_64 --download-only  --to ./bin


echo "pspy"
__get_github_release DominicBreuker/pspy "pspy" 
mv pspy* bin

echo "lineas"
eget  peass-ng/PEASS-ng -a linpeas.sh --download-only --upgrade-only --to ./sh
eget  peass-ng/PEASS-ng -s linux/amd64 --download-only  --upgrade-only --to ./bin
eget  peass-ng/PEASS-ng -s linux/386 --download-only --upgrade-only --to ./bin

echo 'Pretender'
eget RedTeamPentesting/pretender -a Linux_x86_64 --download-only --upgrade-only --to ./bin


echo "Start building static pythons (3.8.10) (impacket, responder)"
cp ./OffensivePythonPipeline/Makefile ./OffensivePythonPipeline/Makefile-tmp
sed -i "s/^PYTHON_BUILD_VERSION=.*/PYTHON_BUILD_VERSION=3.8.10/g" ./OffensivePythonPipeline/Makefile-tmp
sed -i "/^PROJECT_PATH_LINUX=/c\PROJECT_PATH_LINUX=$(pwd)/OffensivePythonPipeline" ./OffensivePythonPipeline/Makefile-tmp
cd OffensivePythonPipeline 
make --file Makefile-tmp linux_responder
make --file Makefile-tmp linux_impacket
cd ..
mv ./OffensivePythonPipeline/binaries_3.8.10/* bin
echo "End building static pythons (3.8.10) (impacket, responder)"



echo 'Ligolo-ng'
eget nicocha30/ligolo-ng -s linux/amd64   --upgrade-only --to ./bin

echo 'socat'
eget ernw/static-toolbox -a  socat-1.7.4.4-x86_64   --upgrade-only --to ./bin
mv  bin/static-toolbox bin/socat

echo 'nc'
wget -O bin/nc https://github.com/H74N/netcat-binaries/raw/refs/heads/master/nc
