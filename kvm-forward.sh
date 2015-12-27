#!/bin/bash

while [ $# -gt 1 ]; do
  case $1 in
    -a|--address) ADDRESS="$2"; shift;;
    -hp|--host-port) HOST_PORT="$2"; shift;;
    -gp|--guest-port) GUEST_PORT="$2"; shift;;
    -t|--protocol) PROTOCOL="$2"; shift;;
  esac
  shift
done

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

echo -n "Forwarding ${PROTOCOL^^} host port $HOST_PORT to $ADDRESS:$GUEST_PORT. Correct? [Y/n] "
YESNO=""; read -e YESNO
case $YESNO in
  ""|[Yy])
    sudo iptables -t nat -A PREROUTING --protocol $PROTOCOL --dport $HOST_PORT -j DNAT --to-destination $ADDRESS:$GUEST_PORT
    sudo iptables -I FORWARD --protocol $PROTOCOL -m state --state NEW --destination $ADDRESS --dport $GUEST_PORT -j ACCEPT
  ;;
esac

if [ "$?" = "0" ]; then
  echo "Done!"
else
  echo "Error!"
fi
