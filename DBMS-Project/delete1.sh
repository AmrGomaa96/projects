#! /bin/bash

source dedetails.sh
export LC_COLLATE=C
shopt -s extglob

function delete() {
    declare -i flag=0
    table_name=$(whiptail --inputbox "please enter table name" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
    while [[ -z "$table_name" ]]; do # user regex to no insert null char
        table_name=$(whiptail --inputbox "please enter valid table name" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
    done
    while [ ! -e $table_name ] || [[ -z "$table_name" ]]; do
        table_name=$(whiptail --inputbox "table doesnt exist , try again or exit" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
        if [ $table_name == 'exit' ]; then
            flag=1
            break
        fi
    done
    if (($flag != 1)); then
        column_name=$(whiptail --inputbox "please enter column name" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
        while [[ -z "$colomun_name" ]]; do # user regex to no insert null char
            colomun_name=$(whiptail --inputbox "please enter valid column name" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
        done
        flag2=$(columnname_validation $table_name $column_name)
        while [ ! $flag2 ]; do
            column_name=$(whiptail --inputbox "column doesn't exist please enter a valid column name" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
            flag2=$(columnname_validation $table_name $column_name)
            if [[ $colomun_name == 'exit' ]]; then
                break
            fi
        done
        if [ $flag2 ]; then
            columnNo=$(Bring_column_number $table_name $column_name)
            value_delete=$(whiptail --inputbox "Please enter value to delete" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
            while [[ -z "$value_delete" ]]; do # user regex to no insert null char
                value_delete=$(whiptail --inputbox "please enter valid value" 8 39 --title "Deleting from table" 3>&1 1>&2 2>&3)
            done
            declare -a var

            var=$(where_condition $value_delete $columnNo $table_name)
            declare -i count=0
            for i in ${var[@]}; do
                delete_condition $(($i - $count))
                count=count+1
            done
            whiptail --msgbox "$count rows affected" 20 78
        fi
    fi
}
