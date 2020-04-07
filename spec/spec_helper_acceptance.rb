require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  on host, '/opt/puppetlabs/puppet/bin/gem install toml-rb'
end
