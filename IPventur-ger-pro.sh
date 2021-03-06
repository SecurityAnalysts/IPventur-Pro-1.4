#! /bin/bash
# IPventur-Pro.sh
# benötigt root rechte, sowie fping und nmap
# updated: 11.06.2020 MrEnergy64 origin: Linux-User
# Version: 1.4
#
clear
# füge das zu überprüfende Netzwerk hinzu
echo ""
echo "****************************"
echo "* IPventur-Deutsch Pro 1.4 *"
echo "***************************"
echo ""
echo "Welches Netzwerk soll gescannt werden (z.B. 192.168.1.0/24 oder 192.168.111.1/32 [Enter]): "
echo ""
read netw
# check ob eine IP Adresse vorhanden ist und gültig
if [[ -z $netw ]]; then
	clear; echo ""; echo "Keine IP Adresse vorhanden, starte Script erneut....";sleep 3; exec "./IPventur-ger-pro.sh"
fi
if [[ $netw =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; then
	clear; echo ""; echo "Valide IP Adresse"
else
	clear;  echo ""; echo "$netw ist keine valide IP Adresse/Subnet mask, starte script erneut....";sleep 3; exec "./IPventur-ger-pro.sh"
fi
# Menü für Parameterübergabe an NMAP
echo ""
echo "****************************"
echo "* IPventur-Deutsch Pro 1.4 *"
echo "****************************"
echo ""
echo "Scanne Netzwerk: $netw"
echo ""
echo "wählen Sie eine NMAP Scan Version aus (1,2,3,4,5,6,7 [Enter]): "
echo ""
echo "  1) NMAP -A 			(intensiver Scan mit OS/Service Version (1000 ports), Traceroute etc.)"
echo "  2) NMAP -v -A -p1-65535	(größere Ausführlichkeit, intensiver Scan, alle Ports)"
echo "  3) NMAP -6 			(Standard Scan mit IPv6)"
echo "  4) NMAP -F -T5 		(schnellster Scan, aber nur Standard Ports)"
echo "  5) NMAP ohne Parameter 	(Standard Scan mit offenen Ports)"
echo "  6) NMAP -d9			(Debug mit höster Stufe, kann sehr lange dauern!)"
echo "  7) NMAP -sV --script 		(Scanne mit Script)"
echo "				(Check wo die Scripts liegen (locate *.nse): ~/.nmap/scripts oder /usr/share/nmap/scripts)"
echo "				(Update neue NSE NMAP Scripts: sudo nmap --script-updatedb)"
echo ""
read n
clear
echo ""
case $n in
# hier können die nmap Parameter geändert werden
  1) echo " Auswahl: NMAP -A"; AUSWAHL="nmap -A";;
  2) echo " Auswahl: NMAP -v -A -p1-65535"; AUSWAHL="nmap -v -A -p1-65535";;
  3) echo " Auswahl: NMAP -6"; AUSWAHL="nmap -6";;
  4) echo " Auswahl: NMAP -F -T5"; AUSWAHL="nmap -F -T5";;
  5) echo "Auswahl: NMAP"; AUSWAHL="nmap";;
  6) echo "Auswahl: NMAP -d9"; AUSWAHL="nmap -d9";;
  7) echo "Auswahl: NMAP -sv --script"; echo ""; echo "Scanne Netzwerk: $netw";echo "";read -p "Whelches Script soll benutzt werden (z.B vulners etc.)?  => " nms; AUSWAHL="nmap -sV --script $nms";;
  *) echo "ungültige Auswahl, starte Script neu....";sleep 3; exec "./IPventur-ger-pro.sh";;
