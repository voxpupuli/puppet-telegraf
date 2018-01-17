# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the input template.

define telegraf::input (
  $plugin_type = $name,
  $options     = [],
) {
  include telegraf

  if $options {
    validate_array($options)
  }

  Class['::telegraf::config']
  -> file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'inputs'=>{'${plugin_type}'=>@options}}) %>")
  }
  ~> Class['::telegraf::service']
}
