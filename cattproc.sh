#!/bin/bash - 
#===============================================================================
#
#          FILE:  
# 
#         USAGE:  ./cattproc.sh {list|startall|stopall} 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: LiangHuiQiang 
#  ORGANIZATION: 
#       CREATED: 2012/11/20 11:33:04 中国标准时间
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#===============================================================================
#  GLOBAL DECLARATIONS
#===============================================================================

THIS_PID=$$
export LANG=c
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/sbin
SCRIPT_PATH=$(dirname $0);
cd $SCRIPT_PATH;

declare -a ProcDir=/home/cattsoft
declare -a StartScript=start.sh
declare -a ErrorLogFile=err.log

declare -a CATT_PROC_NAME
declare -a CATT_PROC_NAME_ZH
declare -a CATT_PROC_START
declare -i RETVAL=0

#===============================================================================
#  FUNCTION DEFINITIONS
#===============================================================================


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getStartScript
#   DESCRIPTION:  
#    PARAMETERS: ProcDIR StartScript Out_File 
#       RETURNS:  
#-------------------------------------------------------------------------------
function getStartScript()
{

    Find_Dir=$1
    Find_File=$2
    Find_Type=f
    Find_Perm=x
    Out_File=$3

    find $Find_Dir -name $Find_File -type $Find_Type -print > $Out_File; 
    
    return 0;
}



