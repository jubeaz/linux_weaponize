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


# https://insinuator.net/2018/02/creating-static-binaries-for-nmap-socat-and-other-tools/


## nmap
#echo "nmap"
# https://github.com/opsec-infosec/nmap-static-binaries/tree/master

## nc
#echo "nc"
#wget --quiet https://github.com/int0x33/nc.exe/raw/master/nc64.exe -P nc -O bin/nc64.exe
#wget --quiet https://github.com/int0x33/nc.exe/raw/master/nc.exe -P nc -O bin/nc.exe 
#

# chisel
echo "chisel"
__get_github_release jpillora/chisel 'linux_(386|amd64)'
mv chisel* bin

echo "nmap"
__get_github_release opsec-infosec/nmap-static-binaries 'nmap-x86_64.tar.gz' 
mv nmap* bin

echo "pspy"
__get_github_release DominicBreuker/pspy "pspy" 
mv pspy* bin

echo "lineas"
__get_github_release peass-ng/PEASS-ng "(linpeas_linux_amd64|linpeas_linux_386|linpeas.sh)"
mv linpeas* bin