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
          location => "${::telegraf::repo_location}${_operatingsystem}",
          release  => $::lsbdistcodename,
          repos    => $::telegraf::repo_type,
          key      => {
            'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
            'source' => "${::telegraf::repo_location}influxdb.key",
          },
        }
        Class['apt::update'] -> Package[$::telegraf::package_name]
      }
      'RedHat': {
        yumrepo { 'influxdata':
          name     => 'influxdata',
          descr    => "InfluxData Repository - ${::operatingsystem} \$releasever",
          enabled  => 1,
          baseurl  => "${::telegraf::repo_location}rhel/\$releasever/\$basearch/${::telegraf::repo_type}",
          gpgkey   => "${::telegraf::repo_location}influxdb.key",
          gpgcheck => 1,
        }
        Yumrepo['influxdata'] -> Package[$::telegraf::package_name]
      }
      'windows': {
        # repo is not applicable to windows
      }
      default: {
        fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu and Windows are supported at this time')
      }
    }
  }

  if $::osfamily == 'windows' {
    # required to install telegraf on windows
    require chocolatey

    # package install
    package { $::telegraf::package_name:
      ensure          => $::telegraf::ensure,
      provider        => chocolatey,
      source          => $::telegraf::windows_package_url,
      install_options => $::telegraf::install_options,
    }
  } else {
    ensure_packages([$::telegraf::package_name], { ensure => $::telegraf::ensure, install_options => $::telegraf::install_options })
  }

}
