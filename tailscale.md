# Tailscale Setup

## Overview

Tailscale is a zero-config VPN built on Wireguard. This document covers the setup and configuration for this system.

## Current Setup

**Version:** 1.94.1
**Service:** `tailscaled` (daemon) — enabled for auto-start on system boot
**Systray:** managed via `tailscale configure systray` — runs when logged in

## Installation & Configuration

### Daemon (`tailscaled`)

1. **Install Tailscale:**
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   ```

2. **Authenticate:**
   ```bash
   sudo tailscale up
   ```
   This opens a browser to log in with your GitHub account.

3. **Auto-start:** `tailscaled` is enabled automatically by the package.
   Check status:
   ```bash
   systemctl status tailscaled
   ```

### Systray (`tailscale-systray`)

The systray provides a GUI status indicator and quick-access menu in the system tray.

**Setup:**

1. **Grant operator rights** (required to manage Tailscale from CLI/GUI):
   ```bash
   sudo tailscale set --operator=$USER
   ```

### Systray

The systray provides a GUI status indicator and quick-access menu in the system tray.

**Setup:**

1. **Grant operator rights** (required to manage Tailscale from CLI/GUI):
   ```bash
   sudo tailscale set --operator=$USER
   ```

2. **Configure systray with auto-start:**
   ```bash
   tailscale configure systray --enable-startup=systemd
   ```
   This uses Tailscale's built-in configuration to set up the systray with systemd auto-start.

3. **Verify:**

### Get Your Tailscale IP
```bash
tailscale ip -4
tailscale ip -6
```

### Ping a Peer
```bash
tailscale ping <hostname>
tailscale ping pi5-n8n
```

### SSH to a Peer
```bash
ssh user@pi5-n8n.tail04dcb4.ts.net
```

### Subnet Routing (Access Local Networks)

To reach devices on the local network (e.g., NAS, TV) via a peer acting as a gateway:

1. **On the gateway device (pi5-n8n):**
   ```bash
   sudo tailscale set --advertise-routes=192.168.1.0/24
   ```

2. **In Tailscale admin console:** Approve the advertised routes.

3. **From any Tailscale device:**
   ```bash
   ping 192.168.1.100  # Example local IP
   ```

## Permissions & Troubleshooting

### "No permission to manage Tailscale"

If you get this error, grant operator rights:
```bash
sudo tailscale set --operator=$USER
```

### Service not auto-starting

**System service:**
```bash
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
```

**User service (systray):**
```bash
systemctl --user enable tailscale-systray
systemctl --user start tailscale-systray
```

### Check Logs

**System service:**
```bash
sudo journalctl -u tailscaled -n 50 --follow
```

**User service:**
```bash
journalctl --user -u tailscale-systray -n 50 --follow
```

## Links

- **Tailscale:** https://tailscale.com/
- **Documentation:** https://tailscale.com/kb/
- **Admin Console:** https://login.tailscale.com/
