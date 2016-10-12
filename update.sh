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
link_ts3_x32="http://yurfile.altervista.org/download.php?fid=L1RTMy90czN4MzIudGFy"
link_ts3_x64="http://yurfile.altervista.org/download.php?fid=L1RTMy90czN4NjQudGFy"
server_arch=???
update_source="http://yurfile.altervista.org/download.php?fid=L1RTMy91cGRhdGUuc2g="
update_status="false"

	# make update if asked
if [ "$1" = "update" ]; then
	update_status="true"
fi ;
 
 # update updater
 if [ "$update_status" = "true" ]; then
 	wget -O $0 $update_source
 	$0
 	exit 0
 fi ;

 # stop ts3server
./ts3server_startscript.sh stop

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

	if [ $server_arch = "x64" ]; then
		wget -O ts3.tar $link_ts3_x64
	else
		wget -O ts3.tar $link_ts3_x32
	fi ;
	echo "newest version downloaded."

	# extracting
	tar -xf ts3.tar
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
./ts3server_startscript.sh start
