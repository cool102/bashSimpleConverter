#!/usr/bin/bash
set -euo pipefail
touch definitions.txt
definitions_file="definitions.txt"

## Option 1. Convert Units

function convert_units {
	definitions_file="definitions.txt"
# Check the existence of this file first.
    OLDIFS=$IFS
    IFS=$'\n' definitions=($(cat definitions.txt)) 
    IFS=$OLDIFS
    arr_length="${#definitions[@]}"
   
    if [ ! -f "$definitions_file" ]; then
        echo "Please add a definition first!"
        return 
    fi

    # Check the existence of this file first.
    OLDIFS=$IFS
    IFS=$'\n' definitions=($(cat definitions.txt)) 
    IFS=$OLDIFS

    arr_length="${#definitions[@]}"

    if [ $arr_length -eq 0 ]; then
        echo "Please add a definition first!"
        return 
    fi
   
   
   # Output recorded definitions.
    echo "Type the line number to convert units or '0' to return"
	for i in $(seq ${arr_length}) ; do
        echo "$i. ${definitions[$i-1]}"
    done
	#If the line number is incorrect, output Enter a valid line number!;
	number_of_lines=$(< "$definitions_file" wc -l)
	while true
	do
		read -r choice
		
		case $choice in
		0)
			break
			;;
		*)
		
		if [[ $choice -gt $number_of_lines ]] || [[ -z "$choice" ]]; then
			echo "Enter a valid line number!" 
		else
			echo "Enter a value to convert:"
			    while true
				do
				read -r value
				re="^[a-zA-Z]{1,}$"
				if [[ "$value" =~ $re ]] || [[ -z "$value" ]]; then
					echo "Enter a float or integer value!"
				else
					file_name="definitions.txt"
					line_number=$choice
					line=$(sed "${line_number}!d" "$file_name")
					read -r text <<< "$line"
					constant=$(echo "$text" | cut -d ' ' -f 2)
					#result=$( $constant * $value )
					result=$(echo "scale=2; $constant * $value" | bc -l )
					printf "Result: %s" "$result"
					return
				fi
                done				
        fi
		
		;;
        esac		
	done
}

## Option 2. Add a definition

function add_definition {

    while true; do 
        # read the user input parameters as an array starting at $1
        echo "Enter a definition:"
        OLDIFS=$IFS
        IFS=$' ' read -a user_input
        IFS=$OLDIFS

        # Check number of parameters
        arrlength="${#user_input[@]}"
        if [ ! $arrlength -eq 2 ]; then
            echo "The definition is incorrect!"
            continue 
        fi

        # Check that the string has the format `unitone_to_unittwo`
        definition="${user_input[0]}"
        re='^[a-zA-Z]+_to_[a-zA-Z]+$'
        if [[ ! "$definition" =~ $re ]]; then
            echo "The definition is incorrect!"
            continue 
        fi

        # Check the number
        constant="${user_input[1]}"
        re_number='^[+-]?[0-9]+(\.[0-9]+)?$'
        if [[ ! $constant =~ $re_number ]]; then
            echo "The definition is incorrect!"
            continue 
        fi

        ## All the checks are correct so, lets save to disk
        echo "${user_input[*]}" >> "$definitions_file"
        return 
    done
}

## Option 3. Delete a definition

function delete_definition {

    if [ ! -f "$definitions_file" ]; then
        echo "Please add a definition first!"
        return 
    fi

    # Check the existence of this file first.
    OLDIFS=$IFS
    IFS=$'\n' definitions=($(cat definitions.txt)) 
    IFS=$OLDIFS

    arr_length="${#definitions[@]}"

     if [ $arr_length -eq 0 ]; then
        echo "Please add a definition first!"
        return 
    fi

    echo "Type the line number to delete or '0' to return"
    for i in $(seq ${arr_length}) ; do
        echo "$i. ${definitions[$i-1]}"
    done

    
    while true; do
        read -r selection
        if [ -z $selection ]; then 
            echo "Enter a valid line number!"
        elif [ $selection = "0" ]; then
            return
        elif [ \( $selection -le 0 \) -o \( $selection -gt ${arr_length} \) ]; then
            echo "Enter a valid line number!"
        else 
            unset 'definitions[$selection-1]'
            new_arr_length="${#definitions[@]}"
            if [ ${new_arr_length} -eq 0 ]; then
                echo "" > ${definitions_file} 
            else
                printf "%s\n" "${definitions[@]}" > ${definitions_file}
            fi
            return
        fi

    done
}



## Main Menu

echo -e "Welcome to the Simple converter!"
menu="Select an option
0. Type '0' or 'quit' to end program
1. Convert units
2. Add a definition
3. Delete a definition"

while true; do
    echo -e "\n$menu\n"
    read -r menu_selection
    case "$menu_selection" in
        "0" | "quit")
            echo "Goodbye!"
            exit;;
        "1")
            #echo -e "Not implemented!";;
			convert_units
			;;
        "2")
            #echo -e "Not implemented!\n";;
            add_definition;;
        "3")
            # echo -e "Not implemented!";;
            delete_definition;;
        *)
            echo -e "Invalid option!\n";;
    esac
done