# Aurora-wallpapers

FROM docker.io/library/alpine:latest AS builder

COPY usr /output/usr

RUN sh <<'EOF'
set -xeuo pipefail
mkdir -p /output/usr/share/backgrounds/aurora/
mkdir -p /output/usr/share/wallpapers/
cd /output/usr/share/backgrounds
for dir in ../backgrounds/aurora/*; do
  ln -s "${dir}" ../wallpapers/
done
EOF

FROM scratch

COPY --from=builder /output/usr /usr
