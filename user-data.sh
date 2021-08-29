#!/bin/sh

# Hostname
hostname "${instanceName}"
sed -i "s|HOSTNAME=.*|HOSTNAME=${instanceName}|" /etc/sysconfig/network
sed -i "s/127.0.0.1.*/& ${instanceName}.localdomain/" /etc/hosts
sed -i "s|# vim:syntax=yaml|  vim: syntax=yaml|" /etc/cloud/cloud.cfg
sed -i "/preserve_hostname: true/d" /etc/cloud/cloud.cfg && echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
sed -i "s|Hostname=.*|Hostname=${instanceName}|" /etc/zabbix/zabbix_agentd.conf
/etc/init.d/zabbix-agent restart

# Change NFS
sed -i "s/10.10.0.90/dft-ar-live-nfs-001.internal.dafiti.com.ar/" /etc/fstab
remount -a

# Reiniciar los servicios

/etc/init.d/newrelic-daemon restart 
/etc/init.d/newrelic-sysmond restart
/etc/init.d/postfix restart
/etc/init.d/filebeat restart

# Stop NGINX / Check GIT Nginx / Check Enabled Nginx

cd /etc/nginx/GIT/nginx-configs/ && git pull
nginx -t
nginx -s reload

# Borrar logs heredados de la imagen

find /shop/logs/live/ -type f -name '*.log-*' -delete
find /shop/logs/live/ -type f -name '*.gz' -delete
find /shop/logs/live/ -type f -name '*.log.*' -delete
find /shop/logs/live/ -type f -name 'TBK*.log' -delete
find /shop/logs/live/ -type f -name '*.log' -exec tee {} \; </dev/null
rm -rf /shop/logs/live/messages/alice* && mkdir /shop/logs/live/messages/alice
rm -rf /shop/logs/live/marketplace.old
rm -rf /shop/www/htdocs/fulfillment.live.ar && rm -rf /shop/www/htdocs/wms.live.ar/
rm -rf /shop/www/htdocs/static.live.ar.tgz
find /var/log/ -type f -name '*.log.*' -delete
find /var/log/ -type f -name '*.gz' -delete
find /var/log/ -type f -name '*.log-*' -delete
find /var/log/ -type f -name '*-2018*' -delete
rm -rf /lost+found/
rm -rf /home/rcrisial/
find /opt/solr/server/logs/ -type f -name '*.log.*' -delete

# Levantar Fpm, NGINX

/etc/init.d/php-fpm restart && /etc/init.d/nginx restart

# Eliminar o-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"centos\" rather than the user \"root\".';echo;sleep 10"
# Para permitir la conexion de Magallanes

sed -i 's|.*ssh-rsa|ssh-rsa|g' /root/.ssh/authorized_keys
service sshd restart


### yum update --exclude=mysql*,ORBit2,puppet5*
###  yum install yum-security -y && yum update --security