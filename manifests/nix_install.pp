#The Nix install class
class sumo::nix_install(
  ########## Parameters Section ##########
  $accessid               = $sumo::accessid,
  $accesskey              = $sumo::accesskey,
  $category               = $sumo::category,
  $clobber                 = $sumo::clobber,
  $collector_name          = $sumo::collector_name,
  $collector_secure_files  = $sumo::collector_secure_files,
  $collector_url           = $sumo::collector_url,
  $description             = $sumo::description,
  $disable_action_source   = $sumo::disable_action_source,
  $disable_script_source   = $sumo::disable_script_source,
  $disable_upgrade         = $sumo::disable_upgrade,
  $ephemeral               = $sumo::ephemeral,
  $fipsjce                 = $sumo::fipsjce,
  $hostname                = $sumo::hostname,
  $sources_file_override   = $sumo::sources_file_override,
  $sync_sources_override   = $sumo::sync_sources_override,
  $proxy_host              = $sumo::proxy_host,
  $proxy_ntlmdomain        = $sumo::proxy_ntlmdomain,
  $proxy_password          = $sumo::proxy_password,
  $proxy_port              = $sumo::proxy_port,
  $proxy_user              = $sumo::proxy_user,
  $runas_username          = $sumo::runas_username,
  $skip_access_key_removal = $sumo::skip_access_key_removal,
  $skip_registration       = $sumo::skip_registration,
  $sources_path            = $sumo::sources_path,
  $sumo_package_suffix     = $sumo::sumo_package_suffix,
  $sumo_package_provider   = $sumo::sumo_package_provider,
  $sumo_package_filename   = $sumo::sumo_package_filename,
  $sumo_short_arch         = $sumo::sumo_short_arch,
  $sumo_exec               = $sumo::sumo_exec,
  $local_config_mgmt       = $sumo::local_config_mgmt,
  $sync_sources_path       = $sumo::sync_sources_path,
  $sumo_tanuki_wrapper     = $sumo::sumo_tanuki_wrapper,
  $target_cpu              = $sumo::target_cpu,
  $time_zone               = $sumo::time_zone,
  $token                   = $sumo::token,
  $use_package             = $sumo::use_package,
  $use_tar_pkg             = $sumo::use_tar_pkg,
)
  {
    ############ Make sure the collector is not already installed.#####

    if !str2bool($::service_file_exists)
    {

      ########## Install from package? ########


      if $use_package {

        ########## Remove existing package if present ############

        file { 'sumo_package_rem':
          ensure => absent,
          path   => "/usr/local/sumo/${sumo_package_filename}",
        }

        ########## Download Sumo Package ############

        exec { 'Download SumoCollector Package':
          command => "/usr/bin/curl -o /usr/local/sumo/${sumo_package_filename} ${collector_url}/rest/download/${sumo_package_suffix}",
          cwd     => '/usr/bin',
          creates => "/usr/local/sumo/${sumo_package_filename}",
          require => [
            File['/usr/local/sumo'],
            File['sumo_package_rem'],
          ],
          path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
          unless  => 'ps -ef | grep -v grep | grep com.sumologic.scala.collector.Collector > /dev/null',
        }

          ########## Create user.properties ############

          if str2bool($skip_registration)
          {
            file { 'user.properties':
              ensure  => 'file',
              path    => '/opt/SumoCollector/config/user.properties',
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => epp('sumo/user.properties.epp', {
                'accessid'                => $accessid,
                'accesskey'               => $accesskey,
                'category'                => $category,
                'clobber'                 => $clobber,
                'collector_name'          => $collector_name,
                'collector_secure_files'  => $collector_secure_files,
                'collector_url'           => $collector_url,
                'description'             => $description,
                'disable_action_source'   => $disable_action_source,
                'disable_script_source'   => $disable_script_source,
                'disable_upgrade'         => $disable_upgrade,
                'ephemeral'               => $ephemeral,
                'fipsjce'                 => $fipsjce,
                'hostName'                => $hostname,
                'skip_access_key_removal' => $skip_access_key_removal,
                'sources_file_override'   => $sources_file_override,
                'sync_sources_override'   => $sync_sources_override,
                'proxy_host'              => $proxy_host,
                'proxy_ntlmdomain'        => $proxy_ntlmdomain,
                'proxy_password'          => $proxy_password,
                'proxy_port'              => $proxy_port,
                'proxy_user'              => $proxy_user,
                'runas_username'          => $runas_username,
                'skip_registration'       => $skip_registration,
                'sources_path'            => $sources_path,
                'local_config_mgmt'       => $local_config_mgmt,
                'sync_sources_path'       => $sync_sources_path,
                'target_cpu'              => $target_cpu,
                'time_zone'               => $time_zone,
                'token'                   => $token,
                'wrapper_java_command'    => undef,
              }),
              require => Package['collector'],
            }
        }
        else{
          file { 'user.properties':
            ensure  => 'file',
            path    => '/opt/SumoCollector/config/user.properties',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => epp('sumo/user.properties.epp', {
              'accessid'                => $accessid,
              'accesskey'               => $accesskey,
              'category'                => $category,
              'clobber'                 => $clobber,
              'collector_name'          => $collector_name,
              'collector_secure_files'  => $collector_secure_files,
              'collector_url'           => $collector_url,
              'description'             => $description,
              'disable_action_source'   => $disable_action_source,
              'disable_script_source'   => $disable_script_source,
              'disable_upgrade'         => $disable_upgrade,
              'ephemeral'               => $ephemeral,
              'fipsjce'                 => $fipsjce,
              'hostName'                => $hostname,
              'skip_access_key_removal' => $skip_access_key_removal,
              'sources_file_override'   => $sources_file_override,
              'sync_sources_override'   => $sync_sources_override,
              'proxy_host'              => $proxy_host,
              'proxy_ntlmdomain'        => $proxy_ntlmdomain,
              'proxy_password'          => $proxy_password,
              'proxy_port'              => $proxy_port,
              'proxy_user'              => $proxy_user,
              'runas_username'          => $runas_username,
              'skip_registration'       => $skip_registration,
              'sources_path'            => $sources_path,
              'local_config_mgmt'       => $local_config_mgmt,
              'sync_sources_path'       => $sync_sources_path,
              'target_cpu'              => $target_cpu,
              'time_zone'               => $time_zone,
              'token'                   => $token,
              'wrapper_java_command'    => undef,

            }),
            require => Package['collector'],
            notify  => Service['collector'];
          }
        }

        ########## Install Package ############

        package { 'collector':
          ensure   => installed,
          provider => $sumo_package_provider,
          source   => "/usr/local/sumo/${sumo_package_filename}",
          require  => Exec['Download SumoCollector Package'],
        }

        ########## Run configureFipsMode.sh  ############
        if $fipsjce {
          exec {'/bin/bash /opt/SumoCollector/script/configureFipsMode.sh -j /opt/SumoCollector/jre/':
            path   => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/sbin'],
            onlyif => 'cat /proc/sys/crypto/fips_enabled',
          }
        }

      } # Use Package

      elsif $use_tar_pkg {
        if ($::java_exists)
          {
            ########## Remove existing package if present ############
            file { 'sumo_tar_package_rem':
              ensure => absent,
              path   => '/opt/SumoCollector_unix.tar.gz',
            }
            ########## Download Sumo Package ############
            exec { 'Download SumoCollector Tar Package':
              command => "/usr/bin/curl -o /opt/SumoCollector_unix.tar.gz ${collector_url}/rest/download/tar",
              cwd     => '/usr/bin',
              creates => '/opt/SumoCollector_unix.tar.gz',
              require => [
                File['/usr/local/sumo'],
                File['sumo_tar_package_rem'],
              ],
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              unless  => 'ps -ef | grep -v grep | grep com.sumologic.scala.collector.Collector > /dev/null',
            }
            ########## Extract Sumo Tar Package ############
            exec { 'Extract SumoCollector Package':
              command => '/usr/bin/tar -xvf /opt/SumoCollector_unix.tar.gz',
              cwd     => '/opt',
              creates => '/opt/sumocollector',
              require => [
                Exec['Download SumoCollector Tar Package'],
              ],
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
            }
            ########## Copy Tanuki Wrapper to sumocollector directory and change permissions ############
            exec { 'Copy Tanuki Wrapper':
              command => "cp /opt/sumocollector/tanuki/${sumo_tanuki_wrapper} /opt/sumocollector",
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              require => [
                Exec['Extract SumoCollector Package'],
              ],
            }

            exec { 'Change wrapper permissions':
              command => "chmod ug+x /opt/sumocollector/${sumo_tanuki_wrapper}",
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              require => [
                Exec['Copy Tanuki Wrapper'],
              ],
            }

            exec { 'Change collector permissions':
              command => 'chmod ug+x /opt/sumocollector/collector',
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              require => [
                Exec['Copy Tanuki Wrapper'],
              ],
            }

            exec { 'Change script permissions':
              command => 'chmod ug+x /opt/sumocollector/script/*',
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              require => [
                Exec['Copy Tanuki Wrapper'],
              ],
            }
            ########## Create user.properties ############

            if str2bool($skip_registration)
            {
                file { 'user.properties':
                  ensure  => 'file',
                  path    => '/opt/sumocollector/config/user.properties',
                  owner   => 'root',
                  group   => 'root',
                  mode    => '0644',
                  content => epp('sumo/user.properties.epp', {
                    'accessid'                => $accessid,
                    'accesskey'               => $accesskey,
                    'category'                => $category,
                    'clobber'                 => $clobber,
                    'collector_name'          => $collector_name,
                    'collector_secure_files'  => $collector_secure_files,
                    'collector_url'           => $collector_url,
                    'description'             => $description,
                    'disable_action_source'   => $disable_action_source,
                    'disable_script_source'   => $disable_script_source,
                    'disable_upgrade'         => $disable_upgrade,
                    'ephemeral'               => $ephemeral,
                    'fipsjce'                 => $fipsjce,
                    'hostName'                => $hostname,
                    'skip_access_key_removal' => $skip_access_key_removal,
                    'sources_file_override'   => $sources_file_override,
                    'sync_sources_override'   => $sync_sources_override,
                    'proxy_host'              => $proxy_host,
                    'proxy_ntlmdomain'        => $proxy_ntlmdomain,
                    'proxy_password'          => $proxy_password,
                    'proxy_port'              => $proxy_port,
                    'proxy_user'              => $proxy_user,
                    'runas_username'          => $runas_username,
                    'skip_registration'       => $skip_registration,
                    'sources_path'            => $sources_path,
                    'local_config_mgmt'       => $local_config_mgmt,
                    'sync_sources_path'       => $sync_sources_path,
                    'target_cpu'              => $target_cpu,
                    'time_zone'               => $time_zone,
                    'token'                   => $token,
                    'wrapper_java_command'    => 'java',
                  }),
                  require => Exec['Copy Tanuki Wrapper'],
                }
            }
            else
            {
              file { 'user.properties':
                  ensure  => 'file',
                  path    => '/opt/sumocollector/config/user.properties',
                  owner   => 'root',
                  group   => 'root',
                  mode    => '0644',
                  content => epp('sumo/user.properties.epp', {
                    'accessid'                => $accessid,
                    'accesskey'               => $accesskey,
                    'category'                => $category,
                    'clobber'                 => $clobber,
                    'collector_name'          => $collector_name,
                    'collector_secure_files'  => $collector_secure_files,
                    'collector_url'           => $collector_url,
                    'description'             => $description,
                    'disable_action_source'   => $disable_action_source,
                    'disable_script_source'   => $disable_script_source,
                    'disable_upgrade'         => $disable_upgrade,
                    'ephemeral'               => $ephemeral,
                    'fipsjce'                 => $fipsjce,
                    'hostName'                => $hostname,
                    'skip_access_key_removal' => $skip_access_key_removal,
                    'sources_file_override'   => $sources_file_override,
                    'sync_sources_override'   => $sync_sources_override,
                    'proxy_host'              => $proxy_host,
                    'proxy_ntlmdomain'        => $proxy_ntlmdomain,
                    'proxy_password'          => $proxy_password,
                    'proxy_port'              => $proxy_port,
                    'proxy_user'              => $proxy_user,
                    'runas_username'          => $runas_username,
                    'skip_registration'       => $skip_registration,
                    'sources_path'            => $sources_path,
                    'local_config_mgmt'       => $local_config_mgmt,
                    'sync_sources_path'       => $sync_sources_path,
                    'target_cpu'              => $target_cpu,
                    'time_zone'               => $time_zone,
                    'token'                   => $token,
                    'wrapper_java_command'    => 'java',
                  }),
                  require => Exec['Copy Tanuki Wrapper'],
                  notify  => Service['collector'];
                }
            }
            ########## Set access control ############
            exec { 'Set access control':
              command => 'sudo /opt/sumocollector/script/secureFiles.sh',
              path    => ['/usr/bin', '/usr/sbin', ],
              require => [
                File['user.properties'],
              ],
            }
            ########## Install Package ############
            exec { 'Install the Collector':
              command => 'sudo /opt/sumocollector/collector install',
              path    => ['/usr/bin', '/usr/sbin', ],
              require => [
                Exec['Set access control'],
              ],
            }
          }
        else
        {
          fail('The collector requires Java 8 or higher already installed for Tarball installation.')
        }
      } # Use tar package
      else {
        ####### Download Script based installer and Install ###########


        ########## Remove existing package if present ############


        file { 'sumo_executable_rem':
          ensure => absent,
          path   => "/usr/local/sumo/${sumo_exec}",
        }

        ########## Download Sumo Executable package ############

        exec { 'Download Sumo Executable':
          command => "/usr/bin/curl -o /usr/local/sumo/${sumo_exec} ${collector_url}/rest/download/linux/${sumo_short_arch}",
          cwd     => '/usr/bin',
          creates => "/usr/local/sumo/${sumo_exec}",
          require => [
            File['/usr/local/sumo'],
            File['sumo_executable_rem'],
          ],
          path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
          unless  => 'ps -ef | grep -v grep | grep com.sumologic.scala.collector.Collector > /dev/null',
        }

        ########## Install Sumo Executable package ############
        if str2bool($skip_registration)
            {
            exec { 'Execute sumo':
              command => "/bin/sh /usr/local/sumo/${sumo_exec} -q -varfile /etc/sumo/sumoVarFile.txt",
              cwd     => '/usr/local/sumo',
              creates => '/opt/SumoCollector/jre',
              require => File['/etc/sumo/sumoVarFile.txt'],
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              unless  => 'ps -ef | grep -v grep | grep com.sumologic.scala.collector.Collector > /dev/null',
            }
        }
        else
        {
            exec { 'Execute sumo':
              command => "/bin/sh /usr/local/sumo/${sumo_exec} -q -varfile /etc/sumo/sumoVarFile.txt",
              cwd     => '/usr/local/sumo',
              creates => '/opt/SumoCollector/jre',
              require => File['/etc/sumo/sumoVarFile.txt'],
              notify  => Service['collector'],
              path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
              unless  => 'ps -ef | grep -v grep | grep com.sumologic.scala.collector.Collector > /dev/null',
            }
        }
      } #Script Based installer

    } # Service Exists
    else
    {
      notice('Service already installed.')
    }

      if !str2bool($skip_registration)
      {
        ####### Make sure that the collector service is running ###########

        service { 'collector':
          ensure     => 'running',
          hasstatus  => true,
          hasrestart => true,
          enable     => true,
      }
    }

  }
