#!/bin/bash
#stop nginx
if [ -f  $HOME/var/run/nginx.pid ]; then
echo "nginx pid file $HOME/var/run/nginx.pid:" `cat $HOME/var/run/nginx.pid`
( /usr/sbin/nginx -c $HOME/etc/nginx/nginx.conf -s stop 2>&1 | sed 's#^nginx:.*[alert].*/var/log/nginx/error.log.*##' ) && echo "Nginx stoped OK"
fi

#stop php-fpm
echo

if [ -f  $HOME/var/run/php-fpm/php-fpm.pid ]; then
echo "php-fpm pid file $HOME/var/run/php-fpm/php-fpm.pid:" `cat $HOME/var/run/php-fpm/php-fpm.pid`
 ( pkill -F $HOME/var/run/php-fpm/php-fpm.pid  && echo "php-fpm (pkill) stoped OK" ) || ( kill `cat $HOME/var/run/php-fpm/php-fpm.pid` && echo "php-fpm (kill) stoped OK" );
fi
