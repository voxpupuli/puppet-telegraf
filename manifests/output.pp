# == Define: telegraf::output
#
# A Puppet wrapper for discrete Telegraf output files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the output template.

define telegraf::output (
  String          $plugin_type = $name,
  Optional[Array] $options     = undef,
) {
  include telegraf

  file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'outputs'=>{'${plugin_type}'=>@options}}) %>"),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
