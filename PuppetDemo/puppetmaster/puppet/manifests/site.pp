node default{
  notify{"Provision a server": }
  file{"/etc/motd": ensure => present, content => "Vagrant / Puppet Provisioned Environment\n"}
}

# The Puppetmaster can manage itself...
node /^puppetmaster/ {
  # Install the MCollective server

  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ 'puppetmaster.localdomain' ],
    client           => 'true'
  }

  mcollective::plugin { ['puppet', 'service']:
    package => true,
  }
}

node /^web/ {
  include nginx

  # Install MCO


  notify{"Provision a Web Server": }
  class { '::mcollective':
    middleware_hosts => [ 'puppetmaster.localdomain' ],
  }

  mcollective::plugin { ['puppet', 'service']:
    package => true,
  }



}

node /^haproxy/{

class { '::mcollective':
middleware_hosts => [ 'puppetmaster.localdomain' ],
}

mcollective::plugin { ['puppet', 'service']:
  package => true,
}


class { 'haproxy': }
  haproxy::listen { 'haproxy':
    collect_exported => false,
    ipaddress        => $::ipaddress,
    ports            => '80',
  }

  haproxy::balancermember { 'master00':
    listening_service => 'haproxy',
    server_names      => 'web01',
    ipaddresses       => '10.0.0.10',
    ports             => '80',
    options           => 'check',
  }

  haproxy::balancermember { 'master01':
    listening_service => 'haproxy',
    server_names      => 'web02',
    ipaddresses       => '10.0.0.11',
    ports             => '80',
    options           => 'check',
  }



}