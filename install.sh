#!/bin/bash
read -p "Which one of installation do you want? (en/ir) " TYPE
echo "\n"

if [[ $TYPE == "en"  ]]
then
    read -p "Enter EU server adddress: " EU_ADDR
    echo "\n"
    ./eur/install.sh $EU_ADDR
elif [[ $TYPE == "ir" ]]
then
    cp ./ir/ir-ip-range.txt /tmp/ir-ip-range.txt
    read -p "Enter IR server address: " IR_ADDR
    echo "\n"
    read -p "Enter IR GW address: " IR_GW
    echo "\n"
    read -p "Enter Your IP: " YOUR_IP
    echo "\n"
    read -p "Enter EU ovpn file path on this server: " EU_FILE
    if [[ -z $EU_FILE ]]
    then
        echo "We need EU ovpn file, Please give correct path"
        exit
    fi
    ./ir/install.sh $IR_ADDR $IR_GW $EU_FILE $YOUR_IP
else
    echo "nothing to do..."
    exit
fi
