require 'spec_helper_acceptance'

describe 'telegraf' do

  context 'default server' do

      it 'should work with no errors' do

        pp = <<-EOS
		    Exec {
              path => '/bin:/usr/bin:/sbin:/usr/sbin',
            }

            class { '::telegraf':
              hostname  => $::hostname,
              outputs   => {
                  'influxdb' => {
                    'urls'     => '["http://localhost:8086"]',
                    'database' => '"telegraf"',
                    'username' => '"telegraf"',
                    'password' => '"metricsmetricsmetrics"',
                  }
              },
              inputs    => {
                  'cpu' => {
                    'percpu'   => 'true',
                    'totalcpu' => 'true',
                  },
              }
            }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes  => true)

      end

  end
end
