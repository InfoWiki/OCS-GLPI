#!/bin/bash
# INSTALLATION AUTOMATISER DE OCS/GLPI - DEBIAN
# Script dev. par Mickael Stanislas pour Infowiki
# http://mickael-stanislas.com/
# https://github.com/InfoWiki
# http://infowiki.fr
#
# Version = 1.0
# Synthaxe: bash ./autoinstall-ocs-glpi.sh
# Synthaxe: sudo bash ./autoinstall-ocs-glpi.sh
# Configuration
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ADDRIP=$(ifconfig eth0 | grep "inet addr" | cut -d " " -f 12 | cut -d : -f 2)


	clear
	echo ""
	echo "	Auto installation du couple OCS/GLPI"
	echo "         --------------------"
	echo -e "\n"
	read -p "[Enter] pour commencer ...."

			clear
			apt-get update										# Recherche de mises à jour
			apt-get upgrade -y									# Installation des mises à jour

			# L'installation de Apache2 et  Mysql
			clear
			echo -e "$NORMAL"
				if [ -n "$( pidof apache2  )" ]							# On test si Apache2 est deja présent 
					then echo -e "" 
					else echo -e "" 
						apt-get install -y apache2 php5 libapache2-mod-php5 php5-gd 	# Installation de Apache et des librairies
						/etc/init.d/apache2 restart					# On redémarre Apache
				fi
				if [ -n "$( pidof mysql  )" ]	                                                # On test si Apache2 est deja présent
                                        then echo -e ""
                                        else echo -e ""
                                                apt-get install -y mysql-server php5-mysql	                # Installation de Mysql
                                                /etc/init.d/apache2 restart                                     # On redémarre Apache
				fi
				clear
                        echo -e " **-------------------------------**\n"
                        echo -e "\tTest avant installation      \n"
				if [ -n "$( pidof apache2  )" ]
					then echo -e "$NORMAL""APACHE2 :""$VERT""\t[OK]\n"
                                        else echo -e "$NORMAL""APACHE2 :""$ROUGE""\t[ERREURS]\n"
				fi
                                if [ -n "$( pidof mysql  )" ]
                                        then echo -e "$NORMAL""MYSQL-SERVER :""$VERT""\t[OK]\n"
                                        else echo -e "$NORMAL""MYSQL-SERVER :""$ROUGE""\t[ERREURS]\n"
                                fi
			echo -e "$NORMAL"""
                        echo -e " **-------------------------------** \n"
			read -p "Appuyer sur une touche pour continuer ..."
			clear

			# Installation de GLPI
			echo -e "Installation de GLPI"
			apt-get install -y glpi									# Installation de GLPI depuis les sources
			/etc/init.d/apache2 restart
			clear
			echo -e " **-------------------------------------------------**	\n"
                        echo -e "\tFINALISATION DE LINSTALLATION DE GLPI      		\n"
			echo -e "Rendez-vous sur http://""$ADDRIP""/glpi		\n"
			echo -e ""
			echo -e "NOTE DE CONNECTION - ID : glpi - MDP : glpi"
			echo -e " **-------------------------------------------------** \n"
			read -p "Appuyer sur une touche quand vous avez termine"

			# Installation de OCS
			apt-get install -y libapache2-mod-php5 libapache2-mod-perl2
			apt-get install -y libxml-simple-perl  libcompress-zlib-perl
			apt-get install -y libdbi-perl libdbd-mysql-perl
			apt-get install -y libnet-ip-perl libphp-pclzip make
			apt-get install -y libapache-dbi-perl
			perl -MCPAN -e 'install XML::Entities'
			perl -MCPAN -e 'install SOAP::Lite'
			/etc/init.d/apache2 restart
			cd ~
			wget --no-check-certificate https://launchpad.net/ocsinventory-server/stable-2.0/2.0.5/+download/OCSNG_UNIX_SERVER-2.0.5.tar.gz
			tar -xvzf OCSNG_UNIX_SERVER-2.0.5.tar.gz
			cd OCSNG_UNIX_SERVER-2.0.5
			sh ./setup.sh
			/etc/init.d/apache2 restart
			clear
                        echo -e " **-------------------------------------------------** \n"
                        echo -e "\tFINALISATION DE LINSTALLATION DE OCS	                \n"
                        echo -e "Rendez-vous sur http://""$ADDRIP""/ocsreports          \n"
                        echo -e "Renseignez les informations suivantes :                \n"
                        echo -e "MysqlServer :""$ROUGE""localhost\n""$NORMAL"
                        echo -e "MysqlUser :""$ROUGE""root\n""$NORMAL"
                        echo -e "Mysqlpassword :""$ROUGE""Celui définit à l'installation\n""$NORMAL"
                        echo -e "NameOfDatabase :""$ROUGE""ocsweb\n""$NORMAL"
                        echo -e "NOTE DE CONNECTION - ID : admin - MDP : admin"
                        echo -e " **-------------------------------------------------** \n"
                        read -p "Appuyer sur une touche quand vous avez terminé"
			rm /usr/share/ocsinventory-reports/ocsreports/install.php
			clear
			echo -e "\n\n"
			echo -e " **---------------------------------------** \n"
                        echo -e "\tINSTALLATION TERMINE        \n"
			echo -e "$VERT""\twww.infowiki.fr""$NORMAL"
                        echo -e " **---------------------------------------** \n"
                        read -p "Appuyer sur une touche quand vous avez terminé"
			exit
