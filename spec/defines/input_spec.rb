require 'spec_helper'

describe 'telegraf::input' do
  let(:title) { 'my_influxdb' }
  let(:params) {{
    plugin_type: 'influxdb',
    options: [
      {'urls' => ['http://localhost:8086',], },
    ],
  }}
  let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }

  describe 'configuration file /etc/telegraf/telegraf.d/my_influxdb.conf input' do
    it 'is declared with the correct content' do
      is_expected.to contain_file(filename).with_content(/\[\[inputs.influxdb\]\]/)
      is_expected.to contain_file(filename).with_content(/urls = \["http:\/\/localhost:8086"\]/)
    end

    it 'requires telegraf to be installed' do
      is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
    end
  end
end

describe 'telegraf::input' do
  let(:title) { 'my_snmp' }
  let(:params) {{
    plugin_type: 'snmp',
    options: [
      {
        'interval' => '60s',
        'tags' => {
          'environment' => 'development',
        },
        'host' => [
          {
            'address'   => 'snmp_host1:161',
            'community' => 'read_only',
            'version'   => 2,
            'get_oids'  => ['1.3.6.1.2.1.1.5',],
          },
        ],
      },
    ],
  }}
  let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }

  describe 'configuration file /etc/telegraf/telegraf.d/my_snmp.conf input with sections' do
    it 'is declared with the correct content' do
      is_expected.to contain_file(filename).with_content(/\[\[inputs.snmp\]\]/)
      is_expected.to contain_file(filename).with_content(/interval = "60s"/)
      is_expected.to contain_file(filename).with_content(/\[inputs.snmp.tags\]/)
      is_expected.to contain_file(filename).with_content(/environment = "development"/)
      is_expected.to contain_file(filename).with_content(/\[\[inputs.snmp.host\]\]/)
      is_expected.to contain_file(filename).with_content(/address = "snmp_host1:161"/)
      is_expected.to contain_file(filename).with_content(/community = "read_only"/)
      is_expected.to contain_file(filename).with_content(/get_oids = \["1.3.6.1.2.1.1.5"\]/)
      is_expected.to contain_file(filename).with_content(/version = 2/)
    end

    it 'requires telegraf to be installed' do
      is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
    end
  end
end

describe 'telegraf::input' do
  let(:title) { 'my_haproxy' }
  let(:params) {{
    plugin_type: 'haproxy',
  }}
  let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }

  describe 'configuration file /etc/telegraf/telegraf.d/my_haproxy.conf input with no options or sections' do
    it 'is declared with the correct content' do
      is_expected.to contain_file(filename).with_content(/\[inputs\]/)
      is_expected.to contain_file(filename).with_content(/haproxy = \[\]/)
    end

    it 'requires telegraf to be installed' do
      is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
    end
  end
end
