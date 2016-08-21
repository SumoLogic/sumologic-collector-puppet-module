# Class for sumologic nix config
class sumo::nix_config (
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

  file { '/usr/local/sumo':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  if $manage_sources {
    file { '/usr/local/sumo/sumo.json':
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
      content => template('sumo/sumo.conf.erb')
    }
  }

  exec { 'Download Sumo Executable':
    command => "/usr/bin/curl -o /usr/local/sumo/${sumo_exec} https://collectors.sumologic.com/rest/download/linux/${sumo_short_arch}",
    cwd     => '/usr/bin',
    creates => "/usr/local/sumo/${sumo_exec}",
    require => File['/usr/local/sumo'],
  }

  exec { 'Execute sumo':
    command => "/bin/sh /usr/local/sumo/${sumo_exec} -q",
    cwd     => '/usr/local/sumo',
    creates => '/opt/SumoCollector',
    require => Exec['Download Sumo Executable'],
  }
}
