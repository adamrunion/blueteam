#!/bin/bash

# This script attempts to prevent common red team attacks

# Explanation:
# Blocks incoming traffic from known malicious IP addresses by adding rules to iptables. This can be modified to include additional IP addresses or IP ranges.
# Disables unnecessary services that could be used by attackers to gain access or perform lateral movement.
# Disables root login via SSH, as this is a common vector for attack.
# Installs and enables a host-based intrusion detection system (HIDS) to detect and alert on suspicious activity.
# Sets up auditd for logging of system events and changes.
# Restricts permissions on sensitive files and directories to prevent unauthorized access.

#!/bin/bash

# Define variables
MALICIOUS_IPS=("1.1.1.1" "2.2.2.2" "3.3.3.3")
LOG_FILE="/var/log/hardening.log"

# Add error handling
set -e

# Redirect output to log file
exec &>> "$LOG_FILE"

# Block incoming traffic from known malicious IP addresses
for ip in "${MALICIOUS_IPS[@]}"; do
    iptables -A INPUT -s "$ip" -j DROP
done

# Disable unnecessary services
services=("telnet" "rsh.socket" "rlogin.socket" "rexec.socket")
for service in "${services[@]}"; do
    if systemctl is-active "$service"; then
        systemctl disable "$service"
        systemctl stop "$service"
    fi
done

# Disable root login via SSH
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Install and enable a host-based intrusion detection system (HIDS)
if ! dpkg -l ossec-hids &> /dev/null; then
    apt-get update
    apt-get install ossec-hids -y
    systemctl enable ossec-hids
fi

# Set up auditd for logging
if ! dpkg -l auditd &> /dev/null; then
    apt-get update
    apt-get install auditd -y
    systemctl enable auditd
    auditctl -e 1
fi

# Restrict permissions on sensitive files and directories
files=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/gshadow"
    "/etc/group"
    "/etc/hosts"
    "/etc/networks"
    "/etc/protocols"
    "/etc/services"
    "/etc/syslog.conf"
    "/etc/rsyslog.conf"
)
directories=("/var/log/messages" "/var/log/auth.log" "/var/log/syslog")
for file in "${files[@]}" "${directories[@]}"; do
    if [[ -e "$file" ]]; then
        chmod 600 "$file"
    fi
done

echo "Script completed successfully!"

