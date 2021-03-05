require 'spec_helper'

describe 'telegraf' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

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
          flush_interval: '60s',
          global_tags: {
            'dc'   => 'dc',
            'env'  => 'production',
            'role' => 'telegraf'
          },
          inputs: [{
            'cpu' => [{
              'percpu'    => true,
              'totalcpu'  => true,
              'fielddrop' => ['time_*']
            }],
            'disk' => [{
              'ignore_fs' => %w[tmpfs devtmpfs]
            }],
            'diskio'      => [{}],
            'kernel'      => [{}],
            'exec'        => [
              {
                'commands' => ['who | wc -l']
              },
              {
                'commands' => ["cat /proc/uptime | awk '{print $1}'"]
              }
            ],
            'mem'         => [{}],
            'net'         => [{
              'interfaces' => ['eth0'],
              'drop'       => ['net_icmp']
            }],
            'netstat'     => [{}],
            'ping'        => [{
              'urls'    => ['10.10.10.1'],
              'count'   => 1,
              'timeout' => 1.0
            }],
            'statsd' => [{
              'service_address'          => ':8125',
              'delete_gauges'            => false,
              'delete_counters'          => false,
              'delete_sets'              => false,
              'delete_timings'           => true,
              'percentiles'              => [90],
              'allowed_pending_messages' => 10_000,
              'convert_names'            => true,
              'percentile_limit'         => 1000,
              'udp_packet_size'          => 1500
            }],
            'swap'        => [{}],
            'system'      => [{}]
          }],
          outputs: [{
            'influxdb' => [{
              'urls'     => ['http://influxdb.example.com:8086'],
              'database' => 'telegraf',
              'username' => 'telegraf',
              'password' => 'telegraf'
            }]
          }]
        )
      end
      case facts[:osfamily]
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
            archive_version: '1.17.2'
          )
        end
      when 'Suse'
        it do
          is_expected.to contain_class('telegraf').with(
            config_file_mode: '0640',
            config_folder_mode: '0770',
            repo_location: 'https://repos.influxdata.com/',
            archive_install_dir: '/opt/telegraf',
            archive_location: 'https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz'
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

      case facts[:kernel]
      when 'windows'
        it { is_expected.to contain_file('C:/Program Files/telegraf/telegraf.conf') }
        it {
          is_expected.to contain_file('C:/Program Files/telegraf/telegraf.d').
            with_purge(false)
        }
      when 'Darwin'
        it { is_expected.to contain_file('/usr/local/etc/telegraf/telegraf.conf') }
        it {
          is_expected.to contain_file('/usr/local/etc/telegraf/telegraf.d').
            with_purge(false)
        }
      else
        it { is_expected.to contain_file('/etc/telegraf/telegraf.conf') }
        it {
          is_expected.to contain_file('/etc/telegraf/telegraf.d').
            with_purge(false)
        }
      end
      case facts[:osfamily]
      when 'Suse'
        it { is_expected.to contain_archive('/tmp/telegraf.tar.gz') }
        it { is_expected.to contain_file('/etc/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/opt/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/var/log/telegraf').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/systemd/system/telegraf.service') }
      when 'Darwin'
        it { is_expected.to contain_archive('/tmp/telegraf-1.17.2.tar.gz') }
        it { is_expected.to contain_file('/usr/local/bin').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/etc').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/opt').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var/log').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/opt/telegraf-1.17.2').with_ensure('directory') }
        it { is_expected.to contain_file('/usr/local/var/log/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/usr/local/bin/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/usr/local/etc/telegraf').with_ensure('link') }
        it { is_expected.to contain_file('/Library/LaunchDaemons/telegraf.plist') }
      else
        it { is_expected.to contain_package('telegraf') }
      end
      it { is_expected.to contain_service('telegraf') }
      case facts[:osfamily]
      when 'RedHat'
        it {
          is_expected.to contain_yumrepo('influxdata').
            with(
              baseurl: "https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable"
            )
        }
      end

      case facts[:osfamily]
      when 'Darwin', 'Suse'
        it { is_expected.to contain_user('telegraf') }
        it { is_expected.to contain_group('telegraf') }
      end

      describe 'allow custom repo_type' do
        let(:params) { { repo_type: 'unstable' } }

        case facts[:osfamily]
        when 'RedHat'
          it {
            is_expected.to contain_yumrepo('influxdata').
              with(
                baseurl: "https://repos.influxdata.com/rhel/\$releasever/\$basearch/unstable"
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
          case facts[:osfamily]
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
          case facts[:osfamily]
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
    end
  end
end
