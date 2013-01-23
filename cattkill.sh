#!/bin/bash - 
#===============================================================================
#
#          FILE:  cattkill.sh
# 
#         USAGE:  ./cattkill.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Lianghuiqiang
#  ORGANIZATION: 
#       CREATED: 2013/1/8 9:56:50 中国标准时间
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

THIS_PID=$$
SYS_LANG=`env|grep LANG|awk -F"=" '{print $NF}'`
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/sbin


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getProcID
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function getProcID(){

    PROC_NAME=$1
    #echo $PROC_NAME;
    unset CATT_PROC_ID;

    if [ `ps -ef |grep $PROC_NAME |grep -v grep |grep -v $THIS_PID|awk '{print $2}'|wc -l` -ne 0 ] ; then
        for i in `ps -ef |grep $PROC_NAME |grep -v grep |grep -v $THIS_PID|awk '{print $2}'`
        do
            CATT_PROC_ID=( "${CATT_PROC_ID[@]}" "$i" );
        done
    else
        echo  "找不到匹配$PROC_NAME的进程；" ;
    fi
    #echo $PROC_NAME;
    # ps -ef |grep $PROC_NAME |grep -v grep|grep -v $THIS_PID |awk '{print $2}'|wc -l
    #echo ${CATT_PROC_ID[@]};
}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  killProc
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function killProc(){

    PROC_NAME=$1;
    #echo $PROC_NAME;
    getProcID $PROC_NAME;
    len=${#CATT_PROC_ID[*]};
    for PROC_ID in  ${CATT_PROC_ID[*]} ; do
        echo -en "正在结束进程:$PROC_ID" 
        kill -15 $PROC_ID;
        if [ `ps -e o pid |grep $PROC_ID |wc -l` -eq "0" ] ; then
            echo -en "完成；\n"
        else
            echo -en "结束进程失败;\t强制结束进程:$PROC_ID"
            kill -9 $PROC_ID；
            if [ `ps -e o pid |grep $PROC_ID |wc -l` -eq "0" ] ; then
                echo -en "完成；\n"
            else
                echo -en "[出错]无法结束进程$PROC_ID\n";
            fi
        fi
    done
}


USAGE_NUM=`echo $* |grep "\-\-help"|wc -l`
if [ $# -eq "0" ] ||  [ $USAGE_NUM -ne "0" ]; then
    echo "Usage: $0 {--help|[ProcName]|...}";
    exit;
else
    for i in $*; do
        if [ "$1" = "--help" ] ; then
                echo "Usage: $0 {--help|[ProcName]|...}";
                exit;
        else
#            echo $1;
            killProc $1;
        fi
        shift;
    done
fi
exit;
