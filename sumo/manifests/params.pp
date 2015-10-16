class sumo::params {

  case $::architecture {
    'x86_64': {
      $sumo_exec       = 'sumo64.sh'
      $sumo_short_arch = '64'
    }
    'amd64': {
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

