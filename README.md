# APCUPS Monitor

## Features:
1. Monitoring parameters of APC UPS in real-time
2. Access to private, self-hosted website for monitoring with basic authentication
3. Sending alert e-mails to you in case of power outage within 5 seconds

## Setup/installation guide
1. System installation (approx. 15 mins)
	1. https://www.raspberrypi.com/software/
	2. Operating system: Raspberry Pi OS (other) -> Raspberry Pi OS Lite (32-bit)
    3. System configuration:
        1. Hostname: any ("cti" is used in the guide)
        2. Login and password: mainly for SSH, e.g. cti; cti
        3. Wifi: rasp1 does not have built-in wifi module, so this is optional
        4. Services: Enable SSH
2. First boot
	1. Change keyboard layout, guide: https://linuxconfig.org/how-to-change-keyboard-layout-on-raspberry-pi
		1. `sudo raspi-config`
		2. (5) Localisation Options
		3. (L3) Keyboard
		4. Keyboard model. Generic-105 key is recommended, unless keyboard you use has a different layout or key number
		5. Other
		6. English (US)
		7. English (US) (first option)
		8. The default for the keyboard layout
		9. After enter you may need to wait approx 2 mins for keyboard reconfiguration to finish
		10. No compose key
		11. Finish
	2. Internet connection: Use ethernet cable or configure wifi connection https://www.makeuseof.com/connect-to-wifi-with-nmcli/
		1. In case of wifi configuration, you may need to use a wifi adapter if your raspberry does not have one built-in.
		2. After inserting ethernet cable into a port, verify connection by running `nmcli dev status`. You should see a list of devices.
		3. If you do not see the device run `nmcli radio wifi on`
		4. Check wifi list: `nmcli dev wifi list`
		5. Connection: `sudo nmcli dev wifi connect chosen_SSID_to_fill password "password_to_fill"`
		6. Alternatively: `sudo nmcli --ask dev wifi connect wybrany_SSID_do_wypelnienia` and type in your password
		7. Verify connection, e.g. `ping google.com -c 3`
3. SSH Conneciton (optional):
	1. `systemctl enable --now sshd`, then both on windows (powershell) and linux ssh connection should be available.
4. System update (recommended):
	1. WARNING: depending on your connection and model of the raspberry, this may take up to 2 hours!
	2. `sudo apt upgrade -y`
5. Git
	1. `sudo apt install git`
	2. `git clone https://github.com/Piotrolinek/APCUPS.git`
6. Nginx server installation
	1. `sudo apt install nginx`
	2. Verify, that system service started and is running: `systemctl status nginx`
	3. If it is not, run: `systemctl enable --now nginx`
	4. Verify default website, using `curl` or any other preferred method. You should see: "Welcome to nginx! If you see this page, the nginx web server is successfully installed and working. Further configuration is required. [...]"
	5. Delete default site which will be replaced by the one prepared by us `rm /var/www/html/index.nginx-debian.html`
7. apcupsd package installation
	1. `sudo apt install apcupsd -y`
	2. Verify, that system service started and is running: `systemctl status apcupsd`
	3. Connection configuration: `nano /etc/apcupsd/apcupsd.conf`
		1. Value `UPSCABLE usb` (default)
		2. Value `UPSTYPE usb` (default)
		3. Value `DEVICE` (delete the default value and leave only DEVICE)
	4. After configuration set `ISCONFIGURED=yes` in file `/etc/default/apcupsd`
	5. Test connection: 
		1. Stop temporarily system service (requirement for the test): `sudo systemctl stop apcupsd`
		2. `apctest`
		3. You can play around there or exit the shell (q)
	6. Run serivce `sudo systemctl enable --now apcupsd`
	7. Check status: `apcaccess status`
		1. `STATUS: COMMLOST` means that connection failed. It is normal during the first boot and you may need to reboot the system (`reboot`). If reboot did not help, you may have missed a step in the guide or misconfigured something, verify services and configuration files. 
	8. Further configuration remains default. https://wiki.debian.org/apcupsd
8. Moving files from repository
	1. `cd /path/to/repository/APCUPS` 
	2. `mv ./index.html /var/www/html/`
	3. `mv ./json_script.service /etc/systemd/system/`
	4. `mv ./json_script.timer  /etc/systemd/system/`
	5. Execution permission for script `chmod +x ./json_script.sh`
	6. Path modificaion in the script `nano /etc/systemd/system/json_script.service`. Default value is: `/home/cti/APCUPS/json_script.sh`
	7. System service activation: `sudo systemctl enable --now json_script.timer`
