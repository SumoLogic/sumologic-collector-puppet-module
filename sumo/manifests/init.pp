class sumo (
  $sumo_exec       = $sumo::params::sumo_exec,
  $sumo_short_arch = $sumo::params::sumo_short_arch,
  $accessid = nil,
  $accesskey = nil,
  $sumo_conf_source_path = $sumo::params::sumo_conf_source_path,
  $sumo_json_source_path = $sumo::params::sumo_json_source_path
) inherits sumo::params {
  if $osfamily == 'windows'{
    include sumo::win_config
  }else{
    include sumo::nix_config
  }

}
