# This class configures prerequisites resources for Oracle installation
#
# To cope with existing alternative approaches, it's possible to define the name of
# the classes to use to manage each kind of resource.
# By default no class name is specified and nothing is done.
# To enable the psick classes use (you can specify alternstive classes):
# @example
# ---
#   psick_profile::oracle::prerequisites::limits_class: 'psick_profile::oracle::prerequisites::limits'
#   psick_profile::oracle::prerequisites::sysctl_class: 'psick_profile::oracle::prerequisites::sysctl'
#   psick_profile::oracle::prerequisites::swap_class: 'psick_profile::oracle::prerequisites::swap'
#   psick_profile::oracle::prerequisites::packages_class: 'psick_profile::oracle::prerequisites::packages'
#   psick_profile::oracle::prerequisites::users_class: 'psick_profile::oracle::prerequisites::users'
#   psick_profile::oracle::prerequisites::dirs_class: 'psick_profile::oracle::prerequisites::dirs'
#
class psick_profile::oracle::prerequisites (
  Optional[String] $limits_class   = undef,
  Optional[String] $sysctl_class   = undef,
  Optional[String] $swap_class     = undef,
  Optional[String] $packages_class = undef,
  Optional[String] $users_class    = undef,
  Optional[String] $dirs_class     = undef,
  Boolean $manage                  = $::psick::manage,
  Boolean $noop_manage             = $::psick::noop_manage,
  Boolean $noop_value              = $::psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    if $limits_class and $limits_class != '' { contain $limits_class }
    if $sysctl_class and $sysctl_class != '' { contain $sysctl_class }
    if $swap_class and $swap_class != '' { contain $swap_class }
    if $packages_class and $packages_class != '' { contain $packages_class }
    if $users_class and $users_class != '' { contain $users_class }
    if $dirs_class and $dirs_class != '' { contain $dirs_class }
  }
}
