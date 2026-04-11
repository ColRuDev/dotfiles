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

# AI tools
abbr -a oc tmux new-session -A -s opencode_session \"command opencode\"
abbr -a gai gentle-ai
