# == Class: telegraf::config
#
# Handles applying templated telegraf configuration
#
class telegraf::config {

  assert_private()

  file { '/etc/telegraf/telegraf.conf':
    ensure  => file,
    content => template('telegraf/telegraf.conf.erb'),
    mode    => '0640',
    owner   => 'root',
    group   => 'telegraf',
    require => Package['telegraf'],
  }

}
