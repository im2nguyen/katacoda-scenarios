#!/bin/bash

if [ ! -f ~/nomad.config.hcl ]
then
  echo -n "Waiting for additional setup tasks to complete.."
  while [ ! -f ~/nomad.config.hcl ]
  do
    echo -n "."
    sleep 2
  done
fi
echo ""
