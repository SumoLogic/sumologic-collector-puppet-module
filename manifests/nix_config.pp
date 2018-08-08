#The Nix configuration class
class sumo::nix_config () {
  ########## Parameters Section ##########

  $accessid                    = $sumo::accessid
  $accesskey                   = $sumo::accesskey
  $category                    = $sumo::category
  $clobber                     = $sumo::clobber
  $collector_name              = $sumo::collector_name
  $collector_secure_files      = $sumo::collector_secure_files
  $collector_url               = $sumo::collector_url
  $description                 = $sumo::description
  $disable_action_source       = $sumo::disable_action_source
  $disable_script_source       = $sumo::disable_script_source
  $disable_upgrade             = $sumo::disable_upgrade
  $ephemeral                   = $sumo::ephemeral
  $hostname                    = $sumo::hostname
  $sources_file_override       = $sumo::sources_file_override
  $sync_sources_override       = $sumo::sync_sources_override
  $proxy_host                  = $sumo::proxy_host
  $proxy_ntlmdomain            = $sumo::proxy_ntlmdomain
  $proxy_password              = $sumo::proxy_password
  $proxy_port                  = $sumo::proxy_port
  $proxy_user                  = $sumo::proxy_user
  $runas_username              = $sumo::runas_username
  $skip_registration           = $sumo::skip_registration
  $sources_path                = $sumo::sources_path
  $sumo_json_source_path       = $sumo::sumo_json_source_path
  $sumo_json_sync_source_path  = $sumo::sumo_json_sync_source_path
  $sumo_package_provider       = $sumo::sumo_package_provider
  $local_config_mgmt           = $sumo::local_config_mgmt
  $sync_sources_path           = $sumo::sync_sources_path
  $target_cpu                  = $sumo::target_cpu
  $time_zone                   = $sumo::time_zone
  $token                       = $sumo::token
  $use_package                 = $sumo::use_package



  ############# Make sure base sumo class is defined #########

  if ! defined(Class['sumo']) {
    fail('You must include the sumo base class before including any sumo sub classes.')
  }

  ############# Make sure sources file exists if the manage sources is false and local_config_mgmt is false #########

  if !$local_config_mgmt and !$sources_file_override and !str2bool($::sources_file_exists){

    fail('Please make sure sources.json exists in /usr/local/sumo/ directory.')
  }

  ############# Make sure syncsources file exists if the manage sync sources is false and local_config_mgmt is true #########

  if $local_config_mgmt and !$sync_sources_override and !str2bool($::sync_file_exists){

    fail('Please make sure syncsources.json exists in /usr/local/sumo/ directory.')
  }




  ########### Make sure that the base directory is created. The installation package is downloaded to this directory. ###############
  file { '/usr/local/sumo':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  ########### Manage Sources? Get the sources file from puppet. ###########
  if $sources_file_override {
    file { $sources_path:
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_source_path,
      require => File['/usr/local/sumo']
    }
  }

  ########### Manage Sync-Sources? Get the sync-sources file from puppet. ###########

  if ($sync_sources_override) {
    file { $sync_sources_path :
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_sync_source_path,
      require => File['/usr/local/sumo']

    }
  }

  ############ Make sure the collector is not already installed. It needs to be after sync #####
  ###########$ sources as the sync sources needs to be copied by puppet if modified. ###########

  if str2bool($::service_file_exists)
  {
    fail('Service already installed.')
  }


  ########### Create user.properties if using package to install #############

  if $use_package  {

    if $sumo_package_provider == ''
    {
      fail("Package installation not supported on this architecture: ${::architecture}")
    }

    # User.properties should be created in the install class after package installation using requires
    # otherwise the installer creates issues while installation.
    # if created here, the requires keyword will create a cyclic dependency.

  }

  ########### Create var file if using downloading and installing #############

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
          'accessid'               => $accessid,
          'accesskey'              => $accesskey,
          'category'               => $category,
          'clobber'                => $clobber,
          'collector_name'         => $collector_name,
          'collector_secure_files' => $collector_secure_files,
          'collector_url'          => $collector_url,
          'description'            => $description,
          'disable_action_source'  => $disable_action_source,
          'disable_script_source'  => $disable_script_source,
          'disable_upgrade'        => $disable_upgrade,
          'ephemeral'              => $ephemeral,
          'hostName'               => $hostname,
          'sources_file_override'  => $sources_file_override,
          'sync_sources_override'  => $sync_sources_override,
          'proxy_host'             => $proxy_host,
          'proxy_ntlmdomain'       => $proxy_ntlmdomain,
          'proxy_password'         => $proxy_password,
          'proxy_port'             => $proxy_port,
          'proxy_user'             => $proxy_user,
          'runas_username'         => $runas_username,
          'skip_registration'      => $skip_registration,
          'sources_path'           => $sources_path,
          'local_config_mgmt'      => $local_config_mgmt,
          'sync_sources_path'      => $sync_sources_path,
          'target_cpu'             => $target_cpu,
          'time_zone'              => $time_zone,
          'token'                  => $token,

        }),
    }
  }



}
