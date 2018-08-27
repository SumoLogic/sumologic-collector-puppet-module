# The official SumoLogic collector puppet module
class sumo (
  $accessid                        = undef,
  $accesskey                       = undef,
  $category                        = undef,
  Boolean $clobber                 = false,
  $collector_name                  = undef,
  $collector_secure_files          = undef,
  $collector_url                   = 'https://collectors.sumologic.com',
  $description                     = undef,
  #$dir                            = undef, #future enhacement
  $disable_action_source           = undef,
  $disable_script_source           = undef,
  $disable_upgrade                 = undef,
  Boolean $ephemeral               = false,
  $hostname                        = $::hostname,
  Boolean $local_config_mgmt       = false,
  Boolean $manage_sources          = false,
  Boolean $sources_override        = false,
  Boolean $sync_sources_override   = false,
  $proxy_host                      = undef,
  $proxy_ntlmdomain                = undef,
  $proxy_password                  = undef,
  $proxy_port                      = undef,
  $proxy_user                      = undef,
  $runas_username                  = undef,
  Boolean $skip_access_key_removal = false,
  $skip_registration               = undef,
  $sources_directory_or_file       = 'file',
  $sumo_exec                       = $sumo::params::sumo_exec,
  $sumo_json_source_path           = $sumo::params::sumo_json_source_path,
  $sumo_json_sync_source_path      = $sumo::params::sumo_json_sync_source_path,
  $sumo_package_suffix             = $sumo::params::sumo_package_suffix,
  $sumo_package_provider           = $sumo::params::sumo_package_provider,
  $sumo_package_filename           = $sumo::params::sumo_package_filename,
  $sumo_short_arch                 = $sumo::params::sumo_short_arch,
  $sumo_win_arch                   = $sumo::params::sumo_win_arch,
  $target_cpu                      = undef,
  $token                           = undef,
  $time_zone                       = undef,
  Boolean $use_package             = false,
  $win_run_as_password             = undef,
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



  if $category { validate_string($category)}
  if $collector_name { validate_string($collector_name) }
  if $collector_secure_files { validate_string($collector_secure_files) }
  if $collector_url { validate_string($collector_url) }
  if $description { validate_string($description) }
  if $disable_script_source { validate_string($disable_script_source) }
  if $disable_action_source { validate_string($disable_action_source) }
  if $disable_upgrade { validate_string($disable_upgrade) }
  if $hostname { validate_string($hostname)}
  if $proxy_host { validate_string($proxy_host) }
  if $proxy_ntlmdomain { validate_string($proxy_ntlmdomain) }
  if $proxy_user { validate_string($proxy_user) }
  if $proxy_password { validate_string($proxy_password) }
  if $proxy_port { validate_string($proxy_port) }
  if $runas_username { validate_string($runas_username) }
  if $skip_registration { validate_string($skip_registration) }
  if $target_cpu { validate_integer($target_cpu)}
  if $time_zone { validate_string($time_zone)}
  if $win_run_as_password { validate_string($win_run_as_password)}

  if ($manage_sources or $sources_override) {
    $sources_file_override = true
  }
  else
  {
    $sources_file_override = false
  }



  if $::osfamily == 'windows'{


    if ($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory') {

      if (!$sources_file_override)
      {
        $sources_path = 'C:\\\\sumo'
      }
      else
      {
        $sources_path = 'C:\\\\sumo\\\\sources.json'
      }

      if (!$sync_sources_override)
      {
        $sync_sources_path = 'C:\\\\sumo'
      }
      else
      {
        $sync_sources_path = 'C:\\\\sumo\\\\syncsources.json'
      }

    }
    elsif $local_config_mgmt {

      $sync_sources_path = 'C:\\\\sumo\\\\syncsources.json'
      $sources_path = ''
    }
    else
    {
      $sources_path = 'C:\\\\sumo\\\\sources.json'
      $sync_sources_path = ''
    }


    include ::sumo::win_config
    include ::sumo::win_install
    Class['sumo::win_config'] -> Class['sumo::win_install'] #Class win_config must be applied before install

  } else {

    if ($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory'){

      if (!$sources_file_override)
      {
        $sources_path = '/usr/local/sumo/'
      }
      else
      {
        $sources_path = '/usr/local/sumo/sources.json'
      }

      if (!$sync_sources_override)
      {
        $sync_sources_path = '/usr/local/sumo/'
      }
      else
      {
        $sync_sources_path = '/usr/local/sumo/syncsources.json'
      }

    }
    elsif $local_config_mgmt {

      $sync_sources_path = '/usr/local/sumo/syncsources.json'
      $sources_path = ''
    }
    else
    {
      $sources_path = '/usr/local/sumo/sources.json'
      $sync_sources_path = ''
    }

    include ::sumo::nix_config
    include ::sumo::nix_install
    Class['sumo::nix_config'] -> Class['sumo::nix_install'] #Class nx_config must be applied before install


  }
}
