#!/usr/bin/env bash
# Save stdin to file descriptor 5
exec 5<&0
#
# About: This is the most widely used and fastest shell script to update all your TeamSpeak 3 server instances.
# Author: liberodark & ERGY13
# Project: thunder-x.fr
# License: GNU GPLv3

./ts3server_startscript.sh stop

wget http://yurfile.altervista.org/download.php?fid=L1RTMy90czMudGFy

tar -xvf ts3.tar

./ts3server_startscript.sh start