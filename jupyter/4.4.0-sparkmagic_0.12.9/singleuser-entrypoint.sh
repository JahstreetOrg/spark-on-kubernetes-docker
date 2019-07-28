#!/bin/bash

set -ex

if [ -n "$LIVY_ENDPOINT" ]; then
    sed -i "s|http://localhost:8998|$LIVY_ENDPOINT|g" /home/$NB_USER/.sparkmagic/config.json
fi

exec jupyterhub-singleuser "$@"
