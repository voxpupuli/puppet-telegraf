# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  $purge = $::telegraf::params::purge

  validate_bool($purge)

  assert_private()

  file { $::telegraf::config_file:
    ensure  => file,
    content => template('telegraf/telegraf.conf.erb'),
    mode    => '0640',
    owner   => 'telegraf',
    group   => 'telegraf',
    notify  => Class['::telegraf::service'],
    require => Class['::telegraf::install'],
  }

  if $purge {
    tidy {
      'purge_inputs':
        path    => '/etc/telegraf/telegraf.d/',
        matches => [ '*.conf' ],
        recurse => 1,
        rmdirs  => false,
    }
  }
}
