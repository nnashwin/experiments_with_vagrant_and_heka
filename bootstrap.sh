#!/bin/bash
sudo locale-gen UTF-8

sudo add-apt-repository ppa:vbernat/haproxy-1.6
sudo add-apt-repository ppa:george-edison55/cmake-3.x

sudo apt-get update

sudo apt-get install -y syslog-ng-core syslog-ng nodejs npm git haproxy cmake tcl8.5 redis-tools

sudo apt-get install build-essential

sudo locale-gen UTF-8

sudo apt-get install cmake

sudo ln -s /usr/bin/nodejs /usr/bin/node


echo PATH $PATH
[ -f ~/.bash_profile ] || touch ~/.bash_profile

# download and untar go

sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz

sudo mkdir /usr/go && sudo tar -zxf go1.4.2.linux-amd64.tar.gz -C /usr/go --strip-components 1
sudo cp -R /usr/go /usr/local/go

echo 'export PATH=/usr/go/bin:$PATH' >> ~/.bash_profile

# download and untar heka

wget https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-linux-amd64.tar.gz
sudo mkdir /usr/heka/ && sudo tar -xzf heka-0_10_0-linux-amd64.tar.gz -C /usr/heka/ --strip-components 1

#download and untar redis

wget http://download.redis.io/releases/redis-3.0.7.tar.gz
sudo mkdir /usr/redis && sudo tar -xzf redis-3.0.7.tar.gz -C /usr/redis/ --strip-components 1
cd /usr/redis && sudo make

# Download and untar prometheus

wget https://github.com/prometheus/prometheus/releases/download/0.17.0rc2/prometheus-0.17.0rc2.linux-amd64.tar.gz
sudo mkdir /usr/prometheus && sudo tar -xzf prometheus-0.17.0rc2.linux-amd64.tar.gz -C /usr/prometheus --strip-components 1

echo 'export PATH=/usr/heka/bin:$PATH' >> ~/.bash_profile

sudo mkdir /usr/share/heka/
sudo mkdir /usr/share/heka/lua_decoders

sudo mkdir /var/log/syslog-ng

sudo mkdir /home/heka




# config heka

echo PATH $PATH

sudo mkdir /usr/heka/log/

sudo cp /vagrant/heka-config.toml /etc/hekad.toml

sudo cp /vagrant/haproxy_decoder.lua /usr/heka/share/heka/lua_decoders/haproxy_decoder.lua
sudo cp /vagrant/redis_decoder.lua /usr/heka/share/heka/lua_decoders/redis_decoder.lua

sudo cp /vagrant/haproxy_decoder.lua /usr/share/heka/lua_decoders/haproxy_decoder.lua
sudo cp /vagrant/redis_decoder.lua /usr/share/heka/lua_decoders/redis_decoder.lua


sudo chmod 755 /home
sudo chmod 777 /home/heka
sudo chmod 777 /home/heka

sudo mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.default
sudo mv /vagrant/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

# config systemd with two custom services: heka and syslog-ng
sudo cp /vagrant/syslog-ng.service /etc/systemd/system/syslog-ng.service
sudo cp /vagrant/heka.service /etc/systemd/system/heka.service

# download prometheus binaries
