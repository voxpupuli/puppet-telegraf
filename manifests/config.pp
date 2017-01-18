# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file {
    $::telegraf::config_file:
      ensure  => file,
      content => template('telegraf/telegraf.conf.erb'),
      owner   => 'telegraf',
      group   => 'telegraf',
      mode    => '0640',
      notify  => Class['::telegraf::service'],
      require => Class['::telegraf::install'],
    ;
    $::telegraf::config_fragment_dir:
      ensure  => directory,
      owner   => 'telegraf',
      group   => 'telegraf',
      mode    => '0750',
      purge   => $::telegraf::purge_config_fragments,
      recurse => true,
      notify  => Class['::telegraf::service'],
      require => Class['::telegraf::install'],
    ;
  }

}
