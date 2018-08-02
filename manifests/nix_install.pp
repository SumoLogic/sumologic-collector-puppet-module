#The Nix install class
class sumo::nix_install()
  {
    ########## Parameters Section ##########

    $sumo_exec              = $sumo::sumo_exec
    $use_package            = $sumo::use_package
    $sumo_package_suffix    = $sumo::sumo_package_suffix
    $sumo_package_provider  = $sumo::sumo_package_provider
    $sumo_package_filename  = $sumo::sumo_package_filename
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
    $manage_sources         = $sumo::manage_sources
    $manage_sync_sources    = $sumo::manage_sync_sources
    $proxy_host             = $sumo::proxy_host
    $proxy_ntlmdomain       = $sumo::proxy_ntlmdomain
    $proxy_password         = $sumo::proxy_password
    $proxy_port             = $sumo::proxy_port
    $proxy_user             = $sumo::proxy_user
    $skip_registration      = $sumo::skip_registration
    $sources                = $sumo::sources
    $sync_sources           = $sumo::sync_sources
    $target_cpu             = $sumo::target_cpu
    $time_zone              = $sumo::time_zone
    $token                  = $sumo::token
    $runas_username         = $sumo::runas_username
    $sources_file           = $sumo::sources_file
    $sumo_short_arch        = $sumo::sumo_short_arch

    ########## Install from package? ########

    if $use_package {

      exec { 'Download SumoCollector Package':
        command => "/usr/bin/curl -o /usr/local/sumo/${sumo_package_filename} https://collectors.sumologic.com/rest/download/${sumo_package_suffix}",
        cwd     => '/usr/bin',
        creates => "/usr/local/sumo/${sumo_package_filename}",
        require => File['/usr/local/sumo'],
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        #       onlyif  => 'test -e /usr/local/sumo/sources.json',
      }

      file { '/opt/SumoCollector/config/user.properties':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp('sumo/user.properties.epp', {
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
          'token'                  => $token,
          'sources_file'           => $sources_file,
          'manage_sources'         => $manage_sources,
          'manage_sync_sources'    => $manage_sync_sources,
        }),
        require => Package['collector'],
        notify  => Service['collector'];
      }

      package { 'collector':
        ensure   => installed,
        provider => $sumo_package_provider,
        source   => "/usr/local/sumo/${sumo_package_filename}",
        require  => Exec['Download SumoCollector Package'],
      }



    }
    ####### Download and Install ###########
    else {
      exec { 'Download Sumo Executable':
        command => "/usr/bin/curl -o /usr/local/sumo/${sumo_exec} https://collectors.sumologic.com/rest/download/linux/${sumo_short_arch}",
        cwd     => '/usr/bin',
        creates => "/usr/local/sumo/${sumo_exec}",
        require => File['/usr/local/sumo'],
      }

      exec { 'Execute sumo':
        command => "/bin/sh /usr/local/sumo/${sumo_exec} -q -varfile /etc/sumo/sumoVarFile.txt",
        cwd     => '/usr/local/sumo',
        creates => '/opt/SumoCollector/jre',
        require => File['/etc/sumo/sumoVarFile.txt'],
        notify  => Service['collector'],
      }


    }

    ####### Make sure that the collector service is running ###########

    service { 'collector':
      ensure     => 'running',
      hasstatus  => true,
      hasrestart => true,
      enable     => true,
    }
  }