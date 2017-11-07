require 'spec_helper'

describe 'telegraf::output' do
  let(:title) { 'my_influxdb' }
  let(:params) {{
    :plugin_type => 'influxdb',
    :options => {
      "urls" => ["http://localhost:8086",],
    },
    :sections => { 'tagpass' => { 'addatag' => ['woof'] } },
  }}
  let(:filename) { "/etc/telegraf/telegraf.d/output-#{title}.conf" }

  describe "configuration file /etc/telegraf/telegraf.d/output-my_influxdb.conf output" do
    it 'is declared with the correct content' do
      should contain_file(filename).with_content(/\[\[outputs\.influxdb\]\]/)
      should contain_file(filename).with_content(/  urls = \["http:\/\/localhost:8086"\]/)
      should contain_file(filename).with_content(/  \[outputs\.influxdb\.tagpass\]/)
      should contain_file(filename).with_content(/    addatag = \["woof"\]/)
    end

    it 'requires telegraf to be installed' do
      should contain_file(filename).that_requires('Class[telegraf::install]')
    end

    it 'notifies the telegraf daemon' do
      should contain_file(filename).that_notifies("Class[telegraf::service]")
    end
  end
end
