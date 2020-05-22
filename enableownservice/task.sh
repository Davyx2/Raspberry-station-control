#!/bin/bash
	lesFichiersCss=( "/etc/alternatives/gdm3.css" "/usr/share/gnome-shell/theme/gdm3.css"  "/usr/share/gnome-shell/theme/Yaru/gnome-shell.css" "/usr/share/gnome-shell/theme/gnome-shell.css" )
	repDestImageDeFond="/home/wanoon/Downloads/"
 
	if [[ "${repDestImageDeFond: -1}" != "/" ]]; then	#	Chemin doit se terminer par /
		repDestImageDeFond="$repDestImageDeFond""/"
	fi
 
################################################################
# Script_Name : Modification-fond-d-ecran-Gdm-1.0.sh
# Description : Personnalisation du fond d'écran de la fenêtre de connexion de GDM sur Ubuntu 19.04
# Date : December 2017 - revu juillet 2019
# écrit par : Griffon (traduit en français et un peu revu lors de sa publication sur le site ubuntu-fr.org)
# Web Site :http://www.c-nergy.be - http://www.c-nergy.be/blog
# Version : 1.0
# Remarque importante : Ce script est mis à disposition sans aucune garantie, à utiliser à vos risques et périls....
##################################################################
 
 
#---------------------------------------------------#
# Étape 0 - Credits .... 
#---------------------------------------------------#
 
/bin/echo -e "\e[1;32m###########################################################\e[0m"
/bin/echo -e "\e[1;32mModification-fond-d-ecran-Gdm-1.0.sh\e[0m"
/bin/echo -e "\e[1;32m"$(basename "$0")"\e[0m"
/bin/echo -e "\e[1;32mwritten by Griffon - December 2017 - Version 1.0 - modifié juillet 2019 - Modification-fond-d-ecran-Gdm-1.0.sh\e[0m"
/bin/echo -e "\e[1;32mTraduit en français et un peu revu lors de sa publication sur le site ubuntu-fr.org\e[0m"
/bin/echo -e "\e[1;32m###########################################################\e[0m"
echo
 
#---------------------------------------------------#
# Étape 1 - Vérification de la présence du paquet yad (zenity utilisé dans le script initial, yad est un "fork" plus puissant)
#---------------------------------------------------#
## ce n'est pas possible ##
## si yad n'est pas installé,
if [[ $(dpkg -s yad 2>/dev/null | grep Status | cut -d' ' -f4) != "installed" ]]
then
## alors il n'est pas possible de l'utiliser pour envoyer un message !
  yad --image=error --title="Installez le paquet yad" --text="Le paquet <b>yad</b> est nécessaire au bon fonctionnement de ce script.\n\nInstallez le paquet par <b>sudo apt-get install yad</b>\n\nArrêt du traitement. Erreur 10."
 
  exit 10;
fi
 
#---------------------------------------------------#
# Étape 2 - Choix du fichier css à modifier
#---------------------------------------------------#
	#	Index des fichiers
	NombreDeFichiersPotentiels="${#lesFichiersCss[@]}"
	if [[ "$NombreDeFichiersPotentiels" -gt "0" ]]; then
		listeIndexFichiersPotentiels="0"
		compteur=1 
		while [[ "$compteur" -lt "$NombreDeFichiersPotentiels" ]]; do 
			listeIndexFichiersPotentiels="$listeIndexFichiersPotentiels"" ""$compteur";
			let "compteur++"; 
		done;
	else
		 yad --image=error --title="Aucun fichier à modifier" --text="Aucun chemin de fichier css n'a été indiqué.\nArrêt du traitement.\nErreur 20." 2>/dev/null
		exit 20;
	fi
 
	#	Constitution de la liste des éléments à afficher par yad	
	ResultatAnalyse=""
	for i in $listeIndexFichiersPotentiels; do
 
		if [[ -f "${lesFichiersCss[$i]}" ]]; then
			Present["$i"]="0"
			if [[ -L "${lesFichiersCss[$i]}" ]]; then
				FichierLien["$i"]="0"
			else
				FichierLien["$i"]="1"
			fi
		else
			Present["$i"]="1"
			FichierLien["$i"]="1"
		fi
 
		if [[ "$ResultatAnalyse" == "" ]]; then
			ResultatAnalyse="False ${lesFichiersCss[$i]} £${Present[$i]}£ £${FichierLien[$i]}£"
		else
			ResultatAnalyse="$ResultatAnalyse False ${lesFichiersCss[$i]} £${Present[$i]}£ £${FichierLien[$i]}£"
		fi
	done
 
	ResultatAnalyse=$(echo "$ResultatAnalyse" | sed 's/£1£/Non/g;s/£0£/Oui/g')
 
	#	Affichage de la fenêtre de choix
	Selection=$(yad --title="Fichier CSS à modifier" --width 800 --height 200 --text-align="center" --list --radiolist --column="Sélectionné" --column="Fichier" --column="Présent sur le disque" --column="Fichier lien" $ResultatAnalyse 2>/dev/null)
 
	#	Abandon par l'utilisateur #############
	retour="$?"
	if [[ "$retour" == "1" ]] || [[ "$retour" == "252" ]] ; then
		echo "Arrêt. Traitement terminé. Erreur 30.";
		yad --image=error --title="Abandon" --text="Vous avez abandonné.\nArrêt du traitement.\nErreur 30." 2>/dev/null
		exit 30 ;
	fi
	###########################################	
 
	LeFichierCSS=$(echo "$Selection" | cut -d'|' -f2)
	echo "Le fichier $LeFichierCSS sera modifié"
 
	#	Contrôle de sécurité. Est-ce que le fichier existe ?
	if [[ ! -e "$LeFichierCSS" ]]; then 
		echo "Erreur dans le nom du fichier. $LeFichierCSS n'existe pas. Arrêt du traitement. Erreur 40."
		yad --image=error --title="Abandon" --text="$LeFichierCSS n'existe pas.\nArrêt du traitement.\nErreur 40." 2>/dev/null
		exit 40 ;
	fi
 
