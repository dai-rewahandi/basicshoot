#!/bin/sh
clear

WATCH_DIR="$HOME/Pictures/Screenshots"
echo "Watching Screenshots: $WATCH_DIR"

inotifywait -e create --format '%f' "$WATCH_DIR" | while read NEWFILE ; do
  # check if file is an image
  if [ -f "$WATCH_DIR/$NEWFILE" ]; then
    echo "File is an image! Processing... $NEWFILE"
    NEWNAME=$NEWFILE
    NEWFILE=$WATCH_DIR/$NEWFILE

    # check if config file exists
    config_file=~/.config/bs/config.sh
    if [ ! -f "$config_file" ]; then
      echo "config file not found!"
      exit 1
    fi

    # check size of image
    size=$( identify -format "%w %h" $NEWFILE )
    arr=($size)
    width=${arr[0]} # width of image
    height=${arr[1]} # height of image

    # width and height of background ( width + 200, height + 200 )
    width_bg=$(( ${arr[0]} + 200 ))
    height_bg=$(( ${arr[1]} + 200 ))

    # rounded corners
    border_width=$((width + 4))
    border_height=$((height + 4))

    # offset for corners
    offset_x=$(( (width_bg - width)))
    offset_y=$(( (height_bg - height)))

    # define radius for rounded corners
    radius=20

    # make rounded corners
    magick -size ${width}x${height} xc:none \
      -fill white -draw "roundrectangle 0,0 $((width-1)),$((height-1)) $radius,$radius" \
      border_redius_mask.png

    # make border mask
    # magick -size ${border_width}x${border_height} xc:none \
    #   -fill "rgb(129, 129, 129)" -draw "roundrectangle 0,0 $((border_width-1)),$((border_height-1)) $radius,$radius" \
    #   border_mask.png

    # make rounded image
    magick $NEWFILE \( border_redius_mask.png -alpha set \) -compose DstIn -composite rounded_image.png

    # add border to rounded image
    # magick border_mask.png \
    #   rounded_image.png -geometry +2+2 -composite \
    #   rounded_image_with_boder.png

    # make shadow 1
    magick rounded_image.png \
      \( +clone -background "rgb(0, 0, 0)" -shadow 60x7+3+3 \) \
      +swap -background none -layers merge +repage \
      tmp_shadow1.png

    # make shadow 2
    magick tmp_shadow1.png \
      \( +clone -background "rgb(0, 0, 0)" -shadow 60x7-3+3 \) \
      +swap -background none -layers merge +repage \
      rounded_image_with_boder_shadowed.png

    # make background gradient
    magick \( xc:red xc:'rgb(170, 54, 206)' +append \) \
      \( xc:'rgb(187, 224, 122)' xc:'rgb(231, 83, 219)' +append \) -append \
      -size ${width_bg}x${height_bg} xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
      gradient_bg.jpg

    # make final image
    magick gradient_bg.jpg \
  \( rounded_image_with_boder_shadowed.png \) -gravity center -composite \
  output.png

  magick output.png \
  -font ~/.fonts/MyCoolFont.ttf \
  -gravity north \
  -pointsize 15 \
  -fill "#ffffff" -stroke "#000000" -strokewidth 2 \
  -annotate +0+30 "Screenshot Keren!" \
  output_with_text.png

    new_dir=$WATCH_DIR/good
    if [ ! -d "$new_dir" ]; then
      mkdir $new_dir
    fi
    mv output_with_text.png $WATCH_DIR/good/$NEWNAME

    # remove temp files
    rm  gradient_bg.jpg tmp_shadow1.png border_redius_mask.png rounded_image.png 

    exit 1
  else
    echo "File is not an image!"
    exit 1
  fi
done
