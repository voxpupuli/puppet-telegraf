# == Class: telegraf::service
#
# Optionally manage the Telegraf service.
#
class telegraf::service {

  assert_private()

  if $telegraf::manage_service {
    service { 'telegraf':
      ensure    => $telegraf::service_ensure,
      hasstatus => $telegraf::service_hasstatus,
      enable    => $telegraf::service_enable,
      restart   => $telegraf::service_restart,
    }
  }
}
