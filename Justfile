export repo_organization := env("GITHUB_REPOSITORY_OWNER", "ublue-os")
export default_tag := env("DEFAULT_TAG", "latest")

[private]
default:
  @just --list

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/env bash
    echo "Checking syntax: Justfile"
    just --unstable --fmt -f Justfile || { exit 1; }


build $target_image=image_name $tag=default_tag:
    #!/usr/bin/env bash

    # Get Version
    ver="${tag}.$(date +%Y%m%d)"

    containerfile_path="${target_dir}/Containerfile"

    if [[ ! -f "$containerfile_path" ]]; then
        echo "Error: No Containerfile found in '$target_dir'"
        exit 1
    fi

    BUILD_ARGS=()
    BUILD_ARGS+=("--build-arg" "IMAGE_NAME=${image_name}")
    BUILD_ARGS+=("--build-arg" "IMAGE_VENDOR=${repo_organization}")
    if [[ -z "$(git status -s)" ]]; then
        BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")
    fi


    podman build \
        "${BUILD_ARGS[@]}" \
        --pull=newer \
        --tag "${target_image}:${tag}" \
        .


