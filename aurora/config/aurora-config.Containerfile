# Aurora-config

FROM scratch

COPY usr/ /output/usr/
COPY etc/ /output/etc/

COPY --from=builder /output /
