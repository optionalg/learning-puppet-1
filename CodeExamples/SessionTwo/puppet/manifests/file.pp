file{"/root/puppet-output.txt":
  ensure  => present,
  content => "This Machine Provisioned By Puppet - modified.",
  owner => 'root',
  group => 'root'
}