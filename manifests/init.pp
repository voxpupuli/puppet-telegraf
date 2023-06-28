#
# @summary A Puppet module for installing InfluxData's Telegraf
#
# @param package_name Package name
# @param ensure State of the telegraf package. You can also specify a particular version to install
# @param config_file Path to the configuration file
# @param logfile Path to the log file
# @param logfile_rotation_interval The logfile will be rotated after the time interval specified, e.g. "1d". 0 = off. Default = "0h"
# @param logfile_rotation_max_size The logfile will be rotated when it becomes larger than the specified size, e.g. "10MB". 0 = off.  Default = "0MB"
# @param logfile_rotation_max_archives Maximum number of rotated archives to keep, older logs are deleted.  If set to -1, no archives are removed. Default = 5
# @param config_file_owner User to own the telegraf config file
# @param config_file_group Group to own the telegraf config file
# @param config_file_mode File mode for the telegraf config file
# @param config_folder Path of additional telegraf config folder
# @param config_folder_mode File mode for the telegraf config folder
# @param hostname Override default hostname used to identify this agent
# @param omit_hostname Do not set the "host" tag in the telegraf agent
# @param interval Default data collection interval for all inputs
# @param round_interval Rounds collection interval to 'interval'
# @param metric_batch_size The maximum batch size to allow to accumulate before sending a flush to the configured outputs
# @param metric_buffer_limit The absolute maximum number of metrics that will accumulate before metrics are dropped
# @param collection_jitter Sleep for a random time within jitter before collecting
# @param flush_interval Default flushing interval for all outputs
# @param flush_jitter Jitter the flush interval by an amount
# @param debug Run telegraf in debug mode
# @param quiet Run telegraf in quiet mode
# @param outputs Specify output plugins and their options
# @param inputs Specify input plugins and their options
# @param global_tags Global tags as a key-value pair
# @param processors Specify processors and their configuration
# @param manage_service Whether to manage the telegraf service or not
# @param manage_repo Whether or not to manage InfluxData's repo
# @param manage_archive Whether or not to manage InfluxData's tar archive
# @param manage_user Whether or not to manage the 'telegraf' user when installing from archive
# @param repo_location Alternate repo location. E.g. an interal mirror
# @param archive_location Alternate archive location. E.g. an interal mirror
# @param archive_version Specify a telegraf archive version. E.g. 1.17.2
# @param archive_install_dir Location to extract archive to must be an absolute path
# @param install_options Additional options to pass when installing package
# @param purge_config_fragments Whether unmanaged configuration fragments should be removed
# @param repo_type Which repo (stable, unstable, nightly) to use
# @param windows_package_url URL for windows telegraf chocolatey repo
# @param precision
# @param service_enable enable state for the telegraf service
# @param service_ensure ensure state for the telegraf service
#
class telegraf (
  String  $package_name                          = $telegraf::params::package_name,
  String  $ensure                                = $telegraf::params::ensure,
  String  $config_file                           = $telegraf::params::config_file,
  String  $config_file_owner                     = $telegraf::params::config_file_owner,
  String  $config_file_group                     = $telegraf::params::config_file_group,
  Optional[Stdlib::Filemode] $config_file_mode   = $telegraf::params::config_file_mode,
  String  $config_folder                         = $telegraf::params::config_folder,
  Optional[Stdlib::Filemode] $config_folder_mode = $telegraf::params::config_folder_mode,
  String  $hostname                              = $telegraf::params::hostname,
  Boolean $omit_hostname                         = $telegraf::params::omit_hostname,
  String  $interval                              = $telegraf::params::interval,
  Boolean $round_interval                        = $telegraf::params::round_interval,
  Integer $metric_batch_size                     = $telegraf::params::metric_batch_size,
  Integer $metric_buffer_limit                   = $telegraf::params::metric_buffer_limit,
  String  $collection_jitter                     = $telegraf::params::collection_jitter,
  String  $flush_interval                        = $telegraf::params::flush_interval,
  String  $flush_jitter                          = $telegraf::params::flush_jitter,
  String  $precision                             = $telegraf::params::precision,
  String  $logfile                               = $telegraf::params::logfile,
  String  $logfile_rotation_interval             = $telegraf::params::logfile_rotation_interval,
  String  $logfile_rotation_max_size             = $telegraf::params::logfile_rotation_max_size,
  Integer $logfile_rotation_max_archives         = $telegraf::params::logfile_rotation_max_archives,
  Boolean $debug                                 = $telegraf::params::debug,
  Boolean $quiet                                 = $telegraf::params::quiet,
  Hash    $inputs                                = $telegraf::params::inputs,
  Hash    $outputs                               = $telegraf::params::outputs,
  Hash    $global_tags                           = $telegraf::params::global_tags,
  Hash    $processors                            = {},
  Boolean $manage_service                        = $telegraf::params::manage_service,
  Boolean $manage_repo                           = $telegraf::params::manage_repo,
  Boolean $manage_archive                        = $telegraf::params::manage_archive,
  Boolean $manage_user                           = $telegraf::params::manage_user,
  Optional[String] $repo_location                = $telegraf::params::repo_location,
  Optional[String] $archive_location             = $telegraf::params::archive_location,
  Optional[String[1]] $archive_version           = $telegraf::params::archive_version,
  Optional[String] $archive_install_dir          = $telegraf::params::archive_install_dir,
  Boolean $purge_config_fragments                = $telegraf::params::purge_config_fragments,
  String  $repo_type                             = $telegraf::params::repo_type,
  String  $windows_package_url                   = $telegraf::params::windows_package_url,
  Boolean $service_enable                        = $telegraf::params::service_enable,
  String  $service_ensure                        = $telegraf::params::service_ensure,
  Array   $install_options                       = $telegraf::params::install_options,
) inherits telegraf::params {
  $service_hasstatus = $telegraf::params::service_hasstatus
  $service_restart   = $telegraf::params::service_restart

  $ensure_file = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  $ensure_status = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }

  contain telegraf::install
  contain telegraf::config
  contain telegraf::service

  $processors.each |$processor, $attributes| {
    telegraf::processor { $processor:
      * => $attributes,
    }
  }

  Class['telegraf::install'] -> Class['telegraf::config'] ~> Class['telegraf::service']
  Class['telegraf::install'] ~> Class['telegraf::service']
}
