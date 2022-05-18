#
class psick_profile::docker::run_examples (
  Variant[Boolean,String] $ensure             = present,
  Enum['command','service'] $default_run_mode = command,

  Boolean          $manage               = $psick::manage,
  Boolean          $noop_manage          = $psick::noop_manage,
  Boolean          $noop_value           = $psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    include psick_profile::docker

    Psick::Docker::Run {
      ensure   => $ensure,
      require  => Class['psick_profile::docker'],
      run_mode => $default_run_mode,
    }
    # Run, in command mode, a container based on official jenkins image
    ::psick_profile::docker::run { 'jenkins':
      image       => 'jenkins',
      run_options => '-p 8080:8080 -p 50000:50000',
    }

    # Run a local image built with docker::push
    #  ::psick_profile::docker::run { 'puppet-agent':
    #  }
    #  ::psick_profile::docker::run { 'apache':
    #  }

    # Run, in service mode (an init file is created and a service started), an official redis instance
    ::psick_profile::docker::run { 'redis':
      image          => 'redis',
      # run_mode     => 'service',
      container_name => 'official_redis',
    }

    ::psick_profile::docker::run { 'registry':
      image          => 'registry',
      repository_tag => '2.4.0',
      run_options    => '-p 5000:5000',
    }

    ::psick_profile::docker::run { 'admiral':
      image       => 'vmware/admiral',
      run_mode    => 'service',
      run_options => '-p 8282:8282',
    }
  }
}