#---------------------------------------------------#
# Étape 2 - Choix de l'image retenue.... 
#---------------------------------------------------#
 
echo
/bin/echo -e "\e[1;32m###########################################################\e[0m"
/bin/echo -e "\e[1;32mChoix du fond d'écran...En cours\e[0m"
/bin/echo -e "\e[1;32m###########################################################\e[0m"
echo
 
	ImageDeFondOriginelle=$(yad --file --title="Choisissez le nouveau fond d'écran de la fenêtre de connexion" --filename="$HOME/.local/share/backgrounds/*" 2>/dev/null)
 
	#	Abandon par l'utilisateur #############
	retour="$?"
	if [[ "$retour" == "1" ]] || [[ "$retour" == "252" ]] ; then
		echo "Arrêt. Traitement terminé. Erreur 50.";
		yad --image=error --title="Abandon" --text="Vous avez abandonné.\nArrêt du traitement.\nErreur 50." 2>/dev/null
		exit 50 ;
	fi
 
	echo "Le fond d'écran choisi est : ""$ImageDeFondOriginelle"
 
	###########################################	
 
	# Récupération du nom court du fichier
	NomImageDeFond=$(basename $ImageDeFondOriginelle)
	NomImageDeFond="${NomImageDeFond%${NomImageDeFond: -4}}"
	NomImageDeFond="${NomImageDeFond%640x480}"
	NomImageDeFond="$NomImageDeFond""640x480.png"
 
	if [[ -e "$repDestImageDeFond$NomImageDeFond" ]]; then	# Si une image du même nom existe déjà dans le répertoire de destination
		echo "$repDestImageDeFond$NomImageDeFond existe déjà."
		index=0
		while [[ -e "$repDestImageDeFond$NomPropose" ]]; do  
			NomPropose=$(basename $ImageDeFondOriginelle)
			NomPropose="${NomPropose%${NomPropose: -4}}"
			NomPropose="${NomPropose%640x480}"
			NomPropose="$NomPropose""640x480_""$index"".png"
			let "index++"
		done
 
		yad --image=important --text="Saisie incorrecte. Une image à ce nom existe déjà. Acceptez vous le nom suivant ? : \nEn cliquant sur <connserver> l'image existante sera utilisée en lieu et place de celle que vous avez sélectionnée à l'étape précédente<b>$NomPropose</b>" --title="Modification du nom du fichier image" --width=500 --button="Annuler"\!gtk-no:1 --button="Conserver":2 --button="Accepter le nouveau nom"\!gtk-ok:0 2>/dev/null
		#	Abandon par l'utilisateur #############
		retour="$?"
		if [[ "$retour" == "1" ]] || [[ "$retour" == "252" ]] ; then
			echo "Arrêt. Traitement terminé. Erreur 60.";
			yad --image=error --title="Abandon" --text="Vous avez abandonné.\nArrêt du traitement.\nErreur 60." 2>/dev/null
			exit 60 ;
		###########################################
 
		elif [[ "$retour" == "0" ]] ; then	#	On n'utilise pas une image existante
			NomImageDeFond="$NomPropose"
 
		elif [[ "$retour" != "2" ]] ; then	#	autre cas -> pb
			echo "Erreur yad. Erreur 70."
			yad --image=error --title="Erreur" --text="Yad a rencontré un problème.\nArrêt du traitement.\nErreur 70." 2>/dev/null
			exit 70 ;
		fi
 
		NomCompletImageDeFond="$repDestImageDeFond$NomImageDeFond"
 
	fi
 
	#	Contrôle de sécurité. Est-ce que le fichier existe ?
	if [[ ! -e "$ImageDeFondOriginelle" ]]; then 
		echo "Erreur dans le nom du fichier. $ImageDeFondOriginelle n'existe pas. Arrêt du traitement. Erreur 80."
		yad --image=error --title="Le fichier n'existe pas" --text="$ImageDeFondOriginelle n'existe pas.\nArrêt du traitement.\nErreur 80." 2>/dev/null
		exit 80 ;
	fi
 
