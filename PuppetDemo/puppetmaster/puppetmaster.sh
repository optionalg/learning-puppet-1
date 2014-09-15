#!/bin/bash

# Set hostname if not already
echo '127.0.0.1 puppet' >> /etc/hosts
echo 'puppet' > /etc/hostname
hostname `cat /etc/hostname`

apt-get update

if [ ! -f /etc/init.d/puppetmaster ]; then
    echo "Install a puppetmaster"
    wget -P /tmp https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
    dpkg -i /tmp/puppetlabs-release-trusty.deb
    apt-get update
    sudo apt-get install -y puppetmaster
else
    echo "Already there"
fi

if [ ! -L /etc/puppet ]; then
  service puppetmaster stop
  rm -rf /etc/puppet && ln -s /vagrant/puppetmaster/puppet /etc/puppet
  service puppetmaster start
fi
