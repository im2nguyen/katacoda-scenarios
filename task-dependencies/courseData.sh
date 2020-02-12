fix_journal() {
  if [ ! -f "/etc/machine-id"]
  then
    systemd-machine-id-setup
    systemd-tmpfiles --create --prefix /var/log/journal
    systemctl start systemd-journald.service
  fi
}

install_zip() {
  NAME="$1"
  if [ ! -f "/usr/local/bin/$NAME" ]
  then
    DOWNLOAD_URL="$2"
    curl -L -o /tmp/$NAME.zip $DOWNLOAD_URL
    sudo unzip -d /usr/local/bin/ /tmp/$NAME.zip
    sudo chmod +x /usr/local/bin/$NAME
    rm /tmp/$NAME.zip
  fi
}

create_nomad_service() {

  if [ ! -f /etc/nomad.d/config.hcl ]
  then
    cat > /etc/nomad.d/config.hcl <<EOF
  data_dir  = "/opt/nomad/data"
  log_level = "DEBUG"

  client {
    enabled = true
  }

  plugin "raw_exec" {
    config {
      enabled = true
    }
  }

  server {
    enabled          = true
    bootstrap_expect = 1
  }
EOF

  fi

  if [ ! -f /etc/systemd/system/nomad.service ]
  then
    cat > /etc/systemd/system/nomad.service <<EOF
  [Unit]
  Description=Nomad
  Documentation=https://nomadproject.io/docs/
  Wants=network-online.target
  After=network-online.target
  StartLimitBurst=3
  StartLimitIntervalSec=10

  # When using Nomad with Consul it is not necessary to start Consul first. These
  # lines start Consul before Nomad as an optimization to avoid Nomad logging
  # that Consul is unavailable at startup.
  # Wants=consul.service
  # After=consul.service

  [Service]
  ExecReload=/bin/kill -HUP $MAINPID
  ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
  KillMode=process
  KillSignal=SIGINT
  LimitNOFILE=65536
  LimitNPROC=infinity
  Restart=on-failure
  RestartSec=2
  TasksMax=infinity
  OOMScoreAdjust=-1000

  [Install]
  WantedBy=multi-user.target
EOF

  fi

  systemctl daemon-reload
  systemctl enable nomad
  systemctl start nomad
  ln -s /etc/nomad.d

}

create_nomad_service() {

  if [ ! -f /etc/consul.d/config.hcl ]
  then
    cat > /etc/consul.d/config.hcl <<EOF
bind_addr        = "{{GetInterfaceIP \"ens3\"}}"
bootstrap_expect = 1
client_addr      = "0.0.0.0"
data_dir         = "/opt/consul/data"
datacenter       = "dc1"
log_level        = "DEBUG"
server           = true
ui               = true

connect {
  enabled = true
}

ports {
  grpc = 8502
}
EOF

  fi

  if [ ! -f /etc/systemd/system/consul.service ]
  then
    cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul
Documentation=https://consul.io/docs/
Wants=network-online.target
After=network-online.target
StartLimitBurst=3
StartLimitIntervalSec=10

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/consul agent -config-dir /etc/consul.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF

  fi

  systemctl daemon-reload
#  systemctl enable consul
#  systemctl start consul
#  ln -s /etc/consul.d

}



fix_journal

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.4-rc1/nomad_0.10.4-rc1_linux_amd64.zip"
install_zip "consul" "https://releases.hashicorp.com/consul/1.7.0/consul_1.7.0_linux_amd64.zip"

mkdir -p /etc/nomad.d /etc/consul.d
mkdir -p /opt/nomad/data /opt/consul/data

create_nomad_service
create_consul_service






