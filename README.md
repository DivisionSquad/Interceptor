# Interceptor
Programme d'empoisonnement ARP open source.

Lancez le programme en tant que root. 

Rentrez premièrement votre interface tel que wlan0 (pour le wifi) ou eth0 (pour l'ethernet variant selon les pc).
Si vous désirez changer votre adresse MAC, demandez à installer macchanger, qui le fera automatiquement.

L'empoisonnement ARP peut se faire de deux manières :

	Premièrement en ne laissant pas passer la communication entre les ordinateurs, pour cela ne pas se mettre en routeur
	(0 dans /proc/sys/net/ipv4/ip_forward)
  
	Deuxièmement en laissant passer la communication entre les ordinateurs, pour cela se mettre en routeur
	(1 dans /proc/sys/net/ipv4/ip_forward), cela permet de faire du Man In The Middle par exemple.
  
Pour utiliser ce script, il vous faudra un autre script appelé "arp-sk", l'installation est automatique si vous ne le possédez pas.

Maintenant pour attaquer concrètement la cible, donnez l'adresse IP pour laquelle vous voulez vous faire passer en premier (Adresse ip de la source), et ensuite l'adresse IP de la source (Adresse ip de destination). 
Pour du Man In The Middle, vous devrez lancer deux fois le programme en alternant les cibles.
