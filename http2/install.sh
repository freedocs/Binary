#!/bin/bash

echo "Install nghttpx..."

cd 
mkdir tmp
cd tmp
wget https://github.com/freedocs/binary/raw/master/http2/nghttp2_1.0.5-DEV-1_amd64.deb
wget https://github.com/freedocs/binary/raw/master/http2/spdylay_1.3.3-DEV-1_amd64.deb

dpkg -i nghttp2_1.0.5-DEV-1_amd64.deb
dpkg -i spdylay_1.3.3-DEV-1_amd64.deb

rm *.deb

wget https://github.com/freedocs/binary/raw/master/http2/nghttpx-init -O /etc/init.d/nghttpx
chmod +x /etc/init.d/nghttpx
mkdir /var/log/nghttpx/
mkdir /etc/nghttpx
wget https://github.com/freedocs/binary/raw/master/http2/nghttpx.conf.sample -O /etc/nghttpx/nghttpx.conf

read -p "Input domain name: " DOMAIN

sed -i "s/www.example.com/$DOMAIN/g" /etc/nghttpx/nghttpx.conf

echo "Install squid3..."

apt-get update
apt-get install squid3 apache2-utils libev4 libjemalloc1 -y
cd /etc/squid3/
mv squid.conf squid.conf.ori
wget https://github.com/freedocs/binary/raw/master/http2/squid.conf.sample -O squid.conf

read -p "Input http username: " USERNAME

htpasswd -c /etc/squid3/password $USERNAME

echo "start services..."

service squid3 restart
service nghttpx start

update-rc.d nghttpx defaults

echo "done."

