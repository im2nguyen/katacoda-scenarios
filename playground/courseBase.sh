install_zip()
{
    NAME="$1"
    DOWNLOAD_URL="$2"

    curl -L -o ~/$NAME.zip $DOWNLOAD_URL
    sudo unzip -d /usr/local/bin/ ~/$NAME.zip
    sudo chmod +x /usr/local/bin/$NAME
    rm ~/$NAME.zip
}

install_zip "consul" "https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip"
install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.3/nomad_0.10.3_linux_amd64.zip"
install_zip "vault" "https://releases.hashicorp.com/vault/1.3.2/vault_1.3.2_linux_amd64.zip"
install_zip "consul-template" "https://releases.hashicorp.com/consul-template/0.24.0/consul-template_0.24.0_linux_amd64.zip"
install_zip "envconsul" "https://releases.hashicorp.com/envconsul/0.9.2/envconsul_0.9.2_linux_amd64.zip"

mkdir -p /etc/nomad.d /etc/consul.d /etc/vault.d
mkdir -p /opt/nomad/data /opt/consul/data /opt/vault/data

echo "Creating Nomad configuration file..."
  cat > config/logging.hcl <<EOF
log_level = "DEBUG"
EOF

  cat > config/acl.hcl <<EOF
acl {
  enabled    = true
  token_ttl  = "30s"
  policy_ttl = "60s"
}
EOF

  cat > config/node.hcl <<EOF
server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF

mkdir -p ~/log
# nohup sh -c "consul agent -dev >~/log/consul.log 2>&1" > ~/log/nohup.log &
# nohup sh -c "nomad agent -dev -bind=0.0.0.0 >~/log/nomad.log 2>&1" > ~/log/nohup.log &