#---------------------------------------------------#
# Étape 3 - Copie du fichier image dans le répertoire /usr/share/background ($repDestImageDeFond)
#	Je convertis en 640x480, c'est probablement inutile
#---------------------------------------------------#
 
	if [[ "$retour" != "2" ]]; then	#	Evidemment si on utilise une image déjà présente, on saute l'étape 3
 
		echo
		/bin/echo -e "\e[1;32m###########################################################\e[0m"
		/bin/echo -e "\e[1;32mCopie du fichier dans le répertoire $repDestImage...En cours\e[0m"
		/bin/echo -e "\e[1;32m###########################################################\e[0m"
		echo
 
		sudo convert -geometry 640x480 "$ImageDeFondOriginelle" "$NomCompletImageDeFond"
		if [[ "$?" != "0" ]]; then
			echo "Erreur convert. Erreur 90."
			yad --image=error --title="Erreur" --text="Convert a rencontré un problème.\nArrêt du traitement.\nErreur 90." 2>/dev/null
		  exit 90 ;
		fi
 
		echo "Conversion de $ImageDeFondOriginelle en $NomCompletImageDeFond"
 
	fi
#---------------------------------------------------#
# Étape 4 - Mise à jour du fichier css
#---------------------------------------------------#
 
	echo
	/bin/echo -e "\e[1;32m###########################################################\e[0m"
	/bin/echo -e "\e[1;32mMise à jour du fichier $LeFichierCSS....En cours\e[0m"
	/bin/echo -e "\e[1;32m###########################################################\e[0m"
	echo
	echo "création d'un backup...."
	if [[ ! -e "$LeFichierCSS"".anc" ]]; then   #  Conservation de toutes les versions du fichier modifié
		echo "création d'un backup...."
		sudo cp "$LeFichierCSS"  "$LeFichierCSS"".anc"
		if [[ "$?" != "0" ]]; then
			echo "Erreur cp. Erreur 100."
			yad --image=error --title="Erreur" --text="cp a rencontré un problème.\nArrêt du traitement.\nErreur 100." 2>/dev/null
		  exit 100 ;
		fi
		echo "Création du fichier de sauvegarde ""$LeFichierCSS"".anc"
	else
		i=0
		while [[ ! -e "$LeFichierCSS"".anc""$i" ]]; do
			let "i+=1"
		done
		sudo cp "$LeFichierCSS"  "$LeFichierCSS"".anc""$i"
		if [[ "$?" != "0" ]]; then
			echo "Erreur cp. Erreur 110."
			yad --image=error --title="Erreur" --text="cp a rencontré un problème.\nArrêt du traitement.\nErreur 110." 2>/dev/null
		  exit 110 ;
		fi
		echo "Création du fichier de sauvegarde ""$LeFichierCSS"".anc""$i"
	fi
 
	sudo sed -i "/#lockDialogGroup/a background: #2c001e url(file:///home/wanoon/Downloads/bg.png);\nbackground-repeat: no-repeat;\nbackground-size: cover;\nbackground-position: center;\n}\nTexteAEffacerParLeScript" "$LeFichierCSS"
		if [[ "$?" != "0" ]]; then
			echo "Erreur sed. Erreur 120."
			yad --image=error --title="Erreur" --text="sed a rencontré un problème.\nArrêt du traitement.\nErreur 120." 2>/dev/null
		  exit 120 ;
		fi
	sudo sed -i '/TexteAEffacerParLeScript/,+2d' "$LeFichierCSS"
		if [[ "$?" != "0" ]]; then
			echo "Erreur sed. Erreur 130."
			yad --image=error --title="Erreur" --text="sed a rencontré un problème.\nArrêt du traitement.\nErreur 120." 2>/dev/null
		  exit 130 ;
		fi
 
#---------------------------------------------------#
# Étape 5 - Invite de l'utilisateur à réinitialiser le système
#---------------------------------------------------#
 
	echo
	echo "Vous devez redémarrer votre appareil pour voir les effets de la mise à jour....:-)"
	echo
 
 
	yad --text "Il faut redémarrer votre session pour prendre en compte vos modifications.\nVoulez vous : " --button="Ne rien faire"\!gtk-no:1 --button="Redémarrer":2 --button="Fermer la session":0 2>/dev/null
	retour="$?"
	case "$retour" in
	"0" )
		pkill -9 -u "$USER"
	;;
	"2" )
		sudo reboot
	esac
 
exit 0;
