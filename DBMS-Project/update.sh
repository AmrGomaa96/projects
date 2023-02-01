#! /bin/bash
source updetails.sh
export LC_COLLATE=C
shopt -s extglob

function update() {
    flag=0
    u_table_name=$(whiptail --inputbox "please enter table name " 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
    while [[ -z "$u_table_name" ]]; do # user regex to no insert null char
        u_table_name=$(whiptail --inputbox "please enter valid table name" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
    done
    while [ ! -e $u_table_name ] || [[ -z "$u_table_name" ]]; do
        u_table_name=$(whiptail --inputbox "table doesnt exist or invalid input , try again or exit" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
        if [[ $u_table_name == 'exit' ]]; then
            flag=1
            break
        fi
    done
    if (($flag != 1)); then
        u_colomun_name=$(whiptail --inputbox "please enter column name" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
        while [[ -z "$u_colomun_name" ]]; do # user regex to no insert null char
            u_colomun_name=$(whiptail --inputbox "please enter valid column name" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
        done
        flag2=$(check_valid_col_name $u_table_name $u_colomun_name)
        while [ ! $flag2 ]; do
            u_colomun_name=$(whiptail --inputbox "column doesn't exist please enter a valid column name" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
            flag2=$(check_valid_col_name $u_table_name $u_colomun_name)
            if [[ $u_colomun_name == 'exit' ]]; then
                break
            fi
        done
        if [ $flag2 ]; then
            col_num2=$(get_column_number $u_table_name $u_colomun_name)
            field_update=$(whiptail --inputbox "Please enter value you want to update" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
            while [[ -z "$field_update" ]]; do # user regex to no insert null char
                field_update=$(whiptail --inputbox "please enter valid value" 8 39 --title "Updating table" 3>&1 1>&2 2>&3)
            done
            declare -a var2
            var2=$(selection_condition $field_update $col_num2 $u_table_name)
            col_type=$(head -n1 "$u_table_name.md" | sed $'s/:/ /g' | awk -v i=$col_num2 -F " " '{ print $i }')
            whiptail --msgbox "$col_type" 20 78
            check_datatype $u_table_name $col_num2 $col_type
            declare -i count=0
            for i in ${var2[@]}; do
                update_from_table $i $col_num2 $u_value
                count=count+1
            done
            whiptail --msgbox "$count rows affected" 20 78
        fi
    fi
}
