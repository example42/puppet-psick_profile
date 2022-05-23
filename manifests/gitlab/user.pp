# Manage a gitlab user
# This define needs the class psick_profile::gitlab::cli
# and is declared in the class psick_profile::gitlab
# Note: Currently this define does not manage CHANGES
# in the managed resource.
#
define psick_profile::gitlab::user (
  String  $password,
  String  $email          = "${title}@${facts['networking']['domain']}",
  String  $description    = $title,
  Hash    $options        = {},

  Array $ssh_keys         = [],
  Array $exec_environment = ["GITLAB_API_ENDPOINT=${psick_profile::gitlab::cli::api_endpoint}",
    "GITLAB_API_PRIVATE_TOKEN=${psick_profile::gitlab::cli::private_token}",
  "GITLAB_API_HTTPARTY_OPTIONS='{verify: false}'"],
  # for self signed https certs
) {
  $default_options = {
    name => $description,
  }
  $command_options = $default_options + $options

  exec { "gitlab create_user ${title}":
    command => "gitlab create_user '${email}' '${password}' '${title}' ${command_options}",
    unless  => "gitlab users --only=username | grep ${title}",
    require => Class['psick_profile::gitlab::cli'],
  }

  if $ssh_keys != [] {
    $ssh_keys.each | $k,$v | {
      exec { "gitlab add key ${k} to ${title}":
        command => "gitlab create_ssh_key '${k}' '${v}'",
        unless  => "gitlab ssh_keys --only=title | grep ${title}",
        require => Class['psick_profile::gitlab::cli'],
      }
    }
  }
}
