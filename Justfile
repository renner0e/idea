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

last-commit-package:
    set -x
    just build "$(git diff-tree --no-commit-id --name-only -r HEAD~1 | cut -f1,2 -d/ | uniq)"

build $package="":
    #!/usr/bin/env bash
    set -xeuo pipefail
    find "${package}" -iname '*\.Containerfile*' -print0 | \
        while IFS= read -r -d '' test ; do \
            podman build -t "$(tr / - <<< "${package}"):latest" -f "$(basename "$test")" "$(dirname "$test")"
        done
