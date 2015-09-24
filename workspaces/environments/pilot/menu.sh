#!/bin/bash

clear
ENVIRONMENT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_PATH=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_PATH=$(dirname "$SCRIPT_PATH")
. ${SCRIPT_PATH}/environment

jenkinsStartStop() {
    ${JENKINS_PATH}/jenkins.sh "toggle"    
}

showMenu() {
    #clear
    tput cup 0 0
    drawWindow " MAIN MENU - CONTINUOUS INTEGRATION SYSTEM" \
    	"[J] Jenkins start/stop" \
    	"   " \
    	"[0] Exit from this menu"
    drawBoxBottom
}

while true; do
	showMenu

	printf "\nOpción: "
	tput el
	read OPCION
	tput ed
	printf "\n${HORIZONTAL_LINE}${HORIZONTAL_LINE}\n"

	case $OPCION in
		E|e) showEnvironmentSettings;;
		J|j) jenkinsStartStop;;
		0) exit 0;;
	esac
done