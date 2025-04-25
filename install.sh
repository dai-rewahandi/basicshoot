chmod +x basicshoot
sudo mv basicshoot ../usr/bin

termux-setup-storage
apt update && apt upgrade
pkg install git -y
pkg install inotify-tools imagemagick fontconfig fontconfig-utils wget -y

mkdir -p ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip




if [ ! -f "$HOME/.config/bs/config" ]; then

    mkdir -p ~/.config/bs
    mkdir -p ~/.config/bs/.tmp
    echo 'RADIUS=15
WATCH_DIR="$HOME/storage/pictures/Screenshots"
TEXT="Dai Reawahandi"
TEXT_SIZE=20
TEXT_COLOR="rgb(255, 255, 255)"
TEXT_ICON="󰄀"'>> $HOME/.config/bs/config
fi