# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {
  assert_private()

  $agent = {
    'hostname'                      => $telegraf::hostname,
    'omit_hostname'                 => $telegraf::omit_hostname,
    'interval'                      => $telegraf::interval,
    'round_interval'                => $telegraf::round_interval,
    'metric_batch_size'             => $telegraf::metric_batch_size,
    'metric_buffer_limit'           => $telegraf::metric_buffer_limit,
    'collection_jitter'             => $telegraf::collection_jitter,
    'flush_interval'                => $telegraf::flush_interval,
    'flush_jitter'                  => $telegraf::flush_jitter,
    'precision'                     => $telegraf::precision,
    'logfile'                       => $telegraf::logfile,
    'logfile_rotation_interval'     => $telegraf::logfile_rotation_interval,
    'logfile_rotation_max_size'     => $telegraf::logfile_rotation_max_size,
    'logfile_rotation_max_archives' => $telegraf::logfile_rotation_max_archives,
    'debug'                         => $telegraf::debug,
    'quiet'                         => $telegraf::quiet,
  }
  $config = stdlib::to_toml({ 'global_tags' => $telegraf::global_tags, 'agent' => $agent, 'outputs' => $telegraf::outputs, 'inputs' => $telegraf::inputs })
  file { $telegraf::config_file:
    ensure  => $telegraf::ensure_file,
    content => $config,
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => $telegraf::config_file_mode,
  }

  $_dir = $telegraf::ensure ? {
    'absent' => { ensure => 'absent', force => true },
    default  => { ensure => 'directory' }
  }

  file { $telegraf::config_folder:
    owner   => $telegraf::config_file_owner,
    group   => $telegraf::config_file_group,
    mode    => $telegraf::config_folder_mode,
    purge   => $telegraf::purge_config_fragments,
    recurse => true,
    *       => $_dir,
  }

  if $telegraf::logfile {
    $log_directory_name = dirname($telegraf::logfile)
  }

  file { $log_directory_name:
    owner => $telegraf::config_file_owner,
    group => $telegraf::config_file_group,
    mode  => $telegraf::config_folder_mode,
    *     => $_dir,
  }

  if $facts['os']['family'] == 'Darwin' {
    file { '/Library/LaunchDaemons/telegraf.plist':
      ensure  => $telegraf::ensure_file,
      content => epp('telegraf/telegraf.plist.epp', {
        'config_file_owner'  => $telegraf::config_file_owner,
        'config_file_group'  => $telegraf::config_file_group,
        'config_file'        => $telegraf::config_file,
        'config_folder'      => $telegraf::config_folder,
        'logfile'            => $telegraf::logfile,
        'log_directory_name' => $log_directory_name,
        'daemon_user'        => $telegraf::daemon_user
      }),
    }
  }
}
