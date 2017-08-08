#!/bin/bash


while [ 1 ] ;do

PROCESSLIST=$(ps -fu $USER | grep java | wc -l)
if [ $PROCESSLIST -gt 1 ]; then

pkill java
sleep 1

else
    break;
fi

done


POMPATH=$HOME/www/pom.xml

if [ -f '$POMPATH' ];then

/opt/maven/bin/mvn clean deploy -f www/pom.xml > mvn.log

if [ 0 -lt `grep -c ERROR mvn.log` ]
then
    echo 'Build ERROR'
    exit 1
fi

nohup java -jar www/target/mwork-b-1.0.0.jar > /dev/null 2>&1 &

fi


REPLACE_TO_USERNAME_CNT=$(grep REPLACE_TO_USERNAME  etc/* -R | wc -l)
if [ $REPLACE_TO_USERNAME_CNT != 0 ]
then
    echo $USER
    find $HOME/etc -type f | xargs sed -i "s/REPLACE_TO_USERNAME/$USER/g"
fi

YOUR_OWN_LISTEN_PORT_CNT=$(grep YOUR_OWN_LISTEN_PORT etc/* -R | wc -l)
if [ $YOUR_OWN_LISTEN_PORT_CNT != 0 ];then
    read -p "Input nginx http listen port:" LPORT;
    OCCUPY_PORT=$(netstat  -anp | grep $LPORT | wc -l);
    if [ $OCCUPY_PORT != 0 ];then
           echo echo Warning:port ${LPORT} has been used in above processes;
           exit;
    fi
    find $HOME/etc -type f | xargs sed -i "s/YOUR_OWN_LISTEN_PORT/$LPORT/g"
fi

#stop nginx
if [ -f  $HOME/var/run/nginx.pid ]; then
echo "nginx pid file $HOME/var/run/nginx.pid:" `cat $HOME/var/run/nginx.pid`
( /usr/sbin/nginx -c $HOME/etc/nginx/nginx.conf -s stop 2>&1 | sed 's#^nginx:.*[alert].*/var/log/nginx/error.log.*##' ) &&
echo "Nginx stoped OK."
fi

echo

echo "Restart nginx ..."
sleep 2 
( ( /usr/sbin/nginx -c $HOME/etc/nginx/nginx.conf 2>&1 | sed 's#^nginx:.*[alert].*/var/log/nginx/error.log.*##' ) && echo "Nginx restart OK." ) || ( echo "Nginx start failed."  && tail  $HOME/var/log/nginx/error.log )


