# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file {
    default:
      owner   => 'telegraf',
      group   => 'telegraf',
      notify  => Class['::telegraf::service'],
      require => Class['::telegraf::install'],
    ;
    $::telegraf::config_file:
      ensure  => file,
      content => template('telegraf/telegraf.conf.erb'),
      mode    => '0640',
    ;
    $::telegraf::config_fragment_dir:
      ensure  => directory,
      mode    => '0750',
      purge   => $::telegraf::purge_config_fragments,
      recurse => true,
    ;
  }

}
