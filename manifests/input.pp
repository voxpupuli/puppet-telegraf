# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the input template.

define telegraf::input (
  String $plugin_type = $name,
  Array  $options     = [],
) {
  include telegraf

  file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'inputs'=>{'${plugin_type}'=>@options}}) %>"),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
