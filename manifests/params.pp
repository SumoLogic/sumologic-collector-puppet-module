# Shared params class
class sumo::params () {
  $sumo_win_arch = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'win64',
    'x86'                   => 'windows',
    'i386'                   => 'windows',
    default                 => fail("There is no supported arch:: ${::architecture}"),
  }

  $sumo_exec = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'sumo64.sh',
    'x86'                   => 'sumo32.sh',
    'i386'                  => 'sumo32.sh',
    default                 => fail("There is no supported arch:: ${::architecture}"),
  }

  $sumo_short_arch = $::architecture ? {
    /x86_64|amd64|x64/      => '64',
    'x86'                   => '32',
    'i386'                  => '32',
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

      if $sumo_short_arch == '64'
      {
        $sumo_package_suffix   = "deb/${sumo_short_arch}"
        $sumo_package_filename = 'sumocollector.deb'
        $sumo_package_provider = 'dpkg'
      }
      else {
        $sumo_package_suffix   = ''
        $sumo_package_filename = ''
        $sumo_package_provider = ''
      }
    }
    'Redhat': {

      if $sumo_short_arch == '64'
      {
        $sumo_package_suffix   = "rpm/${sumo_short_arch}"
        $sumo_package_filename = 'sumocollector.rpm'
        $sumo_package_provider = 'rpm'
      }
      else {
        $sumo_package_suffix   = ''
        $sumo_package_filename = ''
        $sumo_package_provider = ''
      }
    }
    'Suse': {

      if $sumo_short_arch == '64'
      {
        $sumo_package_suffix   = "rpm/${sumo_short_arch}"
        $sumo_package_filename = 'sumocollector.rpm'
        $sumo_package_provider = 'rpm'
      }
      else {
        $sumo_package_suffix   = ''
        $sumo_package_filename = ''
        $sumo_package_provider = ''
      }
    }
    default: {
      $sumo_package_suffix   = ''
      $sumo_package_filename = ''
      $sumo_package_provider = ''
    }
  }
}
