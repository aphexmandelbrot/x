
#!/bin/bash

# A quick BASH script that installs noVNC and sets up an Xfce4 session,
# accessible through a browser on port 5901 TCP. Tested against Kali Linux Xfce4 "full" installations.
# If running this on Azure or other virtual hosting, don't foret to allow ingress TCP 5901 .


# Configure the following parameters if needed:
###############################################
resolution="1280x720x16"
display_number=1
web_vnc_port=5901
###############################################

clear
echo -e "\n[*] Setting up \e[31mKali in a Browser\e[0m, generating ~/start.sh\n"
sleep 2
cat << EOF > ~/start.sh
#!/bin/bash
clear
echo -e "\e[31m\n[*] Starting up noVNC.\e[0m"
export DISPLAY=:$display_number
Xvfb :$display_number -screen 0 $resolution &
sleep 5
# Start up Xfce is available, otherwise assume Gnome
if [ -f /etc/xdg/xfce4/xinitrc ]; then
	startxfce4 2>/dev/null &
fi
x11vnc -display :$display_number -shared -nopw -listen localhost -xkb -bg -ncache_cr -forever
websockify --web /usr/share/novnc $web_vnc_port 127.0.0.1:5900 --cert=self.pem -D
ip="\$(host -t a myip.opendns.com resolver1.opendns.com|tail -1 |cut -d" " -f4)"
echo -e "\e[31m\n[*] Kali in a Browser is set up, you can access https://\$ip:$web_vnc_port\e[0m"
echo -e "[*] Don't forget to open up incoming port TCP $web_vnc_port if you have a firewalled host.".
EOF


chmod 755 ~/start.sh
clear
echo -e "\n[+] Installing pre-requisites, enter sudo password if asked.\n"
sleep 2
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install novnc websockify x11vnc xvfb
sudo apt-get clean
sudo ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
clear

echo -e "\n[+] Generating SSL cert. Please fill in details, then run \e[31m./start.sh\e[0m\n"
sleep 2
openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem


Few commands to help out:

Code:
passwd # Abacabb
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install novnc websockify x11vnc xvfb
sudo ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
This is a Kali-Linux support forum - not general IT/infosec help.

Useful Commands: OS, Networking, Hardware, Wi-Fi
Troubleshooting: Kali-Linux Installation, Repository, Wi-Fi Cards (Official Docs)
Hardware: Recommended 802.11 Wireless Cards 

Documentation: http://docs.kali.org/ (Offline PDF version)
Bugs Reporting & Tool Requests: https://bugs.kali.org/ 
Kali Tool List, Versions & Man Pages: https://tools.kali.org/
Reply With Quote Reply With Quote
Quick Navigation Installing Kali Linux Top
« Previous Thread | Next Thread »
Similar Threads
Slow connection xRDP
By Azura in forum Kali Linux General Questions
Replies: 2
Last Post: 2019-04-13, 18:22
How to set up xrdp on the AWS Kali image
By schroeder in forum How-To Archive
Replies: 4
Last Post: 2018-03-27, 10:59
getting XRDP to work on Kali (Raspberry Pi)
By WEP in forum General Archive
Replies: 1
Last Post: 2015-10-29, 08:32
Issues with using XRDP - Kali Linux
By WEP in forum Installing Archive
Replies: 1
Last Post: 2015-03-13, 15:02
Posting Permissions
You may not post new threads
You may not post replies
You may not post attachments
You may not edit your posts
 
BB code is On
Smilies are On
[IMG] code is On
[VIDEO] code is On
HTML code is Off
Forum Rules


Contact Us Kali Linux Forums Archive Top
All times are GMT. The time now is 17:56.
Kali Linux