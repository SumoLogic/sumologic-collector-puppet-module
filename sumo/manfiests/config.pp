class sumo::config (
  $sumo_exec       = $sumo::params::sumo_exec,
  $sumo_short_arch = $sumo::params::sumo_short_arch,
) inherits sumo::params {


  file {
    '/sumo':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root';
    '/etc/sumo.conf':
      ensure => present,
      owner  => root,
      mode   => '0755',
      group  => root,
      source => 'puppet:///modules/sumo/sumo.conf';
    '/opt/SumoCollector':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root';
    '/sumo/sumo.json':
      ensure  => present,
      owner   => 'root',
      mode    => '0755',
      group   => 'root',
      source  => 'puppet:///modules/sumo/sumo.json',
      require => File['/sumo'];
  }

  exec { 'Download Sumo Executable':
    command => "/usr/bin/curl -o /sumo/${sumo_exec} https://collectors.sumologic.com/rest/download/linux/${sumo_short_arch}",
    cwd     => '/usr/bin',
    path    => [ '/usr/bin', '/usr/local/bin' ],
    creates => "/sumo/${sumo_exec}",
    require => File['/sumo'],
  }
  exec {'Execute sumo':
    command => "/sumo/${sumo_exec} -q",
    creates => '/opt/SumoCollector',
    path    => ['/usr/bin/', '/sumo', '/usr/local/bin' ],
    require => Exec['Download Sumo Executable'],
  }

}


