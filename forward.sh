#!/bin/bash

while [ $# -gt 1 ]; do
  case $1 in
    -i|--interface) INTERFACE="$2"; shift;;
    -a|--address) CONTAINER_ADDRESS="$2"; shift;;
    -hp|--host-port) HOST_PORT="$2"; shift;;
    -gp|--guest-port) GUEST_PORT="$2"; shift;;
    -t|--protocol) PROTOCOL="$2"; shift;;
  esac
  shift
done

if [ -z "$INTERFACE" ]; then
  echo "FATAL: missing interface. (specify with -i <interface>)"; exit 1
fi

if [ -z "$ADDRESS" ]; then
  echo "FATAL: missing guest IP address. (specify with -a <address>)"; exit 1
fi

if [ -z "$HOST_PORT" ]; then
  echo "FATAL: missing host port. (specify with -hp <port>)"; exit 1
fi

if [ -z "$GUEST_PORT" ]; then
  echo "FATAL: missing guest port. (specify with -gp <port>)"; exit 1
fi

if [ -z "$PROTOCOL" ]; then
  echo "FATAL: missing protocol. (specify with -t <protocol>)"; exit 1
fi

echo -n "Forwarding ${PROTOCOL^^} host port $HOST_PORT to $ADDRESS:$GUEST_PORT on interface $INTERFACE. Correct? [Y/n] "
YESNO=""; read -e YESNO
case $YESNO in
  ""|[Yy])
    sudo iptables -t nat -A PREROUTING -i $INTERFACE -p $PROTOCOL --dport $HOST_PORT -j DNAT --to $ADDRESS:$GUEST_PORT
  ;;
esac

if [ "$?" = "0" ]; then
  echo "Done!"
else
  echo "Error!"
fi
