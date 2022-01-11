# == Class: telegraf::install
#
# Conditionally handle InfluxData's official repos and install the necessary
# Telegraf package.
#
class telegraf::install {
  assert_private()

  case $facts['os']['family'] {
    'Darwin': {
      if $telegraf::manage_archive {
        if $telegraf::manage_user {
          group { $telegraf::config_file_group:
            ensure => present,
          }

          user { $telegraf::config_file_owner:
            ensure => present,
            gid    => $telegraf::config_file_group,
          }
        }

        $install_dir_deps = [
          '/usr/local/bin',
          '/usr/local/etc',
          '/usr/local/opt',
          '/usr/local/var',
          '/usr/local/var/log',
        ]

        file { $install_dir_deps:
          ensure => directory,
        }

        file { "${telegraf::archive_install_dir}-${telegraf::archive_version}":
          ensure  => directory,
          owner   => $telegraf::config_file_owner,
          group   => $telegraf::config_file_group,
          require => File[$install_dir_deps],
        }

        archive { "/tmp/telegraf-${telegraf::archive_version}.tar.gz":
          ensure          => present,
          extract         => true,
          extract_path    => "${telegraf::archive_install_dir}-${telegraf::archive_version}",
          extract_command => 'tar xfz %s --strip-components=2',
          source          => "https://dl.influxdata.com/telegraf/releases/telegraf-${telegraf::archive_version}_darwin_amd64.tar.gz",
          creates         => "${telegraf::archive_install_dir}-${$telegraf::archive_version}/usr/bin/telegraf",
          user            => $telegraf::config_file_owner,
          group           => $telegraf::config_file_group,
          cleanup         => true,
          require         => File["${telegraf::archive_install_dir}-${telegraf::archive_version}"],
        }

        file {
          default:
            ensure  => link,
            require => Archive["/tmp/telegraf-${telegraf::archive_version}.tar.gz"],
            ;
          '/usr/local/bin/telegraf':
            target  => "${telegraf::archive_install_dir}-${telegraf::archive_version}/usr/bin/telegraf",
            ;
          '/usr/local/etc/telegraf':
            target  => "${telegraf::archive_install_dir}-${telegraf::archive_version}/etc/telegraf",
            ;
          '/usr/local/var/log/telegraf':
            target  => "${telegraf::archive_install_dir}-${telegraf::archive_version}/var/log/telegraf",
            ;
        }

        file { '/Library/LaunchDaemons/telegraf.plist':
          ensure  => file,
          content => epp('telegraf/telegraf.plist.epp', {
              'config_file_owner' => $telegraf::config_file_owner,
              'config_file_group' => $telegraf::config_file_group,
          }),
        }
      }
    }
    'Debian': {
      if $telegraf::manage_repo {
        if $facts['os']['name'] == 'Raspbian' {
          $distro = $facts['os']['family'].downcase
        } else {
          $distro = $facts['os']['name'].downcase
        }
        if $facts.dig('os','distro','codename') {
          $release = $facts['os']['distro']['codename']
        } else {
          $release = $facts['os']['lsb']['codename']
        }
        apt::source { 'influxdata':
          ensure   => $telegraf::ensure_status,
          comment  => 'Mirror for InfluxData packages',
          location => "${telegraf::repo_location}${distro}",
          release  => $release,
          repos    => $telegraf::repo_type,
          key      => {
            'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
            'source' => "${telegraf::repo_location}influxdb.key",
          },
        }
        Class['apt::update'] -> Package[$telegraf::package_name]
      }
    }
    'RedHat': {
      if $telegraf::manage_repo {
        if $facts['os']['name'] == 'Amazon' {
          $_baseurl = "https://repos.influxdata.com/rhel/6/\$basearch/${telegraf::repo_type}"
        } else {
          $_baseurl = "https://repos.influxdata.com/rhel/\$releasever/\$basearch/${telegraf::repo_type}"
        }
        yumrepo { 'influxdata':
          ensure   => $telegraf::ensure_status,
          name     => 'influxdata',
          descr    => "InfluxData Repository - ${facts['os']['name']} \$releasever",
          enabled  => 1,
          baseurl  => $_baseurl,
          gpgkey   => "${telegraf::repo_location}influxdb.key",
          gpgcheck => 1,
        }
        Yumrepo['influxdata'] -> Package[$telegraf::package_name]
      }
    }
    'Suse': {
      if $telegraf::manage_archive {
        file { $telegraf::archive_install_dir:
          ensure => directory,
        }
        archive { '/tmp/telegraf.tar.gz':
          ensure          => present,
          extract         => true,
          extract_command => 'tar xfz %s --strip-components=2',
          extract_path    => $telegraf::archive_install_dir,
          source          => $telegraf::archive_location,
          cleanup         => true,
          require         => File[$telegraf::archive_install_dir],
        }
        file { '/etc/telegraf':
          ensure => directory,
        }
        if $telegraf::manage_user {
          group { $telegraf::config_file_group:
            ensure => present,
          }
          user { $telegraf::config_file_owner:
            ensure => present,
            gid    => $telegraf::config_file_group,
          }
        }
        file { '/etc/systemd/system/telegraf.service':
          ensure => file,
          source => 'puppet:///modules/telegraf/telegraf.service',
        }
        file { '/var/log/telegraf':
          ensure => directory,
          owner  => $telegraf::config_file_owner,
          group  => $telegraf::config_file_group,
        }
      }
    }
    /windows|FreeBSD/: {
      # repo is not applicable to windows
    }
    default: {
      fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu, Darwin, FreeBSD and Windows repositories and Suse archives are supported at this time')
    }
  }

  if $facts['os']['family'] == 'windows' {
    # required to install telegraf on windows
    require chocolatey

    # package install
    package { $telegraf::package_name:
      ensure          => $telegraf::ensure,
      provider        => chocolatey,
      source          => $telegraf::windows_package_url,
      install_options => $telegraf::install_options,
    }
  } else {
    if ! $telegraf::manage_archive {
      ensure_packages([$telegraf::package_name],
        {
          ensure          => $telegraf::ensure,
          install_options => $telegraf::install_options,
        }
      )
    }
  }
}
