# @class mysql
#
class psick_profile::mysql (

  Variant[Boolean,String]    $ensure   = present,
  Enum['psick','puppetlabs'] $module   = 'psick',

  Optional[Psick::Password]  $root_password = undef,

  Hash                       $sqlfile_hash  = {},
  Hash                       $grant_hash    = {},
  Hash                       $user_hash     = {},
  Hash                       $query_hash    = {},

  Boolean             $manage               = $psick::manage,
  Boolean             $noop_manage          = $psick::noop_manage,
  Boolean             $noop_value           = $psick::noop_value,

) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    # Intallation management
    case $module {
      'psick': {
        contain psick_profile::mysql::install
        contain psick_profile::mysql::root_password
        $user_hash.each |$k,$v| {
          psick_profile::mysql::user { $k:
            * => $v,
          }
        }
        $query_hash.each |$k,$v| {
          psick_profile::mysql::query { $k:
            * => $v,
          }
        }
        $sqlfile_hash.each |$k,$v| {
          psick_profile::mysql::sqlfile { $k:
            * => $v,
          }
        }
        $grant_hash.each |$k,$v| {
          psick_profile::mysql::grant { $k:
            * => $v,
          }
        }
      }
      default: {
        contain mysql
      }
    }
  }
}
