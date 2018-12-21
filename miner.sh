#!/bin/bash

echo "BadGuy Mining Script!"
echo "By: https://github.com/BadGuy552"
if [ ! "$1" ]
then
read -p "Your Wallet: " wallet
else
wallet=$1
fi

echo "Installing dependences.."
sudo apt-get install screen build-essential automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++ zlib1g-dev -y 1>/dev/null 2>/dev/null || install=false
if [ "$install" = false ]
then
echo "Error to install dependences, Aborting..."
exit 1
fi
export MINERPATH=$HOME/miner
mkdir $MINERPATH 1>/dev/null 2>/dev/null
# CPUMINER: https://github.com/tpruvot/cpuminer-multi
echo "Downloading Miner... (tpruvot CPUMINER)"
git clone https://github.com/tpruvot/cpuminer-multi.git $MINERPATH > /dev/null

echo "Compiling Miner.... (maybe this take a long time)"

cd $MINERPATH && ./autogen.sh
cd $MINERPATH && ./configure --with-crypto --with-curl CFLAGS="-march=native" || configure=false
cd $MINERPATH && make || compile=false
if [ "$configure" = false ]
then
echo "Error to configure source to build, Aborting..."
exit 1
fi

if [ "$compile" = false ]
then
echo "Error to compile source, Aborting..."
exit 1
fi
clear

cd $MINERPATH && screen ./cpuminer -a cryptonight -o stratum+tcp://pool.supportxmr.com:3333 -u $wallet -p x --cpu-priority 5
