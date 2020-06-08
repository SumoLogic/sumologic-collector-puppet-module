#The Nix configuration class
class sumo::nix_config (
  ########## Parameters Section ##########
  $accessid                      = $sumo::accessid,
  $accesskey                     = $sumo::accesskey,
  $category                      = $sumo::category,
  $clobber                       = $sumo::clobber,
  $collector_name                = $sumo::collector_name,
  $collector_secure_files        = $sumo::collector_secure_files,
  $collector_url                 = $sumo::collector_url,
  $description                   = $sumo::description,
  $disable_action_source         = $sumo::disable_action_source,
  $disable_script_source         = $sumo::disable_script_source,
  $disable_upgrade               = $sumo::disable_upgrade,
  $ephemeral                     = $sumo::ephemeral,
  $fipsjce                       = $sumo::fipsjce,
  $hostname                      = $sumo::hostname,
  $local_config_mgmt             = $sumo::local_config_mgmt,
  $proxy_host                    = $sumo::proxy_host,
  $proxy_ntlmdomain              = $sumo::proxy_ntlmdomain,
  $proxy_password                = $sumo::proxy_password,
  $proxy_port                    = $sumo::proxy_port,
  $proxy_user                    = $sumo::proxy_user,
  $runas_username                = $sumo::runas_username,
  $skip_access_key_removal       = $sumo::skip_access_key_removal,
  $skip_registration             = $sumo::skip_registration,
  $sources_file_override         = $sumo::sources_file_override,
  $sync_sources_override         = $sumo::sync_sources_override,
  $sources_path                  = $sumo::sources_path,
  $sources_directory_or_file     = $sumo::sources_directory_or_file,
  $sumo_json_source_path         = $sumo::sumo_json_source_path,
  $sumo_json_sync_source_path    = $sumo::sumo_json_sync_source_path,
  $sumo_package_provider         = $sumo::sumo_package_provider,
  $sync_sources_path             = $sumo::sync_sources_path,
  $target_cpu                    = $sumo::target_cpu,
  $time_zone                     = $sumo::time_zone,
  $token                         = $sumo::token,
  $use_package                   = $sumo::use_package,
  $use_tar_pkg                   = $sumo::use_tar_pkg,
) {

  ############# Make sure base sumo class is defined #########

  if ! defined(Class['sumo']) {
    fail('You must include the sumo base class before including any sumo sub classes.')
  }

  ############# Make sure sources file exists if the sources file should not be overridden and local_config_mgmt is false #########

  if ( !$local_config_mgmt and !$sources_file_override ){

    if ($sources_directory_or_file == 'file' and !str2bool($::sources_file_exists))
    {
      fail('Please make sure sources.json exists in /usr/local/sumo/ directory.')
    }
    elsif (($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory') and !str2bool($::sources_dir_exists))
    {
      fail('Please make sure that the directory /usr/local/sumo/ exists with source JSON file(s).')
    }
  }


  ############# Make sure syncsources file exists if the sync sources override is false and local_config_mgmt is true #########

  if ($local_config_mgmt and !$sync_sources_override){


    if ($sources_directory_or_file == 'file' and !str2bool($::sync_file_exists))
    {
      fail('Please make sure syncsources.json exists in /usr/local/sumo/ directory.')
    }
    elsif (($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory') and !str2bool($::sources_dir_exists))
    {
      fail('Please make sure that the directory /usr/local/sumo/ exists with sync source JSON file(s).')
    }
  }




  ########### Make sure that the base directory is created. The installation package is downloaded to this directory. ###############
  file { '/usr/local/sumo':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  ########### Override Sources? Get the sources file from puppet. ###########
  if ($sources_file_override and !$local_config_mgmt){
    file { $sources_path:
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_source_path,
      require => File['/usr/local/sumo']
    }
  }

  ########### Override Sync-Sources? Get the sync-sources file from puppet. ###########

  if ($sync_sources_override and $local_config_mgmt) {
    file { $sync_sources_path :
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_sync_source_path,
      require => File['/usr/local/sumo']

    }
  }



  ############ Make sure the collector is not already installed and Create user.properties if using package to install#####

  if !str2bool($::service_file_exists)
  {

    if ($use_package or $use_tar_pkg)  {

      if ($use_package and $sumo_package_provider == '')
      {
        fail("Package installation not supported on this architecture: ${::architecture}")
      }

      # User.properties should be created in the install class after package installation
      # otherwise the installer creates issues while installation.
      # if created here, the requires keyword will create a cyclic dependency.

    }

    ########### Create var file if using script for installation #############

    else {

      file {
        '/etc/sumo':
          ensure => 'directory',
          owner  => 'root',
          group  => 'root',
          mode   => '0600';

        '/etc/sumo/sumoVarFile.txt':
          ensure  => 'file',
          owner   => 'root',
          group   => 'root',
          mode    => '0600',
          content => epp('sumo/sumoVarFile.txt.epp', {
            'accessid'                => $accessid,
            'accesskey'               => $accesskey,
            'category'                => $category,
            'clobber'                 => $clobber,
            'collector_name'          => $collector_name,
            'collector_secure_files'  => $collector_secure_files,
            'collector_url'           => $collector_url,
            'description'             => $description,
            'disable_action_source'   => $disable_action_source,
            'disable_script_source'   => $disable_script_source,
            'disable_upgrade'         => $disable_upgrade,
            'ephemeral'               => $ephemeral,
            'fipsjce'                 => $fipsjce,
            'hostName'                => $hostname,
            'sources_file_override'   => $sources_file_override,
            'sync_sources_override'   => $sync_sources_override,
            'proxy_host'              => $proxy_host,
            'proxy_ntlmdomain'        => $proxy_ntlmdomain,
            'proxy_password'          => $proxy_password,
            'proxy_port'              => $proxy_port,
            'proxy_user'              => $proxy_user,
            'runas_username'          => $runas_username,
            'skip_access_key_removal' => $skip_access_key_removal,
            'skip_registration'       => $skip_registration,
            'sources_path'            => $sources_path,
            'local_config_mgmt'       => $local_config_mgmt,
            'sync_sources_path'       => $sync_sources_path,
            'target_cpu'              => $target_cpu,
            'time_zone'               => $time_zone,
            'token'                   => $token,
          }),
      }
    }

  }

}
