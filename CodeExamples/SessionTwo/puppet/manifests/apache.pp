
# Define a local host for testing.
host{'mysite.com':
  ip => '127.0.0.1',
}

$mysite_doc_root = '/var/www/html/mysite.com'

# Define a variable with some content.
$http_conf = "<VirtualHost *:80>
  DocumentRoot ${mysite_doc_root}
  ServerName mysite.com
</VirtualHost>"



# PACKAGE - FILE - SERVICE
# Note:  Redhat Only
package{'httpd':
  ensure => present,
}

file{'/etc/httpd/conf.d/10-mysite.conf':
    ensure => file,
    content => $http_conf,
    notify  => Service['httpd'],
    require => Package['httpd'],
}

service{'httpd':
  ensure => running,
  require => Package['httpd'],
}


# Create some content for our site.
file{"/var/www/html/mysite.com":
  ensure => directory,
  require => Package['httpd'],
}

file{'/var/www/html/mysite.com/index.html':
  ensure => file,
  require => [Package['httpd'], File['/var/www/html/mysite.com']],
  content => '<html><body>*** THIS IS MYSITE ***</body></html>'
}

