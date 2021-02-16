#!/bin/bash
# Micropython Docker Entrypoint init script.
# Installs dependencies only on first run to speed up future builds.
# 
# Requires ENV variables:
#   $MPY_BRANCH: Git branch of Micropython to checkout
#   $MPY_PORT_ARCH: Micropython architecture targeted for building
set -e

if [ -z "$SKIP_INIT" ]; then
  if [ ! -f "/init-date" ]; then
    echo "No init-date file detected, preparing binaries..."

    pushd /esp-open-sdk
    CT_EXPERIMENTAL=y \
      CT_ALLOW_BUILD_AS_ROOT=y \
      CT_ALLOW_BUILD_AS_ROOT_SURE=y \
      make STANDALONE=y
    popd

    pushd /micropython
    git checkout $MPY_BRANCH
    git submodule update --init
    popd

    pushd /micropython/mpy-cross
    make STANDALONE=y
    popd

    date > /init-date
  fi
else
  echo "SKIP_INIT set, ignoring initialization."
fi

echo "Initialization complete."
#ls -al "/micropython/ports/$MPY_PORT_ARCH/build/"

exec "$@"