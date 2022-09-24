#!/bin/bash

docker volume create --name opiran-service
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://$1
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v opiran-service:/etc/openvpn -d -p 443:1194/udp -p 443:1194/tcp --name opiran-ovpn --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full opiran nopass
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient opiran > ~/opiran-$1.ovpn
sed -i 's/1194/443/g' ~/opiran-$1.ovpn

ip route add 65.21.28.164/32 via $2
ip route add 193.141.126.143/32 via $2
ip route add 178.131.152.84/32 via $2

if [[ -n $4 ]]; then
    ip route add $4 via $2
fi

for range in $(cat /tmp/ir-ip-range.txt)
do
    ip route add $range via $2
done

sysctl -w net.ipv4.ip_forward=1

iptables -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

openvpn --config $3
