#!/bin/bash

HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=4
BACKTITLE="SINDEN LIGHTGUN TOOL-KIT"
TITLE="Sinden LightGun"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install & Setup the Sinden LightGun"
         2 "Remove & Unistall the Sinden LightGun"
         3 "Open RetroPie Setup")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo -e "$(tput setaf 2)Now Installing!$(tput sgr0)"
	    sleep 3
	    wget -N https://raw.githubusercontent.com/SupremePi/SindenLightgun/main/sinden_lightgun.sh -P /home/pi/RetroPie-Setup/ext/Widge-Supreme-Extras/scriptmodules/supplementary
            sudo ~/RetroPie-Setup/retropie_packages.sh sinden_lightgun
	    echo -e "$(tput setaf 2)finished! Now rebooting to Save Changes!$(tput sgr0)"
	    sleep 3
	    clear
	    sudo reboot	
            ;;
        2)
            echo -e "$(tput setaf 2)Now Removing! $(tput sgr0)"
	    sleep 3
	    sudo ~/RetroPie-Setup/retropie_packages.sh sinden_lightgun remove
            rm -r /home/pi/RetroPie-Setup/ext/Widge-Supreme-Extras
	    echo -e "$(tput setaf 2)finished! Now rebooting to Save Changes!$(tput sgr0)"
	    sleep 3
	    clear
	    sudo reboot 
            ;;
        3)
            cd $HOME/RetroPie-Setup && sudo ./retropie_setup.sh
            ;;
esac
