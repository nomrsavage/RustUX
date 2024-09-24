#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p steam-run rcon rsync

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
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ./steamcmd
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

# uses nixpkgs idk i should probably make the launcher pure as well or just get rid of this altogether who cares (i actually did this!)
#export NIXPKGS_ALLOW_UNFREE=1
#nix-shell --pure ./dependencies.nix --run "./rustwrapper.sh"


# wrapper

echo "Launching Wrapper..."
#screen -S rust_server "steam-run ../rust/runds.sh"

cd ./wrapped/rust/
# print logs
tail -f ./rustserverlog.txt &
tail -f ./rustserverlog.txt | grep "Server startup complete" &
# start server

# whatever this means
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`dirname $0`/RustDedicated_Data/Plugins:`dirname $0`/RustDedicated_Data/Plugins/x86_64
#starting=true
steam-run ./RustDedicated +server.identity "server1" +server.port 28015 +server.level "Procedural Map" +rcon.web false +rcon.port 28016 +rcon.password RCur2vtPyRSTXh34Qksq4pLUns3CyJ9S2YlfXSiXFolWz8VM1j &
# theoretically -batchmode can be ommitted, (not a command or smth in logs??)

# rcon wrapped

#while $starting;
#do
#tail ./rustserverlog.txt | grep -q "Server startup complete"
#if [[ $? == 0 ]]; then
#starting=false
#fi
#done

while true;
do
read -p "> " input
rcon -H localhost -p 28016 -P RCur2vtPyRSTXh34Qksq4pLUns3CyJ9S2YlfXSiXFolWz8VM1j -n $input
done

exit
