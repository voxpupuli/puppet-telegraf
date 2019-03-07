# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file { $telegraf::config_file:
    ensure  => $telegraf::ensure ? {
        'absent' => absent,
        default  => file,
    },
    content => template('telegraf/telegraf.conf.erb'),
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => '0640',
  }
  file { $telegraf::config_folder:
    ensure  => $telegraf::ensure ? {
        'absent' => absent,
        default  => directory,
    },
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => '0770',
    purge   => $telegraf::purge_config_fragments,
    recurse => true,
  }

}
