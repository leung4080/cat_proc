安装部署
1.	切换到root用户
2.	上传cattproc.tar.gz文件到服务器。
3.	解压cattproc.tar.gz
#tar -zxvf cattproc.tar.gz
4.	进入目录
#cd cattproc
5.	添加安装脚本权限
#chmod a+x INSTALL.sh
6.	执行安装脚本
#./INSTALL.sh


使用说明
	列出所有被监视的进程：cattproc list
	启动所有被监视的进程：cattproc startall
	停止所有被监视的进程: cattproc stopall
工作原理

搜索/home/cattsoft目录下所有start.sh脚本，并根据start.sh脚本中的参数

参数说明：
CATT_PROC_MANAGER　　　　　 #是否监视本进程，设置为1时监视，0为 不监视
CATT_PROC_NAME			  #定义进程的名称，要求与ps -ef中的进程名称一致(或者能够唯一匹配一个进程)
CATT_PROC_NAME_ZH　　　　　 #进程的中文名称。

获取所有程序的状况。

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


计划
功能添加：
	1，多子进程的程序监视与管理。
	2, 输出相关系统信息

兼容性：
	计划兼容Redhat Linux　4,5,6版本的操作系统。

附1：安装脚本内容
　　查看INSTALL.sh文件

附2:进程状态说明

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


