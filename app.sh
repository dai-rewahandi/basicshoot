#!/bin/sh
clear

config_file=~/.config/bs/config.sh
WATCH_DIR="$HOME/Pictures/Screenshots"
FONT="$HOME/.config/bs/font.ttf"

function check_fonfig() { 
  if [ ! -f "$config_file" ]; then
    echo "config file not found!"
    exit 1
  fi
}

check_fonfig
source $config_file

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'

  echo -n "Loading $2"
  while ps -p $pid &>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "🌀\n"
}


inotifywait -e create --format '%f' "$WATCH_DIR" | while read NEWFILE ; do
  if [ -f "$WATCH_DIR/$NEWFILE" ]; then
    NEWNAME=$NEWFILE
    NEWFILE=$WATCH_DIR/$NEWFILE
    size=$( identify -format "%w %h" $NEWFILE )
    arr=($size)

    width=${arr[0]}
    height=${arr[1]}

    width_bg=$(( ${arr[0]} + 200 ))
    height_bg=$(( ${arr[1]} + 200 ))

    border_width=$((width + 4))
    border_height=$((height + 4))

    offset_x=$(( (width_bg - width)))
    offset_y=$(( (height_bg - height)))

    function Make_image_with_border_rounded() {

      magick -size ${width}x${height} xc:none \
        -fill white -draw "roundrectangle 0,0 $((width-1)),$((height-1)) $radius,$radius" \
        border_redius_mask.png
      magick $NEWFILE \( border_redius_mask.png -alpha set \) -compose DstIn -composite rounded_image.png
    }
    function Make_shadow() {

      magick rounded_image.png \
        \( +clone -background "rgb(0, 0, 0)" -shadow 60x7+3+3 \) \
        +swap -background none -layers merge +repage \
        tmp_shadow1.png
      magick tmp_shadow1.png \
        \( +clone -background "rgb(0, 0, 0)" -shadow 60x7-3+3 \) \
        +swap -background none -layers merge +repage \
        rounded_image_with_boder_shadowed.png
    }

    function Make_background() {

      magick \( xc:red xc:'rgb(170, 54, 206)' +append \) \
        \( xc:'rgb(187, 224, 122)' xc:'rgb(231, 83, 219)' +append \) -append \
        -size ${width_bg}x${height_bg} xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
        gradient_bg.jpg
    }

    function Join_image() {

      magick gradient_bg.jpg \
        \( rounded_image_with_boder_shadowed.png \) -gravity center -composite \
        output.png
    }

    function Add_text() {

      magick output.png \
        -font $FONT \
        -gravity north \
        -pointsize 15 \
        -fill "#ffffff" -stroke "#000000" -strokewidth 2 \
        -annotate +0+30 "Screenshot Keren!" \
        output_with_text.png
    }

    function Save_image() {

      new_dir=$WATCH_DIR/good
      if [ ! -d "$new_dir" ]; then
        mkdir $new_dir
      fi
      mv output_with_text.png $WATCH_DIR/good/$NEWNAME
    }

    function Remove_tmp() {
      if compgen -G "./"*.{jpg,png} > /dev/null; then
        rm ./*.{jpg,png}
      else
        exit 1
      fi
    }

    Make_image_with_border_rounded & spinner $! 'Rounded corners'
    Make_shadow & spinner $! 'Shadows'
    Make_background & spinner $! 'Background'
    Join_image & spinner $! 'Join'
    Add_text & spinner $! 'Text'
    Save_image & spinner $! 'Save'
    Remove_tmp & spinner $! 'Remove tmp'

    exit 1
  else
    echo "File is not an image!"
    exit 1
  fi
done

