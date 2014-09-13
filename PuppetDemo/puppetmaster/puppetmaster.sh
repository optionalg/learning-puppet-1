#!/bin/bash

apt-get update

if [ ! -f /etc/init.d/puppetmaster ]; then
    echo "Install a puppetmaster"
    sudo apt-get install -y puppetmaster;
else
    echo "Already there"
fi

if [ ! -L /etc/puppet ]; then
  rm -rf /etc/puppet && ln -s /vagrant/puppetmaster/puppet /etc/puppet
  service puppetmaster restart
fi
