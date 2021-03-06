# @class psick_profile::jenkins::scm_sync
# @summary Installs and configures SCM Sync plugin
# This class is automatically loaded if it's set
# psick_profile::jenkins::scm_sync_repository_url
#
# @param ensure If the enable or not the plugin
# @param config_template Template to use for scm-sync-configuration.xml
# @param repository_url Url of the git repo to sync where Jenkins configs
#   are saved
# @param service_reload_command Command to execute to trigger Jenkins reload
#   Possible alternative: "curl -X POST http://127.0.0.1:8080/reload -u admin:\$(cat 'secrets/initialAdminPassword')"
#   For details: https://github.com/jenkinsci/scm-sync-configuration-plugin/issues/44
class psick_profile::jenkins::scm_sync (
  Variant[Boolean,String] $ensure  = 'present',
  String $config_template = 'psick_profile/jenkins/scm_sync/scm-sync-configuration.xml.erb',
  String $jenkins_reload_command   = 'service jenkins force-reload',
  Optional[String] $repository_url = $psick_profile::jenkins::scm_sync_repository_url,
  Boolean $manage                  = $::psick::manage,
  Boolean $noop_manage             = $::psick::noop_manage,
  Boolean $noop_value              = $::psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    if !defined(Psick_profile::Jenkins::Plugin['scm-sync-configuration']) {
      $plugin_enable = $ensure ? {
        'absent' => false,
        default  => true,
      }
      psick_profile::jenkins::plugin { 'scm-sync-configuration':
        enable   => $plugin_enable,
      }
    }
    if $config_template != '' and $repository_url {
      file { "${psick_profile::jenkins::home_dir}/scm-sync-configuration.xml" :
        ensure  => $ensure,
        mode    => '0644',
        owner   => 'jenkins',
        group   => 'jenkins',
        notify  => Service['jenkins'],
        replace => false,
        content => template($config_template),
        require => Package['jenkins'],
      }
    }

    if $repository_url {
      # Trigger scm sync
      exec { 'trigger_jenkins_scm_sync' :
        command => "sleep 5 ; curl http://127.0.0.1:8080/plugin/scm-sync-configuration/reloadAllFilesFromScm -u admin:\$(cat 'secrets/initialAdminPassword')",
        cwd     => $psick_profile::jenkins::home_dir,
        creates => "${psick_profile::jenkins::home_dir}/scm-sync-configuration.success.log",
        require => [File["${psick_profile::jenkins::home_dir}/scm-sync-configuration.xml"], Service['jenkins']],
        user    => 'jenkins',
        notify  => Exec['jenkins_reload'],
      }
      exec { 'jenkins_reload' :
        command     => $jenkins_reload_command,
        cwd         => $psick_profile::jenkins::home_dir,
        require     => [File["${psick_profile::jenkins::home_dir}/scm-sync-configuration.xml"], Service['jenkins']],
        refreshonly => true,
      }
    }
  }
}
