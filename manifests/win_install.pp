#The Win install class
class sumo::win_install(
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
  $sync_sources_path             = $sumo::sync_sources_path,
  $target_cpu                    = $sumo::target_cpu,
  $time_zone                     = $sumo::time_zone,
  $token                         = $sumo::token,
  $win_run_as_password           = $sumo::win_run_as_password

)
  {
    ############ Make sure the collector is not already installed. #####

    if !str2bool($::service_file_exists_win)
    {

      ############ Create var file for installation   ########

      file { 'C:\sumo\sumoVarFile.txt':
        ensure  => 'file',
        group   => 'Administrators',
        mode    => '0644',
        content => epp('sumo/sumoVarFileWin.txt.epp', {
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
          'skip_access_key_removal' => $skip_access_key_removal,
          'sources_file_override'   => $sources_file_override,
          'sync_sources_override'   => $sync_sources_override,
          'proxy_host'              => $proxy_host,
          'proxy_ntlmdomain'        => $proxy_ntlmdomain,
          'proxy_password'          => $proxy_password,
          'proxy_port'              => $proxy_port,
          'proxy_user'              => $proxy_user,
          'runas_username'          => $runas_username,
          'skip_registration'       => $skip_registration,
          'sources_path'            => $sources_path,
          'local_config_mgmt'       => $local_config_mgmt,
          'sync_sources_path'       => $sync_sources_path,
          'target_cpu'              => $target_cpu,
          'time_zone'               => $time_zone,
          'token'                   => $token,
          'win_run_as_password'     => $win_run_as_password

        }),
        require => File['C:\sumo'];
      }

      ############ Download Installer   ########

      $powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
      exec { 'download_sumo':
        command => "${powershell_path} -executionpolicy remotesigned -file C:\\sumo\\download_sumo.ps1",
        require => File['C:\sumo\download_sumo.ps1'],
        creates => 'C:\sumo\sumo.exe'
      }

      ############ Install Collector  ########

      package { 'sumo-collector':
        ensure          => installed,
        install_options => ['-console', '-q', '-varfile', 'C:\sumo\sumoVarFile.txt'],
        source          => 'C:\sumo\sumo.exe',
        require         => [
          Exec['download_sumo'],
          File['C:\sumo\sumoVarFile.txt'],
        ]
      }
    }
    else {
      notice('Service already installed.')
    }

    ####### Make sure that the collector service is running ###########
    if !str2bool($skip_registration)
      {
        service { 'sumo-collector':
          ensure => 'running',
          enable => true,
        }
      }

  }
