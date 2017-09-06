# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the input template.

define telegraf::input (
  String                $plugin_type = $name,
  Variant[Undef, Array] $options     = [],
) {
  include telegraf

  Class['::telegraf::config']
  -> file {"${telegraf::config_folder}/${name}.conf":
    ensure  => file,
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'inputs'=>{'${plugin_type}'=>@options}}) %>"),
    owner   => $::telegraf::config_file_owner,
    group   => $::telegraf::config_file_group,
    mode    => '0640',
  }
  ~> Class['::telegraf::service']
}
