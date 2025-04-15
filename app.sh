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
      echo "Adding rounded corners..."

      magick -size ${width}x${height} xc:none \
        -fill white -draw "roundrectangle 0,0 $((width-1)),$((height-1)) $radius,$radius" \
        border_redius_mask.png
      magick $NEWFILE \( border_redius_mask.png -alpha set \) -compose DstIn -composite rounded_image.png
    }
    function Make_shadow() {
      echo "Adding shadows..."

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
      echo "Making Btfl background..."

      magick \( xc:red xc:'rgb(170, 54, 206)' +append \) \
        \( xc:'rgb(187, 224, 122)' xc:'rgb(231, 83, 219)' +append \) -append \
        -size ${width_bg}x${height_bg} xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
        gradient_bg.jpg
    }

    function Join_image() {
      echo "Join image with background..."

      magick gradient_bg.jpg \
        \( rounded_image_with_boder_shadowed.png \) -gravity center -composite \
        output.png
    }

    function Add_text() {
      echo "Adding text..."

      magick output.png \
        -font $FONT \
        -gravity north \
        -pointsize 15 \
        -fill "#ffffff" -stroke "#000000" -strokewidth 2 \
        -annotate +0+30 "Screenshot Keren!" \
        output_with_text.png
    }

    function Save_image() {
      echo "Saving image..."

      new_dir=$WATCH_DIR/good
      if [ ! -d "$new_dir" ]; then
        mkdir $new_dir
      fi
      mv output_with_text.png $WATCH_DIR/good/$NEWNAME
    }
    Make_image_with_border_rounded
    Make_shadow
    Make_background
    Join_image
    Add_text
    Save_image

    exit 1
  else
    echo "File is not an image!"
    exit 1
  fi
done

