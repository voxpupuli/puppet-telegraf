# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*options*]
#   Hash. Plugin options for use the the input template.
#
# [*sections*]
#   Hash. Some inputs take multiple sections.
#
# [*subsections*]
#   Hash. Some inputs take multiple sections. This one does single brackets
#

define telegraf::input (
  $plugin_type = $name,
  $options     = undef,
  $sections    = undef,
  $subsections    = undef,
) {
  include telegraf

  if $options {
    validate_hash($options)
  }

  if $sections {
    validate_hash($sections)
  }
  if $subsections {
    validate_hash($subsections)
  }

  Class['::telegraf::config']
  ->
  file {"${telegraf::config_folder}/${name}.conf":
    content => template('telegraf/input.conf.erb')
  }
  ~>
  Class['::telegraf::service']
}
