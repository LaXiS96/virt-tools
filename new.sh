#!/bin/bash

while [ $# > 1 ]; do
  case $1 in
    -n|--name) CONTAINER_NAME="$2"; shift;;
    -a|--address) CONTAINER_ADDRESS="$2"; shift;;
  esac
  shift
done
