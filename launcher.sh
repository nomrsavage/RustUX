#!/usr/bin/env bash

# This is the primary launcher file: meaning this is what you would execute to start the server.
# The primary goal of this project is to introduce a declarative system that leaves the important configurations
# hyper-accessible, while fully autonomously managing the server binaries. In fact, you can fully delete the
# ./wrapped folder without losing any data whatsoever.
# (this is not true as of now map saves are stored in the rust folder but in between wipes ig you could lol) symlinks?

# cd into operating directory to download binaries and stuffs
if [[ ! -d ./wrapped ]];
then
echo "Please start this script with the original file structure and in the same working directory as it i have no idea what im doing i know its janky just let it do its thing ig" # idk delete this prob (used to not make the directory bc idk how
mkdir wrapped
fi
cd ./wrapped

# if steamcmd doesnt exist, install and extract it
if [[ ! -d ./steamcmd ]];
then
mkdir steamcmd
curl -L "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ./steamcmd
fi

# install/update and verify rust server installation
if [[ ! -d ./rust ]]; # mkdir if doesnt exist, idk if steam automatically does that so just in case
then
mkdir rust
fi
# install/update (regardless of whether or not directory exists bc its checked before)
steam-run ./steamcmd/steamcmd.sh +force_install_dir ../rust +login anonymous +app_update 258550 validate +quit # should probably move to wrapper?? for server restart and auto update
# install to ../rust because i think steam-run auto moves to the directory of the thingy thing which is weird but ok


# cd back into launcher directory, everything from here forward assumes this
cd ../

# sync declarative config directory, extremely important probably ig
rsync --exclude serverauto.cfg --del -r ./cfg/ ./wrapped/rust/server/server1/cfg/

# uses nixpkgs idk i should probably make the launcher pure as well or just get rid of this altogether who cares
export NIXPKGS_ALLOW_UNFREE=1
nix-shell --pure ./dependencies.nix --run "./rustwrapper.sh"
exit $?
