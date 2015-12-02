#!/bin/bash

while [ $# -gt 1 ]; do
  case $1 in
    -n|--name) CONTAINER_NAME="$2"; shift;;
  esac
  shift
done

if [ -z "$CONTAINER_NAME" ]; then
  echo "FATAL: missing container name. (specify with -n <name>)"; exit 1
fi

echo -e "Stopping container \"$CONTAINER_NAME\"..."
sudo lxc-stop -n $CONTAINER_NAME
echo -e "Destroying container \"$CONTAINER_NAME\"..."
sudo lxc-destroy -n $CONTAINER_NAME

if [ "$?" = "0" ]; then
  echo "Done!"
else
  echo "Error!"
fi
