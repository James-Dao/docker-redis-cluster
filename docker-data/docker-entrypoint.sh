#!/bin/sh

port=7000
if [ "$1" = 'redis-cluster' ]; then
    
    mkdir -p /redis-conf/${port}
    mkdir -p /redis-data/${port}

    if [ -e /redis-data/${port}/nodes.conf ]; then
      rm /redis-data/${port}/nodes.conf
    fi
    
    PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf
    PORT=${port} envsubst < /redis-conf/redis.tmpl > /redis-conf/${port}/redis.conf

    supervisord -c /etc/supervisor/supervisord.conf
    sleep 3

    IP=`ifconfig | grep "inet addr:17" | cut -f2 -d ":" | cut -f1 -d " "`
    #echo "yes" | ruby /redis/src/redis-trib.rb create --replicas 1 ${IP}:7000 ${IP}:7001 ${IP}:7002 ${IP}:7003 ${IP}:7004 ${IP}:7005
    tail -f /var/log/supervisor/redis*.log
else
  exec "$@"
fi
