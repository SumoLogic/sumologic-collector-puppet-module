# class for sumologic windows config
class sumo::win_config (
  $sumo_exec       = $sumo::params::sumo_exec,
  $sumo_short_arch = $sumo::params::sumo_short_arch,
  $accessid        = $sumo::accessid,
  $accesskey       = $sumo::accesskey,
  $sumo_conf_source_path = $sumo::params::sumo_conf_source_path,
  $sumo_json_source_path = $sumo::params::sumo_json_source_path,
  $sources_disk_path = 'c:/sumo/sumo.json'
) inherits sumo::params {
  file {
    'c:/sumo/download_sumo.ps1':
      ensure  => present,
      mode    => '0777',
      group   => 'Administrators',
      source  => 'puppet:///modules/sumo/download_sumo.ps1',
      require => File['c:/sumo/'];
    'c:/sumo/':
      ensure => directory,
      mode   =>  '0777',
      group  => 'Administrators';
    'c:/sumo/sumo.json':
      ensure  => present,
      mode    => '0644',
      group   => 'Administrators',
      source  => $sumo_json_source_path,
      require => File['c:/sumo/'];
  }
  exec { 'download_sumo':
    command => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -executionpolicy remotesigned -file C:\\sumo\\download_sumo.ps1',
    require => File['c:/sumo/download_sumo.ps1'],
    creates => 'C:/sumo/sumo.exe'
    # path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    # refreshonly => true,
    }
    if ($accessid != nil) and ($accesskey != nil){
      file{ 'c:/sumo/sumo.conf':
        ensure  => present,
        mode    => '0644',
        group   => 'Administrators',
        content => template('sumo/sumo.conf.erb'),
        before  => Package['sumologic'];
      }
    }
    else {
      file { 'c:/sumo/sumo.conf':
        ensure => present,
        mode   => '0644',
        group  => 'Administrators',
        source => $sumo_conf_source_path,
        before => Package['sumologic'];
      }
    }
    package { 'sumologic':
      ensure          => installed,
      install_options => ['-q'],
      source          => 'C:/sumo/sumo.exe',
      require         => Exec['download_sumo']
    }
}
