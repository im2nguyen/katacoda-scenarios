#!/bin/bash

if [ ! -f ~/nomad_config.hcl ]
then
  echo -n "Waiting for additional setup tasks to complete.."
  while [ ! -f ~/nomad_config.hcl ]
  do
    echo -n "."
    sleep 3
  done
fi
echo ""
echo "Complete!  Move on to the next step."
