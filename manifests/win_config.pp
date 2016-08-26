# class for sumologic windows config
class sumo::win_config (
  $accessid               = $sumo::accessid,
  $accesskey              = $sumo::accesskey,
  $clobber                = $sumo::clobber,
  $collector_name         = $sumo::collector_name,
  $email                  = $sumo::email,
  $ephemeral              = $sumo::ephemeral,
  $manage_config_file     = $sumo::manage_config_file,
  $manage_sources         = $sumo::manage_sources,
  $password               = $sumo::password,
  $proxy_host             = $sumo::proxy_host,
  $proxy_ntlmdomain       = $sumo::proxy_ntlmdomain,
  $proxy_password         = $sumo::proxy_password,
  $proxy_port             = $sumo::proxy_port,
  $proxy_user             = $sumo::proxy_user,
  $sources                = $sumo::sources,
  $sumo_conf_source_path  = $sumo::sumo_conf_source_path,
  $sumo_exec              = $sumo::sumo_exec,
  $sumo_short_arch        = $sumo::sumo_short_arch,
  $syncsources            = $sumo::syncsources,
) {
  unless ($accessid != undef and $accesskey != undef) or ($email != undef and $password != undef) {
    fail(
      'You must provide either an accesskey and accessid, or an email and password for the SumoLogic collector to connect with.'
    )
  }

  file {
    'C:\sumo\download_sumo.ps1':
      ensure  => present,
      mode    => '0777',
      group   => 'Administrators',
      source  => 'puppet:///modules/sumo/download_sumo.ps1',
      require => File['C:\sumo'];

    'C:\sumo':
      ensure => directory,
      mode   =>  '0777',
      group  => 'Administrators';
  }

  if $manage_sources {
    file { 'C:\sumo\sumo.json':
      ensure  => present,
      mode    => '0644',
      group   => 'Administrators',
      source  => $sumo::sumo_json_source_path,
      require => File['C:\sumo'],
    }
  }

  if $manage_config_file {
    file { 'C:\sumo\sumo.conf':
      ensure  => present,
      mode    => '0644',
      group   => 'Administrators',
      content => template('sumo/sumo.conf.erb'),
      require => File['C:\sumo'];
    }
  }

  $powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
  exec { 'download_sumo':
    command => "${powershell_path} -executionpolicy remotesigned -file C:\\sumo\\download_sumo.ps1",
    require => File['C:\sumo\download_sumo.ps1'],
    creates => 'C:\sumo\sumo.exe'
  }

  package { 'sumologic':
    ensure          => installed,
    install_options => ['-q'],
    source          => 'C:\sumo\sumo.exe',
    require         => [
      Exec['download_sumo'],
      File['C:\sumo\sumo.conf'],
    ]
  }
}
