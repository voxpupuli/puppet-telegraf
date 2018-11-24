require 'spec_helper_acceptance'

describe 'telegraf' do
  context 'default server' do
    it 'works with no errors' do
      pp = <<-EOS
            Exec {
              path => '/bin:/usr/bin:/sbin:/usr/sbin',
            }

            class { '::telegraf':
              hostname  => 'test.vagrant.dev',
              outputs   => {
                  'influxdb' => [{
                    'urls'     => [ 'http://localhost:8086' ],
                    'database' => 'telegraf',
                    'username' => 'telegraf',
                    'password' => 'metricsmetricsmetrics',
                  }]
              },
              inputs    => {
                  'cpu' => [{
                    'percpu'   => true,
                    'totalcpu' => true,
                  }],
              }
            }
        EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to be_zero
    end

    describe package('telegraf') do
      it { is_expected.to be_installed }
    end

    describe service('telegraf') do
      it { is_expected.to be_running }
    end

    describe file '/etc/telegraf/telegraf.conf' do
      it { is_expected.to be_file }
      it { is_expected.to contain '[agent]' }
      it { is_expected.to contain 'hostname = "test.vagrant.dev"' }
      it { is_expected.to contain '[[outputs.influxdb]]' }
      it { is_expected.to contain 'urls = ["http://localhost:8086"]' }
      it { is_expected.to contain 'database = "telegraf"' }
      it { is_expected.to contain 'username = "telegraf"' }
      it { is_expected.to contain 'password = "metricsmetricsmetrics"' }
      it { is_expected.to contain '[[inputs.cpu]]' }
      it { is_expected.to contain 'percpu = true' }
      it { is_expected.to contain 'totalcpu = true' }
    end
  end
end
