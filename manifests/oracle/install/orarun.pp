#
class psick_profile::oracle::install::orarun (
  $version               = $psick_profile::oracle::params::version_short,
  $version_short         = $psick_profile::oracle::params::version_short,
  $oracle_base           = $psick_profile::oracle::params::oracle_base,
  $oracle_home           = $psick_profile::oracle::params::oracle_home,
  $download_dir          = $psick_profile::oracle::params::download_dir,

  $oracle_user           = $psick_profile::oracle::params::oracle_user,
  $oracle_group          = $psick_profile::oracle::params::oracle_group,

  $oracle_sid            = 'orcl', # TODO Paramtrize better
  $sysconfig_template    = 'psick_profile/oracle/orarun/sysconfig.erb',
  $psick_template        = 'psick_profile/oracle/orarun/psick.erb',

  Boolean $manage        = $::psick::manage,
  Boolean $noop_manage   = $::psick::noop_manage,
  Boolean $noop_value    = $::psick::noop_value,

) inherits psick_profile::oracle::params {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    package { 'orarun': }
    file { '/etc/sysconfig/oracle':
      ensure  => file,
      content => template($sysconfig_template),
    }
    file { '/etc/psick.d/oracle.sh':
      ensure  => file,
      content => template($psick_template),
    }

    contain $psick_profile::oracle::prerequisites::users_class
  }
}
