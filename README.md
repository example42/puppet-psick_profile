# psick_profile

[![Coverage Status](https://coveralls.io/repos/example42/puppet-psick_profile/badge.svg?branch=master&service=github)](https://coveralls.io/github/example42/puppet-psick_profile?branch=master)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/81f58c072b394923b760927ff1ad28ef)](https://www.codacy.com/gh/example42/puppet-psick_profile/dashboard?utm_source=github.com&utm_medium=referral&utm_content=example42/puppet-psick_profile&utm_campaign=Badge_Grade)

This module provides a collection of reusable profiles for common applications.

For most of the profiles is not needed a component module.

Prerequites for this module are example42's tp and psick modules.

## Table of Contents

1.  [Description](#description)

2.  [Setup - The basics of getting started with psick_profile](#setup)
    -   [What psick_profile affects](#what-psick_profile-affects)
    -   [Setup requirements](#setup-requirements)
    -   [Beginning with psick_profile](#beginning-with-psick_profile)

3.  [Usage - Configuration options and additional functionality](#usage)

4.  [Limitations - OS compatibility, etc.](#limitations)

5.  [Development - Guide for contributing to the module](#development)

## Description

This module manages plenty of different profiles for many common applications.
You can cherry pick which ones to use and make it cohexist with your own profiles
or with component modules.

For documentation on the specific application profiles refere to the relevant doc pages, when present:

-   [psick_profile::oracle](docs/oracle.md) - Manage Oracle prerequisites and installation

## Setup

Every psick profile can be classified and used indipendently.

You need to classify also the psick class from the psick module (which by default, without 
specific Hiera data it does nothing) in order to leverage on the general variables
set in the main psick class and used in the psick modules.

### What psick_profile affects

Every psick profile manages the relevant application.

In some cases you have the option if to use an external component module to install it
or use Tiny Puppet.

Refere to each profile documentation for more info on the managed resources.

### Setup Requirements

Psick_profile module requires:

-   example42-psick module
-   example42-tp module (which need the example42-tinydata module)

The above, of course, need stdlib, which you probably are already using:

-   puppetlabs/stdlib

According to the OS used you might need other modules:

-   puppetlabs/vcsrepo (if tp::dir define is used with vcsrepos)
-   puppetlabs/concat (might be needed in some profiles)
-   puppetlabs/chocolatey (on Windows nodes)
-   homebrew module (on Darwin nodes)

Some profiles might require an additional component modules.

Refer to [Puppetfile](docs/Puppetfile) in the docs dir for the complete reference of needed modules, in Puppetfile format.

The minimal needs, for Linux nodes are as follows:

mod 'example42-tp', latest
mod 'example42-tinydata', latest
mod 'example42-psick', latest
mod 'puppetlabs-stdlib', latest

Too many? Well this module and the above are probably enough to configure 90% of what you need to manage with Puppet ;-)

### Beginning with psick_profile

Use whatever classification approach you want and classify the psick profile you want to use.

Remember to classify the psick class as well.

Considering that psick class can be used also for classification, all you might need is something as follows:

In your control-repos' `manifests/site.pp` just classify psick for all nodes:

    node default{
      include psick
    }

An then manage everything via Hiera (refer to psick documentation for details), classification included, with something like:

    # Psick based classification for Linux nodes:
    psick::pre::linux_classes:
      puppet: psick::puppet
      hostname: psick::hostname
      hosts: psick::hosts::resource
      dns: psick::dns::resolver
      repo: psick::repo
      users: psick::users
    psick::base::linux_classes:
      ssh: psick::openssh
      sudo: psick::sudo
      time: psick::time
      sysctl: psick::sysctl
      update: psick::update
      motd: psick::motd
      selinux: psick::selinux
      limits: psick::limits
      systat: psick_profile::sar
      mail: psick_profile::postfix
      icinga: psick_profile::icinga2
      monitor_plugins: psick_profile::nagiosplugins

    # Psick based classification for Windows nodes
    psick::pre::windows_classes:
      hosts: psick::hosts::resource
      chocolatey: chocolatey
    psick::base::windows_classes:
      features: psick::windows::features
      registry: psick::windows::registry
      services: psick::windows::services
      tp: tp

    # Psick based classification for MacOS nodes
    psick::pre::darwin_classes:
      homebrew: homebrew
      puppet: psick::puppet
    psick::base::darwin_classes:
      tp: tp

Note that each of the above Hiera keys (looked up in Deep merge mode) allows you to classify classes for different OSes (Linxu, Windows, MacOS) in different stages, applied in order (pre, base, profile).

The value of each Hiera key is an hash of key values: the keys can be any string and you can use to override the classes to include at different Hiera levels.
The values are simply the classes to classify: they can be your own profiles, a componenent module class, a profile from the psick module or a profile from this module.

## Usage

Looks at the single profiles in code documentation or at the directory in docs.

## Limitations

Not all the profiles are tested or work on every OS supported by this module.

## Development

To contribute to this module open a Pull Request on GitHub, and follow the instructions there.
