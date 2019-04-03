while true; do
    WALLPAPER="$(ls -d ~/Pictures/wallpapers/* | shuf -n 1)"
    nitrogen --set-zoom-fill $WALLPAPER
    sleep 5m
done
