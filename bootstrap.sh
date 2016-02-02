#!/bin/bash
sudo locale-gen UTF-8

sudo add-apt-repository ppa:vbernat/haproxy-1.6
sudo add-apt-repository ppa:george-edison55/cmake-3.x

sudo apt-get update

sudo apt-get install -y syslog-ng-core syslog-ng nodejs npm git haproxy

sudo apt-get install build-essential



sudo apt-get install cmake

sudo ln -s /usr/bin/nodejs /usr/bin/node


echo PATH $PATH
[ -f ~/.bash_profile ] || touch ~/.bash_profile

sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz

sudo mkdir /usr/go && sudo tar -zxf go1.4.2.linux-amd64.tar.gz -C /usr/go --strip-components 1

echo 'export PATH=/usr/go/bin:$PATH' >> ~/.bash_profile

wget https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-linux-amd64.tar.gz

sudo mkdir /usr/heka && sudo tar -xzf heka-0_10_0-linux-amd64.tar.gz -C /usr/heka/ --strip-components 1

echo 'export PATH=/usr/heka/bin:$PATH' >> ~/.bash_profile

sudo mkdir /usr/share/heka/

sudo mkdir /var/log/syslog-ng

#exit


echo PATH $PATH

sudo mkdir /usr/heka/log/

sudo cp /vagrant/heka-config.toml /etc/config.toml

sudo cp /vagrant/haproxy_decoder.lua /usr/heka/share/heka/lua_decoders/haproxy_decoder.lua

sudo mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.default

# sudo /etc/init.d/syslog-ng start

# sudo /usr/heka/bin/hekad -config='/etc/config.toml'

