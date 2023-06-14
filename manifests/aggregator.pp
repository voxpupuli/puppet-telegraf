#
# @summary A Puppet wrapper for discrete Telegraf aggregator files
#
# @param options Plugin options for use in the aggregator template
# @param plugin_type Define the telegraf plugin type to use
# @param ensure Set if the ensure params of the config file. If telegraf::ensure is absent the value is automatically absent
#
define telegraf::aggregator (
  String          $plugin_type      = $name,
  Optional[Array] $options          = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  include telegraf

  $_ensure = $telegraf::ensure ? {
    'absent' => 'absent',
    default  => $ensure,
  }

  file { "${telegraf::config_folder}/${name}.conf":
    ensure  => $_ensure,
    content => stdlib::to_toml({ 'aggregators'=> { $plugin_type=> $options } }),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
