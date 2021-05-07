# == Define: telegraf::aggregator
#
# A Puppet wrapper for discrete Telegraf aggregator files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the aggregator template.
#
# [*plugin_type*]
#   String. Define the telegraf plugin type to use (default is $name)
#
# [*ensure*]
#   Set if the ensure params of the config file. If telegraf::ensure is absent the value is automatically absent
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
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'aggregators'=>{'${plugin_type}'=>@options}}) %>"),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
