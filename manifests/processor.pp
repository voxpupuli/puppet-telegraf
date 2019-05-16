# == Define: telegraf::processor
#
# A Puppet wrapper for discrete Telegraf processor files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the processor template.

define telegraf::processor (
  String          $plugin_type = $name,
  Optional[Array] $options     = undef,
) {
  include telegraf

  file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'processors'=>{'${plugin_type}'=>@options}}) %>"),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
