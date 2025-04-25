# basicshoot

A little polish your screenshoot.

![basicshoot](demo.png)

!![basicshoot](demo2.png)

## Installation
```bash
sudo pacman -S inotify-tools

git clone https://github.com/dai-rewahandi/basicshoot.git

cd basicshoot

sh install.sh
```

## Usage
```bash 
basicshoot
```

## Configuration
```bash
vim ~/.config/bs/config
```

```bash
RADIUS=15 # in pixel
WATCH_DIR="$HOME/Pictures/Screenshots" # directory to watch for new screenshot
TEXT="Dai Reawahandi" # text to add to screenshot
TEXT_SIZE=20 # in pixel
TEXT_COLOR="rgb(255, 255, 255)" # text color
TEXT_ICON="󰄀"' # icon
```