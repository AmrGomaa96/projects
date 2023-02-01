#! /bin/bash

function droppingDataBase() {
    Dataname1=$(whiptail --inputbox "please enter the Database name" 8 39 --title "Dropping DataBase" 3>&1 1>&2 2>&3)
    while [[ ! -e $Dataname1 ]]; do
        Dataname1=$(whiptail --inputbox "please enter valid database name or enter 'exit'" 8 39 --title "Dropping DataBase" 3>&1 1>&2 2>&3)
        if [[ $Dataname1 == 'exit' ]]; then
            break
        fi
    done
    if [ $Dataname1 != 'exit' ]; then
        rm -r ./$Dataname1
    fi
}
