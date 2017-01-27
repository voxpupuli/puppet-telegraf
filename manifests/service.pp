# == Class: telegraf::service
#
# Optionally manage the Telegraf service.
#
class telegraf::service {

  assert_private()

  if $::telegraf::manage_service {
    service { 'telegraf':
      ensure    => running,
      hasstatus => $telegraf::service_hasstatus,
      enable    => true,
      restart   => $telegraf::service_restart,
      require   => Class['::telegraf::config'],
    }
  }
}
