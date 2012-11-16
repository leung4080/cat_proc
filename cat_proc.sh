#/bin/bash


. ./pmonitor.ini
awk '$1~/^PROC/{print $1=$3}/' ./pmonitor.ini

