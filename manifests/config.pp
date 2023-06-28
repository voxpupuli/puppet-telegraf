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
}
