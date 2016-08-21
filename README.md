sumo-collector-puppet-module
============================

Puppet module for installing Sumo Logic's collector. This downloads the sumo
logic agent from the Internet, so Internet access is required on your machines.

## Usage
```Puppet
class { 'sumo':
  accessid       => 'accessid',
  accesskey      => 'accesskey',
  manage_sources => false,
}
```

## Parameters
This module supports almost all of the configuration options listed in
SumoLogic's [documentation](http://help.sumologic.com/Send_Data/Installed_Collectors/sumo.conf).  Head there
for a full explanation of what each option does to the SumoLogic collector.

The only required parameters are a pair of authentication parameters: either
`accessid` and `accesskey`, or `email` and `password`.

| Parameter Name        | Description                                            | Default value (in the module, not the collector)
|-----------------------|--------------------------------------------------------|-------------------------------------------------
| accessid              | The access id for the collector to register with       | undef
| accesskey             | The access key for the collector to register with      | undef
| clobber               | Whether you want to clobber the collector              | false
| collector_name        | Name of the collector                                  | undef
| email                 | The email for the collector to register with           | undef
| password              | The password for the collector to register with        | undef
| ephemeral             | Whether to mark the collector as ephemeral             | false
| manage_config_file    | If you want this module to manage your sumo.conf file  | true
| manage_sources        | If you want this module to manage your sources file    | false
| proxy_host            | When using a proxy, the hostname to connect to         | undef
| proxy_ntlmdomain      | When using an NTML proxy, the URL used to connect      | undef
| proxy_password        | When using a proxy, the password to use to connect     | undef
| proxy_port            | When using a proxy, the port to connect to             | undef
| proxy_user            | When using a proxy, the user to connect as             | undef
| sources               | The destination (on disk) of your sources file         | platform specific
| sumo_conf_source_path | The Puppet URL for your sumo.conf file                 | platform specific
| sumo_json_source_path | The Puppet URL for your sumo.json file                 | puppet:///modules/sumo/sumo.json
| sumo_exec             | The installation executable name                       | architecture specific
| sumo_short_arch       | The shortened architecture to download                 | architecture specific
| syncsources           | For Local File Configuration, the sources file to sync | $sources

## Testing / Contributing
See [CONTRIBUTING.md](https://github.com/SumoLogic/sumo-collector-puppet-module/blob/master/CONTRIBUTING.md).
