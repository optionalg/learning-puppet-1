#!/bin/sh

# This is a bootstrap script for the puppetmaster

# Ubuntu Machine With Puppet Installed.  Configure the Puppetmaster.

# Check to see if a puppetmaster exists



#  Install Git

# Check for git
if hash git >/dev/null; then
    echo "*** git Installed"
else
    echo "*** Install git ***"
    yum install -y git
fi

# Check For Puppet.
if hash puppet >/dev/null; then
    echo "*** Puppet Installed"
else
    echo "*** Install Puppet ***"
    apt-getinstall puppet
    # Install modules
    puppet module install puppetlabs-apache
    puppet module install puppetlabs-vcsrepo
    puppet module install puppetlabs-passenger
    puppet module install jdowning-rbenv
    puppet module install puppetlabs-puppetdb
    puppet module install puppetlabs-mcollective
    puppet module install jamtur01-hipchat
fi

## Replace existing puppet.conf file.
if [ -f /etc/puppet/puppet.conf ]; then
   rm -r /etc/puppet/puppet.conf
   wget -P /etc/puppet/ "$conf_base_url/puppet.conf"
fi

if [ ! -f /etc/puppet/autosign.conf ]; then
    echo "*" >> /etc/puppet/autosign.conf
fi


# Check for puppetmaster startup if needed - a starup will generate SSL keys.
if [ ! -f /etc/init.d/puppetmaster ]; then
  yum -y install puppet-server
  # Start and stop the puppetmaster to generate SSL keys
  service puppetmaster start;
fi

if [ ! -d /root/.ssh/ ]; then
   mkdir -p /root/.ssh/
   echo "StrictHostKeyChecking no" >> /root/.ssh/config
fi

#  Put SSH keys into place to check out Git repo.  (Needs a public location.)
if [ ! -f /root/.ssh/id_rsa ]; then
   wget -P /root/.ssh/ "$key_base_url/id_rsa"
   chmod 400 /root/.ssh/id_rsa
fi

if [ ! -f /root/.ssh/id_rsa.pub ]; then
   wget -P /root/.ssh/ "$key_base_url/id_rsa.pub"
   chmod 400 /root/.ssh/id_rsa.pub
fi

# Check for librarian-puppet install

if hash librarian-puppet >/dev/null; then
    echo "*** librarian-puppet Installed"
else
    echo "*** Install librarian-puppet ***"
    gem install librarian-puppet -v 0.9.17
fi

# Check for rbenv / ruby for puppetmaster
if hash rbenv > /dev/null; then
    echo "rbenv installed"
else
    echo "*** Installing RBENV ***"
    # Install rbenv
    yum install -y gcc gcc-c++ glibc-headers readline readline-devel zlib ruby-devel libffi-devel openssl-devel
    if [ ! -d /opt/rbenv ]; then
        mkdir -p /opt/rbenv
        git clone https://github.com/sstephenson/rbenv.git /opt/rbenv
        git clone https://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build
    fi
    #echo 'export RBENV_ROOT=/opt/rbenv; eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
    #source /etc/profile.d/rbenv.sh
    #/opt/rbenv/bin/rbenv install 2.1.2
fi
