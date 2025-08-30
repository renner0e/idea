# Aurora-wallpapers

# We need gnu coreutils because ln -r is not a thing on busybox
# and it's a pain otherwise, KDE wants those symlinks

FROM docker.io/library/ubuntu:24.04 AS builder

COPY usr /output/usr

# We symlink all the directories for compatibility/convenience
RUN bash <<'EOF'
set -xeuo pipefail
shopt -s nullglob
mkdir -p /output/usr/share/{wallpapers,backgrounds}/aurora/
for dir in /output/usr/share/backgrounds/aurora/*; do
  ln -sr "${dir}" /output/usr/share/wallpapers/
done
EOF

FROM scratch

COPY --from=builder /output/usr /usr

#FROM scratch
#
#COPY usr/ /usr
