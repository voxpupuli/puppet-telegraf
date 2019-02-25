# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file { $telegraf::config_file:
    ensure  => file,
    content => template('telegraf/telegraf.conf.erb'),
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => $telegraf::config_file_mode,
  }
  file { $telegraf::config_folder:
    ensure  => directory,
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => $telegraf::config_folder_mode,
    purge   => $telegraf::purge_config_fragments,
    recurse => true,
  }

}
