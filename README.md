# nginx reverse proxy quickly deploy


nginx for spring boot or *** deploy reverse proxy


step 1: centos install nginx 1.8

/etc/yum.repos.d/nginx.repo 并输入如下内容 <br />
[nginx]
name=nginx repo <br />
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/ <br />
gpgcheck=0<br />
enabled=1<br />
更新yum安装cache<br />
yum makecache<br />
命令安装nginx<br />
yum install nginx<br />
查看nginx版本		<br />
nginx -V <br />
service nginx restart<br />

step 2: unzip nginx_reverser.zip

step 3: set port

[test@aohuicheng1 ~]$ ./restart_nginx.sh <br />
Input nginx http listen port:9090
