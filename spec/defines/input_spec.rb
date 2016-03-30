require 'spec_helper'

describe 'telegraf::input' do
  let(:title) { 'influxdb' }
  let(:params) {{
    :options => {
      "urls" => ['http://localhost:8086'],
    },
  }}
  let(:facts) { { :osfamily => 'RedHat' } }
  let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }

  describe 'configuration file /etc/telegraf/telegraf.d/influxdb.conf input' do
    it 'is declared' do
      should contain_file(filename)
        .with('[[inputs.influxdb]]')
        .with('  urls = ["http://localhost:8086"]')
    end

    it 'requires telegraf to be installed' do
      should contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      should contain_file(filename).that_notifies("Class[telegraf::service]")
    end
  end
end

describe 'telegraf::input' do
  let(:title) { 'snmp' }
  let(:params) {{
    :options => {
      "interval" => '60s',
    },
    :sections => {
      "snmp.host" => {
        "address"   => "snmp_host:161",
        "community" => "read_only",
        "version"   => 2,
        "get_oids"  => ['1.3.6.1.2.1.1.5',],
      },
        "snmp.host" => {
        "address"   => "snmp_host:161",
        "community" => "read_only",
        "version"   => 2,
        "get_oids"  => ['1.3.6.1.2.1.1.5',],
      },
    },
  }}
  let(:facts) { { :osfamily => 'RedHat' } }
  let(:filename) { "/etc/telegraf/telegraf.d/#{title}.conf" }

  describe 'configuration file /etc/telegraf/telegraf.d/snmp.conf input with sections' do
    it 'is declared' do
      should contain_file(filename)
    end

    it 'requires telegraf to be installed' do
      should contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      should contain_file(filename).that_notifies("Class[telegraf::service]")
    end
  end
end
