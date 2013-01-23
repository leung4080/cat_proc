#!/bin/bash - 
#===============================================================================
#
#          FILE:  cattdu.sh
# 
#         USAGE:  ./cattdu.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: lianghuiqiang , 
#  ORGANIZATION: 
#       CREATED: 2013/1/7 14:41:51 中国标准时间
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
THIS_PID=$$
SYS_LANG=`env|grep LANG|awk -F"=" '{print $NF}'`
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/sbin
#declare -a DIR_PATH="";

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getDirUsage
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function getDirUsage(){
    #echo $*
    du --max-depth=1 -b $* |sort -nr -k1|awk '{if($1>=1073741824){printf "%.2lfG\t%s\n",$1/1024/1024/1024,$2} else if($1 >= 1048576){printf "%.2lfM\t%s\n",$1/1024/1024,$2}else if($1 >= 1024){printf "%.2lfK\t%s\n",$1/1024,$2}else{printf "%.2lf\t%s\n",$1,$2}}'
}

case "$1" in
    --help)
        echo "Usage: $0 {--help|[Dir]|[File]}"
        ;;
    *)
        USAGE_NUM=`echo $* |grep "\-\-help"|wc -l`
        if  [ $USAGE_NUM -ne "0" ]; then
            echo "Usage: $0 {--help|[Dir]|[File]}"
            exit;
        else
            if [ $# -eq "0" ] ; then
                 DIR_PATH=$PWD;
                getDirUsage  $DIR_PATH;
                exit;
            else
                for i in $*; do
                    if [ "$1" = "--help" ] ; then
                        echo "Usage: $0 {--help|[Dir Path]";
                        exit;
                    else
            	        if [  -d "$1"  ] || [ -f "$1"  ] ; then
                            DIR_PATH=( "${DIR_PATH[@]}" "$1" );
            	        else
                            echo "![err]\"$1\" not directories";
                        #    exit;
            	        fi                       
                    fi
                    shift;
                done
                #echo ${DIR_PATH[@]}
                getDirUsage ${DIR_PATH[@]};
            fi
        fi

#        if [ -n "$1" ] ; then
#            if [  -d "$1"  ] || [ -f "$1"  ] ; then
#                DIR_PATH=$1;
#            else
#                echo "![err]\"$1\" not directories";
#                exit;
#            fi
#        else
#            DIR_PATH="$PWD"
#        fi
#        #echo $DIR_PATH;
#        getDirUsage $DIR_PATH;
    ;;

esac    # --- end of case ---
exit;

