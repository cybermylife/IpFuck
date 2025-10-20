# ipfuck

Ultimate IP reconnaissance tool with integrated scanning capabilities.

## Features

- **Level -1**: Quick and efficient scan
- **Level -2**: Medium scan with HTTP enumeration
- **Level -3**: Aggressive scan with service probes

## Installation

One-liner installation:

```bash
curl -sSL https://raw.githubusercontent.com/TONUSER/ipfuck/main/install.sh | bash
```

## Usage

```bash
ipfuck <ip|domain|url> [-1|-2|-3]
```

### Examples

```bash
# Quick scan
ipfuck 8.8.8.8 -1

# Medium scan  
ipfuck example.com -2

# Aggressive scan
ipfuck https://target.com -3
```

## What it does

- Ping test
- Whois lookup
- Reverse DNS
- Geolocation (ipinfo.io, ipapi.co)
- Port scanning (nmap)
- Service detection
- HTTP enumeration
- SSL/TLS analysis
- Service probes (SMB, SSH, FTP, SMTP)
- Traceroute

## Dependencies

**Required:**
- nmap, whois, bind-tools, curl, python3

**Optional (for enhanced scanning):**
- mtr, dig, openssl

## License

MIT