#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getScriptValue
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function getScriptValue()
{
    FoundScript="/tmp/.foundproc"
    getStartScript $ProcDir $StartScript $FoundScript;
    i=0

    while read LINE ; do
       
         if [ ! -f $LINE ] ; then
                exit "$LINE文件不存在";
            fi

        #过滤CATT_PROC_MANAGER不等1的程序。
        MANAGER=`awk -F"=" 'BEGIN{gsub(/[[:blank:]]*/,"",$1)}$1~/^CATT_PROC_MANAGER/{gsub(/[[:blank:]]*/,"",$2);printf "%d",$2}' $LINE|tr '\n' ' ' |tr '\r' ' '`
        MANAGER=$((MANAGER+0))
        if [ "$MANAGER" -eq 1 ] ; then

            PROC_START=$LINE;
            #获取程序标识符
            PROC_NAME=`awk -F"=" 'BEGIN{gsub(/[[:blank:]]*/,"",$1)}$1~/CATT_PROC_NAME$/{gsub(/\"/,"",$2);print $2}' $LINE |tr '\n' ' ' |tr '\r' ' '|awk '{gsub(/\"/,"",$1);print $1}'`
            
            if [ -z "$PROC_NAME" ] ; then
                  echo "----------"
                  echo "[warn]CATT_PROC_NAME配置出错！"
                  echo "请检查文件($LINE)"
                  echo "----------"
                  continue ;
            fi
            #获取程序中文名称
            PROC_NAME_ZH=`awk -F"=" 'BEGIN{gsub(/[[:blank:]]*/,"",$1)}$1~/CATT_PROC_NAME_ZH$/{gsub(/\"/,"",$2);print $2}' $LINE|tr '\n' ' ' |tr '\r' ' '|awk '{gsub(/\"/,"",$1);print $1}'` 
#           如果中文名称未定义，则使用标识符作为中文名称
            if [ -z $PROC_NAME_ZH ] ;then
#echo "unknow"
                PROC_NAME_ZH=$PROC_NAME;    
            fi

#           PROC_PID=`ps -ef|grep $PROC_NAME|grep -v grep|awk '{print $2}'`            
#           PS_PROC=`ps -e o pid,pcpu,pmem,stat|grep $PROC_PID`
#           PROC_PCPU=`echo $PS_PROC|awk '{print $2}'`
#           PROC_PMEM=`echo $PS_PROC|awk '{print $3}'`
#           PROC_STAT=`echo $PS_PROC|awk '{print $4}'`
            CATT_PROC_NAME=( "${CATT_PROC_NAME[@]}" "$PROC_NAME" )
            CATT_PROC_NAME_ZH=( "${CATT_PROC_NAME_ZH[@]}" "$PROC_NAME_ZH" )
            CATT_PROC_START=( "${CATT_PROC_START[@]}" "$PROC_START" )
            i=$((i+1))
        fi
#    echo $PROC_START;
#       echo $PROC_NAME;
#       echo $PROC_PID;
#       echo $PROC_PCPU;
#       echo $PROC_PMEM;
#        echo $PROC_STAT; 
    done < $FoundScript;

#    echo ${CATT_PROC_NAME[@]}
#    echo ${CATT_PROC_NAME_ZH[@]}
#    echo ${CATT_PROC_START[@]}

    CATT_PROC_NUMBER=$i

#    rm -f $FoundScript;
    return 0;
}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getProcStat
#   DESCRIPTION:  
#    PARAMETERS: proc_name 
#       RETURNS:  
#-------------------------------------------------------------------------------
function getProcStat(){
    echo ""
    #获取程序数量；
    PSUM=${#CATT_PROC_NAME[*]};

for val in `seq 0 $((PSUM-1))`
do
#   echo $val;
    PROC_NAME=`echo ${CATT_PROC_NAME[$val]}`
#   echo $PROC_NAME;
#    echo ${CATT_PROC_NAME_ZH[$val]};
    PROC_PID=`ps -ef|grep $PROC_NAME|grep -v grep|awk '{print $2}'`
    PROC_NUM=`ps -ef|grep $PROC_NAME|grep -v grep|wc -l`
    if [ $PROC_NUM -eq 0 ];then
        PROC_PID="0";
        PROC_PCPU="0";
        PROC_PMEM="0";
        PROC_STAT="0";
    else
        PS_PROC=`ps -e o pid,pcpu,pmem,stat|awk '$1~/'"$PROC_PID"'/'`
#    echo $PS_PROC
        PROC_PCPU=`echo $PS_PROC|awk '{print $2}'`
        PROC_PMEM=`echo $PS_PROC|awk '{print $3}'`
        PROC_STAT=`echo $PS_PROC|awk '{print $4}'`
    fi
    
    CATT_PROC_PID=( "${CATT_PROC_PID[@]}" "$PROC_PID" )
    CATT_PROC_PCPU=( "${CATT_PROC_PCPU[@]}" "$PROC_PCPU")
    CATT_PROC_PMEM=( "${CATT_PROC_PMEM[@]}" "$PROC_PMEM")
    CATT_PROC_STAT=( "${CATT_PROC_STAT[@]}" "$PROC_STAT")

done
#    PSUM=${#CATT_PROC_NAME[*]}; 
#    echo "";
#    ps -e o pid,pmem,pcpu,stat,args|head -1|sed 's/PID/进程号/;s/%MEM/内存占用率/;s/%CPU/CPU占用率/;s/STAT/状态/'|awk '{printf("%4s\t%8s\t%6s\t%10s\t%10s\t%10s\n","程序","进程标识",$1,$2,$3,$4)}' 
#for val in `seq 0 $((PSUM-1))`
#do
#   TMP_NAME_ZH=`echo ${CATT_PROC_NAME_ZH[$val]}`
#   TMP_NAME=`echo ${CATT_PROC_NAME[$val]}`
#
#   if [ -z "$TMP_NAME" ] ; then
#       TMP_NAME="' '"
#       fi
#
#   if [ -n "$TMP_NAME_ZH" ] ; then
#        P_NAME=$TMP_NAME_ZH
#   else
# P_NAME="' '"
#   fi   

#PS_PROC=`ps aux|grep $TMP_NAME |grep -v grep|wc -l`
#if [ $PS_PROC -ne 0 ];then
#printf "%4s %8s" "$P_NAME" "$TMP_NAME" ;
#        ps -e o pid,pmem,pcpu,stat,args | grep $TMP_NAME  |awk '$0!~/grep/{printf("%4s\t%8s\t%6s\t%10s\t%10s\t%10s\n","'$P_NAME'","'$TMP_NAME'",$1,$2,$3,$4)}'
#else
#        printf "%s%s\n" "[未运行]" ${P_NAME}" ("`dirname ${CATT_PROC_START[$val]}`") ">>/tmp/.ps_unrun.tmp 

#fi
#ps aux|grep ${PROC_NAME[0]} |grep -v grep
#done#进程的中文名称。
#echo "";
#echo "------------------------------------------";
#cat /tmp/.ps_unrun.tmp 2>/dev/null
#rm -f /tmp/.ps_unrun.tmp 2>/dev/null
    
}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  ListProc
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function ListProc(){
     getProcStat; 
     PSUM=${#CATT_PROC_NAME[*]}; 
    for val in `seq 0 $((PSUM-1))`
    do
        TMP_PROC_PID=`echo ${CATT_PROC_PID[$val]}`
        HAVE_RUNNING=$((HAVE_RUNNING+TMP_PROC_PID))
    done
#    echo "$PSUM";
    
    if [ $HAVE_RUNNING -ne 0 ] ; then
    ps -e o pid,pmem,pcpu,stat,args|head -1|sed 's/PID/进程号/;s/%MEM/内存占用率/;s/%CPU/CPU占用率/;s/STAT/状态/'|awk '{printf("%10s\t%8s\t%6s\t%10s\t%10s\t%10s\n","程序","进程标识",$1,$2,$3,$4)}' 
    else
        echo "not program running!"
    fi
for val in `seq 0 $((PSUM-1))`
do
PS_PROC=`ps -ef|grep ${CATT_PROC_NAME[$val]} |grep -v grep|wc -l`
if [ $PS_PROC -ne 0 ];then
    PS_PID=`echo ${CATT_PROC_PID[$val]}`
    NAME=`echo ${CATT_PROC_NAME[$val]}`
    NAME_ZH=`echo ${CATT_PROC_NAME_ZH[$val]}`
#printf "%4s %8s" "${CATT_PROC_NAME_ZH[$val]}" "${CATT_PROC_NAME[$val]}" ;
        ps -e o pid,pmem,pcpu,stat,args |awk '$1~/'"$PS_PID"'/&&$0!~/grep/{printf("%10s\t%8s\t%6s\t%10s\t%10s\t%10s\n","'$NAME_ZH'","'$NAME'",$1,$2,$3,$4)}'
else
        printf "%s%s\n" "[未运行]" $NAME_ZH" ("`dirname ${CATT_PROC_START[$val]}`") ">>/tmp/.ps_unrun.tmp 

fi
#ps aux|grep ${PROC_NAME[0]} |grep -v grep
done
echo "";
echo "------------------------------------------";
cat /tmp/.ps_unrun.tmp 2>/dev/null
rm -f /tmp/.ps_unrun.tmp 2>/dev/null


}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  StartProc
#   DESCRIPTION:  启动进程　
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------

function StartProc(){
    
    if [ "$1" = "all" ] ; then
        Len=${#CATT_PROC_START[*]} 
        for (( CNTR=0; CNTR<$Len; CNTR+=1 )); do
            echo "bash ${CATT_PROC_START[$CNTR]} &" |bash
        done

        fi

}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  StopProc
#   DESCRIPTION:  停止进程
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function StopProc(){
    getProcStat;
    if [ "$1" = "all" ] ; then
        Len=${#CATT_PROC_NAME[*]} 
        for (( CNTR=0; CNTR<$Len; CNTR+=1 )); do
            TMP_KILL_PID=`echo ${CATT_PROC_PID[$CNTR]}`;
            echo  "准备结束进程：$TMP_KILL_PID"
            kill -15 "$TMP_KILL_PID";  
            CHK_PID=`ps -ef|awk '$2~/'"$TMP_KILL_PID"'/'|wc -l`
            if [ $CHK_PID -ne 0 ];then
                kill -9 "$TMP_KILL_PID";
                CHK_PID2=`ps -ef|awk '$2~/'"$TMP_KILL_PID"'/'|wc -l`
                if [ $CHK_PID2 -ne 0 ];then
                    exit "[error]结束进程$TMP_KILL_PID出错!"
                fi
            fi
                echo "${CATT_PROC_NAME_ZH[$CNTR]}   已停止；"
                echo "======================================"
        done

    fi
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  readme
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------

function readme(){
    cat << EOF
使用说明
??	列出所有被监视的进程：cattproc list
??	启动所有被监视的进程：cattproc startall
??	停止所有被监视的进程: cattproc stopall

================
配置被监视进程：
修改被监视进程的start.sh文件，并加入如下参数：
CATT_PROC_MANAGER=1　　　　　 #是否监视本进程，设置为1时监视，0为 不监视
CATT_PROC_NAME=			    #定义进程的名称，要求与ps -ef中的进程名称一致(或者能够唯一匹配一个进程)
CATT_PROC_NAME_ZH=         #进程的中文名称。

========================
工作原理

搜索/home/cattsoft目录下所有start.sh脚本，并根据start.sh脚本中的参数

参数说明：
CATT_PROC_MANAGER　　　　　 #是否监视本进程，设置为1时监视，0为 不监视
CATT_PROC_NAME			  #定义进程的名称，要求与ps -ef中的进程名称一致(或者能够唯一匹配一个进程)
CATT_PROC_NAME_ZH　　　　　 #进程的中文名称。

获取所有程序的状况。
=================================
例子

例如/home/cattsoft/collect01/start.sh脚本，内容如下：

#/bin/bash
CATT_PROC_NAME_ZH=采集01
CATT_PROC_MANAGER=1
CATT_PROC_NAME=collect01
#ps -ef |grep collect01  |grep -v grep |awk '{print $2}'| xargs kill -9

sleep 3600

 

执行cattproc脚本,使用list参数。
[cattsoft@VMTEST01 cattproc]$ cattproc list

程序    进程标识        进程号  内存占用率      CPU占用率           状态

------------------------------------------
[未运行]采集02 (/home/cattsoft/collect02) 
[未运行]采集01 (/home/cattsoft/collect01) 
[cattsoft@VMTEST01 cattproc]$

执行cattporc脚本，使用startall参数，启动所有进程。
[cattsoft@VMTEST01 cattproc]$ cattproc startall

再次查看
[cattsoft@VMTEST01 cattproc]$ cattproc list

程序    进程标识        进程号  内存占用率      CPU占用率           状态
采集02  collect02         8227         0.0             0.0               S
采集01  collect01         8231         0.0             0.0               S

------------------------------------------
[cattsoft@VMTEST01 cattproc]$


===================================
附:进程状态说明

D    不可中断睡眠；
R    运行或可运行；
S    可中断睡眠；
T    暂停状态，跟踪状态；
X    退出状态；
Z    僵尸进程；

<    高优先级
N    低优先级
L    页面被锁进内存
s    领头进程
l    多线程
+    前台进程


EOF


}


#===============================================================================
#  MAIN SCRIPT
#===============================================================================





#getScriptValue;

#echo ${CATT_PROC_NAME[@]}
#echo ${CATT_PROC_NAME_ZH[@]}
#echo ${CATT_PROC_START[@]}
#echo ${#CATT_PROC_NAME[*]}
#echo $CATT_PROC_NUMBER;
#getProcStat;


case "$1" in
        list)
                getScriptValue;
                ListProc;
                ;;
        startall)
                getScriptValue;
                StartProc "all"
        ;;
        stopall)
                getScriptValue;
                StopProc "all"
        ;;
        test)
                getScriptValue;
                ListProc;               
                readme;
        ;;
        help)   
                readme;
        ;;
        *)
                echo $"Usage: $0 {list|startall|stopall|help}"
                RETVAL=2
esac
exit $RETVAL

