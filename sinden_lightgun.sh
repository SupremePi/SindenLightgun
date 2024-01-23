#!/usr/bin/env bash

#
# This file is NOT part of The RetroPie Project
#

rp_module_id="sinden_lightgun"
rp_module_desc="Sinden Lightgun Stuff"
rp_module_help="Installs the Sinden Lightgun software for your 32/64 Raspberry Pi, along with Widge's Sinden Lightgun management utility.\n\nBe aware that reinstalling/updating will likely overwrite your LightgunMono config files.\n\nThis package and the Lightgun Management utility were created by Widge & updated by The SUREPEM TEAM in January 2024.\nYouTube: www.youtube.com/@widge\nGitHub:  www.github.com/Widge-5\n\nSinden Lightgun and its logos are registered trademarks owned by Sinden Technology Ltd."
rp_module_repo="git https://github.com/SupremePi/SindenLightgun.git main"
rp_module_section="exp"
rp_module_flags="rpi4 rpi5 rpi"

function depends_sinden_lightgun() {
    getDepends mono-complete v4l-utils libsdl1.2-dev libsdl-image1.2-dev libjpeg-dev xmlstarlet
}

function sources_sinden_lightgun() {
    gitPullOrClone
}


function install_sinden_lightgun() {
    md_ret_files=(
        './Scripts/uninstall.txt'
    )
}


