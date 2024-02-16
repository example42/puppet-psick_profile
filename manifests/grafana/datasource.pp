# This define manages Grafana datasource
#
# @param ensure To configure datasource
# @param name name of the datasource. Required
#   $title of this define is used
# @param type datasource type. Required
# @param proxy access mode. direct or proxy. Required
#
#
# @example Usage via hiera data and the psick_profile::grafana class
#
#    psick_profile::grafana::datasources_hash:
#      InfluxDB:
#        type: influxdb
#        access: proxy
#        database: site
#        user: grafana
#        password: grafana
#        url: http://localhost:8086
#
define psick_profile::grafana::datasource (
  String            $type,
  String            $access,
  String            $file_name          = "${title}.yaml",
  Enum['present','absent'] $ensure      = 'present',
  String            $template           = 'psick_profile/grafana/datasource.yaml.erb',
  Optional[String]  $org_id             = undef,
  Optional[String]  $url                = undef,
  Optional[String]  $database           = undef,
  Optional[String]  $user               = undef,
  Optional[String]  $password           = undef,
  Optional[String]  $basic_auth         = undef,
  Optional[String]  $basic_authuser     = undef,
  Optional[String]  $basic_authpassword = undef,
  Optional[Boolean] $with_credentials   = undef,
  Optional[Boolean] $is_default         = undef,
  Optional[Hash]    $json_data          = undef,
  Optional[Hash]    $secure_json_data   = undef,
  Optional[Boolean] $editable           = undef,
  [Hash]    $options            = {},
) {
  tp::conf { "grafana::${file_name}":
    content  => template($template),
    base_dir => 'datasources',
  }
}
