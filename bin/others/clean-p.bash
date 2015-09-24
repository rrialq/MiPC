#!/bin/bash
clear
figlet -tkf big "Maven (mvn clean)"
DIRS=`ls -d */`

for DIR in $DIRS; do
    if [ -e "${DIR}/pom.xml" ]; then
	echo "    * mvn clean in ${DIR}..."
        pushd "${DIR}" &> /dev/null 
        mvn clean > /dev/null &> /dev/null
        popd &> /dev/null 
    fi
done
