# This class manages the installation and initialisation of a GitLab proxy.
#
# @param ensure If to install or remove the GitLab CI runner
# @param auto_prereq If to automatically install all the prerequisites
#                    resources needed to install the runner
# @param template The path to the erb template (as used in template()) to use
#                 to populate the Runner configuration file. Note that if you
#                 use the runners parameter this file is automatically generated
#                 during runners registration
# @param options An open hash of options you may use in your template
#
class psick_profile::gitlab::proxy (
  String                $ensure      = 'present',
  Boolean               $auto_prereq = false,
  Optional[String]      $template    = 'psick_profile/gitlab/proxy/nginx_gitlab_proxy.conf.erb',
  Hash                  $options     = {},
  String                $server_name = $facts['networking']['fqdn'],
  String                $proxy_pass  = "https://gitlab.${facts['networking']['domain']}:443",
) {
  $options_default = {
    server_name => $server_name,
    proxy_pass  => $proxy_pass,
  }
  $proxy_options = $options_default + $options
  if $auto_prereq {
    ::tp::install { 'nginx' :
      ensure             => $ensure,
    }
  }

  if $template {
    ::tp::conf { 'nginx::gitlab-proxy.conf':
      ensure       => $ensure,
      template     => $template,
      base_dir     => 'conf',
      options_hash => $proxy_options,
    }
  }
}
