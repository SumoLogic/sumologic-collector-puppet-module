# class for sumologic windows config
class sumo::win_config (
  ########## Parameters Section ##########
  $collector_url                 = $sumo::collector_url,
  $local_config_mgmt             = $sumo::local_config_mgmt,
  $sources_file_override         = $sumo::sources_file_override,
  $sync_sources_override         = $sumo::sync_sources_override,
  $sources_directory_or_file     = $sumo::sources_directory_or_file,
  $sources_path                  = $sumo::sources_path,
  $sumo_json_source_path         = $sumo::sumo_json_source_path,
  $sumo_json_sync_source_path    = $sumo::sumo_json_sync_source_path,
  $sync_sources_path             = $sumo::sync_sources_path
){
  ############# Make sure sources file exists if the sources file should not be overridden and local_config_mgmt is false #########

  if ( !$local_config_mgmt and !$sources_file_override ){

    if ($sources_directory_or_file == 'file' and !str2bool($::sources_file_exists_win))
    {
      fail('Please make sure sources.json exists in C:\sumo directory.')
    }
    elsif (($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory') and !str2bool($::sources_dir_exists_win))
    {
      fail('Please make sure that the directory C:\sumo exists with source JSON files.')
    }
  }


  ############# Make sure syncsources file exists if the sync sources override is false and local_config_mgmt is true #########

  if ($local_config_mgmt and !$sync_sources_override){


    if ($sources_directory_or_file == 'file' and !str2bool($::sync_file_exists_win))
    {
      fail('Please make sure syncsources.json exists in C:\sumo directory.')
    }
    elsif (($sources_directory_or_file == 'dir' or $sources_directory_or_file == 'directory') and !str2bool($::sources_dir_exists_win))
    {
      fail('Please make sure that the directory C:\sumo exists with sync source JSON files.')
    }
  }

  ########### Create sumo directory and copy the powershell script for downloading the installer ##########
  file {
    'C:\sumo\download_sumo.ps1':
      ensure  => present,
      mode    => '0777',
      group   => 'Administrators',
      require => File['C:\sumo'],
      content => epp('sumo/download_sumo.ps1.epp', {'collector_url' => $collector_url,});

    'C:\sumo':
      ensure => directory,
      mode   =>  '0777',
      group  => 'Administrators';
  }


  ########### Override Sources? Get the sources file from puppet. ###########
  if ($sources_file_override and !$local_config_mgmt){
    file { $sources_path:
      ensure  => present,
      mode    => '0644',
      group   => 'Administrators',
      source  => $sumo_json_source_path,
      require => File['C:\sumo']
    }
  }

  ########### Override Sync-Sources? Get the sync-sources file from puppet. ###########

  if ($sync_sources_override and $local_config_mgmt) {
    file { $sync_sources_path :
      ensure  => present,
      mode    => '0644',
      group   => 'Administrators',
      source  => $sumo_json_sync_source_path,
      require => File['C:\sumo']

    }
  }
}
