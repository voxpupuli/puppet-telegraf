require 'spec_helper'

describe 'telegraf::aggregator' do
  on_supported_os.each do |os, facts|
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
        when 'Darwin'
          let(:filename) { "/usr/local/etc/telegraf/telegraf.d/#{title}.conf" }
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

      context 'with ensure absent' do
        let(:title) { 'my_basicstats' }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it do
          dir = case facts[:osfamily]
                when 'Darwin'
                  '/usr/local/etc/telegraf/telegraf.d'
                when 'windows'
                  'C:/Program Files/telegraf/telegraf.d'
                else
                  '/etc/telegraf/telegraf.d'
                end

          is_expected.to contain_file(dir + '/my_basicstats.conf').with(
            ensure: 'absent'
          )
        end
      end

      context 'with class ensure absent' do
        let(:pre_condition) do
          [
            'class {"telegraf": ensure => absent}',
          ]
        end
        let(:title) { 'my_basicstats' }
        let(:params) do
          {
            ensure: 'present',
          }
        end

        it do
          dir = case facts[:osfamily]
                when 'Darwin'
                  '/usr/local/etc/telegraf/telegraf.d'
                when 'windows'
                  'C:/Program Files/telegraf/telegraf.d'
                else
                  '/etc/telegraf/telegraf.d'
                end

          is_expected.to contain_file(dir + '/my_basicstats.conf').with(
            ensure: 'absent'
          )
        end
      end
    end
  end
end
