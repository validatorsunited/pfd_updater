# pfd updater
Bash script for price-feeder config update
## Version 1.1.2

Applied for Umee and Ojo networks.

Script downloading new config file, export all data from [account] section till end of file into persistent.toml meaning this data will not be changed, as it applied to personal settings. Then export all data before [account] section into temporary file, making backup of existing config with provided date and time in filename, then merge temporary and persistent files.

As a result you have new config without manual editing.

`listen_addr` is now part of persistent settings, so update won't touch it.

## How to use:
Script suggest you have default variables for your price-feeder

Path to price-feeder directory
`PATH_TO_PFD="$HOME/price-feeder_config"`

Config file name
`PFD_NAME="price-feeder.toml"`

## Install
Paste command in terminal and check your path and config name variables
```
wget -q -O pfd_updater.sh https://raw.githubusercontent.com/validatorsunited/pfd_updater/main/pfd_updater.sh 
nano pfd_updater.sh
chmod +x pfd_updater.sh
/bin/bash pfd_updater.sh
```
