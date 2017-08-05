#!/bin/bash
#
# About: Update TeamSpeak 3 server automatically
# Author: liberodark & ERGY13
# Project: TS3-Update
# License: GNU GPLv3

 # init

dir_temp="/tmp/ts3-updater-$RANDOM"
dir_ts3=$(pwd)
dir_backup="$dir_ts3/backup"
link_ts3_x32="http://dl.4players.de/ts/releases/3.0.13.8/teamspeak3-server_linux_x86-3.0.13.8.tar.bz2"
link_ts3_x64="http://dl.4players.de/ts/releases/3.0.13.8/teamspeak3-server_linux_amd64-3.0.13.8.tar.bz2"
link_ts3_x32_cracked=""
link_ts3_x64_cracked=""
server_arch=$(uname -m)
update_source="https://raw.githubusercontent.com/liberodark/TS3-Update/master/update.sh"
version="1.9.5"

echo "Welcome on TS3-Updater $version"

	# make update if asked
if [ "$1" = "noupdate" ]; then
	update_status="false"
else
	update_status="true"
fi ;

 # update updater
 if [ "$update_status" = "true" ]; then
 	wget -O $0 $update_source
 	$0 noupdate
 	exit 0
 fi ;

 # stop ts3server
sh ts3server_startscript.sh stop

 # backup ts3server

 	# make dir
	if [ ! -e $dir_backup ]; then
		mkdir $dir_backup
	fi ;

	# remove old backups
	if [ $( ls $dir_backup/*.tar | wc -l ) -gt 2 ]; then
		rm $(ls $dir_backup/*.tar | head -n $(( $(ls $dir_backup/*.tar | wc -l) -2 )))
		echo "old backups deleted"
	fi ;

	# make backup
	tar -cf "$dir_backup/backup-$(date +%Y%m%d%H%M%S).tar"  --exclude="backup*" *
	echo "backup done."

# check if ts3server is cracked
	if [ -e "AccountingServerEmulator-Linux" ]; then
		cracked="true"
	else
		cracked="false"
	fi ;

# download last update

	# make temp directory for update
	if [ ! -e $dir_temp ]; then
		mkdir $dir_temp
	else
		echo "The folder '$dir_temp' can't be created."
		exit 1
	fi ;

	# downloading
	cd $dir_temp

	if [ $cracked = "true" ]; then

		echo "127.0.0.1 accounting.teamspeak.com" >> /etc/hosts
		echo "127.0.0.1 backupaccounting.teamspeak.com" >> /etc/hosts
		echo "127.0.0.1 ipcheck.teamspeak.com" >> /etc/hosts

		if [ $server_arch = "x86_64" ]; then
			wget -O ts3.tar $link_ts3_x64_cracked
		else
			wget -O ts3.tar $link_ts3_x32_cracked
		fi ;
	else
		if [ $server_arch = "x86_64" ]; then
			wget -O ts3.tar $link_ts3_x64
		else
			wget -O ts3.tar $link_ts3_x32
		fi ;
	fi ;

	echo "newest version downloaded."

	# extracting
	tar -xf ts3.tar
	rm ts3.tar
	if [ ! -e "ts3server_startscript.sh" ]; then
		cd *
	fi ;
	echo "files extracted."

	# moving to ts3_dir
	cp -fr * $dir_ts3
	echo "server updated"

# cleaning temp files

rm -fr $dir_temp

# starting ts3server

cd $dir_ts3
sh ts3server_startscript.sh start
