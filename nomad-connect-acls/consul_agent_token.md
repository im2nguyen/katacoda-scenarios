
Run the `consul acl set-agent-token agent` command with your recently minted
Consul agent token. For the scenario, you can load it out of the file created
in the last step

```shell
export AGENT_TOKEN=$(awk '/SecretID/ {print $2}' consul-agent.token)
consul acl set-agent-token agent ${AGENT_TOKEN}
```{{execute}}

**Example**

```shell
$ export AGENT_TOKEN=$(awk '/SecretID/ {print $2}' consul-agent.token)
$ consul acl set-agent-token agent ${AGENT_TOKEN}
ACL token "agent" set successfully
```

