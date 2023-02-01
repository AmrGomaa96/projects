#/usr/bin/bash

function check_valid_col_name() {
    awk -F : -v value=$2 '{
        for (i=1; i<NF; i++){
            if($i == value && NR==1){
                print(i)
            }
            
            }
}' $1
}

function get_column_number() {
    awk -F : -v value=$2 '{
 for (i=1; i<NF; i++){
    if($i == value && NR==1){
        print(i)
    }
 }
}' $1
}

function selection_condition() {
    awk -F ':' -v value=$1 -v col_num=$2 '{                    
        if($col_num == value && NR!=1)
            print(NR)
    } ' $3
}

function validation() {
    awk -F':' -v value=$1 '{ 
 if(NR!=1){     
    if($1==value){ 
        print(1);
        }
}
} ' "$2"
}

function check_datatype() {
    while [ -e $1 ]; do
        u_value=$(whiptail --inputbox "Enter the updated value" 8 39 --title "Checking dataType" 3>&1 1>&2 2>&3)
        if (($2 == 1)); then
            var=$(validation $u_value $1)
            whiptail --msgbox "$var" 20 78
            while [ "$var" == 1 ]; do
                u_value=$(whiptail --inputbox "Primary key is not unique" 8 39 --title "Checking dataType" 3>&1 1>&2 2>&3)
                var=$(validation $u_value $1)
            done
        fi
        if [ "$3" = "Integer" ] && [[ $u_value =~ [0-99]+$ ]]; then
            break
        elif [ "$3" = "String" ]; then
            break
        else
            echo "type is not matched, type = $3"
            continue
        fi
    done
}

function update_from_table() {
    echo -e $(awk -F : -v record_num=$1 -v field=$2 -v newValue=$3 '{
            if(NR == record_num){
                for(i=1;i<NF;i++){
                    if(i==field){
                        $i = newValue
                    }
                }
                  gsub(/ /,":",$0)
                  print;
            }
            else{
                print;
            }
        }' $u_table_name) >$u_table_name
    $(sed -i 's/ /\n/g' $u_table_name)
}
