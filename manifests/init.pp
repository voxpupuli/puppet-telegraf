# == Class: telegraf
#
# A Puppet module for installing InfluxData's Telegraf
#
# === Parameters
#
# [*ensure*]
#   String. State of the telegraf package. You can also specify a
#   particular version to install.
#
# [*config_file*]
#   String. Path to the configuration file.
#
# [*hostname*]
#   String. Override default hostname used to identify this agent.
#
# [*interval*]
#   String. Default data collection interval for all inputs.
#
# [*round_interval*]
#   Boolean. Rounds collection interval to 'interval'
#
# [*metric_buffer_limit*]
#   Integer. Cache metric_buffer_limit metrics for each output, and flush this
#   buffer on a successful write.
#
# [*flush_buffer_when_full*]
#   Boolean. Flush buffer whenever full, regardless of flush_interval
#
# [*collection_jitter*]
#   String.  Sleep for a random time within jitter before collecting.
#
# [*flush_interval*]
#   String. Default flushing interval for all outputs.
#
# [*flush_jitter*]
#   String.  Jitter the flush interval by an amount.
#
# [*debug*]
#   Boolean. Run telegraf in debug mode.
#
# [*quiet*]
#   Boolean.  Run telegraf in quiet mode.
#
# [*outputs*]
#   Hash. Specify output plugins and their options.
#
# [*inputs*]
#   Hash.  Specify input plugins and their options.
#
# [*global_tags*]
#   Array.  Global tags as a key-value pair.
#
# [*service_enabled*]
#   Boolean.  Whether to manage the telegraf service or not.
#
class telegraf (
  $ensure                 = 'present',
  $config_file            = '/etc/telegraf/telegraf.conf',
  $hostname               = $::hostname,
  $interval               = '10s',
  $round_interval         = true,
  $metric_buffer_limit    = '1000',
  $flush_buffer_when_full = true,
  $collection_jitter      = '0s',
  $flush_interval         = '10s',
  $flush_jitter           = '0s',
  $debug                  = false,
  $quiet                  = false,
  $inputs                 = undef,
  $outputs                = undef,
  $global_tags            = undef,
  $manage_service         = true,
)
{
  contain ::telegraf::install
  contain ::telegraf::config
  contain ::telegraf::service

  Class['::telegraf::install'] ->
  Class['::telegraf::config'] ->
  Class['::telegraf::service']
}
