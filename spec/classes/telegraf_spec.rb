require 'spec_helper'

describe 'telegraf' do
  context 'Supported operating systems' do
    ['RedHat', ].each do |osfamily|
      [6,7].each do |releasenum|
        context "RedHat #{releasenum} release specifics" do
          let(:facts) {{
            :osfamily               => 'RedHat',
            :kernel                 => 'Linux',
            :operatingsystem        => osfamily,
            :operatingsystemrelease => releasenum,
            :role                   => 'telegraf'
          }}
          it { should compile.with_all_deps }
          it { should contain_class('telegraf::config') }
          it { should contain_class('telegraf::install') }
          it { should contain_class('telegraf::params') }
          it { should contain_class('telegraf::service') }
          it { should contain_class('telegraf')
            .with(
              :ensure         => '0.11.1-1',
              :interval       => '60s',
              :flush_interval => '60s',
              :global_tags    => {
                "dc"   => "dc",
                "env"  => "production",
                "role" => "telegraf",
              },
              :inputs         => {
                "cpu" => {
                  "percpu"    => true,
                  "totalcpu"  => true,
                  "fielddrop" => ["time_*"],
                },
                "disk" => {
                  "ignore_fs" => ['tmpfs','devtmpfs'],
                },
                "diskio"      => nil,
                "kernel"      => nil,
                "mem"         => nil,
                "net"         => {
                  "interfaces" => ['eth0'],
                  "drop"       => ['net_icmp'],
                },
                "netstat"     => nil,
                "ping"        => {
                  "urls"    => ['10.10.10.1'],
                  "count"   => 1,
                  "timeout" => 1.0,
                },
                "statsd"      => {
                  "service_address"          => ':8125',
                  "delete_gauges"            => false,
                  "delete_counters"          => false,
                  "delete_sets"              => false,
                  "delete_timings"           => true,
                  "percentiles"              => [90],
                  "allowed_pending_messages" => 10000,
                  "convert_names"            => true,
                  "percentile_limit"         => 1000,
                  "udp_packet_size"          => 1500,
                },
                "swap"        => nil,
                "system"      => nil,
              },
              :outputs        => {
                "influxdb" => {
                  "urls"     => ["http://influxdb.example.com:8086"],
                  "database" => 'telegraf',
                  "username" => 'telegraf',
                  "password" => 'telegraf',
                },
              },
            )
          }
          it { should contain_file('/etc/telegraf/telegraf.conf') }
          it { should contain_package('telegraf') }
          it { should contain_service('telegraf') }
          it { should contain_yumrepo('influxdata') }
        end
      end
    end
  end
end
