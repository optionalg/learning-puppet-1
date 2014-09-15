#!/bin/sh

apt-get update

if [ ! -f /usr/bin/puppet ]; then
    echo "Install Puppet Agent"
    wget -P /tmp https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
    dpkg -i /tmp/puppetlabs-release-trusty.deb
    apt-get update
    sudo apt-get install -y puppet
else
    echo "Already there"
fi


