# Shared params class
class sumo::params {
  if ($::osfamily == 'windows') {
    $sumo_conf_source_path  = 'puppet:///modules/sumo/sumo_win.conf'
    $sources = 'C:\sumo\sumo.json'
  } else {
    $sumo_conf_source_path  = 'puppet:///modules/sumo/sumo_nix.conf'
    $sources = '/usr/local/sumo/sumo.json'
    case $::architecture {
      'x86_64', 'amd64': {
        $sumo_exec       = 'sumo64.sh'
        $sumo_short_arch = '64'
      }
      'x86': {
        $sumo_exec       = 'sumo32.sh'
        $sumo_short_arch = '32'
      }
      default: { fail("there is no supported arch ${::architecture}") }
    }
  }

  $sumo_json_source_path = 'puppet:///modules/sumo/sumo.json'
  $syncsources           = $sources
}
