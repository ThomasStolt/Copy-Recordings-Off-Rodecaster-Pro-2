#!/bin/bash

# Configuration file path
config_file="rsync_script.cfg"

# Function to validate IP address
is_valid_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        [[ ${octets[0]} -le 255 && ${octets[1]} -le 255 && \
           ${octets[2]} -le 255 && ${octets[3]} -le 255 ]]
        stat=$?
    fi

    return $stat
}

# Function to read IP from the configuration file
read_config() {
    if [ -f "$config_file" ]; then
        echo "Config file found. Checking IP..."
        source "$config_file"
        if [ -n "$RCP2_IP" ] && is_valid_ip "$RCP2_IP"; then
            echo "IP found in config: $RCP2_IP"
            return 0
        else
            echo "No valid IP found in config."
        fi
    else
        echo "Config file not found, creating config file..."
    fi
    return 1
}

# Function to update configuration file with IP
update_config() {
    local ip="$1"
    echo "RCP2_IP=\"$ip\"" > "$config_file"
    # echo "Config updated with IP: $ip"
}

# Function to find active network interface and get network prefix
get_network_prefix() {
    local interface=$(route -n get default | grep 'interface:' | awk '{print $2}')
    local ip_info=$(ifconfig $interface | grep 'inet ' | awk '{print $2}')
    echo $ip_info | cut -d'.' -f1-3
}

# Define the MAC prefix
mac_prefix="82:44:c2"

# Function to ping and check ARP
check_device() {
    local ip="$1"
    ping -c 1 -W 1 "$ip" > /dev/null 2>&1
    if arp -an | grep "($ip)" | grep -qi "$mac_prefix"; then
        # echo "Rodecaster Pro 2 found at $ip"
        update_config "$ip"
        return 0
    fi
}

# Progress Bar Function
progress_bar() {
    local current=$1
    local total=254
    local percent=$((current * 100 / total))

    printf "\rScanning your network for Rodecaster Pro 2: %d%% complete" $percent
}

# Main
if read_config; then
    # check whether port 22 is open on remote device
    if nc -z -w1 "$RCP2_IP" 22; then
        echo "SSH Port on $RCP2_IP is open"
    else
        echo "Device not found."
        exit 1
    fi
    # check whether /usr/bin/rsync exists on remote device, using user root and password Yojcakhev90
    if sshpass -p "Yojcakhev90" ssh -o StrictHostKeyChecking=no root@"$RCP2_IP" '[ -f /usr/bin/rsync ]'; then
        echo "Rsync exists on $RCP2_IP"
    else
        echo "/usr/bin/rsync not found on $RCP2_IP, copying binary over"
        # sshpass -p "Yojcakhev90" scp -o StrictHostKeyChecking=no rsync root@"$RCP2_IP":/usr/bin/rsync

    fi





    echo "Performing other tasks..."
else
    echo "Searching for Rodecaster Pro 2 in your local network..."
    network_prefix=$(get_network_prefix)
    count=0

    for i in {1..254}; do
        ip="$network_prefix.$i"
        check_device "$ip" &
        ((count++))

        # Update progress every 10 IPs
        if (( i % 10 == 0 )); then
            wait
            progress_bar $i
        fi

        # Control concurrency
        if (( count >= 10 )); then
            wait
            count=0
        fi
    done

    # Wait for all background processes to finish
    wait
    progress_bar 254
    echo -e "\nScan complete."

    # Re-read the configuration file to check for the IP address
    if source "$config_file" && [ -n "$RCP2_IP" ] && is_valid_ip "$RCP2_IP"; then
        echo "Rodecaster Pro 2 found at $RCP2_IP"
        other_tasks
    else
        echo "Device not found."
    fi
fi