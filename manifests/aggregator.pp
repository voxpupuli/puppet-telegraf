# == Define: telegraf::aggregator
#
# A Puppet wrapper for discrete Telegraf aggregator files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the aggregator template.

define telegraf::aggregator (
  String          $plugin_type = $name,
  Optional[Array] $options     = undef,
) {
  include telegraf

  file {"${telegraf::config_folder}/${name}.conf":
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'aggregators'=>{'${plugin_type}'=>@options}}) %>"),
    require => Class['telegraf::config'],
    notify  => Class['telegraf::service'],
  }
}
