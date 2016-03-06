require 'beaker-rspec'

config = {
  'main' => {
    'logdir' => '/var/log/puppet',
    'vardir' => '/var/lib/puppet',
    'ssldir' => '/var/lib/puppet/ssl',
    'rundir' => '/var/run/puppet',
  },
}

# Install latest puppet from puppetlabs.com
hosts.each do |host|
  on hosts, install_puppet
end
# Explicitly configure puppet to avoid warnings
configure_puppet(config)

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    on 'debian', 'apt-get -y install apt-transport-https'

    # Install this module for testing
    puppet_module_install(:source => module_root, :module_name => 'telegraf')

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apt'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
