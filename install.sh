#!/bin/bash
# ipfuck installer - Simple PATH installation
# Usage: curl -sSL https://raw.githubusercontent.com/TONUSER/ipfuck/main/install.sh | bash

set -e

VERSION="2.0"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="ipfuck"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_banner() {
    echo -e "${RED}"
    echo "  ██╗██████╗ ███████╗██╗   ██╗██╗  ██╗"
    echo "  ██║██╔══██╗██╔════╝██║   ██║██║ ██╔╝"
    echo "  ██║██████╔╝█████╗  ██║   ██║█████╔╝ "
    echo "  ██║██╔═══╝ ██╔══╝  ██║   ██║██╔═██╗ "
    echo "  ██║██║     ██║     ╚██████╔╝██║  ██╗"
    echo "  ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${BLUE}Ultimate IP Reconnaissance Tool v${VERSION}${NC}"
    echo
}

check_dependencies() {
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    local missing_deps=()
    
    # Check required tools
    for tool in nmap whois curl python3; do
        if ! command -v "$tool" &>/dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}[!] Missing dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}[*] Installing dependencies...${NC}"
        
        # Detect package manager and install
        if command -v pacman &>/dev/null; then
            # Arch Linux
            sudo pacman -S --needed nmap whois bind-tools curl python3
        elif command -v apt &>/dev/null; then
            # Debian/Ubuntu
            sudo apt update && sudo apt install -y nmap whois dnsutils curl python3
        elif command -v yum &>/dev/null; then
            # RHEL/CentOS
            sudo yum install -y nmap whois bind-utils curl python3
        elif command -v dnf &>/dev/null; then
            # Fedora
            sudo dnf install -y nmap whois bind-utils curl python3
        elif command -v zypper &>/dev/null; then
            # openSUSE
            sudo zypper install -y nmap whois bind-utils curl python3
        else
            echo -e "${RED}[!] Unsupported package manager. Please install manually:${NC}"
            echo "nmap whois bind-tools curl python3"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}[+] Dependencies OK${NC}"
}

download_and_install() {
    echo -e "${YELLOW}[*] Downloading ipfuck...${NC}"
    
    # Create temp file
    local temp_script=$(mktemp)
    
    # Download script
    if ! curl -sSL "https://raw.githubusercontent.com/TONUSER/ipfuck/main/ipfuck" -o "$temp_script"; then
        echo -e "${RED}[!] Failed to download ipfuck script${NC}"
        exit 1
    fi
    
    # Make executable
    chmod +x "$temp_script"
    
    echo -e "${YELLOW}[*] Installing ipfuck to ${INSTALL_DIR}...${NC}"
    
    # Create install directory if it doesn't exist
    sudo mkdir -p "$INSTALL_DIR"
    
    # Copy script
    sudo cp "$temp_script" "${INSTALL_DIR}/${SCRIPT_NAME}"
    sudo chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
    
    # Cleanup
    rm -f "$temp_script"
    
    echo -e "${GREEN}[+] ipfuck installed successfully!${NC}"
}

verify_installation() {
    echo -e "${YELLOW}[*] Verifying installation...${NC}"
    
    if command -v "$SCRIPT_NAME" &>/dev/null; then
        echo -e "${GREEN}[+] ipfuck is now available in your PATH${NC}"
        echo -e "${BLUE}Usage: ipfuck <ip|domain|url> [-1|-2|-3]${NC}"
        echo -e "${BLUE}Example: ipfuck 8.8.8.8 -3${NC}"
    else
        echo -e "${RED}[!] Installation failed - ipfuck not found in PATH${NC}"
        exit 1
    fi
}

main() {
    print_banner
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}[!] Don't run this script as root${NC}"
        exit 1
    fi
    
    # Check if curl is available
    if ! command -v curl &>/dev/null; then
        echo -e "${RED}[!] curl is required but not installed${NC}"
        exit 1
    fi
    
    check_dependencies
    download_and_install
    verify_installation
    
    echo -e "${GREEN}[+] Installation complete!${NC}"
}

main "$@"
