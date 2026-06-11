#!/bin/bash

# ============================================================
#   AzminKacakZ SSH Dashboard Installer
# ============================================================

GREEN='\033[0;32m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
RESET='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}${BOLD}"
echo "  Installing AzminKacakZ Terminal Dashboard..."
echo -e "${RESET}"

# Backup existing bashrc
cp ~/.bashrc ~/.bashrc.backup
echo -e "${GREEN}✔ Backed up ~/.bashrc to ~/.bashrc.backup${RESET}"

# Remove old greeting if already installed
sed -i '/AutoCoded By AzminKacakZ/,/^bash_greeting$/{ /^bash_greeting$/d; d }' ~/.bashrc 2>/dev/null

# Write the greeting function
cat >> ~/.bashrc << 'ENDBASHRC'

# ============================================================
#   AutoCoded By AzminKacakZ — SSH Terminal Dashboard
# ============================================================
bash_greeting() {
    CYAN='\033[0;36m'
    GREEN='\033[0;32m'
    ORANGE='\033[0;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    GRAY='\033[0;37m'
    WHITE='\033[1;37m'
    BOLD='\033[1m'
    RESET='\033[0m'
    RED='\033[0;31m'

    clear

    # ── LOGO ──────────────────────────────────────────────
    echo -e "${CYAN}${BOLD}"
    echo '   █████╗ ███████╗███╗   ███╗██╗███╗   ██╗'
    echo '  ██╔══██╗╚══███╔╝████╗ ████║██║████╗  ██║'
    echo '  ███████║  ███╔╝ ██╔████╔██║██║██╔██╗ ██║'
    echo '  ██╔══██║ ███╔╝  ██║╚██╔╝██║██║██║╚██╗██║'
    echo '  ██║  ██║███████╗██║ ╚═╝ ██║██║██║ ╚████║'
    echo '  ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝'
    echo -e "${RESET}"
    echo -e "       ${GREEN}▶ AutoCoded By ${ORANGE}${BOLD}AzminKacakZ${RESET}"
    echo -e "       ${GRAY}  Ubuntu SSH Terminal Dashboard v2.0${RESET}"
    echo -e "${GRAY}  ══════════════════════════════════════════${RESET}"

    # ── CLOCK & DATE ──────────────────────────────────────
    NOW=$(date '+%H:%M:%S')
    DATE=$(date '+%A, %d %B %Y')
    echo -e "  ${CYAN}${BOLD}  ⏱  $NOW${RESET}   ${GRAY}$DATE${RESET}"
    echo -e "${GRAY}  ──────────────────────────────────────────${RESET}"

    # ── SYSTEM INFO ───────────────────────────────────────
    USER_NAME=$(whoami)
    HOST_NAME=$(hostname)
    OS=$(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
    KERNEL=$(uname -r)
    UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
    SHELL_VER=$(bash --version | head -1 | grep -oP '\d+\.\d+\.\d+')
    MEM_USED=$(free -h | awk '/^Mem:/{print $3}')
    MEM_TOTAL=$(free -h | awk '/^Mem:/{print $2}')
    DISK=$(df -h / | awk 'NR==2{print $3 " / " $2 " (" $5 " used)"}')
    IP_LOCAL=$(hostname -I 2>/dev/null | awk '{print $1}')
    IP_PUBLIC=$(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo "N/A")
    CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')
    LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    SSH_IP=${SSH_CLIENT%% *}
    [ -z "$SSH_IP" ] && SSH_IP="Local"

    echo -e "  ${GRAY}◼ User      ${GREEN}${BOLD}$USER_NAME${RESET}${GRAY}@${CYAN}$HOST_NAME${RESET}"
    echo -e "  ${GRAY}◼ OS        ${WHITE}$OS${RESET}"
    echo -e "  ${GRAY}◼ Kernel    ${RESET}$KERNEL"
    echo -e "  ${GRAY}◼ Shell     ${BLUE}Bash $SHELL_VER${RESET}"
    echo -e "  ${GRAY}◼ CPU       ${RESET}$CPU"
    echo -e "  ${GRAY}◼ Uptime    ${ORANGE}$UPTIME${RESET}"
    echo -e "  ${GRAY}◼ Memory    ${RESET}$MEM_USED / $MEM_TOTAL"
    echo -e "  ${GRAY}◼ Disk      ${RESET}$DISK"
    echo -e "  ${GRAY}◼ Load      ${RESET}$LOAD"
    echo -e "  ${GRAY}◼ Local IP  ${CYAN}$IP_LOCAL${RESET}"
    echo -e "  ${GRAY}◼ Public IP ${CYAN}$IP_PUBLIC${RESET}"
    echo -e "  ${GRAY}◼ SSH From  ${PURPLE}$SSH_IP${RESET}"
    echo -e "${GRAY}  ──────────────────────────────────────────${RESET}"

    # ── BEGINNER MENU ─────────────────────────────────────
    echo -e "  ${ORANGE}${BOLD}▶ BEGINNER MENU — What do you want to do?${RESET}"
    echo ""
    echo -e "  ${CYAN}── FILES & FOLDERS ───────────────────────${RESET}"
    echo -e "  ${BLUE}[f1]${RESET}  List files              ${GRAY}ls -lah${RESET}"
    echo -e "  ${BLUE}[f2]${RESET}  Go to home folder       ${GRAY}cd ~${RESET}"
    echo -e "  ${BLUE}[f3]${RESET}  Show current folder     ${GRAY}pwd${RESET}"
    echo -e "  ${BLUE}[f4]${RESET}  Create folder           ${GRAY}mkdir foldername${RESET}"
    echo -e "  ${BLUE}[f5]${RESET}  Delete file/folder      ${GRAY}rm -rf name${RESET}"
    echo ""
    echo -e "  ${CYAN}── SYSTEM ────────────────────────────────${RESET}"
    echo -e "  ${BLUE}[s1]${RESET}  Update & upgrade        ${GRAY}sudo apt update && sudo apt upgrade -y${RESET}"
    echo -e "  ${BLUE}[s2]${RESET}  Check disk usage        ${GRAY}df -h${RESET}"
    echo -e "  ${BLUE}[s3]${RESET}  Check memory usage      ${GRAY}free -h${RESET}"
    echo -e "  ${BLUE}[s4]${RESET}  Monitor processes       ${GRAY}htop${RESET}"
    echo -e "  ${BLUE}[s5]${RESET}  Reboot system           ${GRAY}sudo reboot${RESET}"
    echo -e "  ${BLUE}[s6]${RESET}  Shutdown system         ${GRAY}sudo poweroff${RESET}"
    echo ""
    echo -e "  ${CYAN}── NETWORK ───────────────────────────────${RESET}"
    echo -e "  ${BLUE}[n1]${RESET}  Show IP address         ${GRAY}ip addr show${RESET}"
    echo -e "  ${BLUE}[n2]${RESET}  Test internet           ${GRAY}ping -c 4 google.com${RESET}"
    echo -e "  ${BLUE}[n3]${RESET}  Check open ports        ${GRAY}ss -tulnp${RESET}"
    echo -e "  ${BLUE}[n4]${RESET}  Download a file         ${GRAY}wget URL${RESET}"
    echo ""
    echo -e "  ${CYAN}── PACKAGES ──────────────────────────────${RESET}"
    echo -e "  ${BLUE}[p1]${RESET}  Install a package       ${GRAY}sudo apt install packagename${RESET}"
    echo -e "  ${BLUE}[p2]${RESET}  Remove a package        ${GRAY}sudo apt remove packagename${RESET}"
    echo -e "  ${BLUE}[p3]${RESET}  Search a package        ${GRAY}apt search packagename${RESET}"
    echo ""
    echo -e "  ${CYAN}── TERMINAL ──────────────────────────────${RESET}"
    echo -e "  ${BLUE}[t1]${RESET}  Clear screen            ${GRAY}clear${RESET}"
    echo -e "  ${BLUE}[t2]${RESET}  Command history         ${GRAY}history${RESET}"
    echo -e "  ${BLUE}[t3]${RESET}  Show this menu again    ${GRAY}bash_greeting${RESET}"
    echo -e "  ${BLUE}[t4]${RESET}  Exit SSH session        ${GRAY}exit${RESET}"
    echo ""
    echo -e "${GRAY}  ══════════════════════════════════════════${RESET}"
    echo -e "  ${GREEN}  Tip: ${GRAY}Type any command above to run it!${RESET}"
    echo -e "${GRAY}  ══════════════════════════════════════════${RESET}"
    echo ""
}

bash_greeting
ENDBASHRC

echo -e "${GREEN}✔ Dashboard added to ~/.bashrc${RESET}"

# Also apply to SSH logins via /etc/profile.d if root
if [ "$EUID" -eq 0 ]; then
    cp ~/.bashrc /etc/profile.d/azmin_dashboard.sh 2>/dev/null
    echo -e "${GREEN}✔ Applied system-wide for all SSH users${RESET}"
fi

source ~/.bashrc
echo ""
echo -e "${GREEN}${BOLD}✔ Installation complete! Dashboard is now active.${RESET}"
echo -e "${GRAY}  To show menu again anytime, just type: ${CYAN}bash_greeting${RESET}"
echo ""
