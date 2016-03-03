#!/bin/bash
sudo locale-gen UTF-8

sudo add-apt-repository ppa:vbernat/haproxy-1.6
sudo add-apt-repository ppa:george-edison55/cmake-3.x

sudo apt-get update

sudo apt-get install -y syslog-ng-core syslog-ng git haproxy cmake tcl8.5 redis-tools unzip

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

touch /etc/apt/sources.list.d/docker.list

sudo apt-get install -y build-essential apt-transport-https ca-certificates docker.io


# download and untar go

sudo wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz

sudo tar -zxf go1.4.2.linux-amd64.tar.gz -C ~/go --strip-components 1
mkdir work

#set path and root of go
echo 'export GOPATH=$HOME/work' >> ~/.bash_profile
echo 'export GOROOT=$HOME/go' >> ~/.bash_profile

echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.bash_profile

# Download, untar, and copy config file for prometheus

sudo wget https://github.com/prometheus/prometheus/releases/download/0.17.0rc2/prometheus-0.17.0rc2.linux-amd64.tar.gz
sudo mkdir /usr/prometheus && sudo tar -xzf prometheus-0.17.0rc2.linux-amd64.tar.gz -C /usr/prometheus --strip-components 1
sudo cp /vagrant_data/prometheus.yml /usr/prometheus/prometheus.yml

# Download and untar graphana
sudo wget https://grafanarel.s3.amazonaws.com/builds/grafana-2.5.0.linux-x64.tar.gz
sudo mkdir /usr/grafana && sudo tar -xzf grafana-2.5.0.linux-x64.tar.gz -C /usr/grafana/ --strip-components 1

# copy grafana config to the correct dir
sudo cp /vagrant_data/grafana_conf.ini /usr/grafana/conf/custom.ini

#create dir and copy json files to upload dashboards into grafana
sudo mkdir /usr/grafana/dashboard_json
sudo cp /vagrant_data/grafana_dashboards/* /usr/grafana/dashboard_json/

