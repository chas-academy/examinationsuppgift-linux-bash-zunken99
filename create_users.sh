#!/bin/bash


#-----------------------------------
#script för att skapa användare och
#dela in i katalog
#-----------------------------------


#kontrollera att script körs som root

if [ "$EUID" -ne 0 ]; then
	echo "Fel: Script måste köras som root."
	exit 1
fi

# kontrollera att minst en användare matats in

if [ $# -eq 0 ]; then
	echo "Fel, vänligen mata in användare."
	exit 1
fi

#Hämta lista med befintliga användare

existing_users=$(cut -d: -f1 /etc/psswd)

# Loopar alla args

for username in "$@"
do
	echo "Skapar användare: $username"

	#skapar användare med hemkatalog
	useradd -m "$username"

	#Kontrollerar success
	if [ $? -ne 0 ]; then
		echo "Kunde inte skapa användaren @username"
		continue
	fi

	#hemkatalog
	home_dir="/home/$username"

	#skapa mappar
	mkdir -p "$home_dir/Documents"
	mkdir -p "$home_dir/Downloads"
	mkdir -p "$home_dir/Work"


	# Sätt ägare
	chown -R "$username:$username" "$home_dir"


	# Rättigheter
	chmod 700 "$home_dir/Documents"
	chmod 700 "$home_dir/Downloads"
	chmod 700 "$home_dir/Work"

	# Skapa welcome.txt
	
	{
		echo "Välkommen $username"
		echo ""
		echo "Andra användare: "
		echo "$existing_users"
	} > "$home_dir/welcome.txt"

	#Sätt ägare och rättigheter på filen
	
	chown "$username:$username" "$home_dir/welcome.txt"
	chmod 400 "$home_dir/welcome.txt"
	
	echo "Användare $username skapad."
done

















