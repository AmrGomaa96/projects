#! /bin/bash

function where_condition() {
    awk -F ':' -v value=$1 -v colnum=$2 '{                    
        if($colnum == value && NR!=1)
            print(NR)
    } ' $3
}

function Bring_column_number() {
    awk -F : -v value=$2 '{
        for (i=1; i<NF; i++){
            if($i == value && NR==1){print(i)}
        }
    }' $1
}

function columnname_validation() {
    awk -F : -v value=$2 '{
        for (i=1; i<NF; i++)
        {
            if($i == value && NR==1){print(i)}
        }
        }' $1
}

function delete_condition() {
    echo -e $(awk -F : -v col_num3=$1 '{
            if(NR == col_num3){
                next
            }
            else{
                print;
            }

        }' $table_name) >$table_name
    $(sed -i 's/ /\n/g' $table_name)
}
