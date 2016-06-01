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
#   Hash.  Global tags as a key-value pair.
#
# [*manage_service*]
#   Boolean.  Whether to manage the telegraf service or not.
#
# [*manage_repo*]
#   Boolean.  Whether or not to manage InfluxData's repo.
#
class telegraf (
  $ensure                 = $telegraf::params::ensure,
  $config_file            = $telegraf::params::config_file,
  $hostname               = $telegraf::params::hostname,
  $interval               = $telegraf::params::interval,
  $round_interval         = $telegraf::params::round_interval,
  $metric_buffer_limit    = $telegraf::params::metric_buffer_limit,
  $flush_buffer_when_full = $telegraf::params::flush_buffer_when_full,
  $collection_jitter      = $telegraf::params::collection_jitter,
  $flush_interval         = $telegraf::params::flush_interval,
  $flush_jitter           = $telegraf::params::flush_jitter,
  $debug                  = $telegraf::params::debug,
  $quiet                  = $telegraf::params::quiet,
  $inputs                 = $telegraf::params::inputs,
  $outputs                = $telegraf::params::outputs,
  $global_tags            = $telegraf::params::global_tags,
  $manage_service         = $telegraf::params::manage_service,
  $manage_repo            = $telegraf::params::manage_repo,
) inherits ::telegraf::params
{

  validate_string($ensure)
  validate_string($config_file)
  validate_string($hostname)
  validate_string($interval)
  validate_bool($round_interval)
  validate_integer($metric_buffer_limit)
  validate_bool($flush_buffer_when_full)
  validate_string($collection_jitter)
  validate_string($flush_interval)
  validate_string($flush_jitter)
  validate_bool($debug)
  validate_bool($quiet)
  validate_hash($inputs)
  validate_hash($outputs)
  validate_hash($global_tags)
  validate_bool($manage_service)
  validate_bool($manage_repo)

  # currently the only way how to obtain merged hashes
  # from multiple files (`:merge_behavior: deeper` needs to be
  # set in your `hiera.yaml`)
  $_outputs = hiera_hash('telegraf::outputs', $outputs)
  $_inputs = hiera_hash('telegraf::inputs', $inputs)

  contain ::telegraf::install
  contain ::telegraf::config
  contain ::telegraf::service

  Class['::telegraf::install'] ->
  Class['::telegraf::config'] ->
  Class['::telegraf::service']
}
