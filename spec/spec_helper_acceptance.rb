require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
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
    puppet_module_install(:source => proj_root, :module_name => "#{File.basename(proj_root)}")
    # Install dependancies
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '-v 4.3.2')
    end
  end
end
