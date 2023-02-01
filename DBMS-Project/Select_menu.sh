source selectingScript.sh

function selecting() {
    tableName=$(whiptail --inputbox "please enter name of table to select from" 8 39 --title "Selecting from table" 3>&1 1>&2 2>&3)
    while [[ -z "$tableName" ]]; do
        tableName=$(whiptail --inputbox "please enter a valid table name" 8 39 --title "Selecting from table" 3>&1 1>&2 2>&3)
    done
    if [ -e ./$tableName ]; then
        whiptail --msgbox "connecting to the table  ..." 20 78
        while [ 1 ]; do

            CHOICE=$(
                whiptail --title "Selecting menu" --menu "Make your choice" 16 100 9 \
                    "1)" "Select all data" \
                    "2)" "Select specific colomun" \
                    "3)" "Select specific row" \
                    "4)" "Back" 3>&2 2>&1 1>&3
            )

            case $CHOICE in
            "1)")
                selectAll $tableName
                ;;

            "2)")
                selectColomun $tableName
                ;;

            "3)")
                selectRow $tableName
                ;;

            "4)")
                whiptail --msgbox "returning to previous menu..." 20 78
                break
                ;;
            esac
        done
    else
        whiptail --msgbox "No such table, please enter a valid table name"
    fi

}
