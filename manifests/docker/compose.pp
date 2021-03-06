# == Class: psick_profile::docker::compose
#
# Class to install Docker Compose using the recommended curl command.
# Original source: https://github.com/garethr/garethr-docker/blob/master/manifests/compose.pp
#
# === Parameters
#
# [*ensure*]
#   Whether to install or remove Docker Compose
#   Valid values are absent present
#   Defaults to present
#
# [*version*]
#   The real_version of Docker Compose to install.
#
class psick_profile::docker::compose (
  Variant[Boolean,String]  $ensure           = present,
  Hash                     $options          = {},
  Variant[Undef,String[1]] $template         = undef,
  String                   $version          = '',

  Boolean          $manage               = $psick::manage,
  Boolean          $noop_manage          = $psick::noop_manage,
  Boolean          $noop_value           = $psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    include psick_profile::docker

    $real_version = $version ? {
      ''      => $psick_profile::docker::module_settings['compose_version'],
      default => $version,
    }

    if $ensure == 'present' {
      exec { "Install Docker Compose ${real_version}":
        path    => '/usr/bin/',
        cwd     => '/tmp',
        command => "curl -s -L https://github.com/docker/compose/releases/download/${real_version}/docker-compose-${facts['kernel']}-x86_64 > /usr/local/bin/docker-compose-${real_version}",
        creates => "/usr/local/bin/docker-compose-${real_version}",
      }
      -> file { "/usr/local/bin/docker-compose-${real_version}":
        owner => 'root',
        mode  => '0755',
      }
      -> file { '/usr/local/bin/docker-compose':
        ensure => 'link',
        target => "/usr/local/bin/docker-compose-${real_version}",
      }
    } else {
      file { [
          "/usr/local/bin/docker-compose-${real_version}",
          '/usr/local/bin/docker-compose',
        ]:
          ensure => absent,
      }
    }
  }
}
