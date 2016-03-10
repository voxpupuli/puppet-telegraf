# == Class: telegraf::service
#
# Optionally manage the Telegraf service.
#
class telegraf::service {

  assert_private()

  if $::telegraf::manage_service {
    service { 'telegraf':
      ensure    => running,
      hasstatus => true,
      enable    => true,
      restart   => 'pkill -HUP telegraf',
      require   => Class['::telegraf::config'],
    }
  }
}
