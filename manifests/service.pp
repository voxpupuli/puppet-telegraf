# == Class: telegraf::service
#
# Ensure the Telegraf service is running
#
class telegraf::service {

  assert_private()

  service { 'telegraf':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }
}
