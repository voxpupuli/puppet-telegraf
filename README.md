# telegraf puppet module

[![License](https://img.shields.io/github/license/voxpupuli/puppet-telegraf.svg)](https://github.com/voxpupuli/puppet-telegraf/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-telegraf.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-telegraf)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/telegraf.svg)](https://forge.puppetlabs.com/puppet/telegraf)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/telegraf.svg)](https://forge.puppetlabs.com/puppet/telegraf)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/telegraf.svg)](https://forge.puppetlabs.com/puppet/telegraf)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/telegraf.svg)](https://forge.puppetlabs.com/puppet/telegraf)

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Overview

A reasonably simple yet flexible Puppet module to manage configuration of
[InfluxData's Telegraf](https://influxdata.com/time-series-platform/telegraf/) metrics collection agent.

## Setup

This module has the following dependencies:

* https://github.com/puppetlabs/puppetlabs-stdlib
* https://github.com/puppetlabs/puppetlabs-apt (on Debian / Ubuntu)

*NB:* On some apt-based distributions you'll need to ensure you have support
for TLS-enabled repos in place.  This can be achieved by installing the
`apt-transport-https` package.

This module **requires** the [toml-rb](https://github.com/eMancu/toml-rb) gem. Either install the gem using puppet's native gem provider, [puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/puppetserver_gem), [pe_gem](https://forge.puppetlabs.com/puppetlabs/pe_gem), [pe_puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/pe_puppetserver_gem), or manually using one of the following methods:
```
  # apply or puppet-master
  gem install toml-rb
  # PE apply
  /opt/puppetlabs/puppet/bin/gem install toml-rb
  # AIO or PE puppetserver
  /opt/puppet/bin/puppetserver gem install toml-rb
```

In addition, for Windows, the following dependencies must be met:

* Chocolatey installed
* [`chocolatey/chocolatey`](https://forge.puppet.com/chocolatey/chocolatey) OR [`puppetlabs/chocolatey`](https://forge.puppet.com/puppetlabs/chocolatey)
  * **Note:** either or both of these modules can handle ensuring the install of Chocolatey.

### Usage

Telegraf's configuration is split into four main sections - global tags,
options specific to the agent, input plugins, and output plugins.  The
documentation for these sections is [here](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md),
and this module aims to be flexible enough to handle configuration of any of
these stanzas.

To get started, Telegraf can be installed with a very basic configuration by
just including the class:

```puppet
include telegraf
```

However, to customise your configuration you'll want to do something like the following:

```puppet
class { 'telegraf':
    hostname => $facts['hostname'],
    outputs  => {
        'influxdb' => [
            {
                'urls'     => [ "http://influxdb0.${facts['domain']}:8086", "http://influxdb1.${facts['domain']}:8086" ],
                'database' => 'telegraf',
                'username' => 'telegraf',
                'password' => 'metricsmetricsmetrics',
            }
        ]
    },
    inputs   => {
        'cpu' => [
            {
                'percpu'   => true,
                'totalcpu' => true,
            }
        ]
    }
}
```

Or here's a Hiera-based example (which is the recommended approach):

```yaml
---
telegraf::global_tags:
  role: "%{::role}"
  hostgroup: "%{::hostgroup}"
  domain: "%{::domain}"
telegraf::inputs:
  cpu:
    - percpu: true
      totalcpu: true
  exec:
    - commands:
        - who | wc -l
    - commands:
        - cat /proc/uptime | awk '{print $1}'
  mem: [{}]
  io: [{}]
  net: [{}]
  disk: [{}]
  swap: [{}]
  system: [{}]
telegraf::outputs:
  influxdb:
    - urls:
        - "http://influxdb0.%{::domain}:8086"
        - "http://influxdb1.%{::domain}:8086"
      database: 'influxdb'
      username: 'telegraf'
      password: 'telegraf'
```

`telegraf::inputs` accepts a hash of any inputs that you'd like to configure. However, you can also optionally define individual inputs using the `telegraf::input` type - this suits installations where, for example, a core module sets the defaults and other modules import it.

Example 1:

```puppet
telegraf::input { 'my_exec':
  plugin_type => 'exec',
  options     => [{
    'commands'    => ['/usr/local/bin/my_input.py',],
    'name_suffix' => '_my_input',
    'data_format' => 'json',
  }],
  require     => File['/usr/local/bin/my_input.py'],
}
```

Will create the file `/etc/telegraf/telegraf.d/my_exec.conf`:

    [[inputs.exec]]
      commands = ['/usr/local/bin/my_input.py']
      name_suffix = '_my_input'
      data_format = 'json'

Example 2:

```puppet
telegraf::input { 'influxdb-dc':
  plugin_type => 'influxdb',
  options     => [
    {'urls' => ['http://remote-dc:8086',],},
  ],
}
```

Will create the file `/etc/telegraf/telegraf.d/influxdb-dc.conf`:

```
[[inputs.influxdb]]
  urls = ["http://remote-dc:8086"]
```

Example 3:

```puppet
telegraf::input { 'my_snmp':
  plugin_type    => 'snmp',
  options        => {
    'interval' => '60s',
    'host' => [
      {
        'address'   => 'snmp_host1:161',
        'community' => 'read_only',
        'version'   => 2,
        'get_oids'  => ['1.3.6.1.2.1.1.5',],
      }
    ],
    'tags' => {
      'environment' => 'development',
    },
  },
}
```

Will create the file `/etc/telegraf/telegraf.d/snmp.conf`:

    [[inputs.snmp]]
      interval = "60s"

    [[inputs.snmp.host]]
      address = "snmp_host1:161"
      community = "read_only"
      version = 2
      get_oids = ["1.3.6.1.2.1.1.5"]

    [inputs.snmp.tags]
      environment = "development"

Example 4:

Outputs, Processors and Aggregators are available in the same way:

```puppet
telegraf::output { 'my_influxdb':
  plugin_type => 'influxdb',
  options     => [
    {
      'urls'     => [ "http://influxdb.example.come:8086"],
      'database' => 'telegraf',
      'username' => 'telegraf',
      'password' => 'metricsmetricsmetrics',
    }
  ]
}

telegraf::processor { 'my_regex':
  plugin_type => 'regex',
  options     => [
    {
      tags => [
        {
          key         => 'foo',
          pattern     => String(/^a*b+\d$/),
          replacement => 'c${1}d',
        }
      ]
    }
  ]
}

telegraf::aggregator { 'my_basicstats':
  plugin_type => 'basicstats',
  options     => [
    {
      period        => '30s',
      drop_original => false,
    },
  ],
}

```

Example 5:

```puppet
class { 'telegraf':
    ensure              => '1.0.1',
    hostname            => $facts['hostname'],
    windows_package_url => http://internal_repo:8080/chocolatey,
}
```

Will install telegraf version 1.0.1 on Windows using an internal chocolatey repo

## Hierarchical configuration from multiple files

Hiera YAML and JSON backends support [deep hash merging](https://docs.puppet.com/hiera/3.1/configuring.html#mergebehavior) which is needed for inheriting configuration from multiple files.

First of all, make sure that the `deep_merge` gem is installed on your Puppet Master.

An example of `hiera.yaml`:

```yaml
---
:hierarchy:
    - "roles/%{role}"
    - "type/%{virtual}"
    - "domain/%{domain}"
    - "os/%{osfamily}"
    - "common"
:backends:
    - yaml
:yaml:
    :datadir: /etc/puppet/hiera
:merge_behavior: deeper
```

Then you can define configuration shared for all `physical` servers and place it into `type/physical.yaml`:

```yaml
telegraf::inputs:
  cpu:
    - percpu: true
      totalcpu: true
  mem: [{}]
  io: [{}]
  net: [{}]
  disk: [{}]
```

Specific roles will include some extra plugins, e.g. `role/frontend.yaml`:

```yaml
telegraf::inputs:
  nginx:
    - urls: ["http://localhost/server_status"]
```

## Limitations

The latest version (2.0) of this module requires Puppet 4 or newer.  If you're looking for support under Puppet 3.x, then you'll want to make use of [an older release](https://github.com/yankcrime/puppet-telegraf/releases/tag/1.5.0).

Furthermore, the introduction of toml-rb means that Ruby 1.9 or newer is also a requirement.

This module has been developed and tested against:

 * Ubuntu 14.04
 * Ubuntu 16.04
 * Debian 8
 * CentOS / RHEL 6
 * CentOS / RHEL 7
 * Windows 2008, 2008 R2, 2012, 2012 R2

Support for other distributions / operating systems is planned.  Feel free to assist with development in this regard!

The configuration generated with this module is only compatible with newer releases of Telegraf, i.e 0.11.x.  It won't work with the 0.2.x series.

## Development

Please fork this repository, hack away on your branch, run the tests:

```shell
$ bundle exec rake test acceptance
```

And then submit a pull request.  [Succinct, well-described and atomic commits preferred](http://chris.beams.io/posts/git-commit/).
