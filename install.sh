#!/bin/bash
set -e

VERSION="2.1"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="ipfuck"

print_banner() {
    echo "  ██╗██████╗ ███████╗██╗   ██╗██╗  ██╗"
    echo "  ██║██╔══██╗██╔════╝██║   ██║██║ ██╔╝"
    echo "  ██║██████╔╝█████╗  ██║   ██║█████╔╝ "
    echo "  ██║██╔═══╝ ██╔══╝  ██║   ██║██╔═██╗ "
    echo "  ██║██║     ██║     ╚██████╔╝██║  ██╗"
    echo "  ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝"
    echo "Ultimate IP Reconnaissance Tool v${VERSION}"
    echo
}

check_dependencies() {
    echo "[*] Checking dependencies..."
    
    local missing_deps=()
    
    for tool in nmap whois curl python3; do
        if ! command -v "$tool" &>/dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "[!] Missing dependencies: ${missing_deps[*]}"
        echo "[*] Installing dependencies..."
        
        if command -v pacman &>/dev/null; then
            sudo pacman -S --needed nmap whois bind-tools curl python3
        elif command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y nmap whois dnsutils curl python3
        elif command -v yum &>/dev/null; then
            sudo yum install -y nmap whois bind-utils curl python3
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y nmap whois bind-utils curl python3
        elif command -v zypper &>/dev/null; then
            sudo zypper install -y nmap whois bind-utils curl python3
        else
            echo "[!] Unsupported package manager. Please install manually:"
            echo "nmap whois bind-tools curl python3"
            exit 1
        fi
    fi
    
    echo "[+] Dependencies OK"
}

download_and_install() {
    echo "[*] Downloading ipfuck..."
    
    local temp_script=$(mktemp)
    
    if ! curl -sSL "https://raw.githubusercontent.com/CyberMyLife/IpFuck/main/ipfuck" -o "$temp_script"; then
        echo "[!] Failed to download ipfuck script"
        exit 1
    fi
    
    chmod +x "$temp_script"
    
    echo "[*] Installing ipfuck to ${INSTALL_DIR}..."
    
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp "$temp_script" "${INSTALL_DIR}/${SCRIPT_NAME}"
    sudo chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
    
    rm -f "$temp_script"
    
    echo "[+] ipfuck installed successfully!"
}

verify_installation() {
    echo "[*] Verifying installation..."
    
    if command -v "$SCRIPT_NAME" &>/dev/null; then
        echo "[+] ipfuck is now available in your PATH"
        echo "Usage: ipfuck <ip|domain|url> [-1|-2|-3]"
        echo "Example: ipfuck 8.8.8.8 -3"
    else
        echo "[!] Installation failed - ipfuck not found in PATH"
        exit 1
    fi
}

main() {
    print_banner
    
    if [ "$EUID" -eq 0 ]; then
        echo "[!] Don't run this script as root"
        exit 1
    fi
    
    if ! command -v curl &>/dev/null; then
        echo "[!] curl is required but not installed"
        exit 1
    fi
    
    check_dependencies
    download_and_install
    verify_installation
    
    echo "[+] Installation complete!"
}

main "$@"
