node default{
  notify{"Provision a server": }
  file{"/etc/motd": ensure => present, content => "Vagrant / Puppet Provisioned Environment\n"}
}

# The Puppetmaster can manage itself...
node /^puppet/ {
  # Install the MCollective server

  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ 'puppet' ],
    client           => 'true'
  }

  mcollective::plugin { ['puppet', 'service']:
    package => true,
  }
}

node /^web/ {
  include nginx

  package{"git": ensure => installed,}

   vcsrepo{"/usr/share/nginx/html/puppet":
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/chad-thompson/learning-puppet-web.git',
    revision => 'master',
    require => Package['git'],
   }

  class { '::mcollective':
    middleware_hosts => [ 'puppet' ],
  }

  mcollective::plugin { ['puppet', 'service']:
    package => true,
  }

  # Install a basic
}

node /^haproxy/{

class { '::mcollective':
middleware_hosts => [ 'puppet' ],
}

mcollective::plugin { ['puppet', 'service']:
  package => true,
}


class { 'haproxy': }



  haproxy::listen { 'haproxy':
    collect_exported => false,
    ipaddress        => '0.0.0.0',
    ports            => '80',
    mode             => 'http',
    options          =>   {
      'option' => [
        'tcplog',
         'httplog'
      ]
    }
  }

  haproxy::balancermember { 'web01':
    listening_service => 'haproxy',
    server_names      => 'web01',
    ipaddresses       => '10.89.10.101',
    ports             => '80',
    options           => 'check',
  }

  haproxy::balancermember { 'web02':
    listening_service => 'haproxy',
    server_names      => 'web02',
    ipaddresses       => '10.89.10.102',
    ports             => '80',
    options           => 'check',
  }



}