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

### Usage

Telegraf's configuration is split into four main sections - global tags,
options specific to the agent, input plugins, and output plugins.  The
documentation for these sections is [here](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md),
and this module aims to be flexible enough to handle configuration of any of
these stanzas.

To get started, Telegraf can be installed with a very basic configuration by
just including the class:

    include ::telegraf

However, to customise your configuration you'll want to do something like the following:

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

Or here's a Hiera-based example (which is the recommended approach):

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

To configure individual inputs, you can use `telegraf::input`

    telegraf::input { 'influxdb': 
        "options" => {
            "urls" => ["http://localhost:8086",],
        },
    }

Will create the file `/etc/telegraf/telegraf.d/influxdb.conf`

    [[inputs.influxdb]]
      urls = ["http://localhost:8086"]

    telegraf::input { 'snmp':
        options => {
            "interval" => "60s",
        },
        "sections" => {
            "snmp.host" => {
                "address"   => "snmp_host1:161",
                "community" => "read_only",
                "version"   => "2",
                "get_oids"  => ["1.3.6.1.2.1.1.5",],
            },
        },
    }

Will create the file `/etc/telegraf/telegraf.d/snmp.conf`

    [[inputs.snmp]]
      interval = "60s"

    [[inputs.snmp.host]]
      address = "snmp_host1:161"
      community = "read_only"
      version = 2
      get_oids = ["1.3.6.1.2.1.1.5"]

## Limitations

This module has been developed and tested against:

 * Ubuntu 14.04
 * Debian 8
 * CentOS / RHEL 6
 * CentOS / RHEL 7

Support for other distributions / operating systems is planned.  Feel free to
assist with development in this regard!

The configuration generated with this module is only compatible with newer
releases of Telegraf, i.e 0.10.x.  It won't work with the 0.2.x series.

## Development

Fork, hack, test, then raise a PR.