9. Email functionality (optional)
	1. Configuration file: `sender_config.ini`
		1. In case you want to fall back to default values of the file you can run script `config_writer.py`
		2. Section `REQUIRED` (as the name implies) is required and must be filled. Leaving it empty will result in an exception being thrown.
			1. sender_address - Email address of an "automatic sender" (look point 11.Creating gmail)
			2. receiver_address - Email address the alerts are targeted to
			3. sender_application_password - Generated app password of an "automatic server" (look point 11.Creating gmail)
		3. Section `DEFAULT` optional fields you may want to configure:
			1. send_onbatt - Bool (True/False) - Send mail when UPS goes into battery mode - default True - send
			1. send_offbatt - Wartość bool (True/False) - Send mail when UPS goes into normal mode - default True - send
			1. subject_onbatt - Email subject when UPS goes into battery mode
			1. subject_offbatt - Email subject when UPS goes into normal mode
			1. body_onbatt - Email body when UPS goes into normal mode
			1. body_offbatt - Email body when UPS goes into normal mode
	3. Required file modifications: (Warning! pay attention to sender.py file location, default value is `/home/cti/APCUPS/sender.py`)
		1. `nano /etc/apcupsd/onbattery` somewhere below the comment paste: `python /home/cti/APCUPS/sender.py --onbatt`
		2. `nano /etc/apcupsd/offbattery` somewhere below the comment paste: `python /home/cti/APCUPS/sender.py --offbatt`
		3. `nano /home/cti/APCUPS/sender.py` line 9, modify the path if you are not using default setup (`/home/cti/APCUPS/sender_config.ini`)
10. Execution permissions:
	1. Change directory to repository directory and run:
		1. `sudo chmod +x ./config_writer.py`
		2. `sudo chmod +x ./json_script.sh`
		3. `sudo chmod +x ./sender.py`
11. Creating gmail (Warning! You must set up 2FA to use this this feature!)
	1. Google SMTP server allows for 200 emails per day and is free
	2. Address and password anything you want
	3. You must set up 2FA to use this this feature
	4. Next, go to account management
		1. Search for: `Application passwords` or something along those lines
		3. Generate password for application (with any name you want)
		4. You will receive a password in a form of 4 groups of 4 characters like `xxxx xxxx xxxx xxxx`
		5. Paste that password to configuration file `sender_config.ini`, field `sender_application_password`
12. Ngrok
	1. Register an account at https://ngrok.com/ (you can use google account if you have completed step 11)
	2. After logging in, in the left panel, section Getting Started -> Your Authtoken - this is your authentication token, it will be used shortly. If it is missing, generate one now.
	3. Download package (command comes from official site https://ngrok.com/download):
		1. `curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok`
	4. Add your authtoken from 12.2 `ngrok config add-authtoken <wygenerowany_authtoken>`
	5. Expose Nginx server on port 80 `ngrok http 80`
		1. It is possible you get an error `ERR_NGROK_121` (`"Your ngrok-agent version "2.3.41" is too old. [...]"`). In that case run `ngrok update`
		2. It is possible to set basic authentication, e.g.: `ngrok http 80 --basic-auth "login:password"`
		3. Remember, every time you run the tunnel, the link changes
		4. It is possible to generate (ONCE!) a permanent link:
			1. https://dashboard.ngrok.com/domains, left panel
			2. Cloud Edge -> domains
			3. New Domain
			4. New static global domail will be generated. Unfortunately in free plan you cannot modify it.
			5. Click on the right side an icon with terminal, copy the link with url (you can also add basic authentication to it), so example command looks like this: `ngrok http --url=profound-warthog-model.ngrok-free.app 80 --basic-auth "cti:PolitechnikaLodzkaCTI"`
	6. To run the tunnel in the background, add `> /dev/null &` at the end
	7. (Optional, recommended) Automatically run the command at the start of the system:
		1. Change directory to APCUPS and run `sudo mv ./ngrok_starter.service /etc/systemd/system/` 
		2. `systemctl enable ngrok_starter.service`
		3. If the service is not running automatically after installation run `systemctl start ngrok_starter.service`
	8. (Optional) It is possible to save static tunneling setting to a config file (file location is revealed after typing in an authtoken, normally it is `root/.ngrok2/ngrok.yml`)
14. "Static" IP (Optional):
	13.1 `nano /etc/network/interfaces`
	13.2 `
		iface eth0 inet static
		address 192.168.1.100        # Your desired static IP address
		netmask 255.255.255.0        # Your subnet mask
		gateway 192.168.1.1          # Your gateway (router) IP address
		dns-nameservers 8.8.8.8      # DNS server(s) - You can add multiple servers
		`
	13.3 `sudo systemctl restart networking`
	13.4 Alternatively run: `sudo nmcli con mod "Your Connection Name" ipv4.addresses "192.168.1.100/24" ipv4.gateway "192.168.1.1" ipv4.dns "8.8.8.8" ipv4.method manual; sudo systemctl restart NetworkManager`


15. Miscellaneous
	1. Default timezone is Europe/London
		1. To change it run `sudo timedatectl set-timezone desired_timezone`
		1. Verification `date`
		1. Status of APC UPS will be updated after a reboot
	2. I created an "installation script", it should shorten greatly most of the manual steps like moving files, granting permissions etc. BUT IT HAS NOT BEEN TESTED! Also if you decide to try running it, remember to change path within the file, called `APCUPS_location`, default value is `/home/cti/APCUPS`.
	3. Unfortunately the guide is ridiculously long and setting everything up will probably take hours (most of which will probably be a system update), so the script might be worth running either way.
	4. The provided `json_script.sh` can be modified as you wish, by simply removing or commenting lines. Only BEGIN and END are required. If you wish to delete "END APC", you must remove the comma from the last line, such that JSON passes validation.
	6. The guide may have misspels, minor mistakes or major mistakes/missing points resulting in impossible to complete setup. In that case send me an email.