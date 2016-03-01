class sumo (
  $sumo_exec       = $sumo::params::sumo_exec,
  $sumo_short_arch = $sumo::params::sumo_short_arch,
  $accessid,
  $accesskey,
  $sumo_conf_source_path = $sumo::params::sumo_conf_source_path,
  $sumo_json_source_path = $sumo::params::sumo_json_source_path
) inherits sumo::params {
  include sumo::config
}
