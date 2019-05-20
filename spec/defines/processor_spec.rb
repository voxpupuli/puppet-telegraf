require 'spec_helper'

describe 'telegraf::processor' do
  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'my_regex' do
        let(:title) { 'my_regex' }
        let(:params) do
          {
            plugin_type: 'regex',
            options: [
              {
                'tags' => [
                  {
                    'key'         => 'foo',
                    'pattern'     => %r{^a*b+\d$}.source,
                    'replacement' => 'c${1}d'
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

        describe 'configuration file /etc/telegraf/telegraf.d/my_regex.conf processor' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[\[processors.regex\]\]})
            is_expected.to contain_file(filename).with_content(%r{key = "foo"})
            is_expected.to contain_file(filename).with_content(%r{pattern = "\^a\*b\+\\\\d\$"})
            is_expected.to contain_file(filename).with_content(%r{replacement = "c\$\{1\}d"})
          end

          it 'requires telegraf to be installed' do
            is_expected.to contain_file(filename).that_requires('Class[telegraf::install]')
          end

          it 'notifies the telegraf daemon' do
            is_expected.to contain_file(filename).that_notifies('Class[telegraf::service]')
          end
        end
      end

      context 'my_enum' do
        let(:title) { 'my_enum' }
        let(:params) do
          {
            plugin_type: 'enum',
            options: [
              {
                'mapping' => [
                  {
                    'field'          => 'status',
                    'dest'           => 'status_code',
                    'value_mappings' => {
                      'green' => 1,
                      'amber' => 2,
                      'red'   => 3
                    }
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

        describe 'configuration file /etc/telegraf/telegraf.d/my_enum.conf processor with sections' do
          it 'is declared with the correct content' do
            is_expected.to contain_file(filename).with_content(%r{\[\[processors.enum\]\]})
            is_expected.to contain_file(filename).with_content(%r{\[\[processors.enum.mapping\]\]})
            is_expected.to contain_file(filename).with_content(%r{field = "status"})
            is_expected.to contain_file(filename).with_content(%r{dest = "status_code"})
            is_expected.to contain_file(filename).with_content(%r{\[processors.enum.mapping.value_mappings\]})
            is_expected.to contain_file(filename).with_content(%r{green = 1})
            is_expected.to contain_file(filename).with_content(%r{amber = 2})
            is_expected.to contain_file(filename).with_content(%r{red = 3})
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
