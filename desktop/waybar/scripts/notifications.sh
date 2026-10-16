#!/bin/sh
# Waybar "custom/notifications" module (return-type: json).
# Counts active mako notifications and degrades gracefully when mako is absent.

count=0
if command -v makoctl >/dev/null 2>&1; then
    count=$(makoctl list 2>/dev/null | grep -c '"id"')
fi
case "$count" in ''|*[!0-9]*) count=0 ;; esac

if [ "$count" -gt 0 ]; then
    text=$(printf '\357\203\263 %s' "$count")
    tooltip="$count notification(s)"
    class=unread
else
    text=$(printf '\357\203\263')
    tooltip="No notifications"
    class=empty
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$class"
