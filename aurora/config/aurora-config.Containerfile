# Aurora-config
# logos


FROM docker.io/library/:latest AS builder

COPY usr/ /output/usr/
COPY etc/ /output/etc/

RUN sh <<'EOF'
set -xeuo pipefail
ln -s 
EOF

FROM scratch

COPY --from=builder /output /
