#! /bin/bash
function listing_tables() {
    list=$(ls -I "*.md") #listing all tables excpet metadata
    whiptail --msgbox "$list" 20 78
}
check=4

function dataType() {
    while [ 1 ]; do

        CHOICE=$(
            whiptail --title "Operative Systems" --menu "Make your choice" 16 100 9 \
                "1)" "String" \
                "2)" "Integer" 3>&2 2>&1 1>&3
        )

        case $CHOICE in
        "1)")
            echo -n "String:" >>"$table_name.md"
            check=0
            break
            ;;

        "2)")
            echo -n "Integer:" >>"$table_name.md"
            check=1
            break
            ;;
        esac
    done
}
function checkUnique() {
    awk -F':' -v value=$1 '{ 
 if(NR!=1){     
    if($1==value){ 
        print(1);
        }
}
} ' "$2"
}

function create_table() {
    table_name=$(whiptail --inputbox "please enter table name" 8 39 --title "Creating Table" 3>&1 1>&2 2>&3)
    while [[ !( $table_name =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ || "$table_name" = 'ok') ]]; do
        table_name=$(whiptail --inputbox "please enter a valid name or enter 'ok' to exit" 8 39 --title "Creating Table" 3>&1 1>&2 2>&3)
    done
    while [ -e "$table_name" ] || [[ !( $table_name =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ || "$table_name" = 'ok') ]]; do
        table_name=$(whiptail --inputbox "table already exist or invalid name, enter 'ok' to exit" 8 39 --title "Creating Table" 3>&1 1>&2 2>&3)
    done

    if [ ! "$table_name" = 'ok' ]; then
        touch $table_name
        touch "$table_name.md"
        number=$(whiptail --inputbox "please enter the number of columns" 8 39 --title "Colomun Number" 3>&1 1>&2 2>&3)
        while [[ ! $number =~ [1-99]+$ ]]; do
            number=$(whiptail --inputbox "please enter a valid number" 8 39 --title "Colomun Number" 3>&1 1>&2 2>&3)
        done

        for i in $(seq 1 $number); do
            if (($i == 1)); then
                pk=$(whiptail --inputbox "please enter the primary key" 8 39 --title "Primary Key" 3>&1 1>&2 2>&3)
                while [[ ! $pk =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ ]]; do
                    pk=$(whiptail --inputbox "please enter a valid string column name" 8 39 --title "Primary Key" 3>&1 1>&2 2>&3)
                done
                dataType
                echo -n "$pk:" >$table_name

            else
                variable=$(whiptail --inputbox "please enter column name " 8 39 --title "Colomun Name" 3>&1 1>&2 2>&3)
                while [[ ! $variable =~ ^([a-zA-Z\_])+([a-zA-Z0-9\_])*$ ]]; do
                    variable=$(whiptail --inputbox "please enter a valid string " 8 39 --title "Colomun Name" 3>&1 1>&2 2>&3)
                done
                dataType
                echo -n "$variable:" >>$table_name
            fi

            if (($i == $number)); then
                echo "" >>$table_name
            fi
        done
    fi
}

function insert() {
    table2=$(whiptail --inputbox "please enter table name " 8 39 --title "Inserting into table" 3>&1 1>&2 2>&3)
    declare -i number=$(head -n1 "$table2.md" | awk -F : '{print NF-1 ;}')

    for i in $(seq 1 $number); do
        col_name=$(head -n1 $table2 | sed $'s/:/ /g' | awk -v i=$i -F " " '{ print $i }')
        col_type=$(head -n1 $table2.md | sed $'s/:/ /g' | awk -v i=$i -F " " '{ print $i }')
        while [ -e $table2 ]; do
            x=$(whiptail --inputbox "please enter the $col_name " 8 39 --title "Inserting into table" 3>&1 1>&2 2>&3)
            if (($i == 1)); then
                if [[ -z "$x" ]]; then
                    whiptail --msgbox "Invalid id" 20 78
                    continue
                else
                    var=$(checkUnique $x $table2)
                    while [ "$var" = 1 ]; do
                        x=$(whiptail --inputbox "primary key is not unique or invalid ,please enter again " 8 39 --title "Inserting into table" 3>&1 1>&2 2>&3)
                        if [[ -z "$x" ]]; then
                            continue
                        else
                            var=$(checkUnique $x $table2)
                        fi
                    done
                fi
            fi
            if [ "$col_type" = "Integer" ] && [[ $x =~ [0-99]+$ ]]; then
                echo -n "$x:" >>$table2
                break
            elif [ "$col_type" = "String" ]; then
                echo -n "$x:" >>$table2
                break
            else
                whiptail --msgbox "invalid datatype entered, type = $col_type" 20 78
                continue
            fi
        done
        if (($i == $number)); then
            echo "" >>$table2
        fi
    done
}

function dropTable() {
    tableName2=$(whiptail --inputbox "please enter the table name " 8 39 --title "Dropping table" 3>&1 1>&2 2>&3)
    while [[ ! -e $tableName2 ]]; do
        tableName2=$(whiptail --inputbox "please enter valid table name or enter 'exit' " 8 39 --title "Dropping table" 3>&1 1>&2 2>&3)
        if [[ $tableName2 == 'exit' ]]; then
            break
        fi
    done

    if [ $tableName2 != 'exit' ]; then
        rm -r ./$tableName2 ./$tableName2.md
    fi
}
