�1�3��װ����
1.	�л���root�û�
2.	�ϴ�cattproc.tar.gz�ļ�����������
3.	��ѹcattproc.tar.gz
#tar -zxvf cattproc.tar.gz
4.	����Ŀ¼
#cd cattproc
5.	��Ӱ�װ�ű�Ȩ��
#chmod a+x INSTALL.sh
6.	ִ�а�װ�ű�
#./INSTALL.sh


ʹ��˵��
�8�5	�г����б����ӵĽ��̣�cattproc list
�8�5	�������б����ӵĽ��̣�cattproc startall
�8�5	ֹͣ���б����ӵĽ���: cattproc stopall
����ԭ��

����/home/cattsoftĿ¼������start.sh�ű���������start.sh�ű��еĲ���

����˵����
CATT_PROC_MANAGER���������� #�Ƿ���ӱ����̣�����Ϊ1ʱ���ӣ�0Ϊ ������
CATT_PROC_NAME			  #������̵����ƣ�Ҫ����ps -ef�еĽ�������һ��(�����ܹ�Ψһƥ��һ������)
CATT_PROC_NAME_ZH���������� #���̵��������ơ�

��ȡ���г����״����

����

����/home/cattsoft/collect01/start.sh�ű����������£�

#/bin/bash
CATT_PROC_NAME_ZH=�ɼ�01
CATT_PROC_MANAGER=1
CATT_PROC_NAME=collect01
#ps -ef |grep collect01  |grep -v grep |awk '{print $2}'| xargs kill -9

sleep 3600

 

ִ��cattproc�ű�,ʹ��list������
[cattsoft@VMTEST01 cattproc]$ cattproc list

����    ���̱�ʶ        ���̺�  �ڴ�ռ����      CPUռ����           ״̬

------------------------------------------
[δ����]�ɼ�02 (/home/cattsoft/collect02) 
[δ����]�ɼ�01 (/home/cattsoft/collect01) 
[cattsoft@VMTEST01 cattproc]$

ִ��cattporc�ű���ʹ��startall�������������н��̡�
[cattsoft@VMTEST01 cattproc]$ cattproc startall

�ٴβ鿴
[cattsoft@VMTEST01 cattproc]$ cattproc list

����    ���̱�ʶ        ���̺�  �ڴ�ռ����      CPUռ����           ״̬
�ɼ�02  collect02         8227         0.0             0.0               S
�ɼ�01  collect01         8231         0.0             0.0               S

------------------------------------------
[cattsoft@VMTEST01 cattproc]$


�ƻ�
������ӣ�
	1�����ӽ��̵ĳ�����������
	2, ������ϵͳ��Ϣ

�����ԣ�
	�ƻ�����Redhat Linux��4,5,6�汾�Ĳ���ϵͳ��

��1����װ�ű�����
�����鿴INSTALL.sh�ļ�

��2:����״̬˵��

D    �����ж�˯�ߣ�
R    ���л�����У�
S    ���ж�˯�ߣ�
T    ��ͣ״̬������״̬��
X    �˳�״̬��
Z    ��ʬ���̣�

<    �����ȼ�
N    �����ȼ�
L    ҳ�汻�����ڴ�
s    ��ͷ����
l    ���߳�
+    ǰ̨����


