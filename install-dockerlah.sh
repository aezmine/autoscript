#!/bin/bash
set -e

# ============================================================
#   Auto-scripted by MinKacakZ — Use It Wisely
# ============================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ─────────────────────────────────────────────
#  Spinner
# ─────────────────────────────────────────────
spinner() {
    local pid=$1
    local msg="${2:-Working...}"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r${CYAN}  ${spin:$i:1}  ${WHITE}%s${RESET}" "$msg"
        sleep 0.1
    done
    printf "\r${GREEN}  ✔  ${WHITE}%s${RESET}\n" "$msg"
}

run_step() {
    local msg="$1"
    shift
    "$@" &>/tmp/docker_install_log &
    spinner $! "$msg"
}

# ─────────────────────────────────────────────
#  MAIN BANNER
# ─────────────────────────────────────────────
clear
echo ""
echo -e "${BLUE}${BOLD}"
cat << 'BANNER'
  ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗
  ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
  ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝
  ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
  ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║
  ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
BANNER
echo -e "${RESET}"

echo -e "${CYAN}${BOLD}"
cat << 'LOGO'
         .---.
        /     \        🐳  DOCKER INSTALLER
       | () () |            Ubuntu 24.04 LTS
        \  ^  /
         '---'    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     _____|_|_____
    /               \   Build. Ship. Run. Anywhere.
   /   🐋  🐋  🐋   \
  /___________________\
LOGO
echo -e "${RESET}"

echo -e "${MAGENTA}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}${BOLD}  ║       Auto-scripted by  M i n K a c a k Z        ║${RESET}"
echo -e "${MAGENTA}${BOLD}  ║                  ⚡ Use It Wisely ⚡               ║${RESET}"
echo -e "${MAGENTA}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

# ─────────────────────────────────────────────
#  System Info Box
# ─────────────────────────────────────────────
echo -e "${YELLOW}${BOLD}  ┌─────────────────────────────────────────────────┐${RESET}"
echo -e "${YELLOW}${BOLD}  │  📋  System Info                                 │${RESET}"
echo -e "${YELLOW}  │  👤  User   : $(whoami)$(printf '%*s' $((40 - ${#$(whoami)})) '')│${RESET}"
echo -e "${YELLOW}  │  🖥️   Host   : $(hostname)$(printf '%*s' $((40 - ${#$(hostname)})) '')│${RESET}"
echo -e "${YELLOW}  │  🐧  OS     : Ubuntu 24.04 LTS$(printf '%*s' 21 '')│${RESET}"
echo -e "${YELLOW}  │  📅  Date   : $(date '+%Y-%m-%d %H:%M:%S')$(printf '%*s' $((40 - 19)) '')│${RESET}"
echo -e "${YELLOW}${BOLD}  └─────────────────────────────────────────────────┘${RESET}"
echo ""

sleep 1

# ─────────────────────────────────────────────
#  STEP 1 — Remove old packages
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  🗑️   STEP 1 — Removing Conflicting Packages      ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

OLD_PKGS=(docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc)
for pkg in "${OLD_PKGS[@]}"; do
    sudo apt-get remove -y "$pkg" &>/dev/null || true
    echo -e "  ${DIM}${RED}✖  Removed (if existed): ${pkg}${RESET}"
done
echo ""

# ─────────────────────────────────────────────
#  STEP 2 — System Update
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  🔄  STEP 2 — Updating System                    ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

run_step "Running apt update..."  sudo apt update
run_step "Running apt upgrade..." sudo apt upgrade -y
echo ""

# ─────────────────────────────────────────────
#  STEP 3 — Dependencies
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  📦  STEP 3 — Installing Dependencies             ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

run_step "Installing ca-certificates, curl, gnupg..." \
    sudo apt install -y ca-certificates curl gnupg
echo ""

# ─────────────────────────────────────────────
#  STEP 4 — GPG Key & Repo
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  🔑  STEP 4 — Adding Docker GPG Key & Repo        ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

sudo install -m 0755 -d /etc/apt/keyrings

run_step "Fetching Docker GPG key..." \
    bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "  ${GREEN}✔  Docker repository added${RESET}"
echo ""

# ─────────────────────────────────────────────
#  STEP 5 — Install Docker
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  🐳  STEP 5 — Installing Docker Engine            ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

run_step "Updating package index with Docker repo..." sudo apt update

run_step "Installing Docker CE, CLI, plugins..." \
    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
echo ""

# ─────────────────────────────────────────────
#  STEP 6 — Enable & Start Docker
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  ⚙️   STEP 6 — Enabling & Starting Docker          ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

run_step "Enabling Docker service on boot..." sudo systemctl enable docker
run_step "Starting Docker service..."         sudo systemctl start docker
echo ""

# ─────────────────────────────────────────────
#  STEP 7 — User Group
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  👤  STEP 7 — Adding User to Docker Group         ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

sudo usermod -aG docker "$USER"
echo -e "  ${GREEN}✔  User '${USER}' added to docker group${RESET}"
echo ""

# ─────────────────────────────────────────────
#  STEP 8 — Verify
# ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║  🔍  STEP 8 — Verifying Installation              ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

DOCKER_VER=$(docker --version 2>/dev/null || echo "N/A")
COMPOSE_VER=$(docker compose version 2>/dev/null || echo "N/A")

echo -e "  ${GREEN}✔  ${WHITE}${DOCKER_VER}${RESET}"
echo -e "  ${GREEN}✔  ${WHITE}${COMPOSE_VER}${RESET}"
echo ""

echo -e "  ${YELLOW}🚀 Running hello-world test container...${RESET}"
echo ""
sudo docker run hello-world
echo ""

# ─────────────────────────────────────────────
#  SUCCESS BANNER
# ─────────────────────────────────────────────
echo -e "${GREEN}${BOLD}"
cat << 'SUCCESS'
  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗██╗
  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝██║
  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗██║
  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║╚═╝
  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║██╗
  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝╚═╝
SUCCESS
echo -e "${RESET}"

echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}  ║   🐳  Docker is installed and running!  🐳        ║${RESET}"
echo -e "${GREEN}${BOLD}  ╠══════════════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}  ║                                                  ║${RESET}"
echo -e "${GREEN}  ║   ${YELLOW}⚠️  ACTION REQUIRED:${GREEN}                              ║${RESET}"
echo -e "${GREEN}  ║   Log out and log back in (or run:               ║${RESET}"
echo -e "${GREEN}  ║   ${WHITE}newgrp docker${GREEN}) for group changes to apply.    ║${RESET}"
echo -e "${GREEN}  ║                                                  ║${RESET}"
echo -e "${GREEN}${BOLD}  ╠══════════════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}  ║  ${CYAN}⚡ Auto-scripted by MinKacakZ — Use It Wisely ⚡${GREEN}  ║${RESET}"
echo -e "${GREEN}${BOLD}  ╚══════════════════════════════════════════════════╝${RESET}"
echo ""

echo -e "${DIM}  Full install log: /tmp/docker_install_log${RESET}"
echo ""
