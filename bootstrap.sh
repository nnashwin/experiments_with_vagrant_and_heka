#!/bin/bash
sudo locale-gen UTF-8

sudo add-apt-repository ppa:vbernat/haproxy-1.6
sudo add-apt-repository ppa:george-edison55/cmake-3.x

sudo apt-get update

sudo apt-get install -y syslog-ng-core syslog-ng nodejs npm git haproxy cmake tcl8.5 redis-tools unzip

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

touch /etc/apt/sources.list.d/docker.list

sudo apt-get install -y build-essential apt-transport-https ca-certificates docker.io

sudo ln -s /usr/bin/nodejs /usr/bin/node

echo PATH $PATH
[ -f ~/.bash_profile ] || touch ~/.bash_profile

# download and untar go

sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz

sudo tar -zxf go1.4.2.linux-amd64.tar.gz -C ~/go --strip-components 1
mkdir work

#set path and root of go
echo 'export GOPATH=$HOME/work' >> ~/.bash_profile
echo 'export GOROOT=$HOME/go' >> ~/.bash_profile

echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.bash_profile

# download and untar heka

sudo wget https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-linux-amd64.tar.gz
sudo mkdir /usr/heka/ && sudo tar -xzf heka-0_10_0-linux-amd64.tar.gz -C /usr/heka/ --strip-components 1

#Download and untar redis

sudo wget http://download.redis.io/releases/redis-3.0.7.tar.gz
sudo mkdir /usr/redis && sudo tar -xzf redis-3.0.7.tar.gz -C /usr/redis/ --strip-components 1
cd /usr/redis && sudo make

# Download, untar, and copy config file for prometheus

sudo wget https://github.com/prometheus/prometheus/releases/download/0.17.0rc2/prometheus-0.17.0rc2.linux-amd64.tar.gz
sudo mkdir /usr/prometheus && sudo tar -xzf prometheus-0.17.0rc2.linux-amd64.tar.gz -C /usr/prometheus --strip-components 1
sudo cp /vagrant_data/prometheus.yml /usr/prometheus/prometheus.yml

# Download and untar consul, copying it into /usr/local/bin
sudo wget https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip
sudo unzip consul_0.6.3_linux_amd64.zip
sudo mv consul /usr/local/bin/

# Download and untar graphana
sudo wget https://grafanarel.s3.amazonaws.com/builds/grafana-2.5.0.linux-x64.tar.gz
sudo mkdir /usr/grafana && sudo tar -xzf grafana-2.5.0.linux-x64.tar.gz -C /usr/grafana/ --strip-components 1

# copy grafana config to the correct dir
sudo cp /vagrant_data/grafana_conf.ini /usr/grafana/conf/custom.ini

#create dir and copy json files to upload dashboards into grafana
sudo mkdir /usr/grafana/dashboard_json
sudo cp /vagrant_data/grafana_dashboards/* /usr/grafana/dashboard_json/

# clone exporter repo into the file system

# echo 'export PATH=/usr/heka/bin:$PATH' >> ~/.bash_profile

# sudo mkdir /usr/share/heka/
# sudo mkdir /usr/share/heka/lua_decoders
# sudo mkdir /usr/share/heka/lua_filters
# sudo mkdir /usr/share/heka/lua_modules

# sudo mkdir /var/log/syslog-ng

# sudo mkdir /home/heka

# # config heka

# echo PATH $PATH

# sudo mkdir /usr/heka/log/


# sudo cp /vagrant_data/heka-config.toml /etc/hekad.toml

# sudo cp /vagrant/haproxy_decoder.lua /usr/share/heka/lua_decoders/haproxy_decoder.lua
# sudo cp /vagrant/redis_decoder.lua /usr/share/heka/lua_decoders/redis_decoder.lua
# sudo cp /vagrant/rethinkdb_decoder.lua /usr/share/heka/lua_decoders/rethinkdb_decoder.lua

# sudo cp /usr/heka/share/heka/lua_decoders/* /usr/share/heka/lua_decoders/
# sudo cp /usr/heka/share/heka/lua_filters/* /usr/share/heka/lua_filters/
# sudo cp /usr/heka/share/heka/lua_modules/* /usr/share/heka/lua_modules/

# config heka dashboard to send to prometheus
# sudo mkdir /usr/share/heka/dasher


sudo chmod 755 /home
sudo chmod 777 /home/heka
sudo chmod 777 /home/heka

# copy syslog-ng conf to the appropriate directory

sudo mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.default
sudo cp /vagrant_data/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

# config systemd custom logging services
sudo systemctl enable /vagrant_data/syslog-ng.service
sudo systemctl enable /vagrant_data/heka.service
sudo systemctl enable /vagrant_data/node-exporter.service
sudo systemctl enable /vagrant_data/grafana.service
sudo systemctl enable /vagrant_data/prometheus.service


#start systemctl services
sudo systemctl start syslog-ng.service
#sudo systemctl start heka.service
sudo systemctl start prometheus.service
sudo systemctl start node-exporter.service
sudo systemctl start grafana.service
