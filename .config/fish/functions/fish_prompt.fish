function fish_prompt
    set -l last_status $status

    # ── Línea del directorio (estilo pure, azul negrita) ──
    set_color blue --bold
    printf '%s' (prompt_pwd)
    set_color normal

    # Rama git, si estamos en un repo
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git branch --show-current 2>/dev/null)
        if test -n "$branch"
            set_color brblack
            printf ' %s' $branch
            set_color normal
        end
    end

    echo

    # ── Símbolo: magenta en éxito, rojo si el comando anterior falló ──
    if test $last_status -eq 0
        set_color magenta
    else
        set_color red
    end
    printf '❯'
    set_color normal

    echo -n ' '
end
