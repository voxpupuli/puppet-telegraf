# == Class: telegraf::params
#
# A set of default parameters for Telegraf's configuration.
#
class telegraf::params {
  case $facts['os']['family'] {
    'windows': {
      $config_file          = 'C:/Program Files/telegraf/telegraf.conf'
      $config_file_owner    = 'Administrator'
      $config_file_group    = 'Administrators'
      $config_folder        = 'C:/Program Files/telegraf/telegraf.d'
      $logfile              = 'C:/Program Files/telegraf/telegraf.log'
      $manage_repo          = false
      $manage_archive       = false
      $manage_user          = false
      $archive_install_dir  = undef
      $archive_location     = undef
      $repo_location        = undef
      $service_enable       = true
      $service_ensure       = running
      $service_hasstatus    = false
      $service_restart      = undef
    }
    'Suse': {
      $config_file          = '/etc/telegraf/telegraf.conf'
      $config_file_owner    = 'telegraf'
      $config_file_group    = 'telegraf'
      $config_file_mode     = '0640'
      $config_folder        = '/etc/telegraf/telegraf.d'
      $config_folder_mode   = '0770'
      $logfile              = ''
      $manage_repo          = false
      $manage_archive       = true
      $manage_user          = true
      $archive_install_dir  = '/opt/telegraf'
      $archive_location     = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz'
      $repo_location        = 'https://repos.influxdata.com/'
      $service_enable       = true
      $service_ensure       = running
      $service_hasstatus    = true
      $service_restart      = 'pkill -HUP telegraf'
    }
    default: {
      $config_file          = '/etc/telegraf/telegraf.conf'
      $config_file_owner    = 'telegraf'
      $config_file_group    = 'telegraf'
      $config_file_mode     = '0640'
      $config_folder        = '/etc/telegraf/telegraf.d'
      $config_folder_mode   = '0770'
      $logfile              = ''
      $manage_repo          = true
      $manage_archive       = false
      $manage_user          = false
      $archive_install_dir  = undef
      $archive_location     = undef
      $repo_location        = 'https://repos.influxdata.com/'
      $service_enable       = true
      $service_ensure       = running
      $service_hasstatus    = true
      $service_restart      = 'pkill -HUP telegraf'
    }
  }
  $package_name           = 'telegraf'
  $ensure                 = 'present'
  $install_options        = []
  $hostname               = $trusted['hostname']
  $omit_hostname          = false
  $interval               = '10s'
  $round_interval         = true
  $metric_batch_size      = 1000
  $metric_buffer_limit    = 10000
  $collection_jitter      = '0s'
  $flush_interval         = '10s'
  $flush_jitter           = '0s'
  $precision              = ''
  $debug                  = false
  $quiet                  = false
  $global_tags            = {}
  $manage_service         = true
  $purge_config_fragments = false
  $repo_type              = 'stable'
  $windows_package_url    = 'https://chocolatey.org/api/v2/'

  $outputs = {
    'influxdb' => [{
        'urls'     => ['http://localhost:8086'],
        'database' => 'telegraf',
        'username' => 'telegraf',
        'password' => 'metricsmetricsmetrics',
    }],
  }

  $inputs = {
    'cpu' => [{
        'percpu'   => true,
        'totalcpu' => true,
    }],
  }
}
