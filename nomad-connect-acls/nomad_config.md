Open the nomad.d/config.hcl file and add an consul stanza with your token.

```hcl
consul {
  token = "«your nomad agent token»"
}
```

You can run this command to do some magic and inject your Nomad agent token
you created in the previous step.

```bash
cat <<EOF >> ~/nomad.config.hcl

consul {
  token = "$(awk '/SecretID/ {print $2}' nomad-agent.token)"
}
EOF
```{{execute}}

Run the `systemctl restart nomad`{{execute}} command to restart Nomad to load
these changes.