#The Nix configuration class
class sumo::nix_config () {
  ########## Parameters Section ##########

  $accessid               = $sumo::accessid
  $accesskey              = $sumo::accesskey
  $category               = $sumo::category
  $clobber                = $sumo::clobber
  $collector_name         = $sumo::collector_name
  $collector_secure_files  = $sumo::collector_secure_files
  $collector_url          = $sumo::collector_url
  $description            = $sumo::description
  $disable_action_source  = $sumo::disable_action_source
  $disable_script_source  = $sumo::disable_script_source
  $disable_upgrade        = $sumo::disable_upgrade
  $ephemeral              = $sumo::ephemeral
  $hostname               = $sumo::hostname
  $local_exec_file        = $sumo::local_exec_file
  $manage_download        = $sumo::manage_download
  $manage_sources         = $sumo::manage_sources
  $manage_sync_sources    = $sumo::manage_sync_sources
  $proxy_host             = $sumo::proxy_host
  $proxy_ntlmdomain       = $sumo::proxy_ntlmdomain
  $proxy_password         = $sumo::proxy_password
  $proxy_port             = $sumo::proxy_port
  $proxy_user             = $sumo::proxy_user
  $skip_registration      = $sumo::skip_registration
  $sources                = $sumo::sources
  $sumo_json_source_path  = $sumo::sumo_json_source_path
  $sumo_json_sync_source_path  = $sumo::sumo_json_sync_source_path
  $sync_sources           = $sumo::sync_sources
  $target_cpu             = $sumo::target_cpu
  $time_zone              = $sumo::time_zone
  $token                  = $sumo::token
  $runas_username         = $sumo::runas_username
  $use_package            = $sumo::use_package
  $sumo_package_provider  = $sumo::sumo_package_provider
  $sources_file           = $sumo::sources_file



  ############# Make sure base sumo class is defined #########

  if ! defined(Class['sumo']) {
    fail('You must include the sumo base class before including any sumo sub classes.')
  }

  ############ Make sure the collector is not already installed ########### Not working, need to write a custom fact

  # if ('ps -ef | grep -v grep | grep -q com.sumologic.scala.collector.Collector') == 0
  # {
  #   fail('The Sumo Logic Collector is already installed!')
  # }

  ########### Make sure that the base directory is created. The installation package is downloaded to this directory. ###############
  file { '/usr/local/sumo':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  ########### Manage Sources? Get the sources file from puppet. ###########
  if $manage_sources {
    file { $sources:
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_source_path,
      require => File['/usr/local/sumo']
    }
  }

  ########### Manage Sync-Sources? Get the sync-sources file from puppet. ###########

  if ($manage_sync_sources) {
    file { $sync_sources :
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo_json_sync_source_path,
      require => File['/usr/local/sumo']

    }
  }

  ########### Manage Config File? Get the config file from puppet ############
  #
  #  if $manage_config_file {
  #    file { '/etc/sumo.conf':
  #      ensure  => present,
  #      owner   => 'root',
  #      group   => 'root',
  #      mode    => '0600',
  #      content => template($sumo_conf_template_path),
  #    }
  #  }

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
          'proxy_host'             => $proxy_host,
          'proxy_ntlmdomain'       => $proxy_ntlmdomain,
          'proxy_password'         => $proxy_password,
          'proxy_port'             => $proxy_port,
          'proxy_user'             => $proxy_user,
          'runas_username'         => $runas_username,
          'skip_registration'      => $skip_registration,
          'sources'                => $sources,
          'sync_sources'           => $sync_sources,
          'target_cpu'             => $target_cpu,
          'time_zone'              => $time_zone,
          'sources_file'           => $sources_file,
          'token'                  => $token,
          'manage_sources'         => $manage_sources,
          'manage_sync_sources'    => $manage_sync_sources,
        }),
    }
  }



}
