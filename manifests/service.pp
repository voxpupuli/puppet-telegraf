# == Class: telegraf::service
#
# Optionally manage the Telegraf service.
#
class telegraf::service {

  assert_private()

  case $::operatingsystem {
    'Ubuntu' : {
      if versioncmp($::operatingsystemmajrelease, '16.04') >= 0 {
        $service_provider = 'systemd'
      } else {
        $service_provider = undef
      }
    }
    default : {
      $service_provider = undef
    }
  }

  if $::telegraf::manage_service {
    service { 'telegraf':
      ensure    => $telegraf::service_ensure,
      hasstatus => $telegraf::service_hasstatus,
      enable    => $telegraf::service_enable,
      restart   => $telegraf::service_restart,
      require   => Class['::telegraf::config'],
      provider  => $service_provider,
    }
  }
}
