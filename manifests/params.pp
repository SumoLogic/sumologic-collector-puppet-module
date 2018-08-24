# Shared params class
class sumo::params () {
  $sumo_win_arch = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'win64',
    'x86'                   => 'windows',
    default                 => fail("There is no supported arch:: ${::architecture}"),
  }

  $sumo_exec = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'sumo64.sh',
    'x86'                   => 'sumo32.sh',
  }

  $sumo_short_arch = $::architecture ? {
    /x86_64|amd64|x64/      => '64',
    'x86'                   => '32',
    default                 => fail("There is no supported arch:: ${::architecture}"),
  }

  $sumo_json_source_path = $::osfamily ? {
    'windows'       => 'puppet:///modules/sumo/sumo_win.json',
    default         => 'puppet:///modules/sumo/sumo_nix.json',
  }

  $sumo_json_sync_source_path = $::osfamily ? {
    'windows'       => 'puppet:///modules/sumo/sumo_sync_win.json',
    default         => 'puppet:///modules/sumo/sumo_sync_nix.json',
  }


  case $::osfamily {

    'Debian': {

      if $sumo_short_arch != '64'
      {
        fail('Debian package supported only for 64 bit architecture.')

      }

      $sumo_package_suffix   = "deb/${sumo_short_arch}"
      $sumo_package_filename = 'sumocollector.deb'
      $sumo_package_provider = 'dpkg'
    }
    'Redhat': {

      if $sumo_short_arch != '64'
      {
        fail('Redhat package supported only for 64 bit architecture.')

      }

      $sumo_package_suffix   = "rpm/${sumo_short_arch}"
      $sumo_package_filename = 'sumocollector.rpm'
      $sumo_package_provider = 'rpm'
    }
    'Suse': {

      if $sumo_short_arch != '64'
      {
        fail('Redhat package supported only for 64 bit architecture.')

      }

      $sumo_package_suffix   = "rpm/${sumo_short_arch}"
      $sumo_package_filename = 'sumocollector.rpm'
      $sumo_package_provider = 'rpm'
    }
    default: {
      $sumo_package_suffix   = ''
      $sumo_package_filename = ''
      $sumo_package_provider = ''
    }
  }
}
