


mkdir -p /etc/consul.d /var/log/consul /opt/consul/data

# Create Service Definition
cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description=HashiCorp Nomad
Requires=network-online.target
After=network-online.target

[Service]
LimitAS=infinity
LimitRSS=infinity
LimitCORE=infinity
LimitNOFILE=infinity
User=root
EnvironmentFile=-/etc/sysconfig/consul
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -server $OPTIONS -config-file=/etc/consul.d/consul.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
StandardOutput=journal

[Install]
WantedBy=multi-user.target
EOF

# Create Consul Configuration
cat << EOF > /etc/consul.d/consul.hcl
bootstrap_expect = 1
advertise_addr = "{{GetInterfaceIP \"ens3\"}}"
client_addr = "0.0.0.0"
data_dir = "/opt/consul/data"
datacenter = "dc1"
enable_debug = true
log_file = "/var/log/consul/consul"
log_level = "DEBUG"
server = true
connect {
  enabled = true
}
ui = true
EOF

systemctl enable consul
systemctl start consul

# Need Nomad 0.10.2 for logging to file
wget https://releases.hashicorp.com/nomad/0.10.2/nomad_0.10.2_linux_amd64.zip
unzip nomad_0.10.2_linux_amd64.zip
mv nomad /usr/local/bin/nomad
rm nomad_0.10.2_linux_amd64.zip

# Create all the necessary directories
mkdir -p /etc/nomad.d /var/log/nomad /opt/nomad/data

# Create Service Definition
cat << EOF > /etc/systemd/system/nomad.service
[Unit]
Description=HashiCorp Nomad
Requires=network-online.target
After=network-online.target

[Service]
LimitAS=infinity
LimitRSS=infinity
LimitCORE=infinity
LimitNOFILE=infinity
User=root
EnvironmentFile=-/etc/sysconfig/nomad
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/nomad agent -server $OPTIONS -config=/etc/nomad.d/nomad.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
StandardOutput=journal

[Install]
WantedBy=multi-user.target
EOF

# Create Nomad Configuration
cat << EOF > /etc/nomad.d/nomad.hcl
data_dir = "/opt/nomad/data"
datacenter = "dc1"
enable_debug = true
log_file = "/var/log/nomad/nomad"
log_level = "DEBUG"

client {
  enabled = true
}

plugin "raw_exec" {
  enabled = true
}

server {
  encrypt          = "rn5HmQP/a1o2hvNxMfMYag=="
  enabled          = true
  bootstrap_expect = 1
  raft_protocol    = 3
}
EOF

systemctl enable nomad
systemctl start nomad
nomad version
