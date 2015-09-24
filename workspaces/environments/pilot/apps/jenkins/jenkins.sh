#!/bin/bash

# Find the environment folder
findEnvironmentFolder() {
	ENVIRONMENT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
	while [ "${ENVIRONMENT_PATH}" != "/"  ] && [ ! -f "${ENVIRONMENT_PATH}/environment" ]; do
		ENVIRONMENT_PATH=$(dirname "${ENVIRONMENT_PATH}")
	done
	if [ "${ENVIRONMENT_PATH}" != "/" ]; then
		ENVIRONMENTS_PATH=$(dirname "${ENVIRONMENT_PATH}")
	else
		ENVIRONMENTS_PATH="/"
	fi
}


if [ "${ENVIRONMENTS_PATH}" = "" ]; then
	findEnvironmentFolder
	. "${ENVIRONMENTS_PATH}/environment"
fi

JAVA_HOME="${JSE7}"
JAVA_COMMAND=${JAVA_HOME}/bin/java
JAVA_OPTS="-d64 -Xms512m -Xmx2048m -XX:MaxPermSize=256m -Djava.net.useSystemProxies=false -XX:+UseSerialGC -Djava.net.preferIPv4Stack=true"
JAVA_OPTS="${JAVA_OPTS} -DJENKINS_HOME=${JENKINS_HOME}"
CLASSPATH=$HOME/.groovy/lib/http-builder-0.5.2.jar
PATH=$JAVA_HOME/bin:$PATH

JENKINS_REALM_OPTS="--argumentsRealm.passwd.hudson=jenkins2010 --argumentsRealm.roles.hudson=jenkins" 
JENKINS_ACCESSLOG="--accessLoggerClassName=winstone.accesslog.SimpleAccessLogger --simpleAccessLogger.format=combined --simpleAccessLogger.file=${JENKINS_LOGS_PATH}/access.log"
JENKINS_OPTS="--httpPort=${JENKINS_PORT} --prefix=${JENKINS_PREFIX} ${JENKINS_ACCESSLOG}"
RUN_AS=shudson

LC_MESSAGES=en_EN

printf "${JENKINS_DESCRIPTION} : ${JENKINS_NAME} > "

d_toggle() {
	printf "TOGGLE STATUS... "
	if [ -f "$JENKINS_PID_FILENAME" ]; then
		d_stop
	else
		d_start
	fi
} 



d_start() {
	printf "STARTING... "
	#start-stop-daemon --start --quiet --background --make-pidfile --pidfile "${JENKINS_PID_FILENAME}" --chuid $RUN_AS --exec $COMMAND}
	nohup ${JAVA_COMMAND} -cp ${CLASSPATH} ${JAVA_OPTS} -jar ${JENKINS_PATH}/jenkins.war ${JENKINS_OPTS}> ${JENKINS_LOGS_PATH}/out.log 2> ${JENKINS_LOGS_PATH}/err.log < /dev/null &
    echo $! > "${JENKINS_PID_FILENAME}"
    printf "PID en ${JENKINS_PID_FILENAME}\n"
}

d_stop() {
	printf "STOPPING... "
    if [ -e "${JENKINS_PID_FILENAME}" ]; then
       	PIDNUMBER=`cat "${JENKINS_PID_FILENAME}"`
   		printf "${PIDNUMBER}: "
       	kill -SIGTERM $PIDNUMBER
       	RETVAL=$?
       	if [ $RETVAL = 0 ]; then
       		printf "STOPPED\n" 
       	else
           printf "ERROR=$RETVAL PID=$PIDNUMBER\n"
       fi
    else
       	printf "NOT RUNNING OR MISSING FILE ${JENKINS_PID_FILENAME}\n"
    fi
    rm "${JENKINS_PID_FILENAME}"
}

echo "$1"

case $1 in
start)
	d_start;;
stop)
	d_stop
	;;
toggle)
	d_toggle;;
restart)
	printf "RESTARTING...\n"
	d_stop
	sleep 1
	d_start;;
*)
	echo "USAGE: $0 {start|stop|restart}"
	exit 1;;
esac

exit 0
