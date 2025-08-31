# Aurora-logos

FROM docker.io/library/alpine:latest AS builder

RUN apk add --no-cache imagemagick rsvg-convert

COPY src/ /tmp/

RUN <<EOF
mkdir -p /output/usr/share/icons/hicolor/scalable/apps/
mkdir -p /output/usr/share/icons/hicolor/scalable/places/

mkdir -p /output/usr/share/pixmaps

cd /tmp
cp distributor-logo.svg distributor-logo-darkwhite-circle.svg distributor-logo-white.svg distributor-logo-white-circle.svg /output/usr/share/icons/hicolor/scalable/

magick -background none fedora-logo.svg -quality 90 -resize $((400-10*2))x100 -gravity center -extent 400x100 /output/usr/share/pixmaps/fedora-logo.png
magick -background none fedora-logo.svg -quality 90 -resize $((128-3*2))x32 -gravity center -extent 128x32 /output/usr/share/pixmaps/fedora-logo-small.png
magick -background none fedora-logo.svg -quality 90 -resize $((200-5*2))x50 -gravity center -extent 200x100 /output/usr/share/pixmaps/fedora_logo_med.png
magick -background none distributor-logo.svg -quality 90 -resize 256x256! /output/usr/share/pixmaps/system-logo.png

ln -s fedora-logo.svg /output/usr/share/pixmaps/fedora_whitelogo.svg
ln -s distributor-logo.svg /output/usr/share/pixmaps/fedora-logo-sprite.svg
ln -s distributor-logo.svg /output/usr/share/icons/hicolor/scalable/places/distributor-logo.svg
ln -s distributor-logo-white.svg /output/usr/share/icons/hicolor/scalable/places/distributor-logo-white.svg
ln -s distributor-logo-white.svg /output/usr/share/icons/hicolor/scalable/places/start-here.svg
ln -s distributor-logo-white.svg /output/usr/share/icons/hicolor/scalable/apps/start-here.svg
ln -s distributor-logo-white-circle.svg /output/usr/share/icons/hicolor/scalable/places/distributor-logo-white-circle.svg
ln -s distributor-logo-darkwhite-circle.svg /output/usr/share/icons/hicolor/scalable/places/distributor-logo-darkwhite-circle.svg

mkdir -p /output/usr/share/plymouth/themes/spinner

magick -background none fedora-logo.svg -quality 90 -resize $((128-3*2))x32 -gravity center -extent 128x32 /output/usr/share/plymouth/themes/spinner/watermark.png
magick -background none fedora-logo.svg -quality 90 -resize $((128-3*2))x32 -gravity center -extent 128x32 /output/usr/share/plymouth/themes/spinner/kinoite-watermark.png



cp fedora-logo.svg /output/usr/share/pixmaps/


EOF


FROM scratch

COPY --from=builder /output /
