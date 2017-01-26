# == Class: telegraf::install
#
# Conditionally handle InfluxData's official repos and install the necessary
# Telegraf package.
#
class telegraf::install {

  assert_private()

  $_operatingsystem = downcase($::operatingsystem)

  if $::telegraf::manage_repo {
    case $::osfamily {
      'Debian': {
        apt::source { 'influxdata':
          comment  => 'Mirror for InfluxData packages',
          location => "https://repos.influxdata.com/${_operatingsystem}",
          release  => $::lsbdistcodename,
          repos    => $::telegraf::repo_type,
          key      => {
            'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
            'source' => 'https://repos.influxdata.com/influxdb.key',
          },
        }
        Class['apt::update'] -> Package['telegraf']
      }
      'RedHat': {
        yumrepo { 'influxdata':
          descr    => 'InfluxData Repository - RHEL $releasever',
          enabled  => 1,
          baseurl  => "https://repos.influxdata.com/${_operatingsystem}/\$releasever/\$basearch/${::telegraf::repo_type}",
          gpgkey   => 'https://repos.influxdata.com/influxdb.key',
          gpgcheck => true,
        }
        Yumrepo['influxdata'] -> Package['telegraf']
      }
      default: {
        fail('Only RedHat, CentOS, Debian and Ubuntu are supported at this time')
      }
    }
  }

  ensure_packages(['telegraf'], { ensure => $::telegraf::ensure })

}
