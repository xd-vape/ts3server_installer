#!/bin/bash
# Teamspeak³ Server installer by xd vape

MACHINE=$(uname -m)
Instversion="1.0"
VERSION=3.12.1
SERVERUSER=ts3server_amd64
LOCATION=/home/$SERVERUSER/

# Functions

function greenMessage() {
  echo -e "\\033[32;1m${*}\\033[0m"
}

function magentaMessage() {
  echo -e "\\033[35;1m${*}\\033[0m"
}

function cyanMessage() {
  echo -e "\\033[36;1m${*}\\033[0m"
}

function redMessage() {
  echo -e "\\033[31;1m${*}\\033[0m"
}

function yellowMessage() {
  echo -e "\\033[33;1m${*}\\033[0m"
}

function whiteMessage() {
  echo -e "\\033[39;1m${*}\\033[0m"
}

function errorQuit() {
  errorExit 'Exit now!'
}

function errorExit() {
  redMessage "${@}"
  exit 1
}

function makeDir() {
  if [ -n "$1" ] && [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

# INSTALLER

clear
greenMessage "[..........................] (0%)"
apt-get install sudo -y >/dev/null
clear
greenMessage "[#.........................] (10%)"
sudo apt-get install curl -y >/dev/null
clear
greenMessage "[##........................] (15%)" 
sudo apt-get install wget -y >/dev/null
clear
greenMessage "[###.......................] (27%)"
sudo apt-get install nano -y >/dev/null
clear
greenMessage "[#####.....................] (36%)"
sudo apt-get install screen -y >/dev/null
clear
greenMessage "[######....................] (45%)"
sudo apt-get install htop -y >/dev/null
clear
greenMessage "[#############.............] (59%)"
sudo apt-get install git -y >/dev/null
clear
greenMessage "[#################.........] (68%)"
sudo apt-get install tar -y >/dev/null
clear
greenMessage "[####################......] (76%)"
sudo apt-get install bzip -y >/dev/null
clear
greenMessage "[#######################...] (86%)" 
sudo apt-get install unzip -y >/dev/null
clear
greenMessage "[#########################.] (96%)" 
sudo apt-get update -y >/dev/null
clear
whiteMessage "[##########################] (100%)"
sudo apt-get upgrade -y >/dev/null
clear

if [ "$MACHINE" == "x86_64" ]; then
  ARCH="amd64"
else
  errorExit "$MACHINE wird nicht unterstützt"!
fi

sleep 1
echo "┌──────────────────────────────────────────────┐"
echo "│                                              │"
echo "│         Teamspeak³ Server Installer          │"
echo "│               Installer v$Instversion                 │"
echo "│              Script by xd vape               │"
echo "│                                              │"
echo "├──────────────────────────────────────────────┤"
echo "│                                              │"
echo "│  1. TS3 Server Installieren                  │"
echo "│  2. TS3 Server Entfernen                     │"
echo "│  3. TS3 Server Starten                       │"
echo "│  4. Installer Quit                           │"
echo "│                                              │"
echo "└──────────────────────────────────────────────┘"
read -p "Wähle eine Option aus: " opt


# TS Install
if [ "$opt" = "1" ]; then
  clear
  sleep 1
  echo "┌──────────────────────────────────────────────┐"
  echo "│                                              │"
  echo "│         Teamspeak³ Server Installer          │"
  echo "│               Installer v1.0                 │"
  echo "│              Script by xd vape               │"
  echo "│                                              │"
  echo "└──────────────────────────────────────────────┘"
  echo "Server automatisch installieren oder selber entscheiden?" 
  redMessage "Wenn du in deinen Eignen Ordner installieren willst, dann erstell dir bitte einen neuen User!" 
  select installdir in "Automatisch" "Eigener Ordner" "Quit"
  do
  if [ "$installdir" == "Automatisch" ]
  then
  # Check if the script was run as root user. Otherwise exit the script
  if [ "$(id -u)" != "0" ]; then
      errorExit "Wechsel zum Root-Konto erforderlich!"
  fi
    clear
    yellowMessage "Teamspeak Server wird heruntergeladen..."
    adduser -q --disabled-password --gecos "" $SERVERUSER
    cd $LOCATION || return
    DOWNLOAD_URL_VERSION="https://files.teamspeak-services.com/releases/server/$VERSION/teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2"
    STATUS=$(wget --server-response -L $DOWNLOAD_URL_VERSION 2>&1 | awk '/^  HTTP/{print $2}')
    if [ "$STATUS" == "200" ]; then
        DOWNLOAD_URL=$DOWNLOAD_URL_VERSION
    fi
    tar -xvf teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2 >/dev/null
    rm teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2
    cd teamspeak3-server_linux_$ARCH || return
    mv * ../ 
    cd ..
    rmdir teamspeak3-server_linux_$ARCH/
    sudo chown -R $SERVERUSER $LOCATION
    greenMessage "Teamspeak Server erfolgreich installiert!"
      echo "Soll der Server gestartet werden?" 
      select start_server in "Ja" "Nein"
      do
      if [ "$start_server" == "Ja" ]
      then
        clear
        cd || return
        echo "echo Hello World" >> $LOCATION/.ts3server_license_accepted
        clear
        runuser -l $SERVERUSER -c './ts3server_startscript.sh start'
        yellowMessage "!!!!!BITTE SPEICHER DIR ALLES AB!!!!!"
        exit 0
      fi
      if [ "$start_server" == "Nein" ]
      then
        errorExit 'Installer wird verlassen!'
        exit 0
      fi
      done
    fi

    if [ "$installdir" == "Eigener Ordner" ]
    then
      read -p "Wo soll der Server installiert werden? :" installowndir
      mkdir $installowndir
      cd $installowndir
      DOWNLOAD_URL_VERSION="https://files.teamspeak-services.com/releases/server/$VERSION/teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2"
      STATUS=$(wget --server-response -L $DOWNLOAD_URL_VERSION 2>&1 | awk '/^  HTTP/{print $2}')
      if [ "$STATUS" == "200" ]; then
          DOWNLOAD_URL=$DOWNLOAD_URL_VERSION
      fi
      tar -xvf teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2 >/dev/null
      rm teamspeak3-server_linux_$ARCH-$VERSION.tar.bz2
      cd teamspeak3-server_linux_$ARCH || return
      mv * ../ 
      cd ..
      rmdir teamspeak3-server_linux_$ARCH/

      greenMessage "Teamspeak Server erfolgreich installiert!"
      echo "Soll der Server gestartet werden?" 
      select start_server in "Ja" "Nein"
      do
      if [ "$start_server" == "Ja" ]
      then
        clear
        cd || return
        echo "echo Hello World" >> $installowndir/.ts3server_license_accepted
        clear
        cd $installowndir 
        ./ts3server_startscript.sh start
        yellowMessage "!!!!!BITTE SPEICHER DIR ALLES AB!!!!!"
        exit 0
      fi
      if [ "$start_server" == "Nein" ]
      then
        errorExit 'Installer wird verlassen!'
        exit 0
      fi
      done
    fi

    if [ "$installdir" == "Quit" ]
    then
        errorExit 'Installer wird verlassen!'
        exit 0
    fi
  done
fi

if [ "$opt" = "2" ]; then
    echo "Test"
fi

if [ "$opt" = "3" ]; then
 echo "Test3"
fi

if [ "$opt" = "4" ]; then
 echo "Ciao"
 exit 0
fi