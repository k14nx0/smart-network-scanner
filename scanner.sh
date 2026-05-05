#!/bin/bash

target=$1

if [ -z "$target" ]; then
  echo "Usage: ./scanner.sh <target>"
  exit 1
fi

ports=(22 25 80 443)

green="\e[32m"
red="\e[31m"
reset="\e[0m"

open_count=0

echo "=================================="
echo "      SMART NETWORK SCANNER"
echo "=================================="
echo ""
echo "Target: $target"
echo ""

for port in "${ports[@]}"; do

  case $port in
    22) service="SSH" ;;
    25) service="SMTP" ;;
    80) service="HTTP" ;;
    443) service="HTTPS" ;;
    *) service="UNKNOWN" ;;
  esac

  timeout 1 bash -c "</dev/tcp/$target/$port" &>/dev/null

  if [ $? -eq 0 ]; then
    echo -e "${green}[OPEN]${reset}   Port $port ($service)"
    ((open_count++))
  else
    echo -e "${red}[CLOSED]${reset} Port $port ($service)"
  fi

done

echo ""
echo "================================"
echo "Scan Complete"
echo "Open Ports: $open_count"
echo "================================"
  
