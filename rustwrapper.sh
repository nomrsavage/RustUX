#!/usr/bin/env bash
echo "Launching Wrapper..."
#screen -S rust_server "steam-run ../rust/runds.sh"

cd ./wrapped/rust/
# print logs
tail -f ./rustserverlog.txt &
tail -f ./rustserverlog.txt | grep "Server startup complete" &
# start server
#steam-run ./runds.sh

# whatever this means
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`dirname $0`/RustDedicated_Data/Plugins:`dirname $0`/RustDedicated_Data/Plugins/x86_64
#starting=true
steam-run ./RustDedicated +server.identity "server1" +rcon.web false +rcon.port 28016 +rcon.password RCur2vtPyRSTXh34Qksq4pLUns3CyJ9S2YlfXSiXFolWz8VM1j &
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
