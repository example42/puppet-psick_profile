# == Class: site::monitor::nrpe
#
class psick_profile::nrpe (
  $ensure                     = 'present',

  $config_dir_source          = undef,
  $config_file_template       = undef,
  $extra_config_file_template = undef,
  Boolean $manage             = $::psick::manage,
  Boolean $noop_manage        = $::psick::noop_manage,
  Boolean $noop_value         = $::psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }
    $options_default = {
      nrpe_timeout               => '10',
      disk_warning               => '20%',
      disk_critical              => '10%',
      swap_warning               => '40%',
      swap_critical              => '20%',
      users_warning              => '10',
      users_critical             => '15',
      load_warning               => '15,10,5',
      load_critical              => '30,25,20',
      procs_warning              => '300',
      procs_critical             => '600',
      zombie_procs_warning       => '5',
      zombie_procs_critical      => '10',
      ntp_server                 => '0.pool.ntp.org',
      ntp_warning                => '1',
      ntp_critical               => '3',
      nginx_status_port          => '26000',
      backup_inc_warning         => '28',
      backup_inc_critical        => '52',
      backup_full_warning        => '40',
      backup_full_critical       => '60',
      backup_psick             => 'hetzner',
      puppetrun_warning          => '86400',
      puppetrun_critical         => '172800',
      memory_warning             => '10',
      memory_critical            => '5',
    }
    #
    $options_user=lookup('nrpe_options', Hash, 'deep', {})
    $options=merge($options_default,$options_user)

    ::tp::install { 'nrpe':
      ensure => $ensure,
    }

    ::tp::dir { 'nrpe':
      ensure => $ensure,
      source => $config_dir_source,
    }
    ::tp::conf { 'nrpe':
      ensure       => $ensure,
      template     => $config_file_template,
      options_hash => $options,
    }

    ::tp::conf { 'nrpe::extra.conf':
      ensure       => $ensure,
      template     => $extra_config_file_template,
      options_hash => $options,
    }
  }
}
