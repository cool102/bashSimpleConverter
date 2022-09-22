print_menu () {
	echo -e "\nSelect an option"
	echo "0. Type '0' or 'quit' to end program"
	echo "1. Convert units"
	echo "2. Add a definition"
	echo "3. Delete a definition"
}

add_definition () {
	while true
	do
		echo "Enter a definition:"
		read -a input

		re_definition="^[a-z]+_to_[a-z]+$"
		re_constant="^[+-]?[0-9]+\.?[0-9]*$"

		arr_length="${#input[@]}"
		definition="${input[0]}"
		constant="${input[1]}"

		if [[ "$arr_length" -eq 2 && "$definition" =~ $re_definition && "$constant" =~ $re_constant ]]; then
			file_name="definitions.txt"
			line="${definition} ${constant}"
			echo "$line" >> "$file_name"
			break
		else
			echo "The definition is incorrect!"
		fi
	done
}

delete_definition () {
	file_name="definitions.txt"
	
	if [ -s "$file_name" ]; then
		echo "Type the line number to delete or '0' to return"
		counter=0
		
		while IFS= read -r line;
		do
			counter=$((counter+1))
			printf "%s. %s\n" "$counter" "$line"
		done < "$file_name"		
		
		while true
		do
			read -r line_number
			if [[ -n "$line_number" && "$line_number" -eq 0 ]]; then
				break
			elif [[ -z "$line_number" || "$line_number" -lt "$counter" || "$line_number" -gt "$counter" ]]; then
				echo "Enter a valid line number!"
			else
				sed -i "${line_number}d" "$file_name"
				break
			fi
		done
	else
		echo "Please add a definition first!"
	fi
}

echo "Welcome to the Simple converter!"

while true
do
	print_menu
	read -r option
	case "$option" in
		0 | "quit")
			echo "Goodbye!"
			exit
			;;
		1) 
			echo "Not implemented!"
			;;
		2) 
			add_definition
			;;
		3)
			delete_definition
			;;
		*) echo "Invalid option!"
			;;
	esac
done