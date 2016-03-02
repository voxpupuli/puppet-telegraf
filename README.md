# telegraf

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Overview

A Puppet module to manage configuration of [InfluxData's Telegraf](https://influxdata.com/time-series-platform/telegraf/) 
metrics collection agent.

## Setup

There's a couple of fairly standard dependencies for this module, as follows:

* https://github.com/puppetlabs/puppetlabs-apt
* https://github.com/puppetlabs/puppetlabs-stdlib

### Usage

Telegraf can be installed with a very basic configuration by just including the
class:

    include ::telegraf

However, you'll probably want to override the default settings with a useful
set of 'inputs' and 'outputs'.  The general recommendation is to use Hiera,
populated with something such as the following:

	telegraf::global_tags:
	  role: "%{::role}"
	  domain: "%{::domain}"
	telegraf::outputs:
	  influxdb:
	    urls: '["https://influxdb0.vagrant.dev:8086"]'
	    database: 'telegraf'
	    username: 'test'
	    password: 'test'
	telegraf::inputs:
	  cpu:
	    percpu: true
	    totalcpu: true
	  mem:
	  io:
	  net:
	  disk: 
	    ignore_fs: '["tmpfs", "devtmpfs"]'
	  diskio:
	  swap:
	  system:

## Limitations

This module has been developed and tested against both Ubuntu 14.04 and Debian
8.2, although support for other distributions / operating systems is planned.
Feel free to assist with development in this regard!

The configuration generated with this module is only compatible with newer
releases of Telegraf, i.e 0.10.x.  It won't work with the 0.2.x series.

## Development

Fork, hack, test, raise a PR.
