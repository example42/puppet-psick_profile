#
class psick_profile::docker::builder (

  Variant[Boolean,String] $ensure              = present,
  Hash                    $images              = {},

  Variant[Undef,String]   $template            = 'psick/docker/Dockerfile.erb',
  String[1]               $workdir             = '/var/tmp/dockerfiles',

  Variant[Undef,String]   $maintainer          = undef,
  String                  $from                = '',

  Variant[Undef,String]   $default_image_os        = downcase($facts['os']['name']),
  Variant[Undef,String]   $default_image_osversion = $facts['os']['release']['major'],

  Variant[Undef,String]   $repository_tag      = undef,

  Variant[Undef,Array]    $exec_environment    = [],
  Variant[Boolean,Pattern[/on_failure/]] $exec_logoutput = 'on_failure',

  Boolean                 $always_build        = false,
  String                  $build_options       = '',
  Pattern[/command|supervisor/] $command_mode  = 'supervisor',

  Boolean                 $mount_data_dir      = true,
  Boolean                 $mount_log_dir       = true,

  Boolean                 $push                = false,

  Boolean                $manage               = $psick::manage,
  Boolean                $noop_manage          = $psick::noop_manage,
  Boolean                $noop_value           = $psick::noop_value,

) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    include psick_profile::docker

    $real_repository_tag=$repository_tag ? {
      undef   => "${default_image_os}-${default_image_osversion}",
      default => $repository_tag,
    }
    $images.each |$image,$opts| {
      psick_profile::docker::tp_build { $image:
        ensure           => pick_default($opts['ensure'],$ensure),
        template         => pick_default($opts['template'],$template),
        workdir          => pick_default($opts['workdir'],$workdir),
        username         => pick_default($opts['username'],$::docker::username),
        image_os         => pick_default($opts['image_os'],$default_image_os),
        image_osversion  => pick($opts['image_osversion'],$default_image_osversion),
        maintainer       => pick($opts['maintainer'],$maintainer),
        from             => pick_default($opts['from'],$from),
        repository       => pick($opts['repository'],$image),
        repository_tag   => pick($opts['repository_tag'],$real_repository_tag),
        exec_environment => pick($opts['exec_environment'],$exec_environment),
        prepend_lines    => pick($opts['prepend_lines'],[]),
        append_lines     => pick($opts['append_lines'],[]),
        exec_logoutput   => pick($opts['exec_logoutput'],$exec_logoutput),
        always_build     => pick($opts['always_build'],$always_build),
        build_options    => pick_default($opts['build_options'],$build_options),
        command_mode     => pick($opts['command_mode'],$command_mode),
        mount_data_dir   => pick($opts['mount_data_dir'],$mount_data_dir),
        mount_log_dir    => pick($opts['mount_log_dir'],$mount_log_dir),
        conf_hash        => pick($opts['conf_hash'],{}),
        dir_hash         => pick($opts['dir_hash'],{}),
        data_module      => $psick_profile::docker::data_module,
      }
    }

    if $push {
      $images.each |$image,$opts| {
        if $opts['push'] != false {
          docker::push { $image:
            ensure           => pick_default($opts['ensure'],$ensure),
            username         => pick_default($opts['username'],$::docker::username),
            repository       => pick($opts['repository'],$image),
            repository_tag   => pick($opts['repository_tag'],$real_repository_tag),
            exec_environment => pick($opts['exec_environment'],$exec_environment),
            data_module      => $psick_profile::docker::data_module,
          }
        }
      }
    }
  }
}
