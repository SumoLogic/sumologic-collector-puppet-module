# sumo-collector-puppet-module

### Sumo Puppet Module Overview

- The Sumo Puppet module downloads the sumo logic collector agent from the Internet and installs the Sumo Collector agent. The module needs to download the package from the Sumologic API's so Internet access is required on your machines.
- The module also allows sources to be created during installation and updated afterwards.
- Currently, the module only supports the installation of latest collector version.
- Upgrade of the collector is not supported currently.

#### Note:

For Puppet 4.x and later:

- Utilize the release v0.2.1 or later. Release v0.2.1 and subsequent v0.2.x releases will be enhanced per puppet guidelines to support latest puppet versions.

For Puppet 3.x:

- Utilize the release v1.0.6 if you need sumo.conf compatibility.
- Utilize the release v1.0.8 if you need latest SumoLogic collector compatibility.

## Setup

To begin using this module, use the Puppet Module Tool (PMT) from the command line to install this module:

puppet module install sumologic-sumo

To install Sumo Puppet Module from GitHub, follow below steps:

- Navigate to Puppet global modules directory or specific environment modules directory.
- Clone the Sumo Puppet module.
- Rename the module as sumo.

## Usage

Once the Sumo puppet module is installed, you will need to supply the sumo class with the authentication information.

- The accessid.
- The accesskey.

OR

- One-time token for installation.

Additional optional parameters can be passed as required. The parameters details are explained in the next section.

### Examples

A basic example, using accesskey/accessid, module expects the sources.json to be present on agent nodes in the default directory:

```Puppet
class { 'sumo':
  accessid       => 'accessid',
  accesskey      => 'accesskey',
}
```

Another example, using accesskey/accessid and manage_sources as true, the module will copy the sources.json on agent nodes in the default directory:

```Puppet
class { 'sumo':
  accessid       => 'accessid',
  accesskey      => 'accesskey',
  manage_sources => true,
}
```

Note: manage_sources will be deprecated in future releases, use sources_override instead.

Below example illustrates setting up local configuration management. In this case the syncsources.json file will be used for describing Sources to configure on registration, which will be continuously monitored and synchronized with the Collector's configuration.
In this case the module expects the syncsources.json to be present on agent nodes in the default directory:

```Puppet
class { 'sumo':
  accessid              => 'accessid',
  accesskey             => 'accesskey',
  local_config_mgmt     => true,
}
```

Below example illustrates local configuration management with the syncsources.json being managed by the puppet master i.e. the module will copy the syncsources.json on agent nodes in the default directory:

```Puppet
class { 'sumo':
  accessid              => 'accessid',
  accesskey             => 'accesskey',
  local_config_mgmt     => true,
  sync_sources_override => true,
}
```

All the above examples illustrate setting up the sources using a single JSON file (sources.json/syncsources.json) present under the default directory.
To specify sources in multiple JSON files, specify the parameter sources_directory_or_file as 'dir'. If specified as 'dir', the collector will look for any JSON files present under the default directory:

```Puppet
class { 'sumo':
  accessid                  => 'accessid',
  accesskey                 => 'accesskey',
  sources_directory_or_file => 'dir',
}
```

With local configuration management:

```Puppet
class { 'sumo':
  accessid                  => 'accessid',
  accesskey                 => 'accesskey',
  local_config_mgmt         => true,
  sources_directory_or_file => 'dir',
}
```

Advanced example illustrating passing additional command-line parameters and using rpm or deb package for installation:

```Puppet
class { 'sumo':
  accessid                => 'accessid',
  accesskey               => 'accesskey',
  sync_sources_override   => true,
  use_package	          => true,
  local_config_mgmt       => true,
  clobber                 => false,
  ephemeral               => true,
  skip_access_key_removal => true,
}
```

Advanced example illustrating tarball binary package for installation:

```Puppet
class { 'sumo':
  accessid                => 'accessid',
  accesskey               => 'accesskey',
  sync_sources_override   => true,
  use_package	          => false,
  use_tar_pkg             => true,
  local_config_mgmt       => true,
  clobber                 => false,
  ephemeral               => true,
  skip_access_key_removal => true,
}
```

## Parameters

This module supports all the command-line options except dir [directory] listed in
SumoLogic's [documentation](https://help.sumologic.com/Send-Data/Installed-Collectors/05Reference-Information-for-Collector-Installation/06Parameters-for-the-Command-Line-Installer). Head there
for a full explanation of what each option does to the SumoLogic collector.

The only required parameters are a pair of authentication parameters: `accessid` and `accesskey`.

