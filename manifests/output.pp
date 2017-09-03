# == Define: telegraf::output
#
# A Puppet wrapper for discrete Telegraf output files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the output template.

define telegraf::output (
  $plugin_type = $name,
  $options     = undef,
) {
  include telegraf

  if $options {
    validate_array($options)
  }

  Class['::telegraf::config']
  -> file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'outputs'=>{'${plugin_type}'=>@options}}) %>")
  }
  ~> Class['::telegraf::service']
}
