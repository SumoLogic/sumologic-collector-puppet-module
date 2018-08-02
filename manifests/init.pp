# The official SumoLogic collector puppet module
class sumo (
  $accessid              = undef,
  $accesskey             = undef,
  $category              = undef,
  $clobber               = 'false',
  $collector_name        = undef,
  $collector_secure_files = undef,
  $collector_url         = 'https\://nite-events.sumologic.net',
  $description           = undef,
  #$dir                  = undef, #future enhacement
  $runas_username        = undef,
  $win_run_as_password     = undef,
  #skipAccessKeyRemoval
  $disable_action_source   = undef,
  $disable_script_source   = undef,
  $disable_upgrade        = undef,
  $ephemeral             = 'false',
  $hostname              = $::hostname,
  $local_exec_file       = undef,
  Boolean $manage_download       = true,
  Boolean $manage_sources        = false,
  Boolean $manage_sync_sources   = false,
  $proxy_host            = undef,
  $proxy_ntlmdomain      = undef,
  $proxy_password        = undef,
  $proxy_port            = undef,
  $proxy_user            = undef,
  $skip_registration      = undef, # Needs to be handled
  $sources               = $sumo::params::sources, #sources file path to be passed in as parameter in future upgrade
  $sumo_json_source_path = $sumo::params::sumo_json_source_path,
  $sumo_json_sync_source_path = $sumo::params::sumo_json_sync_source_path,
  $sumo_exec             = $sumo::params::sumo_exec,
  $sumo_short_arch       = $sumo::params::sumo_short_arch,
  $sumo_win_arch         = $sumo::params::sumo_win_arch,
  $sync_sources           = $sumo::params::sync_sources, #sources file path to be passed in as parameter in future upgrade
  $target_cpu             = undef,
  $token                 = undef,
  $time_zone              = undef,
  $use_package           = false,
  $sumo_package_suffix   = $sumo::params::sumo_package_suffix,
  $sumo_package_provider = $sumo::params::sumo_package_provider,
  $sumo_package_filename = $sumo::params::sumo_package_filename,
  $sources_file          = 'sources.json',
) inherits sumo::params {

  if ($accessid and $accesskey) or ($token) {
    if ($accessid)
    {
      validate_string($accessid)
      validate_string($accesskey)
    }
    else {
      validate_string($token)
    }
  }
  else {
    fail('Please provide an access_id/access_key pair or a token for authentication to utilize Class[::sumo]!')
  }



  validate_bool($manage_download)
  validate_bool($manage_sources)
  validate_bool($manage_sync_sources)

  #validate_bool($clobber)
  #validate_bool($ephemeral)

  if $collector_name { validate_string($collector_name) }
  if $collector_secure_files { validate_string($collector_secure_files) }
  if $collector_url { validate_string($collector_url) }
  if $time_zone { validate_string($time_zone)}
  if $category { validate_string($category)}
  if $target_cpu { validate_integer($target_cpu)}
  if $description { validate_string($description) }
  if $disable_script_source { validate_string($disable_script_source) }
  if $disable_action_source { validate_string($disable_action_source) }
  if $disable_upgrade { validate_string($disable_upgrade) }
  if $description { validate_string($description) }
  if $proxy_host { validate_string($proxy_host) }
  if $proxy_ntlmdomain { validate_string($proxy_ntlmdomain) }
  if $proxy_user { validate_string($proxy_user) }
  if $proxy_password { validate_string($proxy_password) }
  if $proxy_port { validate_string($proxy_port) }



  #Class['sumo::config'] -> Class['sumo::install']

  #contain sumo::install
  #contain sumo::config

  if $::osfamily == 'windows'{

    include ::sumo::win_config

  } else {

    include ::sumo::nix_config
    include ::sumo::nix_install
    Class['sumo::nix_config'] -> Class['sumo::nix_install'] #Class nx_config must be applied before install


  }
}
