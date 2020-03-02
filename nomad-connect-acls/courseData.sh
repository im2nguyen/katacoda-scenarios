#!/bin/bash
date > /setupTime.txt

set -m
chmod +x /var/tmp/waitIntro.sh

logger() {
  command logger -f /var/log/courseData.sh.log "$1"
}

fix_journal() {
  # This fixes an issue with the katacoda base machine that causes journald to
  # fail on startup - H/T https://serverfault.com/a/800047
  if [ ! -f "/etc/machine-id" ]
  then
    logger "courseData.sh - Fixing Journal"
    systemd-machine-id-setup
    systemd-tmpfiles --create --prefix /var/log/journal
    systemctl start systemd-journald.service
  fi
}

install_cni_plugins() {
  if [ ! -d "/opt/cni/bin" ]
  then
    logger "courseData.sh - Installing CNI Plugins"
    curl -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.4/cni-plugins-linux-amd64-v0.8.4.tgz
    sudo mkdir -p /opt/cni/bin
    sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
    rm cni-plugins.tgz
    logger "courseData.sh - Installing CNI Plugins Complete"
  fi
}

create_config_link {
  NAME="$1"
  ln "/etc/${NAME}.d/config.hcl" "${NAME}_config.hcl"
}

install_service() {
  NAME="$1"
  if [ ! -f "/etc/${NAME}.d/config.hcl" ]
  then
    logger "courseData.sh - Installing ${NAME} service."
    mkdir -p "/etc/${NAME}.d" "/opt/${NAME}/data"
    cp "/var/tmp/${NAME}_config.hcl" "/etc/${NAME}.d/config.hcl"
    cp "/var/tmp/${NAME}.service" "/etc/systemd/system/${NAME}.service"
    systemctl daemon-reload
    systemctl start "${NAME}"
    create_config_link "${NAME}"
    logger "courseData.sh - Installing ${NAME} service complete."
  fi
}

install_zip() {
  NAME="$1"
  if [ ! -f "/usr/local/bin/${NAME}" ]
  then
    logger "courseData.sh - Installing ${NAME}"
    logger "courseData.sh -   Downloading ${2}"
    DOWNLOAD_URL="$2"
    curl -L -o "/tmp/${NAME}.zip" "${DOWNLOAD_URL}"
    logger "courseData.sh -   Unzipping /tmp/${NAME}.zip"
    sudo unzip -d /usr/local/bin/ "/tmp/${NAME}.zip"
    logger "courseData.sh -   Moving ${NAME} to /usr/local/bin"
    sudo chmod +x "/usr/local/bin/${NAME}"
    rm "/tmp/${NAME}.zip"
    logger "courseData.sh - Installing ${NAME} complete."
  fi
  install_service "${NAME}"
}

## main

fix_journal
install_cni_plugins

install_zip "consul" "https://releases.hashicorp.com/consul/1.7.0/consul_1.7.0_linux_amd64.zip" &
install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip" &


logger "courseData.sh - Installing pyhcl."
pip install pyhcl

ln /etc/consul.d/config.hcl consul_config.hcl
logger "courseData.sh - Done."

date >> /setupTime.txt
