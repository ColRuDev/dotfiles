#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Runtime env (mise/nix/asdf) — only if the file exists
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
