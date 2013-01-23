#!/bin/bash

#设置权限
cp cattproc.sh /usr/local/bin/cattproc
cp cattdu.sh /usr/local/bin/cattdu
cp cattkill.sh /usr/local/bin/cattkill
chown cattsoft:cattsoft /usr/local/bin/cattdu
chown cattsoft:cattsoft /usr/local/bin/cattproc
chown cattsoft:cattsoft /usr/local/bin/cattkill
chmod a+x /usr/local/bin/cattproc
chmod a+x /usr/local/bin/cattdu
chmod a+x /usr/local/bin/cattkill

#添加环境变量：
export PATH=$PATH:/usr/local/bin/
echo "export PATH=$PATH:/usr/local/bin/" >> /home/cattsoft/.bash_profile
echo "export PATH=$PATH:/usr/local/bin/" >> /etc/profile
