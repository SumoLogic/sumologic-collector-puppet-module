
class sumo {

    file { '/etc/sumo.conf':
      ensure  => present,
      owner   => root,
      mode    =>0755,
      group   => root,
      source => "puppet:///files/sumo/sumo.conf"
    }
    file { '/sumo/sumo.json':
      ensure  => present,
      owner   => root,
      mode    =>0755,
      group   => root,
      source => "puppet:///files/sumo/sumo.json"
    }
  }

case $::architecture {
  'x86_64':{
        exec { "/usr/bin/curl -o /sumo/sumo64.sh https://collectors.sumologic.com/rest/download/linux/64":
        cwd     => "/usr/bin",
        creates => "/opt/SumoCollector",
        }
        exec { "/sumo/sumo64.sh -q":
        creates => "/opt/SumoCollector",
        }
  }
  'x86':{
        exec { "/usr/bin/curl -o /sumo/sumo32.sh https://collectors.sumologic.com/rest/download/linux/32":
        cwd     => "/usr/bin",
        creates => "/opt/SumoCollector",
        }
        exec { "/sumo/sumo32.sh -q":
        creates => "/opt/SumoCollector",
        }
  }
}
node 'client1' {
    include sumo
}
