node /^web/ {

  include diceweb

#  include apache
#
#  host{"mysite.com":
#    ip => "127.0.0.1",
#  }
#
#  file{"/opt/mysite":
#    ensure => directory,
#  }
#
#  file{"/opt/mysite/index.html":
#    ensure => file,
#    content => "THIS IS MY SITE",
#    require => File['/opt/mysite'],
#  }
#
#  apache::vhost{"mysite.com":
#      port => '80',
#      docroot => '/opt/mysite/',
#      require => File['/opt/mysite'],
#  }
}

node default {
  notify{"There is nothing defined for the default node.": }
}


