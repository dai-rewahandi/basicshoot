#!/bin/sh
clear

size=$( identify -format "%w %h" img.png )
arr=($size)

width=${arr[0]}
height=${arr[1]}
width_bg=$(( ${arr[0]} + 200 ))
height_bg=$(( ${arr[1]} + 200 ))

radius=25




magick -size ${width}x${height} xc:none \
    -fill white -draw "roundrectangle 0,0 $((width-1)),$((height-1)) $radius,$radius" \
    mask.png

magick img.png mask.png -alpha set -compose DstIn -composite rounded.png
rm mask.png


magick rounded.png \
  \( +clone -background "rgb(0, 0, 0)" -shadow 50x10+0+4 \) \
  +swap -background none -layers merge +repage \
  tmp_shadow1.png

# 3. Bayangan kedua: (0, 2px), blur 4px, opacity 10% (layer tambahan)
magick tmp_shadow1.png \
  \( +clone -background "rgb(0, 0, 0)" -shadow 50x10+0+2 \) \
  +swap -background none -layers merge +repage \
  rounded_shadow.png

rm tmp_shadow1.png


magick \( xc:red xc:'rgb(170, 54, 206)' +append \) \
          \( xc:'rgb(187, 224, 122)' xc:'rgb(231, 83, 219)' +append \) -append \
          -size ${width_bg}x${height_bg} xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
          output_bg.jpg


magick output_bg.jpg \
  \( rounded_shadow.png \) -geometry +100+100 -composite \
  output.png

rm rounded_shadow.png
rm output_bg.jpg
rm rounded.png
#!/bin/sh
clear

size=$( identify -format "%w %h" img.png )
arr=($size)

width=${arr[0]}
height=${arr[1]}

width_bg=$(( ${arr[0]} + 200 ))
height_bg=$(( ${arr[1]} + 200 ))

radius=25




magick -size ${width}x${height} xc:none \
    -fill white -draw "roundrectangle 0,0 $((width-1)),$((height-1)) $radius,$radius" \
    mask.png

magick img.png mask.png -alpha set -compose DstIn -composite rounded.png
rm mask.png


magick rounded.png \
  \( +clone -background "rgb(0, 0, 0)" -shadow 50x10+0+4 \) \
  +swap -background none -layers merge +repage \
  tmp_shadow1.png

# 3. Bayangan kedua: (0, 2px), blur 4px, opacity 10% (layer tambahan)
magick tmp_shadow1.png \
  \( +clone -background "rgb(0, 0, 0)" -shadow 50x10+0+2 \) \
  +swap -background none -layers merge +repage \
  rounded_shadow.png

rm tmp_shadow1.png


magick \( xc:red xc:'rgb(170, 54, 206)' +append \) \
          \( xc:'rgb(187, 224, 122)' xc:'rgb(231, 83, 219)' +append \) -append \
          -size ${width_bg}x${height_bg} xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
          output_bg.jpg


offset_x=$(( (width_bg - width) / 4 ))
offset_y=$(( (height_bg - height) / 4 ))

magick output_bg.jpg \
  \( rounded_shadow.png \) -geometry +${offset_x}+${offset_y} -composite \
  output.png

echo $offset_x
echo $offset_y

rm rounded_shadow.png
rm output_bg.jpg
rm rounded.png
