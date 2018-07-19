class sumo::nix_config (
  $runAs_username         = undef,
) {
  ########## Parameters Section ##########
  $accessid               = $sumo::accessid
  $accesskey              = $sumo::accesskey
  $category               = $sumo::category
  $clobber                = $sumo::clobber
  $collector_name         = $sumo::collector_name
  $collector_secureFiles  = $sumo::collector_secureFiles
  $collector_url          = $sumo::collector_url
  $description            = $sumo::description
  $disableActionSource    = $sumo::disableActionSource
  $disableScriptSource    = $sumo::disableScriptSource
  $disableUpgrade         = $sumo::disableUpgrade
  $ephemeral              = $sumo::ephemeral
  $hostName               = $sumo::hostName
  $local_exec_file        = $sumo::local_exec_file
  $manage_download        = $sumo::manage_download
  $manage_sources         = $sumo::manage_sources
  $proxy_host             = $sumo::proxy_host
  $proxy_ntlmdomain       = $sumo::proxy_ntlmdomain
  $proxy_password         = $sumo::proxy_password
  $proxy_port             = $sumo::proxy_port
  $proxy_user             = $sumo::proxy_user
  $skipRegistration       = $sumo::skipRegistration
  $sources                = $sumo::sources
  $sumo_exec              = $sumo::sumo_exec
  $sumo_json_source_path  = $sumo::sumo_json_source_path
  $sumo_json_sync_source  = $sumo::sumo_json_sync_source
  $sumo_short_arch        = $sumo::sumo_short_arch
  $syncSources            = $sumo::syncSources
  $targetCPU              = $sumo::targetCPU
  $timeZone               = $sumo::timeZone
  $token                  = $sumo::token
  $winRunAs_password      = undef

  if ! defined(Class['sumo']) {
    fail('You must include the sumo base class before including any sumo sub classes')
  }

  file { '/usr/local/sumo':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  if $manage_sources {
    file { $sources:
      ensure  => present,
      owner   => 'root',
      mode    => '0600',
      group   => 'root',
      source  => $sumo::sumo_json_source_path,
      require => File['/usr/local/sumo']
    }
  }

  if $manage_config_file {
    file { '/etc/sumo.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template($sumo_conf_template_path),
    }
  }

  file {
    '/etc/sumo':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0600';

    '/etc/sumo/sumoVarFile.txt':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => epp('sumo/sumoVarFile.txt.epp', {
        'accessid'        => $accessid,
        'accesskey'       => $accesskey,
        'category'        => $category,
        'clobber'         => $clobber,
        'collector_name'  => $collector_name,
        'collector_secureFiles'   => $collector_secureFiles,
        'collector_url'   => $collector_url,
        'description'     => $description,
        'disableActionSource'     => $disableActionSource,
        'disableScriptSource'     => $disableScriptSource,
        'disableUpgrade'  => $disableUpgrade,
        'ephemeral'       => $ephemeral,
        'hostName'        => $hostName,
        'proxy_host'      => $proxy_host,
        'proxy_ntlmdomain' => $proxy_ntlmdomain,
        'proxy_password'  => $proxy_password,
        'proxy_port'      => $proxy_port,
        'proxy_user'      => $proxy_user,
        'runAs_username'  => $runAs_username,
        'skipRegistration'        => $skipRegistration,
        'sources'         => $sources,
        'syncSources'     => $syncSources,
        'targetCPU'       => $targetCPU,
        'timeZone'        => $timeZone,
        'winRunAs_password'        => $winRunAs_password,
      }),
  }


  # Install from package?
  if $use_package and $sumo_package_provider != '' {
    exec { 'Download SumoCollector Package':
      command => "/usr/bin/curl -o /usr/local/sumo/${sumo_package_filename} -q https://collectors.sumologic.com/rest/download/${sumo_package_suffix}",
      cwd     => '/usr/bin',
      creates => "/usr/local/sumo/${sumo_package_filename}",
      require => File['/usr/local/sumo'],
    }
    package { 'sumocollector':
      ensure   => installed,
      provider => $sumo_package_provider,
      source   => $dl_filename,
      require  => Exec['Download SumoCollector Package'],
    }
    service { 'sumocollector':
      ensure   => running,
      enable   => true,
      require  => Package['sumocollector'],
    }
  }
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

    service { 'collector' :
      ensure  => 'running',
      enable  => true,
    }
  }
}
