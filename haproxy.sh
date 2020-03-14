#startup script

#!/bin/sh
#
# processname: haproxy
# path: /opt/haproxy/latestVersion/init.d
# config: /opt/haproxy/latestVersion/conf/haproxy.conf
# pidfile: /var/run/haproxy.pid


if [ -f /etc/init.d/functions ]; then
  . /etc/init.d/functions
elif [ -f /etc/rc.d/init.d/functions ] ; then
  . /etc/rc.d/init.d/functions
else
  exit 0
fi

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0

# This is our service name
BASENAME=`basename $0`
if [ -L $0 ]; then
  BASENAME=`find $0 -name $BASENAME -printf %l`
  BASENAME=`basename $BASENAME`
fi


[ -f /opt/haproxy/latestVersion/conf/haproxy.conf ] || exit 1

RETVAL=0

start() {
  /opt/haproxy/latestVersion/bin/haproxy -c -q -f /opt/haproxy/latestVersion/conf/haproxy.conf
  if [ $? -ne 0 ]; then
    echo "Errors found in configuration file, check it with 'haproxy check'."
    return 1
  fi

  echo -n "Starting haproxy: "
  /opt/haproxy/latestVersion/bin/haproxy -D -f /opt/haproxy/latestVersion/conf/haproxy.conf -p /opt/haproxy/latestVersion/tmp/haproxy.pid
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && touch /opt/haproxy/latestVersion/tmp/subsys/haproxy
  return $RETVAL
}

stop() {
  echo -n "Shutting down haproxy: "
  killproc haproxy -USR1
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && rm -f /opt/haproxy/latestVersion/tmp/subsys/haproxy
  [ $RETVAL -eq 0 ] && rm -f /opt/haproxy/latestVersion/tmp/haproxy.pid
  return $RETVAL
}

restart() {
  /opt/haproxy/latestVersion/bin/haproxy -c -q -f /opt/haproxy/latestVersion/conf/haproxy.conf
  if [ $? -ne 0 ]; then
    echo "Errors found in configuration file, check it with 'haproxy check'."
    return 1
  fi
  stop
  start
}

reload() {
  /opt/haproxy/latestVersion/bin/haproxy -c -q -f /opt/haproxy/latestVersion/conf/haproxy.conf
  if [ $? -ne 0 ]; then
    echo "Errors found in configuration file, check it with 'haproxy check'."
    return 1
  fi
  /opt/haproxy/latestVersion/bin/haproxy -D -f /opt/haproxy/latestVersion/conf/haproxy.conf -p /opt/haproxy/latestVersion/tmp/haproxy.pid -sf $(cat /opt/haproxy/latestVersion/tmp/haproxy.pid)
}

check() {
  /opt/haproxy/latestVersion/bin/haproxy -c -q -V -f /opt/haproxy/latestVersion/conf/haproxy.conf
}

rhstatus() {
  status haproxy
}

condrestart() {
  [ -e /opt/haproxy/latestVersion/tmp/subsys/haproxy ] && restart || :
}

# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  reload)
    reload
    ;;
  condrestart)
    condrestart
    ;;
  status)
    rhstatus
    ;;
  check)
    check
    ;;
  *)
    echo $"Usage: haproxy {start|stop|restart|reload|condrestart|status|check}"
    exit 1
esac

exit $?
