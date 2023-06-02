#
# @summary A Puppet wrapper for discrete Telegraf output files
#
# @param options Plugin options for use in the output template.
# @param plugin_type Define the telegraf plugin type to use (default is $name)
# @param ensure Set if the ensure params of the config file. If telegraf::ensure is absent the value is automatically absent
#
define telegraf::output (
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
    content => stdlib::to_toml({ 'outputs'=> { $plugin_type=> $options } }),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
