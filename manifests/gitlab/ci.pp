# Deprecated profile. Use psick::puppet::ci instead.
class psick_profile::gitlab::ci (
  String                $ensure           = 'present',
  String                $config_file_path = '/etc/gitlab-ci.conf',
  Variant[Undef,String] $template         = 'psick_profile/gitlab/runner/ci.conf.erb',
  Hash                  $options          = {},
  Array                 $default_nodes    = [],
  Array                 $always_nodes     = [],

  Boolean           $manage               = $psick::manage,
  Boolean           $noop_manage          = $psick::noop_manage,
  Boolean           $noop_value           = $psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    $options_default = {
      catalog_diff_default_nodes => pick(join($default_nodes,','),' '),
      catalog_preview_default_nodes => pick(join($default_nodes,','),' '),
      tp_test_default_nodes => pick(join($default_nodes,','),' '),
      testing_query_default_nodes => pick(join($default_nodes,','),' '),
      integration_query_default_nodes => pick(join($default_nodes,','),' '),
      production_query_default_nodes => pick(join($default_nodes,','),' '),

      catalog_diff_always_nodes => pick(join($always_nodes,','),' '),
      catalog_preview_always_nodes => pick(join($always_nodes,','),' '),
      tp_test_always_nodes => pick(join($always_nodes,','),' '),
      testing_query_always_nodes => pick(join($always_nodes,','),' '),
      integration_query_always_nodes => pick(join($always_nodes,','),' '),
      production_query_always_nodes => pick(join($always_nodes,','),' '),
    }
    $ci_options = $options_default + $options
    file { $config_file_path:
      ensure  => $ensure ,
      content => template($template),
      require => Class['psick_profile::gitlab::runner'],
    }

    warning('Deprecated profile. Use psick::puppet::ci instead.')
  }
}
