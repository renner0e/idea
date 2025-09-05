
[private]
default:
  @just --list

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/env bash
    echo "Checking syntax: Justfile"
    just --unstable --fmt -f Justfile || { exit 1; }

last-commit-package:
    #!/usr/bin/env bash
    set -xeuo pipefail
    #TODO: If the justfile or github workflows was changed build everything
    just build "$(git diff-tree --no-commit-id --name-only -r HEAD~1 | cut -f1,2 -d/ | uniq | grep -v Justfile)"

gen-builds-tags:
    #!/usr/bin/env bash
    set -xeuo pipefail
    SHA_SHORT="$(git rev-parse --short HEAD)"
    DATE="$(date +%Y%m%d)"

    echo "latest"
    echo "${SHA_SHORT}"
    echo "${DATE}"

build $package="" ghcr="0":
    #!/usr/bin/env bash
    #set -xeuo pipefail

    echo "Building package: ${package}"

    mapfile -t TAGS < <(just gen-builds-tags)
    
    for containerfile in $(find "${package}" -iname '*\.Containerfile*'); do
      # Get the name of the container by stripping the file extension
      image_name="$(basename "${containerfile}" | sed 's/\.Containerfile//')"

      echo "Building image: ${image_name}"

      # Build the dynamic `--tag` arguments string.
      tag_args=""
      for tag in "${TAGS[@]}"; do
        tag_args+="--tag ${image_name}:${tag} "
      done

      podman build \
        --file "${containerfile}" \
        --format oci \
        ${tag_args} \
        "$(dirname "${containerfile}")"
    done


