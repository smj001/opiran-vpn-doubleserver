#!/bin/bash
docker volume create --name opiran-service
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u tcp://$1
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v opiran-service:/etc/openvpn -d -p 53:1194 --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full $2 nopass
docker run -v opiran-service:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient $2 > $2.ovpn
