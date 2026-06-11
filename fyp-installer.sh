#!/bin/bash
set -e

# ============================================================
# FYP SERVER AUTO INSTALLER - Enhanced Edition
# Script by: AZMINKacakz
# Use it wisely, build for fun 🚀
# ============================================================

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# --- Spinner ---
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [${CYAN}%c${NC}]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- Print centered text ---
print_center() {
    local text="$1"
    local color="$2"
    local width=62
    local pad=$(( (width - ${#text}) / 2 ))
    printf "%${pad}s" ""
    echo -e "${color}${text}${NC}"
}

# --- Section header ---
section() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    printf "${CYAN}║${NC}  ${BOLD}${YELLOW}%-58s${NC}${CYAN}║${NC}\n" "$1"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# --- Step printer ---
step() {
    echo -e "  ${GREEN}▶${NC} ${WHITE}$1${NC}"
}

# --- Success message ---
ok() {
    echo -e "  ${GREEN}✔${NC} ${GREEN}$1${NC}"
}

# --- Warning ---
warn() {
    echo -e "  ${YELLOW}⚠${NC}  ${YELLOW}$1${NC}"
}

# ============================================================
# UBUNTU ASCII ART + BRANDING
# ============================================================
clear
echo ""
echo -e "${MAGENTA}        .${NC}"
echo -e "${MAGENTA}       (  )${NC}"
echo -e "${MAGENTA}      (    )${NC}"
echo -e "${MAGENTA}       (  )${NC}"
echo -e "${MAGENTA}        )(${NC}"
echo -e "${MAGENTA}       /  \\${NC}"
echo -e "${MAGENTA}      ( oo )${NC}    ${BOLD}${WHITE}╔════════════════════════════════╗${NC}"
echo -e "${MAGENTA}      _\`--'_${NC}   ${BOLD}${WHITE}║   FYP SERVER AUTO INSTALLER    ║${NC}"
echo -e "${RED}     / \`--' \\${NC}  ${BOLD}${WHITE}║       Ubuntu 24.04 LTS         ║${NC}"
echo -e "${RED}    /  (oo)  \\${NC} ${BOLD}${WHITE}╠════════════════════════════════╣${NC}"
echo -e "${RED}   /   \`--'  \\${NC} ${BOLD}${WHITE}║  Script by: ${CYAN}AZMINKacakz${WHITE}         ║${NC}"
echo -e "${RED}  / ___/  \\__ \\${NC}${BOLD}${WHITE}║  Use it wisely, build for fun  ║${NC}"
echo -e "${WHITE} / /  |    |  \\${NC}${BOLD}${WHITE}╚════════════════════════════════╝${NC}"
echo -e "${WHITE}/_/   |    |   \\_${NC}"
echo ""
echo -e "${DIM}${WHITE}         ~~~~ Ubuntu / Debian Style ~~~~${NC}"
echo ""

# Animated dots
echo -ne "${CYAN}  Initializing"
for i in 1 2 3 4 5; do
    sleep 0.3
    echo -ne "."
done
echo -e " ${GREEN}Ready!${NC}"
echo ""

# ============================================================
# ROOT CHECK
# ============================================================
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✘  Please run as root!  sudo bash fyp-installer.sh    ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi

# ============================================================
# DOMAIN INPUT
# ============================================================
section "⚙  CONFIGURATION"

echo -e "  ${CYAN}Enter your domain name:${NC}"
echo -ne "  ${YELLOW}▶ Domain (e.g. fyp.minazmin.my): ${NC}"
read DOMAIN
echo ""
echo -e "  ${GREEN}✔ Domain set to:${NC} ${BOLD}${WHITE}https://${DOMAIN}${NC}"
echo ""

# ============================================================
# DETECT OS
# ============================================================
section "🔍  DETECTING SYSTEM"

OS_ID=$(. /etc/os-release && echo "$ID")
OS_VERSION=$(. /etc/os-release && echo "$VERSION_ID")
ARCH=$(uname -m)
HOSTNAME_VAL=$(hostname)

echo -e "  ${CYAN}OS        :${NC} ${WHITE}${OS_ID^} ${OS_VERSION}${NC}"
echo -e "  ${CYAN}Arch      :${NC} ${WHITE}${ARCH}${NC}"
echo -e "  ${CYAN}Hostname  :${NC} ${WHITE}${HOSTNAME_VAL}${NC}"

# Detect Java path based on arch
if [ "$ARCH" = "aarch64" ]; then
    JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-arm64"
    warn "ARM64 detected — using arm64 Java path"
else
    JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-amd64"
    ok "x86_64 detected — using amd64 Java path"
fi

echo ""

# ============================================================
# UPDATE SYSTEM
# ============================================================
section "📦  UPDATING SYSTEM"
step "Running apt update & upgrade..."
apt update -qq && apt upgrade -y -qq
ok "System updated!"

# ============================================================
# INSTALL JAVA
# ============================================================
section "☕  INSTALLING JAVA 21"
step "Installing OpenJDK 21..."
apt install openjdk-21-jdk -y -qq
JAVA_VER=$(java -version 2>&1 | head -1)
ok "Java installed: ${JAVA_VER}"

# ============================================================
# INSTALL & CONFIGURE MYSQL
# ============================================================
section "🗄️  INSTALLING MYSQL"
step "Installing MySQL Server..."
apt install mysql-server -y -qq
systemctl enable mysql --quiet
systemctl start mysql

step "Configuring MySQL root account..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';" 2>/dev/null || \
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'admin';" 2>/dev/null || true
mysql -u root -padmin -e "FLUSH PRIVILEGES;" 2>/dev/null

step "Creating database 'fypdb'..."
mysql -u root -padmin 2>/dev/null <<SQL
CREATE DATABASE IF NOT EXISTS fypdb;
FLUSH PRIVILEGES;
SQL

ok "MySQL configured!"

echo ""
echo -e "${CYAN}  ┌─────────────────────────────────────┐${NC}"
echo -e "${CYAN}  │${NC}   ${BOLD}${YELLOW}MySQL Credentials${NC}                   ${CYAN}│${NC}"
echo -e "${CYAN}  ├─────────────────────────────────────┤${NC}"
echo -e "${CYAN}  │${NC}  Database : ${WHITE}fypdb${NC}                     ${CYAN}│${NC}"
echo -e "${CYAN}  │${NC}  Username : ${WHITE}root${NC}                      ${CYAN}│${NC}"
echo -e "${CYAN}  │${NC}  Password : ${RED}admin${NC}                     ${CYAN}│${NC}"
echo -e "${CYAN}  └─────────────────────────────────────┘${NC}"
echo ""

# ============================================================
# INSTALL NGINX
# ============================================================
section "🌐  INSTALLING NGINX"
step "Installing Nginx..."
apt install nginx -y -qq
systemctl enable nginx --quiet
systemctl start nginx
ok "Nginx running!"

# ============================================================
# CONFIGURE FIREWALL
# ============================================================
section "🔒  CONFIGURING FIREWALL (UFW)"
step "Installing UFW..."
apt install ufw -y -qq
ufw --force reset > /dev/null 2>&1
ufw allow OpenSSH  > /dev/null
ufw allow 80/tcp   > /dev/null
ufw allow 443/tcp  > /dev/null
ufw allow 8080/tcp > /dev/null
echo "y" | ufw enable > /dev/null 2>&1 || true
ok "Firewall configured: SSH, 80, 443, 8080 open"

# ============================================================
# INSTALL TOMCAT
# ============================================================
section "🐱  INSTALLING APACHE TOMCAT 9"

TOMCAT_VERSION="9.0.118"
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

step "Downloading Tomcat ${TOMCAT_VERSION}..."
cd /tmp

# Fallback mirror support
if ! wget -q --timeout=30 "${TOMCAT_URL}" -O "apache-tomcat-${TOMCAT_VERSION}.tar.gz"; then
    warn "Primary mirror failed, trying archive mirror..."
    TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
    wget -q --timeout=60 "${TOMCAT_URL}" -O "apache-tomcat-${TOMCAT_VERSION}.tar.gz"
fi

ok "Downloaded!"

step "Extracting Tomcat..."
rm -rf /opt/tomcat
mkdir -p /opt/tomcat
tar -xzf "apache-tomcat-${TOMCAT_VERSION}.tar.gz" -C /opt/tomcat --strip-components=1

chmod +x /opt/tomcat/bin/*.sh

step "Creating tomcat user..."
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat 2>/dev/null || true
chown -R tomcat:tomcat /opt/tomcat

step "Creating systemd service..."
cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=${JAVA_HOME_PATH}"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms256m -Xmx1g -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tomcat --quiet
systemctl restart tomcat
sleep 3

if systemctl is-active --quiet tomcat; then
    ok "Tomcat is running on port 8080!"
else
    warn "Tomcat may have an issue. Check: journalctl -u tomcat -n 20"
fi

# ============================================================
# CONFIGURE NGINX REVERSE PROXY
# ============================================================
section "🔧  CONFIGURING NGINX REVERSE PROXY"

step "Writing Nginx site config..."
cat > /etc/nginx/sites-available/fyp << NGINX
server {
    listen 80;
    server_name ${DOMAIN};

    client_max_body_size 100M;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 60s;
        proxy_read_timeout 60s;
    }
}
NGINX

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/fyp /etc/nginx/sites-enabled/fyp

if nginx -t 2>/dev/null; then
    systemctl restart nginx
    ok "Nginx configured and restarted!"
else
    warn "Nginx config test failed — check /etc/nginx/sites-available/fyp"
fi

# ============================================================
# DNS CHECK
# ============================================================
section "🌍  DNS VERIFICATION"

SERVER_IP=$(curl -s --max-time 5 ifconfig.me || curl -s --max-time 5 api.ipify.org || echo "UNKNOWN")

echo -e "${BOLD}  Make sure this DNS A Record is set:${NC}"
echo ""
echo -e "${CYAN}  ┌─────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}  │${NC}  Type  : ${WHITE}A Record${NC}                           ${CYAN}│${NC}"
echo -e "${CYAN}  │${NC}  Host  : ${YELLOW}${DOMAIN}${NC}"
echo -e "${CYAN}  │${NC}  Value : ${GREEN}${SERVER_IP}${NC}"
echo -e "${CYAN}  └─────────────────────────────────────────────┘${NC}"
echo ""

# Quick DNS propagation check
echo -ne "  ${YELLOW}Checking DNS propagation${NC}"
RESOLVED_IP=$(getent hosts "${DOMAIN}" 2>/dev/null | awk '{print $1}' || echo "")
if [ "$RESOLVED_IP" = "$SERVER_IP" ]; then
    echo -e " ... ${GREEN}✔ DNS resolved correctly!${NC}"
else
    echo -e " ... ${YELLOW}⚠ Not yet propagated (expected: ${SERVER_IP}, got: ${RESOLVED_IP:-none})${NC}"
    echo ""
    echo -e "  ${DIM}Press ENTER once DNS is propagated to continue...${NC}"
    read
fi

# ============================================================
# INSTALL SSL (CERTBOT)
# ============================================================
section "🔐  INSTALLING SSL CERTIFICATE"
step "Installing Certbot..."
apt install certbot python3-certbot-nginx -y -qq

step "Requesting SSL certificate for ${DOMAIN}..."
if certbot --nginx -d "${DOMAIN}" --redirect --non-interactive --agree-tos -m "admin@${DOMAIN}" 2>&1 | grep -q "Congratulations"; then
    ok "SSL certificate installed successfully!"
elif certbot --nginx -d "${DOMAIN}" --redirect --non-interactive --agree-tos -m "admin@${DOMAIN}"; then
    ok "SSL certificate installed!"
else
    warn "SSL installation may have encountered an issue."
    warn "Try manually: certbot --nginx -d ${DOMAIN}"
fi

# ============================================================
# FINAL SUMMARY
# ============================================================
echo ""
echo ""
echo -e "${GREEN}  ██████╗  ██████╗ ███╗   ██╗███████╗${NC}"
echo -e "${GREEN}  ██╔══██╗██╔═══██╗████╗  ██║██╔════╝${NC}"
echo -e "${GREEN}  ██║  ██║██║   ██║██╔██╗ ██║█████╗  ${NC}"
echo -e "${GREEN}  ██║  ██║██║   ██║██║╚██╗██║██╔══╝  ${NC}"
echo -e "${GREEN}  ██████╔╝╚██████╔╝██║ ╚████║███████╗${NC}"
echo -e "${GREEN}  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝${NC}"
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║${NC}  ${BOLD}${WHITE}INSTALLATION COMPLETE!${NC}                               ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  🌐 Website   : ${YELLOW}https://${DOMAIN}${NC}"
echo -e "${CYAN}  ║${NC}  🗄️  Database  : ${WHITE}fypdb${NC} / ${WHITE}root${NC} / ${RED}admin${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ☕ Tomcat     : ${WHITE}http://localhost:8080${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  🔒 SSL        : ${GREEN}Active via Let's Encrypt${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  ${BOLD}${YELLOW}Deploy Your WAR File:${NC}                                ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  ${WHITE}1.${NC} Rename your build to ${YELLOW}ROOT.war${NC}                      ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${WHITE}2.${NC} Upload to your VPS                               ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${WHITE}3.${NC} Run these commands:${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}                                                         ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${GREEN}sudo rm -rf /opt/tomcat/webapps/ROOT${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${GREEN}sudo rm -f /opt/tomcat/webapps/ROOT.war${NC}            ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${GREEN}sudo cp ROOT.war /opt/tomcat/webapps/${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${GREEN}sudo systemctl restart tomcat${NC}                      ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  ${BOLD}${YELLOW}Useful Commands:${NC}                                     ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  📋 Tomcat logs  : ${WHITE}tail -f /opt/tomcat/logs/catalina.out${NC} ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  🔄 Restart all  : ${WHITE}systemctl restart tomcat nginx mysql${NC}  ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  🩺 Status check : ${WHITE}systemctl status tomcat${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}  ║${NC}  ${DIM}Script by AZMINKacakz — Use it wisely, build for fun${NC}  ${CYAN}║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}Happy building! 🚀${NC}"
echo ""
