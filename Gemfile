source 'https://rubygems.org'

gem 'guard'
gem 'guard-bundler'
gem 'guard-rake'
gem 'rake'
gem 'r10k', '>= 2.0.0'
gem 'pry'

group :test do
  gem "beaker"
  gem "beaker-rspec"
  gem "hiera", "> 1.3"
  gem "jwt", "> 0.1.4"
  gem "puppet", ENV['PUPPET_VERSION'] || ">  3.7.0"
  gem "puppetlabs_spec_helper"
  gem "rspec"
  gem "rspec-puppet"
end
