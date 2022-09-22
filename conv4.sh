 #!/usr/bin/env bash 

function add_definition {
echo "Enter a definition:"
	read -a user_input
	arr_length="${#user_input[@]}"
	definition="${user_input[0]}"
	constant="${user_input[1]}"
	re_definition="[a-z]+_to_[a-z]+"
	re_constant="^[+-]?[0-9]+\.?[0-9]*$"
	#echo $definition
	#echo $constant
	#echo $arr_length
	if [[ "$definition" =~ $re_definition ]]; then
    # to add a line
		file_name="definitions.txt"
		line="$definition"
		#echo "$definition"
		#echo "$constant"
		#	k=$((x+=1))
		echo $((k+=1))"." "$line" "$constant" >> "$file_name"     
	else
    
    echo "The definition is incorrect!"
	fi
	echo ""
}

function delete_definition {
count=$( wc definitions.txt | tr -s [:space:] | cut -d ' ' -f3 )
	#echo "$count"
	if [ $count -eq 0 ]; then
		echo "Please add a definition first!"
		echo ""
	
	else 
		echo "Type the line number to delete or '0' to return"
		cat definitions.txt
		while true 
		do
			read -a ln
				case $ln in
				0)
					break
					;;
				*)
					lc=$( wc definitions.txt | tr -s [:space:] | cut -d ' ' -f2 ) 
								 
					if [ $ln -le $lc ]; then
						file_name="definitions.txt"
						line_number=$ln					
						sed -i "${line_number}d" "$file_name"
						break
					else
						echo "Enter a valid line number!"			
					fi
					;;
				esac
		done
	
	fi
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
            echo -e "Not implemented!";;
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
