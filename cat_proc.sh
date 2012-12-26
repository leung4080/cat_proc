#!/bin/bash - 
#===============================================================================
#
#          FILE:  cat_proc.sh
# 
#         USAGE:  ./cat_proc.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: LiangHuiQiang 
#  ORGANIZATION: 
#       CREATED: 2012/11/16 16:45:35 中国标准时间
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

export LANG=c;
test "$(whoami)" != 'root' && (echo you are using a non-privileged account; exit 1)
DATE=`date +%Y%m%d`

function get_conf_ini(){
    PSUM=0
while read LINE;do
    eval `echo $LINE|sed 's/ //g'|awk -F"=" '$1~/^PROC/{print $1"="$2}'`

        if [ -z `echo $LINE|sed 's/ //g'|awk -F"=" '$1~/^PROC_NAME/'` ] ; then
    (( PSUM += 1  ))
        fi
done < pmonitor.ini
   echo $PSUM

}