| Parameter Name             | Description                                                                                                                                                                                                 | Default value (in the module, not the collector) |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| accessid                   | The access id for the collector to register with                                                                                                                                                            | undef                                            |
| accesskey                  | The access key for the collector to register with                                                                                                                                                           | undef                                            |
| token                      | One-time token for installation                                                                                                                                                                             | undef                                            |
| clobber                    | Whether you want to clobber the collector                                                                                                                                                                   | false                                            |
| collector_name             | Name of the collector                                                                                                                                                                                       | undef                                            |
| collector_secure_files     | To enable or disable Enhanced File System Security                                                                                                                                                          | undef                                            |
| collector_url              | The URL used to download and register Collector                                                                                                                                                             | 'https://collectors.sumologic.com'               |
| description                | Description for the Collector to appear in Sumo Logic                                                                                                                                                       | undef                                            |
| disable_action_source      | To disable the running of script-based Sources                                                                                                                                                              | undef                                            |
| disable_script_source      | To disable the running of script-based action Sources                                                                                                                                                       | undef                                            |
| disable_upgrade            | If true, the Collector rejects upgrade requests from Sumo Logic                                                                                                                                             | undef                                            |
| ephemeral                  | Whether to mark the collector as ephemeral                                                                                                                                                                  | false                                            |
| fipsjce                    | Whether or not to enable FIPS 140-2 compliant Java Cryptography Extension (JCE)                                                                                                                             | false                                            |
| hostname                   | The host name of the machine on which the Collector is running                                                                                                                                              | Hostname                                         |
| local_config_mgmt          | If you want this module to enable local config management                                                                                                                                                   | false                                            |
| manage_sources             | If you want this module to manage your sources file, will be deprecated in later releases. Use sources_override                                                                                             | false                                            |
| proxy_host                 | When using a proxy, the hostname to connect to                                                                                                                                                              | undef                                            |
| proxy_ntlmdomain           | When using an NTML proxy, the URL used to connect                                                                                                                                                           | undef                                            |
| proxy_password             | When using a proxy, the password to use to connect                                                                                                                                                          | undef                                            |
| proxy_port                 | When using a proxy, the port to connect to                                                                                                                                                                  | undef                                            |
| proxy_user                 | When using a proxy, the user to connect as                                                                                                                                                                  | undef                                            |
| runas_username             | When set, the Collector will run as the specified user                                                                                                                                                      | undef                                            |
| skip_access_key_removal    | If true, it will skip the access key removal from the user.properties file                                                                                                                                  | false                                            |
| skip_registration          | When true, the Collector will install files and create user.properties file, but not register or start the Collector                                                                                        | 'false'                                          |
| sources_override           | If you want this module to manage your sources file                                                                                                                                                         | false                                            |
| sources_directory_or_file  | 'file': Sources are listed in a single JSON file (sources.json/syncsources.json) in default dir. 'dir': Sources are listed in multiple JSON files under the default directory. (/usr/local/sumo or c:\sumo) | 'file'                                           |
| sumo_exec                  | The installation executable name                                                                                                                                                                            | architecture specific                            |
| sumo_json_source_path      | The Puppet URL for your sources.json file                                                                                                                                                                   | puppet:///modules/sumo/sources.json              |
| sumo_json_sync_source_path | The Puppet URL for your syncsources.json file                                                                                                                                                               | puppet:///modules/sumo/syncsources.json          |
| sumo_package_filename      | Name to store the downloaded sumo package with                                                                                                                                                              | architecture specific (if use_package == true)   |
| sumo_package_suffix        | The final string on the download URL                                                                                                                                                                        | architecture specific (if use_package == true)   |
| sumo_package_provider      | Puppet package provider to install the package                                                                                                                                                              | architecture specific (if use_package == true)   |
| sumo_short_arch            | The shortened architecture to download                                                                                                                                                                      | architecture specific                            |
| sumo_win_arch              | The shortened architecture to download                                                                                                                                                                      | architecture specific                            |
| sync_sources_override      | If you want this module to manage your sync sources file                                                                                                                                                    | false                                            |
| target_cpu                 | You can choose to set a CPU target to limit the amount of CPU processing a Collector uses                                                                                                                   | undef                                            |
| time_zone                  | The time zone to use when the time zone can't be extracted from the time stamp                                                                                                                              | undef                                            |
| use_package                | Install from a rpm or a deb package. This flag overrides the tarball flag: use_tar_pkg i.e. if both use_package and use_tar_pkg are true, the rpm or the deb package will be used for installation.         | false                                            |
| use_tar_pkg                | Install from a tarball.                                                                                                                                                                                     | false                                            |
| win_run_as_password        | When set in conjunction with -VrunAs.username, the Collector will run as the specified user with the specified password                                                                                     | undef                                            |

## Testing / Contributing

See [CONTRIBUTING.md](https://github.com/SumoLogic/sumo-collector-puppet-module/blob/master/CONTRIBUTING.md).
