#!/bin/bash

#����Ȩ��
cp cattproc.sh /usr/local/bin/cattproc
chown cattsoft:cattsoft /usr/local/bin/cattproc
chmod a+x /usr/local/bin/cattproc

#��ӻ���������
export PATH=$PATH:/usr/local/bin/
echo "export PATH=$PATH:/usr/local/bin/" >> /home/cattsoft/.bash_profile
echo "export PATH=$PATH:/usr/local/bin/" >> /etc/profile
