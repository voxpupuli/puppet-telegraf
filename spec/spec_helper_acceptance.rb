require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  on 'debian', 'apt-get -y install wget'
  # Install Puppet
  install_puppet
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    # We assume the module is in auto load layout
    puppet_module_install(:source => proj_root, :module_name => 'telegraf')
    # Install dependancies
    hosts.each do |host|
      if fact('osfamily') == 'Debian'
        on host, 'apt-get -y install apt-transport-https'
      end
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apt'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
