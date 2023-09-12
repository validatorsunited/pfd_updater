#!/bin/bash

#Path to price-feeder directory
PATH_TO_PFD="$HOME/price-feeder_config"
#Config file name
PFD_NAME="price-feeder.toml"

#begin
echo -e "\033[1mPFD updater 1.0\033[0m"
echo -e "\nYou have set variables for price-feeder:\n"
echo -e "price-feeder dir:\n" $PATH_TO_PFD
echo -e "price-feeder config:\n" $PFD_NAME
echo -e "\nInput raw link to new price-feeder.example.toml:\n"
read input

#download new config
wget -O $PATH_TO_PFD/price-feeder.example.toml $input

#check for tmp exist, if yes remove tmp file
TMP_FILE=$PATH_TO_PFD/price-feeder.toml.tmp
if test -f "$TMP_FILE"; then
    rm $TMP_FILE
fi

#check for persistent file exist, if no create from existing config
PERSISTENT_FILE=$PATH_TO_PFD/persistent.toml
if test -f "$PERSISTENT_FILE"; then
    echo -e "Your persistent.toml exists OK\n"
else
    echo -e "No persistent data, creating persistent.toml with your settings...\n"
    sed -n '/account/,$p' $PATH_TO_PFD/$PFD_NAME >> $PATH_TO_PFD/persistent.toml #collect persistent data from existing config
fi

#save listen_addr present value
addr_to_change=$(cat $PATH_TO_PFD/price-feeder.example.toml | grep listen_addr)
addr_present=$(cat $PATH_TO_PFD/$PFD_NAME | grep listen_addr)
echo -e "Your present" $addr_present "OK\n"

#collect all deviation_thresholds and currency_pairs data from price-feeder.example.toml
tac $PATH_TO_PFD/price-feeder.example.toml | sed -n -e '/account/,$p' | tac | sed -n '/account/!p' >> $PATH_TO_PFD/price-feeder.toml.tmp

#merge tmp file data with persistent data
cat $PATH_TO_PFD/persistent.toml >> $PATH_TO_PFD/price-feeder.toml.tmp

#change listen_addr from example value to present value
sed -i "s/$addr_to_change/$addr_present/" $PATH_TO_PFD/price-feeder.toml.tmp

#create backup folder
mkdir -p $PATH_TO_PFD/pfd_backups

#creating backup file with existing price-feeder config
echo -e "Creating backup file with your current $PFD_NAME..."
sleep 1
NOW=$( date '+%F_%H:%M:%S' )
cp $PATH_TO_PFD/$PFD_NAME $PATH_TO_PFD/pfd_backups/$PFD_NAME.backup.$NOW

#check for backup exist
BACKUP_FILE=$PATH_TO_PFD/pfd_backups/$PFD_NAME.backup.$NOW
if test -f "$BACKUP_FILE"; then
    echo -e "-----------------"
    echo -e "Created backup" $BACKUP_FILE "OK"
    mv $PATH_TO_PFD/price-feeder.toml.tmp $PATH_TO_PFD/$PFD_NAME #swap tmp with old config
    rm $PATH_TO_PFD/price-feeder.example.toml #remove example.toml
    echo -e "Your new config is ready OK"
    echo -e "\033[1mDon't forget to restart your pfd service to apply changes!\033[0m"
else
    echo -e "ERROR Backup" $BACKUP_FILE "not found, stop and exit!\n"
fi
