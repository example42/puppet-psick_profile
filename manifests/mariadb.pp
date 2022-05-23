# @class mariadb
#
class psick_profile::mariadb (

  Variant[Boolean,String]    $ensure = present,
  Enum['psick']              $module = 'psick',

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
        contain psick_profile::mariadb::tp
        contain psick_profile::mariadb::root_password
        $user_hash.each |$k,$v| {
          psick_profile::mariadb::user { $k:
            * => $v,
          }
        }
        $query_hash.each |$k,$v| {
          psick_profile::mariadb::query { $k:
            * => $v,
          }
        }
        $sqlfile_hash.each |$k,$v| {
          psick_profile::mariadb::sqlfile { $k:
            * => $v,
          }
        }
        $grant_hash.each |$k,$v| {
          psick_profile::mariadb::grant { $k:
            * => $v,
          }
        }
      }
      default: {
        contain mariadb
      }
    }
  }
}
