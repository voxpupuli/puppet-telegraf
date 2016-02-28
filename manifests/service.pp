# == Class: telegraf::service
#
# Ensure the Telegraf service is running
#
class telegraf::service {

  assert_private()

  if $::telegraf::manage_service {
    service { 'telegraf':
      ensure    => running,
      hasstatus => true,
      enable    => true,
      require   => Class['::telegraf::config'],
    }
  }
}
