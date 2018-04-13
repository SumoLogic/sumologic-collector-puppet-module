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

    case $::osfamily {
      'Debian': {
        $sumo_package_suffix   = "deb/${sumo_short_arch}"
        $sumo_package_filename = 'sumocollector.deb'
        $sumo_package_provider = 'dpkg'
      }
      'Redhat': {
        $sumo_package_suffix   = "rpm/${sumo_short_arch}"
        $sumo_package_filename = 'sumocollector.rpm'
        $sumo_package_provider = 'rpm'
      }
      default: {
        $sumo_package_provider = ''
      }
    }
  }

  $sumo_conf_template_path = 'sumo/sumo.conf.erb'
  $sumo_json_source_path = 'puppet:///modules/sumo/sumo.json'
  $syncsources           = $sources
}
