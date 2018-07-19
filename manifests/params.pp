# Shared params class
class sumo::params () {
  $sumo_win_arch = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'win64',
    'x86'                   => 'windows',
    default                   => fail("there is no supported arch $::architecture}"),
  }

  $sumo_exec = $::architecture ? {
    /(x86_64|amd64|x64)/    => 'sumo64.sh',
    'x86'                   => 'sumo32.sh',
  }

  $sumo_short_arch = $::architecture ? {
    /x86_64|amd64|x64/      => '64',
    'x86'                   => '32',
    default                   => fail("there is no supported arch $::architecture}"),
  }

  $sumo_json_source_path = $::osfamily ? {
    'windows'       => 'puppet:///modules/sumo/json/sumo_win.json',
    default         => 'puppet:///modules/sumo/json/sumo_nix.json',
  }

  $sources = $::osfamily ? {
    'windows'       => 'C:\\sumo\\sumo.json',
    default         => '/usr/local/sumo/sumo.json',
  }

  $syncSources           = $sources
}
