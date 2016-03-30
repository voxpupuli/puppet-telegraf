# == Define: telegraf::input
#
# A puppet wrapper for the input files
#
# === Parameters
# [*options*]
#   Options for use the the input template
#
# [*sections*]
#   Some inputs take multiple sections

define telegraf::input (
  $options  = undef,
  $sections = undef,
) {
  include telegraf

  Class['telegraf::config']
  ->
  file {"/etc/telegraf/telegraf.d/${name}.conf":
    content => template('telegraf/input.conf.erb')
  }
  ~>
  Class['telegraf::service']
}
