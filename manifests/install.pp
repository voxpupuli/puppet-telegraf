# == Class: telegraf::install
#
# Installs the telegraf package
#
class telegraf::install {

  assert_private()

  $_operatingsystem = downcase($::operatingsystem)

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
      ensure_packages(['telegraf'], {
        'ensure'  => $::telegraf::ensure,
        'require' => Exec['apt_update'],
      })
    }
    'RedHat': {
      yumrepo { 'influxdata':
        descr    => 'influxdata',
        enabled  => 1,
        baseurl  => "https://repos.influxdata.com/rhel/${::operatingsystemmajrelease}/${::architecture}/stable",
        gpgkey   => 'https://repos.influxdata.com/influxdb.key',
        gpgcheck => true,
      }
    }
    default: {
      fail('Only RedHat, CentOS, Debian and Ubuntu are supported at this time')
    }
  }
}
