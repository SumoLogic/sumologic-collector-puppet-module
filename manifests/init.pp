# The official SumoLogic collector puppet module
class sumo (
  $accessid              = undef,
  $accesskey             = undef,
  $clobber               = false,
  $collector_name        = undef,
  $email                 = undef,
  $ephemeral             = false,
  $manage_config_file    = true,
  $manage_sources        = false,
  $password              = undef,
  $proxy_host            = undef,
  $proxy_ntlmdomain      = undef,
  $proxy_password        = undef,
  $proxy_port            = undef,
  $proxy_user            = undef,
  $sources               = $sumo::params::sources,
  $sumo_conf_source_path = $sumo::params::sumo_conf_source_path,
  $sumo_json_source_path = undef,
  $sumo_json_content     = undef,
  $sumo_exec             = $sumo::params::sumo_exec,
  $sumo_short_arch       = $sumo::params::sumo_short_arch,
  $syncsources           = $sumo::params::syncsources,
) inherits sumo::params {
   if $manage_sources {
     if $sumo_json_source_path == undef and $sumo_json_content == undef {
       $sumo_json_source_path = $sumo::params::sumo_json_source_path
    }
    unless ($sumo_json_source_path != undef and $sumo_json_content == undef) or ($sumo_json_source_path == undef and $sumo_json_content != undef) {
      fail("You must define exactly one of sumo_json_source_path or sumo_json_content. ${sumo_json_source_path} ${sumo_json_content}")
    }
  }

  if $::osfamily == 'windows'{
    class { 'sumo::win_config': }
  } else {
    class { 'sumo::nix_config': }
  }
}
