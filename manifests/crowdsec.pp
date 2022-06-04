# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include psick_profile::crowdsec
class psick_profile::crowdsec (
  String  $install_class    = 'psick_profile::crowdsec::tp',
  Hash    $collections_hash = {},
  Boolean $manage               = $::psick::manage,
  Boolean $noop_manage          = $::psick::noop_manage,
  Boolean $noop_value           = $::psick::noop_value,
  Optional[String] $enroll_key  = undef,
  String $enroll_name           = $facts['networking']['fqdn'],
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    if $install_class != '' {
      contain $install_class
    }

    if $enroll_key {
      # TODO: Make this more reliable (find command to check if console is enrolled)
      Service['crowdsec'] ~> Exec["cscli console enroll --name ${enroll_name}"]
      exec { "cscli console enroll --name ${enroll_name}":
        command     => "cscli console enroll --name ${enroll_name} ${enroll_key}",
        path        => $facts['path'],
        refreshonly => true,
      }
    }

    $collections_hash.each | $k,$v | {
      if $install_class != '' {
        Class[$install_class] -> Exec["crowdsec collection add ${k}"]
      }
      exec { "crowdsec collection add ${k}":
        command => "cscli collections install ${k}",
        path    => $facts['path'],
        unless  => "cscli collections list | grep ${k}",
      }
    }
  }
}
