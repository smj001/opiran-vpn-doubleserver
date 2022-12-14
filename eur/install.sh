#!/bin/bash
docker volume create --name opiran-service
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://$1
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v opiran-service:/etc/openvpn -d -p 443:1194/udp -p 443:1194/tcp --name opiran-ovpn --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full opiran nopass
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient opiran > ~/opiran-$1.ovpn
sed -i 's/1194/443/g' ~/opiran-$1.ovpn
