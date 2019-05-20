require 'spec_helper'

describe 'telegraf::aggregator' do
  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'my_basicstats' do
        let(:title) { 'my_basicstats' }
        let(:params) do
          {
            plugin_type: 'basicstats',
            options: [
              {
                'period'        => '30s',
                'drop_original' => false
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

        describe 'configuration file /etc/telegraf/telegraf.d/my_basicstats.conf aggregator' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[\[aggregators.basicstats\]\]})
            is_expected.to contain_file(filename).with_content(%r{period = "30s"})
            is_expected.to contain_file(filename).with_content(%r{drop_original = false})
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
