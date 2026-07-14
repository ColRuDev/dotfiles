# CachyOS Fish config — optional, only on CachyOS/Arch
test -f /usr/share/cachyos-fish-config/cachyos-config.fish && source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# YADM abbreviations
abbr -a ya yadm add
abbr -a ys yadm status
abbr -a yp yadm push
abbr -a yc --set-cursor "yadm commit -m \"%\""

# Package Management abbreviationse
if which pacman >/dev/null 2>&1
    abbr -a up sudo pacman -Syu
    abbr -a autoremove 'sudo pacman -Rns $(pacman -Qtdq)'
    abbr -a pup paru -Sua
else if which dnf >/dev/null 2>&1
    abbr -a up sudo dnf upgrade
    abbr -a autoremove sudo dnf autoremove
else if which pikman >/dev/null 2>&1
    abbr -a up 'pikman update; and pikman upgrade'
    abbr -a autoremove sudo
else if which apt >/dev/null 2>&1
    abbr -a up 'sudo apt update; and sudo apt upgrade -y'
    abbr -a autoremove sudo apt autoremove

end

abbr -a fup flatpak update

# AI tools abbreviations
abbr -a oc tmux new-session \"command opencode\"
abbr -a gai gentle-ai

# Editors abbreviations
abbr -a z zeditor
abbr -a v nvim

# pnpm
set -gx PNPM_HOME "/home/nickescolr/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# npm
set -gx PATH $HOME/.local/bin $PATH
# pnpm end
