# == Class: telegraf::params
#
# A set of default parameters for Telegraf's configuration.
#
class telegraf::params {

  $ensure                 = 'present'
  $config_file            = '/etc/telegraf/telegraf.conf'
  $hostname               = $::hostname
  $interval               = '10s'
  $round_interval         = true
  $metric_buffer_limit    = '1000'
  $flush_buffer_when_full = true
  $collection_jitter      = '0s'
  $flush_interval         = '10s'
  $flush_jitter           = '0s'
  $debug                  = false
  $quiet                  = false
  $global_tags            = {}
  $manage_service         = true
  $manage_repo            = true

  $outputs = {
    'influxdb'  => {
      'urls'     => [ 'http://localhost:8086' ],
      'database' => 'telegraf',
      'username' => 'telegraf',
      'password' => 'metricsmetricsmetrics',
    }
  }

  $inputs = {
    'cpu'  => {
      'percpu'   => true,
      'totalcpu' => true,
    }
  }
}
