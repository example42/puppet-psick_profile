# This class installs Varant using the unibet/vagrant module
#
# @param version The Vagrant version to install
# @param plugins An array of Vagrant plugins to install
# @param default_plugins An array of Vagrant plugins installed by default
# @param The user to use for plugins installation
#
class psick_profile::vagrant (
  Psick::Ensure $version = undef,
  Array $plugins         = [],
  Array $default_plugins = ['vagrant-vbguest' ,  'vagrant-cachier'],
  String $user           = 'root',

  String $module         = 'psick_profile',
  Boolean $manage        = $::psick::manage,
  Boolean $noop_manage   = $::psick::noop_manage,
  Boolean $noop_value    = $::psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    # Intallation management
    case $module {
      'psick_profile': {
        class { 'psick_profile::vagrant::tp':
          ensure => $version,
        }
      }
      default: {
        class { 'vagrant':
          version => $version,
        }
        $all_plugins = $default_plugins + $plugins

        $all_plugins.each | $plugin | {
          ::vagrant::plugin { $plugin:
            user => $user,
          }
        }
      }
    }
  }
}
