# So both have export
export PATH=/home/shark/.opencode/bin:$PATH

# Status display theming
BOLD='\e[1m'
DIM='\e[2m'
RESET='\e[0m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
MAGENTA='\e[35m'

header() {
    for ((i=0; i < width - ${#title} - 4; i++)); do printf '─'; done
    printf "┐${RESET}\n"
}

footer() {
    local i
    printf "${CYAN}"
    for ((i=0; i<50; i++)); do printf '─'; done
    printf "┘${RESET}\n"
}

battery_status() {
    local pct full now color
    pct=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null) || { echo "  No battery found"; return; }
    full=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null)
    now=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null)

    if   (( pct <= 20 )); then color="$RED"
    elif (( pct <= 60 )); then color="$YELLOW"
    else                      color="$GREEN"
    fi

    printf "  Level:    ${BOLD}${color}%s%%${RESET}\n" "$pct"
    [ -n "$full" ] && [ -n "$now" ] && printf "  Energy:   ${DIM}%s / %s Wh${RESET}\n" "$now" "$full"
}

tunnel_status() {
    local output
    output=$(ip -br a show 2>/dev/null | while IFS= read -r line; do
        case "$line" in
            *mullvad*|*wg*|*tun*|*us*|*nl*)
                local iface="${line%% *}" rest="${line#* }"
                printf "  ${BOLD}${MAGENTA}%-10s${RESET} %s\n" "$iface" "$rest"
                ;;
        esac
    done)
    if [ -z "$output" ]; then
        echo "  No tunnel interfaces found"
    else
        printf '%s\n' "$output"
    fi
}

show_status() {
    echo
    header "TUNNEL STATUS"
    tunnel_status
    footer
    echo
    header "BATTERY STATUS"
    battery_status
    footer
}

# aliases (minus my SSH aliases for different servers)
alias batt="cat /sys/class/power_supply/BAT0/capacity"
alias bat="batcat"

# diff configs for DE or TTY
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    [ -f ~/.bashrc_de ] && . ~/.bashrc_de
else
    [ -f ~/.bashrc_tty ] && . ~/.bashrc_tty
fi

