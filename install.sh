sudo cp basicshoot /usr/local/bin
sudo chmod +x /usr/local/bin/basicshoot

if [ ! -f "$HOME/.config/bs/config" ]; then

    mkdir -p ~/.config/bs
    mkdir -p ~/.config/bs/.tmp
    echo 'RADIUS=15
WATCH_DIR="$HOME/Pictures/Screenshots"
TEXT="Bs"
TEXT_SIZE=20
TEXT_COLOR="rgb(255, 255, 255)"
TEXT_ICON="󰄀"'>> $HOME/.config/bs/config
    echo 'Installation is complete !!!'

elif [[ $1 = "-R" ]]; then

    sudo rm /usr/local/bin/basicshoot
    rm -r ~/.config/bs
    echo 'basicshoot is no longer installed'
fi
