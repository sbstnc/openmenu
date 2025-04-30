#!/bin/bash

set -e # Exit on error

# --- Configuration ---
IMAGE_URL="https://hub.docker.com/r/sbstnc/openmenu-dev"
IMAGE_VERSION="${1:?Error: Image version must be provided as the first argument. Usage: $0 <version>}"

# --- Dynamic Values ---
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VCS_REF="unknown"
VCS_URL="unknown"

SOURCE_DIR=".." # Relative path back to project root

if command -v git &> /dev/null; then
    # Check if inside a git repository
    if git -C "${SOURCE_DIR}" rev-parse --is-inside-work-tree &> /dev/null; then
        VCS_REF=$(git -C "${SOURCE_DIR}" rev-parse --short HEAD) || VCS_REF="unknown"
        VCS_URL=$(git -C "${SOURCE_DIR}" config --get remote.origin.url) || VCS_URL="unknown"
    else
        VCS_REF="unknown-not-repo"
        VCS_URL="unknown-not-repo"
    fi
else
    VCS_REF="unknown-no-git"
    VCS_URL="unknown-no-git"
fi

echo "--- Building Devcontainer ---"
echo "Timestamp: ${BUILD_DATE}"
echo "Image URL: ${IMAGE_URL}"
echo "Image Ver: ${IMAGE_VERSION}"
echo "VCS Ref:   ${VCS_REF}"
echo "VCS URL:   ${VCS_URL}"
echo "-----------------------------"

docker build \
    --platform linux/amd64 \
    --build-arg BUILD_DATE="${BUILD_DATE}" \
    --build-arg IMAGE_URL="${IMAGE_URL}" \
    --build-arg IMAGE_VERSION="${IMAGE_VERSION}" \
    --build-arg VCS_REF="${VCS_REF}" \
    --build-arg VCS_URL="${VCS_URL}" \
    -t "openmenu-dev:${IMAGE_VERSION}" \
    -t "openmenu-dev:latest" \
    . \
    --load

echo "Build complete."