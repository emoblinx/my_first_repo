#!/bin/bash

URL="http://www.multimedia.v6.navy"
prev=0
count=1

while sleep 1; do
  now=$(date +%s)
  if [ $prev -eq 0 ]; then
    interval=0
  else
    interval=$((now - prev))
  fi
  prev=$now

  code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

  if [[ "$code" =~ ^2[0-9]{2}$ || "$code" =~ ^3[0-9]{2}$ ]]; then
    if [ "$interval" -gt 3 ]; then
      printf "%4d %s %s - \033[31m%ds\033[0m \033[32m%s OK\033[0m\n" "$count" "$(date +%T)" "$URL" "$interval" "$code"
    else
      printf "%4d %s %s - %ds \033[32m%s OK\033[0m\n" "$count" "$(date +%T)" "$URL" "$interval" "$code"
    fi
  else
    if [ "$interval" -gt 3 ]; then
      printf "%4d %s %s - \033[31m%ds\033[0m \033[31m%s FAIL\033[0m\n" "$count" "$(date +%T)" "$URL" "$interval" "$code"
    else
      printf "%4d %s %s - %ds \033[31m%s FAIL\033[0m\n" "$count" "$(date +%T)" "$URL" "$interval" "$code"
    fi
  fi

  count=$((count + 1))
done
