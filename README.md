# CachyOS Gaming/Desktop Setup Script

A simple setup script for fresh CachyOS installations.

## Features

* Installs yay automatically
* Installs common gaming applications
* Installs desktop applications
* Configures Kvantum
* Installs MacTahoe KDE theme
* Creates useful terminal aliases
* Updates the system automatically

### Installed Applications

* Steam
* Heroic Games Launcher
* ProtonUp-Qt
* Discord
* Spotify
* Mission Center
* Zen Browser
* Parsec
* Git
* Kvantum
* Tk

## Requirements

* Fresh CachyOS installation
* Internet connection
* Sudo privileges

## Run Without Git

Download and execute directly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/cachyos-setup.sh)
```

Or with wget:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/cachyos-setup.sh)
```

## What the Script Does

1. Installs yay if missing
2. Installs selected applications
3. Creates terminal aliases
4. Installs and configures MacTahoe KDE
5. Configures Kvantum
6. Updates the system
7. Offers reboot

## Disclaimer

Review the script before executing it:

```bash
curl -fsSL https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/cachyos-setup.sh
```

Run scripts from the internet only if you trust the source.



## Ideas for future

- Menu selection for each step
- Packages by category
- Theme selector (colors)
- Icon set for theme also being installed
- Adapt Desktop layout if possible??
- Presetup few configs (example; Vencord plugins, default browser)
