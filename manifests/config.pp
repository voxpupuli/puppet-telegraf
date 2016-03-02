# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config {

  assert_private()

  file { '/etc/telegraf/telegraf.conf':
    ensure  => file,
    content => template('telegraf/telegraf.conf.erb'),
    mode    => '0640',
    owner   => 'telegraf',
    group   => 'telegraf',
    require => Class['::telegraf::install'],
  }

}
