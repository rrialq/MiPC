#!/bin/bash

function showMenu() {
	clear
	echo "[H] Borrar historial del BASH"
	echo "==================================================="
	echo "[S] Terminar este programa"
}


function deleteBashHistory() {
    cat /dev/null > ~/.bash_history && history -c && exit
}



if [ "$1" == "" ]; then
    showMenu
else
    echo "Opcion: $1"
fi


case "$1" in
    "H" | "deleteBashHistory" )
        deleteBashHistory
    ;;
esac