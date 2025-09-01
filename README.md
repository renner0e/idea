
# This is an experiment!!11

# TODO
- Figure out a cool name for the repo
- Github Actions
- Only rebuild containers that got changed by a PR
- Cosign
- Renovate
- Documentation

```
just build aurora
```
builds all of aurora stuff


```
just build aurora/config
```
only builds config


# Example Usage

```Containerfile
FROM ghcr.io/ublue-os/kinoite-main:latest

COPY --from=localhost/aurora-wallpapers:latest /usr /usr

COPY --from=localhost/aurora-logos:latest /usr /usr

COPY --from=localhost/aurora-config:latest /usr /usr
COPY --from=localhost/aurora-config:latest /etc /etc
```
