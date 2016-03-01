class sumo (
  $sumo_exec       = $sumo::params::sumo_exec,
  $sumo_short_arch = $sumo::params::sumo_short_arch,
  $accessid,
  $accesskey
) inherits sumo::params {

  include sumo::config

}
