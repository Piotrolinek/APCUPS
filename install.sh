#!/bin/bash

######################################################
# This variable needs to be fixed before running!    #
# Currently it is using a default value, if you had  #
# used a different one, installation will fail!      #
######################################################
# Ta sekcja musi byc poprawiona przed uruchomieniem! #
# Jest ona wypelniona wartosciami domyslnymi, jezeli #
# zostaly uzyte inne, skrypt nie zadziala!           #
######################################################

# full path to repository directory
# pelna sciezka do katalogu repozytorium 
APCUPS_location="/home/cti/APCUPS"

######################################################

sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
rm /var/www/html/index.nginx-debian.html

sudo apt install apcupsd -y
sed -i '
    /\<#UPSNAME\>/c\UPSNAME Back-UPS 650
    /\<UPSCABLE\>/c\UPSCABLE usb
    /\<UPSTYPE\>/c\UPSTYPE usb
    /\<DEVICE\>/c\DEVICE
' "/etc/apcupsd/apcupsd.conf"
sed -i '
    /\<ISCONFIGURED=\>/c\ISCONFIGURED=yes
' "/etc/default/apcupsd"
sudo systemctl enable apcupsd
sudo systemctl start apcupsd

sudo mv "${APCUPS_location}/index.html" "/var/www/html/"
sudo mv "${APCUPS_location}/json_script.service" "/etc/systemd/system/"
sudo mv "${APCUPS_location}/json_script.timer" " /etc/systemd/system/"
sudo chmod +x "${APCUPS_location}/json_script.sh"
sudo sed -i "
    /\<ExecStart=\/home\/cti\/APCUPS\/json_script.sh\>/c\ExecStart=${APCUPS_location}/json_script.sh
" "/etc/systemd/system/json_script.service"

sudo systemctl enable json_script.timer
sudo systemctl start json_script.timer

sudo chmod +x "${APCUPS_location}/config_writer.py"
sudo chmod +x "${APCUPS_location}/sender.py"

sudo sed -i "/^# Send a message to all users/a\python ${APCUPS_location}/sender.py --onbatt" "/etc/apcupsd/onbattery"
sudo sed -i "/exit 0/i\python ${APCUPS_location}/sender.py --offbatt" "/etc/apcupsd/offbattery"
sudo sed -i "/config.read(\"\/home\/cti\/APCUPS\/sender_config.ini\")/c\    config.read(\"${APCUPS_location}\/sender_config.ini\")" "${APCUPS_location}/sender.py"

curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok