source /usr/share/cachyos-zsh-config/cachyos-config.zsh
# Flatpak PATH fix
if [ -d "/var/lib/flatpak/exports/share" ]; then
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi
if [ -d "$HOME/.local/share/flatpak/exports/share" ]; then
    export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
fi

. "$HOME/.local/bin/env"
