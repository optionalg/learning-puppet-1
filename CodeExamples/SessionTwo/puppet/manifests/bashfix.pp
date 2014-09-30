
# SHELLSHOCK!!1!
case $operatingsystem {

  'CentOS':{
    package{'bash':
      ensure => '4.1.2-15.el6_5.2'
    }
  }

  'Ubuntu':{
      package{'bash':
        ensure => '4.3-7ubuntu1.4'
    }
  }
}
