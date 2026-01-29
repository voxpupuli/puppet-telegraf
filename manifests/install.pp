# == Class: telegraf::install
#
# Conditionally handle InfluxData's official repos and install the necessary
# Telegraf package.
#
class telegraf::install {
  assert_private()

  case $facts['os']['family'] {
    'Darwin': {
      if $telegraf::manage_user {
        group { $telegraf::config_file_group:
          ensure => present,
        }

        user { $telegraf::daemon_user:
          ensure => present,
          gid    => $telegraf::config_file_group,
        }
      }

      if $telegraf::manage_archive {
        file { "${telegraf::archive_install_dir}-${telegraf::archive_version}":
          ensure => directory,
          owner  => $telegraf::config_file_owner,
          group  => $telegraf::config_file_group,
        }

        -> archive { "/tmp/telegraf-${telegraf::archive_version}.tar.gz":
          ensure          => present,
          extract         => true,
          extract_path    => "${telegraf::archive_install_dir}-${telegraf::archive_version}",
          extract_command => 'tar xfz %s --strip-components=2',
          source          => "https://dl.influxdata.com/telegraf/releases/telegraf-${telegraf::archive_version}_darwin_amd64.tar.gz",
          creates         => "${telegraf::archive_install_dir}-${telegraf::archive_version}/usr/bin/telegraf",
          user            => $telegraf::config_file_owner,
          group           => $telegraf::config_file_group,
          cleanup         => true,
        }

        -> file { '/usr/local/bin/telegraf':
          ensure => link,
          target => "${telegraf::archive_install_dir}-${telegraf::archive_version}/usr/bin/telegraf",
        }
      } else {
        package { $telegraf::package_name:
          ensure          => $telegraf::ensure,
          provider        => 'homebrew',
          install_options => $telegraf::install_options,
        }
      }

      if $telegraf::manage_repo {
        notify { 'telegraf repo warn':
          message  => "Installing from repo on ${facts['os']['name']} is not supported",
          loglevel => 'warning',
        }
      }
    }
    'Debian': {
      if $telegraf::manage_repo {
        apt::source { 'influxdata':
          ensure   => $telegraf::ensure_status,
          comment  => 'Mirror for InfluxData packages',
          location => "${telegraf::repo_location}debian",
          release  => 'stable',
          repos    => 'main',
          key      => {
            'name'   => 'influxdata-archive.key',
            'source' => "${telegraf::repo_location}influxdata-archive.key",
          },
        }
        Class['apt::update'] -> Package[$telegraf::package_name]
      }
      elsif $telegraf::manage_archive {
        notify { 'telegraf archive warn':
          message  => "Installing from archive on ${facts['os']['name']} is not supported",
          loglevel => 'warning',
        }
      }
    }
    'RedHat': {
      if $telegraf::manage_user {
        group { $telegraf::config_file_group:
          ensure => present,
        }
        user { $telegraf::daemon_user:
          ensure => present,
          gid    => $telegraf::config_file_group,
        }
      }

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
          gpgkey   => "${telegraf::repo_location}influxdata-archive.key",
          gpgcheck => 1,
        }
        Yumrepo['influxdata'] -> Package[$telegraf::package_name]
      }
      elsif $telegraf::manage_archive {
        file { $telegraf::archive_install_dir:
          ensure => directory,
        }
        archive { '/tmp/telegraf.tar.gz':
          ensure          => present,
          extract         => true,
          extract_command => 'tar xfz %s --strip-components=2',
          extract_path    => $telegraf::archive_install_dir,
          creates         => "${telegraf::archive_install_dir}/usr/bin/telegraf",
          source          => $telegraf::archive_location,
          cleanup         => true,
          require         => File[$telegraf::archive_install_dir],
        }
        file { '/etc/telegraf':
          ensure => directory,
        }

        file { '/etc/systemd/system/telegraf.service':
          ensure => file,
          source => 'puppet:///modules/telegraf/telegraf.service',
        }
      }
    }
    'Suse': {
      if $telegraf::manage_user {
        group { $telegraf::config_file_group:
          ensure => present,
        }
        user { $telegraf::daemon_user:
          ensure => present,
          gid    => $telegraf::config_file_group,
        }
      }

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
          creates         => "${telegraf::archive_install_dir}/usr/bin/telegraf",
          cleanup         => true,
          require         => File[$telegraf::archive_install_dir],
        }
        file { '/etc/telegraf':
          ensure => directory,
        }

        file { '/etc/systemd/system/telegraf.service':
          ensure => file,
          source => 'puppet:///modules/telegraf/telegraf.service',
        }
      }
      elsif $telegraf::manage_repo {
        notify { 'telegraf repo warn':
          message  => "Installing from repo on ${facts['os']['name']} is not supported",
          loglevel => 'warning',
        }
      }
    }
    'windows': {
      # required to install telegraf on windows
      require chocolatey

      # package install
      package { $telegraf::package_name:
        ensure          => $telegraf::ensure,
        provider        => chocolatey,
        source          => $telegraf::windows_package_url,
        install_options => $telegraf::install_options,
      }
    }
    'FreeBSD': {
      # repo is not applicable to windows
    }
    default: {
      fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu, Darwin, FreeBSD and Windows repositories and Suse archives are supported at this time')
    }
  }

  unless $telegraf::manage_archive {
    stdlib::ensure_packages([$telegraf::package_name],
      {
        ensure          => $telegraf::ensure,
        install_options => $telegraf::install_options,
      }
    )
  }
}
