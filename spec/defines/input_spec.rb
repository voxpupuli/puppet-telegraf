require 'spec_helper'

describe 'telegraf::input' do
  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'my_influxdb' do
        let(:title) { 'my_influxdb' }
        let(:params) do
          {
            plugin_type: 'influxdb',
            options: [
              { 'urls' => ['http://localhost:8086'] }
            ]
          }
        end

        case facts[:kernel]
        when 'windows'
          let(:filename) { "C:/Program Files/telegraf/telegraf.d/#{title}.conf" }
        else
          let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }
        end

        describe 'configuration file /etc/telegraf/telegraf.d/my_influxdb.conf input' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[\[inputs.influxdb\]\]})
            is_expected.to contain_file(filename).with_content(%r{urls = \["http://localhost:8086"\]})
          end

          it 'requires telegraf to be installed' do
            is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
          end

          it 'notifies the telegraf daemon' do
            is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
          end
        end
      end
      context 'my_snmp' do
        let(:title) { 'my_snmp' }
        let(:params) do
          {
            plugin_type: 'snmp',
            options: [
              {
                'interval' => '60s',
                'tags' => {
                  'environment' => 'development'
                },
                'host' => [
                  {
                    'address'   => 'snmp_host1:161',
                    'community' => 'read_only',
                    'version'   => 2,
                    'get_oids'  => ['1.3.6.1.2.1.1.5']
                  }
                ]
              }
            ]
          }
        end

        case facts[:kernel]
        when 'windows'
          let(:filename) { "C:/Program Files/telegraf/telegraf.d/#{title}.conf" }
        else
          let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }
        end

        describe 'configuration file /etc/telegraf/telegraf.d/my_snmp.conf input with sections' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[\[inputs.snmp\]\]})
            is_expected.to contain_file(filename).with_content(%r{interval = "60s"})
            is_expected.to contain_file(filename).with_content(%r{\[inputs.snmp.tags\]})
            is_expected.to contain_file(filename).with_content(%r{environment = "development"})
            is_expected.to contain_file(filename).with_content(%r{\[\[inputs.snmp.host\]\]})
            is_expected.to contain_file(filename).with_content(%r{address = "snmp_host1:161"})
            is_expected.to contain_file(filename).with_content(%r{community = "read_only"})
            is_expected.to contain_file(filename).with_content(%r{get_oids = \["1.3.6.1.2.1.1.5"\]})
            is_expected.to contain_file(filename).with_content(%r{version = 2})
          end

          it 'requires telegraf to be installed' do
            is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
          end

          it 'notifies the telegraf daemon' do
            is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
          end
        end
      end
      context 'my_haproxy' do
        let(:title) { 'my_haproxy' }
        let(:params) do
          {
            plugin_type: 'haproxy'
          }
        end

        case facts[:kernel]
        when 'windows'
          let(:filename) { "C:/Program Files/telegraf/telegraf.d/#{title}.conf" }
        else
          let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }
        end

        describe 'configuration file /etc/telegraf/telegraf.d/my_haproxy.conf input with no options or sections' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[inputs\]})
            is_expected.to contain_file(filename).with_content(%r{haproxy = \[\]})
          end

          it 'requires telegraf to be installed' do
            is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
          end

          it 'notifies the telegraf daemon' do
            is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
          end
        end
      end
    end
  end
end
