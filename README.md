# ipfuck

Ultimate IP reconnaissance tool with integrated scanning capabilities.

## Installation

```bash
curl -sSL https://raw.githubusercontent.com/CyberMyLife/IpFuck/main/install.sh | bash
```

## Usage

```bash
ipfuck <ip|domain|url> [-1|-2|-3]
```

### Examples

```bash
ipfuck 8.8.8.8 -1
ipfuck example.com -2
ipfuck https://target.com -3
```

## Features

- **Level -1**: Quick scan
- **Level -2**: Medium scan with HTTP enumeration
- **Level -3**: Aggressive scan with service probes

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

- nmap, whois, bind-tools, curl, python3

## License

MIT
