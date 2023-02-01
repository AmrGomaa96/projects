#! /bin/bash

function Create_database() {
    name=$(whiptail --inputbox "please enter Database name or enter 'exit'" 8 39 --title "Creating Database" 3>&1 1>&2 2>&3)
    while [[ ! $name =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ ]]; do
        name=$(whiptail --inputbox "please enter a valid name or enter 'exit'" 8 39 --title "Creating Database" 3>&1 1>&2 2>&3)
        if [[ $name=='exit' ]]; then
            break
        fi
    done

    while [ -e $name ] || [[ !( $name =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ || "$name" = 'exit') ]]; do
        name=$(whiptail --inputbox "This name is already taken or invalid name please choose another name or enter 'exit'" 8 39 --title "Creating Database" 3>&1 1>&2 2>&3)
    done
    if [ $name != 'exit' ]; then
        mkdir ./$name
    fi

}
