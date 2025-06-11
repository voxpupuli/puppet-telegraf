# frozen_string_literal: true

require 'spec_helper'

describe 'telegraf' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:config_dir) do
        case facts[:os]['family']
        when 'Darwin'
          '/usr/local/etc/telegraf'
        when 'FreeBSD'
          '/usr/local/etc'
        when 'windows'
          'C:/Program Files/telegraf'
        else
          '/etc/telegraf'
        end
      end
      let(:main_config) { "#{config_dir}/telegraf.conf" }

      context 'default include'
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('telegraf::config') }
      it { is_expected.to contain_class('telegraf::install') }
      it { is_expected.to contain_class('telegraf::params') }
      it { is_expected.to contain_class('telegraf::service') }

      it do
        is_expected.to contain_class('telegraf').with(
          ensure: '1.3.5-1',
          interval: '60s',
          metric_batch_size: '1000',
          metric_buffer_limit: '10000',
          logfile_rotation_interval: '0h',
          logfile_rotation_max_size: '0MB',
          logfile_rotation_max_archives: 5,
          flush_interval: '60s',
          global_tags: {
            'dc' => 'dc',
            'env' => 'production',
            'role' => 'telegraf'
          },
          inputs: [{
            'cpu' => [{
              'percpu' => true,
              'totalcpu' => true,
              'fielddrop' => ['time_*']
            }],
            'disk' => [{
              'ignore_fs' => %w[tmpfs devtmpfs]
            }],
            'diskio' => [{}],
            'kernel' => [{}],
            'exec' => [
              {
                'commands' => ['who | wc -l']
              },
              {
                'commands' => ["cat /proc/uptime | awk '{print $1}'"]
              }
            ],
            'mem' => [{}],
            'net' => [{
              'interfaces' => ['eth0'],
              'drop' => ['net_icmp']
            }],
            'netstat' => [{}],
            'ping' => [{
              'urls' => ['10.10.10.1'],
              'count' => 1,
              'timeout' => 1.0
            }],
            'statsd' => [{
              'service_address' => ':8125',
              'delete_gauges' => false,
              'delete_counters' => false,
              'delete_sets' => false,
              'delete_timings' => true,
              'percentiles' => [90],
              'allowed_pending_messages' => 10_000,
              'convert_names' => true,
              'percentile_limit' => 1000,
              'udp_packet_size' => 1500
            }],
            'swap' => [{}],
            'system' => [{}]
          }],
          outputs: [{
            'influxdb' => [{
              'urls' => ['http://influxdb.example.com:8086'],
              'database' => 'telegraf',
              'username' => 'telegraf',
              'password' => 'telegraf'
            }]
          }],
          processors: [{
            'rename_processor' => {
              'plugin_type' => 'rename',
              'options' => [{
                'order' => 1,
                'namepass' => ['diskio'],
                'replace' => { 'tag' => 'foo', 'dest' => 'bar' }
              }]
            }
          }]
        )
      end

      case facts[:os]['family']
      when 'windows'
        it do
          is_expected.to contain_class('telegraf').without(
            %w[
              config_file_mode
              config_folder_mode
              archive_install_dir
              archive_location
              archive_version
              repo_location
              service_restart
            ]
          )
        end
      when 'Darwin'
        it do
          is_expected.to contain_class('telegraf').with(
            config_file_mode: '0640',
            config_folder_mode: '0770',
            archive_install_dir: '/usr/local/opt/telegraf',
            archive_version: '1.29.4'
          )
        end
      when 'FreeBSD'
        it do
          is_expected.to contain_class('telegraf').with(
            config_file_mode: '0640',
            config_folder_mode: '0770'
          )
        end
      when 'Suse'
        it do
          is_expected.to contain_class('telegraf').with(
            config_file_mode: '0640',
            config_folder_mode: '0770',
            repo_location: 'https://repos.influxdata.com/',
            archive_install_dir: '/opt/telegraf',
            archive_location: 'https://dl.influxdata.com/telegraf/releases/telegraf-1.29.4_linux_amd64.tar.gz'
          )
        end
      else
        it do
          is_expected.to contain_class('telegraf').with(
            config_file_mode: '0640',
            config_folder_mode: '0770',
            repo_location: 'https://repos.influxdata.com/'
          )
        end

        it do
          is_expected.to contain_class('telegraf').without(
            %w[
              archive_install_dir
              archive_location
              archive_version
            ]
          )
        end
      end

      it { is_expected.to contain_telegraf__processor('rename_processor') }
      it { is_expected.to contain_file(main_config).with_ensure('file') }

      it {
        is_expected.to contain_file("#{config_dir}/telegraf.d").
          with_purge(false)
      }

      it {
        is_expected.to contain_file("#{config_dir}/telegraf.d/rename_processor.conf"). \
          with_content(<<~STRING
            [[processors.rename]]
            namepass = ["diskio"]
            order = 1
            [processors.rename.replace]
            dest = "bar"
            tag = "foo"
          STRING
                      )
      }

      case facts[:os]['family']
      when 'Suse'
        it { is_expected.to contain_archive('/tmp/telegraf.tar.gz') }
        it { is_expected.to contain_file('/etc/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/opt/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/var/log/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/systemd/system/telegraf.service') }
      when 'Darwin'
        it { is_expected.to contain_archive('/tmp/telegraf-1.29.4.tar.gz') }
        it { is_expected.to contain_file('/usr/local/bin').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/etc').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/opt').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var/log').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/opt/telegraf-1.29.4').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var/log/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/usr/local/bin/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/usr/local/etc/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/Library/LaunchDaemons/telegraf.plist') }
      else
        it { is_expected.to contain_package('telegraf') }
      end
      it { is_expected.to contain_service('telegraf') }

      case facts[:os]['family']
      when 'RedHat'
        it {
          is_expected.to contain_yumrepo('influxdata').
            with(
              baseurl: 'https://repos.influxdata.com/rhel/$releasever/$basearch/stable'
            )
        }
      end

      case facts[:os]['family']
      when 'Darwin', 'Suse'
        it { is_expected.to contain_user('telegraf') }
        it { is_expected.to contain_group('telegraf') }
      end

      describe 'allow custom repo_type' do
        let(:params) { { repo_type: 'unstable' } }

        case facts[:os]['family']
        when 'RedHat'
          it {
            is_expected.to contain_yumrepo('influxdata').
              with(
                baseurl: 'https://repos.influxdata.com/rhel/$releasever/$basearch/unstable'
              )
          }
        end
      end

      describe 'manage repo' do
        let(:pre_condition) do
          'class {"telegraf": manage_repo => true}'
        end

        it do
          is_expected.to compile.with_all_deps
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_apt__source('influxdata')
            is_expected.to contain_class('apt::update').that_comes_before('Package[telegraf]')
            is_expected.to contain_package('telegraf')
          when 'RedHat'
            is_expected.to contain_yumrepo('influxdata').that_comes_before('Package[telegraf]')
            is_expected.to contain_package('telegraf')
          when 'windows'
            is_expected.to compile.with_all_deps
            is_expected.to contain_package('telegraf')
          end
        end
      end

      describe 'do not manage repo' do
        let(:pre_condition) do
          [
            'class {"telegraf": manage_repo => false}',
          ]
        end

        it do
          case facts[:os]['family']
          when 'Debian'
            is_expected.to compile.with_all_deps
            is_expected.to contain_package('telegraf')
            is_expected.not_to contain_apt__source('influxdata')
          when 'RedHat'
            is_expected.to compile.with_all_deps
            is_expected.to contain_package('telegraf')
            is_expected.not_to contain_yumrepo('influxdata')
          when 'windows'
            is_expected.to compile.with_all_deps
            is_expected.to contain_package('telegraf')
          end
        end
      end

      # These next two blocks cover cases where manage_repo and manage_archive are set to something other than the defaults
      describe 'manage archive and do not manage repo' do
        let(:pre_condition) do
          <<-PRE_COND
          class{ 'telegraf':
            manage_repo => false,
            manage_archive => true,
            manage_user => true,
            archive_install_dir => '/opt/telegraf',
            archive_location => "https://dl.influxdata.com/telegraf/releases/telegraf-1.22.2_linux_amd64.tar.gz",
          }
          PRE_COND
        end

        it {
          case facts[:os]['family']
          when 'RedHat'
            is_expected.to compile
            is_expected.to contain_archive('/tmp/telegraf.tar.gz')
            is_expected.to contain_file('/etc/telegraf').with_ensure('directory')
            is_expected.to contain_file('/opt/telegraf').with_ensure('directory')
            is_expected.to contain_file('/var/log/telegraf').with_ensure('directory')
            is_expected.to contain_file('/etc/systemd/system/telegraf.service')
          when 'Debian'
            is_expected.to contain_notify('telegraf archive warn').with(loglevel: 'warning')
          end
        }
      end

      describe 'manage repo and do not manage archive' do
        let(:pre_condition) do
          <<-PRE_COND
          class{ 'telegraf':
            manage_repo => true,
            manage_archive => false,
          }
          PRE_COND
        end

        it {
          case facts[:os]['family']
          when 'Suse', 'Darwin'
            is_expected.to compile
            is_expected.to contain_notify('telegraf repo warn').with(loglevel: 'warning')
          end
        }
      end

      describe 'with ensure absent' do
        let(:pre_condition) do
          [
            'class {"telegraf": ensure => absent}',
          ]
        end

        it do
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_package('telegraf').with(ensure: 'absent')
            is_expected.to contain_apt__source('influxdata').with(
              ensure: 'absent'
            )
          when 'RedHat'
            is_expected.to contain_package('telegraf').with(ensure: 'absent')
            is_expected.to contain_yumrepo('influxdata').with(ensure: 'absent')

          when 'windows'
            is_expected.to contain_package('telegraf').with(ensure: 'absent')
          end

          is_expected.to contain_file(main_config).with(
            ensure: 'absent'
          )

          is_expected.to contain_file("#{config_dir}/telegraf.d").with(
            ensure: 'absent',
            force: true
          )

          is_expected.not_to contain_service('telegraf')
        end
      end
    end
  end
end
