#!/usr/bin/env bash

# 1. Obtener directamente los IDs de todos los Sinks de audio mediante JSON
SINKS=($(pw-dump | jq -r '.[] | select(.type=="PipeWire:Interface:Node" and .info.props["media.class"]=="Audio/Sink") | .id'))

# 2. Obtener de forma directa el ID del Sink actual
CURRENT=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oP 'id \K\d+')

# 3. Calcular el siguiente ID en el ciclo
NEXT=""
for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[$i]}" == "$CURRENT" ]]; then
        NEXT="${SINKS[$(( (i + 1) % ${#SINKS[@]} ))]}"
        break
    fi
done

# Fallback si por alguna razón no detectó el activo
NEXT="${NEXT:-${SINKS[0]}}"

# 4. Cambiar dispositivo y notificar
if [[ -n "$NEXT" ]]; then
    wpctl set-default "$NEXT"
fi
