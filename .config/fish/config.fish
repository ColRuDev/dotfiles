source /usr/share/cachyos-fish-config/cachyos-config.fish

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

# Update abbr
abbr -a up sudo pacman -Syu
abbr -a fup flatpak update
abbr -a pup paru -Sua
abbr -a autoremove sudo pacman -Rns $(pacman -Qtdq)

# AI tools
abbr -a oc tmux new-session \"command opencode\"
abbr -a gai gentle-ai

# Editors
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
