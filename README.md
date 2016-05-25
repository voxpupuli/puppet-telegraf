# telegraf

[![Build Status](https://travis-ci.org/datacentred/puppet-telegraf.png?branch=master)](https://travis-ci.org/datacentred/puppet-telegraf)

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

There's a couple of fairly standard dependencies for this module, as follows:

* https://github.com/puppetlabs/puppetlabs-stdlib
* https://github.com/puppetlabs/puppetlabs-apt (on Debian / Ubuntu)

*NB:* On some apt-based distributions you'll need to ensure you have support
for TLS-enabled repos in place.  This can be achieved by installing the
`apt-transport-https` package.

### Usage

Telegraf's configuration is split into four main sections - global tags,
options specific to the agent, input plugins, and output plugins.  The
documentation for these sections is [here](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md),
and this module aims to be flexible enough to handle configuration of any of
these stanzas.

To get started, Telegraf can be installed with a very basic configuration by
just including the class:

```puppet
include ::telegraf
```

However, to customise your configuration you'll want to do something like the following:

```puppet
class { '::telegraf':
    hostname => $::hostname,
    outputs  => {
        'influxdb' => {
            'urls'     => [ "http://influxdb0.${::domain}:8086", "http://influxdb1.${::domain}:8086" ],
            'database' => 'telegraf',
            'username' => 'telegraf',
            'password' => 'metricsmetricsmetrics',
            }
        },
    inputs   => {
        'cpu' => {
            'percpu'   => true,
            'totalcpu' => true,
        },
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
    percpu: true
    totalcpu: true
  mem:
  io:
  net:
  disk:
  swap:
  system:
telegraf::outputs:
  influxdb:
    urls:
      - "http://influxdb0.%{::domain}:8086"
      - "http://influxdb1.%{::domain}:8086"
    database: 'influxdb'
    username: 'telegraf'
    password: 'telegraf'
```

To configure individual inputs, you can use `telegraf::input`.

Example 1

```puppet
telegraf::input { 'my_exec':
  plugin_type => 'exec'
  options     => {
    'commands'    => ['/usr/local/bin/my_input.py',],
    'name_suffix' => '_my_input',
    'data_format' => 'json',
  },
  require     => File['/usr/local/bin/my_input.py'],
}
```

Will create the file `/etc/telegraf/telegraf.d/my_exec.conf`:

    [[inputs.exec]]
      commands = ['/usr/local/bin/my_input.py']
      name_suffix = '_my_input'
      data_format = 'json'

Example 2

```puppet
telegraf::input { 'influxdb-dc':
  plugin_type => 'influxdb',
  options     => {
    'urls' => ['http://remote-dc:8086',],
  },
}

Will create the file `/etc/telegraf/telegraf.d/influxdb-dc.conf`:

    [[inputs.influxdb]]
      urls = ["http://remote-dc:8086"]

Example 3

```puppet
telegraf::input { 'my_snmp':
  plugin_type => 'snmp',
  options     => {
    'interval' => '60s',
  },
  sections    => {
    'snmp.host' => {
      'address'   => 'snmp_host1:161',
      'community' => 'read_only',
      'version'   => 2,
      'get_oids'  => ['1.3.6.1.2.1.1.5',],
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

## Hierarchical configuration from multiple files

Hiera YAML and JSON backends support deep hash merging which is needed for inheriting configuration from multiple files.

First of all, make sure that `gem 'deep_merge'` is installed on your Puppet master.

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
    percpu: true
    totalcpu: true
  mem:
  io:
  net:
  disk:
```
specific roles will include some extra plugins, e.g. `role/frontend.yaml`:

```yaml
telegraf::inputs:
  nginx:
    urls: ["http://localhost/server_status"]
```

## Limitations

This module has been developed and tested against:

 * Ubuntu 14.04
 * Debian 8
 * CentOS / RHEL 6
 * CentOS / RHEL 7

Support for other distributions / operating systems is planned.  Feel free to
assist with development in this regard!

The configuration generated with this module is only compatible with newer
releases of Telegraf, i.e 0.11.x.  It won't work with the 0.2.x series.

## Development

Fork, hack, test, then raise a PR.
