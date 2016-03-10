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
          release  => $::distcodename,
          repos    => 'stable',
          key      => {
            'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
            'source' => 'https://repos.influxdata.com/influxdb.key',
          },
        }
        Class['apt::update'] -> Package['telegraf']
      }
      'RedHat': {
        yumrepo { 'influxdata':
          descr    => 'influxdata',
          enabled  => 1,
          baseurl  => "https://repos.influxdata.com/rhel/${::operatingsystemmajrelease}/${::architecture}/stable",
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