esac
# Wähle das Ausgabeformat
clear
echo ""
echo "****************************"
echo "* IPventur-English Pro 1.4 *"
echo "****************************"
echo ""
echo "Scanne Netzwerk: $netw"
echo "NMAP Parameter:  $AUSWAHL"
echo ""
echo "Wähle ein NMAP Ausgabeformat (1,2,3,4,5 [Enter]): "
echo ""
echo "  1) -oN 			(Ausgabe Scan in normal)"
echo "  2) -oS 			(Ausgabe Scan in s|<rIpt kIddi3)"
echo "  3) -oG 			(Ausgabe Scan im Grepable Format)"
echo "  4) -oX			(Ausgabe Scan im XML Format, muss aber re-editiert werden)"
echo "  5) -oA			(Ausgabe Scan in allen Formaten)"
echo ""
echo "Hinweis: es werden zwei Ausgabedateien erstellt (Ausnahme Nr.5): eine mit Standard und eine mit Ihrer Wahl!"
echo ""
read n
echo ""
case $n in
# here you can change the namp output parameters
  1) echo " Auswahl: -oN",; AUSWAHL2="-oN";;
  2) echo " Auswahl: -oS"; AUSWAHL2="-oS";;
  3) echo " Auswahl: -oG"; AUSWAHL2="-oG";;
  4) echo " Auswahl: -oX"; AUSWAHL2="-oX";;
  5) echo " Auswahl: -oA"; AUSWAHL2="-oA";;
  *) echo "ungültige Auswahl, starte Script neu....";sleep 3; exec "./IPventur-ger-pro.sh";;
esac
clear
echo "------------------------------------------------------------"
# Überprüfe ob fping und nmap vorhanden ist
echo "------------------------------------------------------------"
echo
command -v fping >/dev/null 2>&1 || { echo >&2 "fping ist nicht installiert!  Bitte installieren."; exit 1; }
echo "Programm fping ist vorhanden!"
echo
command -v nmap >/dev/null 2>&1 || { echo >&2 "nmap ist nicht installiert!  Bitte installieren."; exit 1; }
echo "Programm nmap ist vorhanden!"
echo ""
echo "Scanne Netzwerk: 	$netw"
echo "NMAP Parameter: 	$AUSWAHL"
echo "Ausgabeformat: 		$AUSWAHL2"
echo ""
echo "Übersicht aktiver Netzwerkteilnehmer:"
echo "(für MAC Adressen: als root/sudo im selben Netzwerk starten)"
echo "------------------------------------------------------------"
echo
echo
# aktuelles Startdatum und Uhrzeit wird der Ausgangsdatei hinzugefügt
datum=$(date +%d.%m.%Y-%H:%M:%S)
datum2=$(date +%d%m%Y)
echo Start: $datum
echo Kommando:  $AUSWAHL $AUSWAHL2 $netw
netz2=$(echo $netw | cut -d "/" -f 1)
netz=$netz2
echo Start: $datum > lanliste-$netz-$datum2.txt
echo Kommando: $AUSWAHL $AUSWAHL2 $netw >> lanliste-$netz-$datum2.txt
echo ""
# Beginn Ergebnisdatei
echo "------------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo "Netzwerkbestand $datum / $netw" > lanliste-$netz-$datum2.txt
echo "------------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo "------------------------------------------------------------"
echo "" >> lanliste-$netz-$datum2.txt
# Scannen des Netztes und Ablage in Ergebnisdatei, fping stellt fest welche IP Online ist
for k in $(fping -aq -g $netw); do
	echo "wird untersucht: $k"
	echo "Aktiv: $k" >> lanliste-$netz-$datum2.txt
# -n startet IP DNS Namen check und IP Adresse, -sP zeigt IP Adresse mit MAC Adresse und Hersteller ID
	nmap -R -sP $k | awk '/Nmap scan report for/{printf $5" "$6;}/MAC Address:/{print " => "$3" "$4" "$5" "$6;}' | sort >> lanliste-$netz-$datum2.txt
# -A zeigt mehr Informationen wie OS Version, Traceroute, welche Scripts laufen etc.
	$AUSWAHL $k | grep -B1 open >> lanliste-$netz-$datum2.txt
# zweiter nmap command mit gewähltem Ausgabeformat 
	$AUSWAHL $k --append-output $AUSWAHL2 lanliste$AUSWAHL2-$netz-$datum2 >> lanliste-$netz-$datum2.txt
	echo "---------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo >> lanliste-$netz-$datum2.txt
done
echo "-------------------------------------------------------"
echo "                      E N D E" >> lanliste-$netz-$datum2.txt
datum=$(date +%d.%m.%Y-%H:%M:%S)
echo $datum >> lanliste-$netz-$datum2.txt
echo "-------------------------------------------------------" >> lanliste-$netz-$datum2.txt
echo Ende: $datum
echo
# Anzeige Ergebnisdatei
less lanliste-$netz-$datum2.txt
