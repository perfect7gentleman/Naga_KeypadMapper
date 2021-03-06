#!/bin/bash
echo "Checking requirements..."
# ydotool installed check
command -v ydotool >/dev/null 2>&1 || { echo >&2 "I require ydotool but it's not installed! Aborting."; exit 1; }

echo "Compiling code..."
# Compilation
cd src
g++ -march=native -mtune=native -O3 -pipe -fdata-sections -fdevirtualize-at-ltrans -ffunction-sections -fgraphite-identity -fipa-pta -flto=9 -flto-compression-level=9 -floop-interchange -floop-nest-optimize -floop-parallelize-all -fomit-frame-pointer -fuse-linker-plugin -fno-asynchronous-unwind-tables -fno-plt -fno-semantic-interposition -fno-stack-protector -s naga.cpp -o naga

if [ ! -f ./naga ]; then
	echo "Error at compile! Ensure you have gcc installed Aborting"
	exit 1
fi

echo "Create config files"
# Configuration
sudo mv naga /usr/local/bin/
sudo chmod 755 /usr/local/bin/naga

cd ..
#HOME=$( getent passwd "$SUDO_USER" | cut -d: -f6 )

sudo cp nagastart.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/nagastart.sh


cp naga.desktop ~/.config/autostart/
echo "Some window managers do not support ~/.config/autostart. Please add nagastart.sh to be executed when your window manager starts if this is your case."

#This method is too problematic
#if ! grep -Fxq "bash /usr/local/bin/nagastart.sh &" "$HOME"/.profile; then
#	echo "bash /usr/local/bin/nagastart.sh &" >> "$HOME"/.profile
#fi

mkdir -p ~/.naga
cp -n mapping_{01,02,03}.txt ~/.naga/
sudo chown -R $(whoami):$(id -gn $(whoami)) ~/.naga/

echo "Creating udev rule..."

echo 'KERNEL=="event[0-9]*",SUBSYSTEM=="input",GROUP="razer",MODE="640"' > /tmp/80-naga.rules

sudo mv /tmp/80-naga.rules /etc/udev/rules.d/80-naga.rules
sudo groupadd -f razer
sudo gpasswd -a "$(whoami)" razer

echo "Starting daemon..."
# Run
nohup sudo bash /usr/local/bin/nagastart.sh >/dev/null 2>&1 &
