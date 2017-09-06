# == Define: telegraf::output
#
# A Puppet wrapper for discrete Telegraf output files
#
# === Parameters
#
# [*options*]
#   List. Plugin options for use in the output template.

define telegraf::output (
  String                $plugin_type = $name,
  Variant[Undef, Array] $options     = undef,
) {
  include telegraf

  Class['::telegraf::config']
  -> file {"${telegraf::config_folder}/${name}.conf":
    ensure  => file,
    content => inline_template("<%= require 'toml-rb'; TomlRB.dump({'outputs'=>{'${plugin_type}'=>@options}}) %>"),
    owner   => $::telegraf::config_file_owner,
    group   => $::telegraf::config_file_group,
    mode    => '0640',
  }
  ~> Class['::telegraf::service']
}
