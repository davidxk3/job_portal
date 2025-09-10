
MainMenu() {
	while [ "$CHOICE" != "START" ]
	do
	clear
	echo "================================================================="
	echo "| Oracle All Inclusive Tool |"
	echo "| Main Menu - Select Desired Operation(s):| "
	echo "| <CTRL-Z Anytime to Enter Interactive CMD Prompt> |"
	echo "-----------------------------------------------------------------"
	echo " $IS_SELECTEDM  M) View Manual"
	echo " "
	echo " $IS_SELECTED1  1) Drop Tables"
	echo " $IS_SELECTED2  2) Create Tables"
	echo " $IS_SELECTED3  3) Populate Tables"
	echo " $IS_SELECTED4  4) Query Tables (display 5 interesting queries)"
	echo " $IS_SELECTED5  5) Read records based on user request"
	echo " $IS_SELECTED6  6) Add/Update records based on user request"
	echo " $IS_SELECTED7  7) Delete records based on user request"
	echo " $IS_SELECTED8  8) Search for specific record" 
	echo " "
	echo " $IS_SELECTEDE E) End/Exit"
	echo -ne "\n\nChoose: "
	read CHOICE
	if [ "$CHOICE" = "0" ] 
	then
		echo "Nothing Here"
	elif [ "$CHOICE" = "1" ]
	then
		bash drop_tables.sh
                echo -ne "\nPress any key to see menu again"
                read char

	elif [ "$CHOICE" = "2" ]
	then
		bash create_tables.sh
		echo -ne "\nPress any key to see menu again"
                read char


	elif [ "$CHOICE" = "3" ]
	then
		bash populate_tables.sh
	        echo -ne "\nPress any key to see menu again"
                read char

	
	elif [ "$CHOICE" = "4" ]
	then
		bash queries.sh
		echo -ne "\nPress any key to see menu again"
    		read char		
	elif [ "$CHOICE" = "5" ]
	then
		bash readqueries.sh
		echo -ne "\nPress any key to see menu again"
		read char
	elif [ "$CHOICE" = "6" ]
	then
		echo "Choose 'add' or 'update'"
		read result
		if [ "$result" = "add" ] ; then
			bash addqueries.sh
		elif [ "$result" = "update" ] ; then
			bash updatequeries.sh
		else 
			echo -ne "That is not a valid option."
		fi
		echo -ne "\nPress any key to see menu again"
		read char 
	elif [ "$CHOICE" = "7" ]
	then
		bash deletequeries.sh
		echo -ne "\nPress any key to see menu again"
		read char 
	elif [ "$CHOICE" = "8" ]
	then
		bash searchqueries.sh
		echo -ne "\nPress any key to see menu again"
		read char 
	elif [ "$CHOICE" = "9" ]
	then
		bash searchqueries.sh
		echo -ne "\nPress any key to see menu again"
		read char 
	elif [ "$CHOICE" = "E" ]
	then
		exit
	fi
done
}

ProgramStart()
{
	while [ 1 ]
	do
		MainMenu
	done
}

# Start off calling ProgramStart()
ProgramStart	