function configure_sinden_lightgun() {

if [[ "$md_mode" == "install" ]]; then

 echo "INSTALLING"
    
    ## Remove the basic install of sinden if found##
    if [[ -d $home/Lightgun ]]; then
    rm -r "$home/Lightgun"
    rm -r "/home/pi/RetroPie/roms/ports/Sinden Lightguns" > /dev/null 2>&1
    fi

    mkUserDir "$home/Lightgun"
    mkUserDir "$home/Lightgun/utils"

    cp -v "$md_build/Scripts/sindenautostart.sh" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/recoiltcs.txt" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/help.txt" "$home/Lightgun/utils"
    cp -v $md_build/Borders/* /opt/retropie/emulators/retroarch/overlays/
	
	## Check if on a Supreme Build ##
	if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then
        cp -v "$md_build/Scripts/Sinden Lightgun.sh" "$home/RetroPie/retropiemenu/controllertools/"
        cp -v "$md_build/Scripts/sinden.png" "$home/RetroPie/retropiemenu/icons/"
	cp -v "$md_build/Scripts/Sinden Lightgun.sh" "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/controllertools/"
	cp -v "$md_build/Scripts/sinden.png" "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/icons/"	
	else
 	cp -v "$md_build/Scripts/Sinden Lightgun.sh" "$home/RetroPie/retropiemenu/"
        cp -v "$md_build/Scripts/sinden.png" "$home/RetroPie/retropiemenu/icons/"
	fi


    if isPlatform "64bit"; then
	echo "Installing 64bit Drivers"
        cp -rv $md_build/64bit/* $home/Lightgun/
    else
	echo "Installing 32bit Drivers"
        cp -rv $md_build/32bit/* $home/Lightgun/
    fi

    ## Clean up ownerships and permissions ##
    chown -R $user:$user "$home/Lightgun"
    chmod +x "$home/Lightgun/utils/sindenautostart.sh"
	
    ## Check if on a Supreme Build ##
    if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then	
    chown -R $user:$user "$home/RetroPie/retropiemenu"
    chown -R $user:$user "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5"
    chmod +x "$home/RetroPie/retropiemenu/controllertools/Sinden Lightgun.sh"
    chmod +x "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/controllertools/Sinden Lightgun.sh"
    else
    chown -R $user:$user "$home/RetroPie/retropiemenu"
    chmod +x "$home/RetroPie/retropiemenu/Sinden Lightgun.sh"
    fi

     # Check RetroPie's gamelist.xml to see if an entry for Sinden Lightgun already exists, and remove it if it does
     if xmlstarlet sel -t -v "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" > /dev/null 2>&1; then
     xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
	
     # Check if RetroPie's gamelist.xml was added to the retropiemenu then check entry for Sinden Lightgun that may already exist, and remove it if it does  
     if [[ -f $home/RetroPie/retropiemenu/gamelist.xml ]]; then
     xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/RetroPie/retropiemenu/gamelist.xml" 
     fi

    # Check if on a Supreme Build and make the RetroPie's gamelist.xml edit! Then check entry for Sinden Lightgun that may already exist, and remove it if it does  
    if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then   
    xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/.supreme_toolkit/sb_toolkit/retropie-gml-pi5/gamelist.xml"
    xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/gamelist.xml"
    fi  
    fi
	
    # Add in a new Sinden Lighgun entry to RetroPie's gamelist.xml
    if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then
    xmlstarlet ed --inplace --subnode "/gameList" --type elem -n "game" \
    --subnode "//gameList/game[last()]" --type elem -n "path" -v "./controllertools/Sinden Lightgun.sh" \
    --subnode "//gameList/game[last()]" --type elem -n "name" -v "Sinden Lightgun" \
    --subnode "//gameList/game[last()]" --type elem -n "desc" -v "Start, stop, test and calibrate your Sinden Lightguns. Includes Autostart settings." \
    --subnode "//gameList/game[last()]" --type elem -n "image" -v "./icons/sinden.png" \
    "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
	  
    # Add in a new Sinden Lighgun entry to all Extra RetroPie's gamelist.xml
    sudo cp "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" "/home/pi/.supreme_toolkit/sb_toolkit/retropie-gml-pi5/gamelist.xml"
    sudo cp "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" "/home/pi/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/gamelist.xml"
    sudo cp "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" "/home/pi/RetroPie/retropiemenu" 
    else
    # Add in a new Sinden Lighgun entry to RetroPie's gamelist.xml
    xmlstarlet ed --inplace --subnode "/gameList" --type elem -n "game" \
    --subnode "//gameList/game[last()]" --type elem -n "path" -v "./Sinden Lightgun.sh" \
    --subnode "//gameList/game[last()]" --type elem -n "name" -v "Sinden Lightgun" \
    --subnode "//gameList/game[last()]" --type elem -n "desc" -v "Start, stop, test and calibrate your Sinden Lightguns. Includes Autostart settings." \
    --subnode "//gameList/game[last()]" --type elem -n "image" -v "./icons/sinden.png" \
    "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
    fi

elif [[ "$md_mode" == "remove" ]]; then

    echo "REMOVING"
    
    /home/pi/Lightgun/utils/sindenautostart.sh -u

    if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then	
    rm -r "$home/Lightgun"
    rm "$home/RetroPie/retropiemenu/controllertools/Sinden Lightgun.sh"
    rm "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/controllertools/Sinden Lightgun.sh"
    rm "$home/RetroPie/retropiemenu/icons/sinden.png"
    rm  "$home/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/icons/sinden.png"
    else 
    rm "$home/RetroPie/retropiemenu/Sinden Lightgun.sh"
    rm "$home/RetroPie/retropiemenu/icons/sinden.png"
    fi

     # Check RetroPie's gamelist.xml to see if an entry for Sinden Lightgun already exists, and remove it if it does
     if xmlstarlet sel -t -v "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml" > /dev/null 2>&1; then
     xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
	
     # Check if RetroPie's gamelist.xml was added to the retropiemenu then check entry for Sinden Lightgun that may already exist, and remove it if it does  
     if [[ -f $home/RetroPie/retropiemenu/gamelist.xml ]]; then
     xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/RetroPie/retropiemenu/gamelist.xml" 
     fi

    # Check if on a Supreme Build and make the RetroPie's gamelist.xml edit! Then check entry for Sinden Lightgun that may already exist, and remove it if it does  
    if [[ -d $home/.supreme_toolkit/sb_toolkit/retropie-gml-pi5 ]]; then   
    xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/.supreme_toolkit/sb_toolkit/retropie-gml-pi5/gamelist.xml"
    xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/home/pi/.supreme_toolkit/sb_toolkit/retropiemenu-pi5/gamelist.xml"
    fi  
    fi
	
fi
  
}
