sumo-collector-puppet-module
============================

Puppet module for installing Sumo Logic's collector. This downloads the sumo logic agent from the Internet, so Internet access is required on your machines.



## The Files in the files directory are stubs for the json and config if the conf file is not filled out on windows it will not install properly.


## Usage  

include sumo


## optional variables

`$sumo_conf_source_path` - source path to the .conf file which contains access/secret key
`$sumo_json_source_path` - source path to the .json file to configure sources
