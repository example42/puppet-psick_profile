# @class openswan
#
class psick_profile::openswan (

  Psick::Ensure   $ensure                   = 'present',

  String                     $module        = 'psick_profile',

  Hash                       $connections    = {},
  Hash                       $setup_options  = {},
  String                     $setup_template = 'psick_profile/openswan/ipsec.conf.erb',

  Boolean          $manage               = $::psick::manage,
  Boolean          $noop_manage          = $::psick::noop_manage,
  Boolean          $noop_value           = $::psick::noop_value,
) {

  # We declare resources only if $manage = true
  if $manage {

    if $noop_manage {
      noop($noop_value)
    }

    case $module {
      'psick_profile': {
        contain ::psick_profile::openswan::install
      }
      default: {
        contain ::openswan
      }
    }
    $connections.each |$k,$v| {
      psick_profile::openswan::connection { $k:
        * => $v,
      }
    }

    if $setup_template != '' {
      $content = template($setup_template)
      tp::conf { 'openswan':
        content => $content,
      }
    }
  }
}
