#
class psick_profile::docker (

  Variant[Boolean,String] $ensure           = present,

  String                  $install_class    = 'psick_profile::docker::tp',

  String[1]               $username         = 'example42',

  Hash                    $options          = {},
  Hash                    $settings         = {},

  Array                   $profiles         = [],

  Array                   $allowed_users    = [],

  Boolean                 $auto_restart     = true,

  Variant[Undef,Hash]     $run              = undef,
  Variant[Undef,Hash]     $build            = undef,
  Variant[Undef,Hash]     $test             = undef,
  Variant[Undef,Hash]     $push             = undef,

  String[1]               $data_module      = 'tinydata',

  Boolean                 $manage           = $psick::manage,
  Boolean                 $noop_manage      = $psick::noop_manage,
  Boolean                 $noop_value       = $psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    $tp_settings = tp_lookup('docker-engine','settings',$data_module,'merge')
    $module_settings = $tp_settings + $settings
    if $module_settings['service_name'] and $auto_restart {
      $service_notify = "Service[${module_settings['service_name']}]"
    } else {
      $service_notify = undef
    }

    if $install_class != '' {
      contain $install_class
    }

    if $profiles != [] {
      $profiles.each |$kl| {
        contain "::psick_profile::docker::profile::${kl}"
      }
    }

    if $run {
      create_resources('psick_profile::docker::run', $run )
    }
    if $build {
      create_resources('psick_profile::docker::tp_build', $build )
    }
    if $test {
      create_resources('psick_profile::docker::test', $test )
    }
    if $push {
      create_resources('psick_profile::docker::push', $push )
    }

    $allowed_users.each | $u | {
      exec { "Add ${u} to docker":
        unless  => "grep docker /etc/group | grep ${u}",
        require => Class[$install_class],
        command => "usermod -a -G docker ${u}",
      }
    }
  }
}
