#
class psick_profile::oracle::install::testinstance {

  psick_profile::oracle::instance { 'test':
#    autostart => false,
    require   => CLass[$psick_profile::oracle::prerequisites_class],
  }

}
