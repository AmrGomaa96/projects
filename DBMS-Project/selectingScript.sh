#! /bin/bash
export LC_COLLATE=C
shopt -s extglob

function selectAll() {
    result=$(cat $1)
    whiptail --msgbox "$result" 20 78
}
####################################################selecting using colomun name

function col_num() {
    result=$(awk -F : -v value=$2 '{
     for (i=1; i<NF; i++){
        if($i == value && NR == 1){
            print(i)
        
        }
     }
    }' $1)
    echo $result
}

function selectColomun() {
    colName=$(whiptail --inputbox "please enter coloumn name" 8 39 --title "Selecting Colomun" 3>&1 1>&2 2>&3)
    result=$(col_num $1 $colName)
    if [[ -z "$result" ]]; then
        whiptail --msgbox "invaild coloumn name" 20 78
    else
        result_col=$(awk -F : -v value=$result '{
        if ( NR != 1)
        print($value)
        }' $1)
        whiptail --msgbox "$result_col" 20 78
    fi
}
######################################################################

####################################################selecting row using any table valid value
function selectRow() {
    value=$(whiptail --inputbox "enter a value to print its row" 8 39 --title "Selecting Row" 3>&1 1>&2 2>&3)
    count=0
    result_row=$(awk -F : -v value=$value '{
        for (i=1; i<NF; i++)
        {
            if($i == value && NR != 1){
                print($0)
                count++
                }
        }
        }END{
            if (count == 0){print ("Invalid value")}
        } ' $1)
    whiptail --msgbox "$result_row" 20 78
}
##########################################################################
