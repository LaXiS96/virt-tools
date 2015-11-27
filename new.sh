#!/bin/bash

while [ $# -gt 1 ]; do
  case $1 in
    -n|--name) CONTAINER_NAME="$2"; shift;;
    -a|--address) CONTAINER_ADDRESS="$2"; shift;;
  esac
  shift
done

if [ -z "$CONTAINER_NAME" ]; then
  echo "FATAL: missing container name. (specify with -n <name>)"; exit 1
fi
if [ -z "$CONTAINER_ADDRESS" ]; then
  echo "FATAL: missing container address. (specify with -a <#.#.#.#>)"; exit 1
fi

HOST_ADDRESS="$(wget -q -O- https://api.ipify.org/)"
if [ -z "$HOST_ADDRESS" ]; then
  echo "ERROR: could not retrieve host's external IP address."
  echo -n "Please enter the host's external IP address: "; read -e HOST_ADDRESS
fi
