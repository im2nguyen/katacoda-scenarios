<!--
You need to create a policy for the Nomad Server Agents.

First, load the management token out of your bootstrap file - `export CONSUL_HTTP_TOKEN=$(awk '/SecretID/ {print $2}' consul.bootstrap)`{{execute}}

Verify that your token is working by running `consul members`{{execute}}. If everything
is working correctly, you should see output similar this.

```shell
$ consul members
Node    Address           Status  Type    Build  Protocol  DC   Segment
host01  172.17.0.25:8301  alive   server  1.7.0  2         dc1  <all>
```
-->
Now to create the Nomad agent policy file, run `touch nomad-server-policy.hcl`{{execute}}
to create a blank file. Open `nomad-server-policy.hcl`{{open}} in the editor and
add this content.

<pre class="file" data-filename="nomad-server-policy.hcl" data-target="replace">
agent_prefix "" {
  policy = "write"
}

node_prefix "" {
  policy = "write"
}

service_prefix "" {
  policy = "write"
}

acl = "write"
</pre>

Create the Nomad server policy by uploading this file.

```shell
consul acl policy create \
  -name "nomad-server-token" \
  -description "Nomad Server Token Policy" \
  -rules @nomad-server-policy.hcl
```{{execute}}

**Example**

```shell
$ consul acl policy create -name "nomad-server-token" -description "Nomad Server Token Policy" -rules @nomad-server-policy.hcl
ID:           aec3686a-e475-060e-5a39-263a5c0f298b
Name:         nomad-server-token
Description:  Nomad Server Token Policy
Datacenters:
Rules:
agent_prefix "" {
  policy = "write"
}
node_prefix "" {
  policy = "write"
}
service_prefix "" {
  policy = "write"
}
acl = "write"
```

Generate a token associated with this policy and save it to a file named nomad-agent.token.

```shell
consul acl token create \
  -description "Nomad Demo Agent Token" \
  -policy-name "nomad-server-token" | tee nomad-agent.token
```{{execute}}

```shell
$ consul acl token create -description "Nomad Demo Agent Token" -policy-name "nomad-server-token" | tee nomad-agent.token
AccessorID:       a073f54a-b51a-59ae-a014-6e95564885ea
SecretID:         427d2bb2-9c43-5d54-39ce-d6115c5c10d9
Description:      Nomad Demo Agent Token
Local:            false
Create Time:      2020-02-12 22:30:42.402962642 +0000 UTC
Policies:
   fed881c2-a9c1-b89d-3941-056fca77eb17 - nomad-server-token
```

<!---
Use the `touch nomad-client-policy.hcl`{{execute}} to create another blank
policy file. Open it in the editor and add this content.

<pre class="file" data-filename="nomad-client-policy.hcl" data-target="replace">
agent_prefix "" {
  policy = "read"
}

service_prefix "" {
  policy = "write"
}
</pre>


Notice that the policy includes write access to the services API. Nomad clients
need this access when starting a Consul-enabled task.  Nomad servers require

Create the Nomad server policy by uploading this file using the `consul acl policy create -name "nomad-server-token" -description "Nomad Server Token Policy" -rules @nomad-server-policy.hcl`{{execute}} command.

```shell
$ consul acl policy create -name "nomad-server-token" -description "Nomad Server Token Policy" -rules @nomad-server-policy.hcl
ID:           aec3686a-e475-060e-5a39-263a5c0f298b
Name:         nomad-server-token
Description:  Nomad Server Token Policy
Datacenters:
Rules:
node_prefix "" {
   policy = "write"
}
service_prefix "" {
   policy = "read"
}
```

Create the Nomad client policy by uploading this file using the `consul acl policy create -name "nomad-client-token" -description "Nomad Client Token Policy" -rules @nomad-client-policy.hcl`{{execute}} command.

```shell
$ consul acl policy create -name "nomad-client-token" -description "Nomad Client Token Policy" -rules @nomad-client-policy.hcl
ID:           04a88c9a-bf4e-783d-a54e-844be7beb2ea
Name:         nomad-client-token
Description:  Nomad Client Token Policy
Datacenters:
Rules:
agent_prefix "" {
  policy = "read"
}

service_prefix "" {
  policy = "write"
}
```

Generate a token associated with this policy and save it to a file named nomad-agent.token by running `consul acl token create -description "Nomad Demo Agent Token" -policy-name "nomad-server-token" -policy-name "nomad-client-token" | tee nomad-agent.token`{{execute}}

```
$ consul acl token create -description "Nomad Demo Agent Token" -policy-name "nomad-server-token" -policy-name "nomad-client-token" | tee nomad-agent.token
AccessorID:       a073f54a-b51a-59ae-a014-6e95564885ea
SecretID:         427d2bb2-9c43-5d54-39ce-d6115c5c10d9
Description:      Nomad Demo Agent Token
Local:            false
Create Time:      2020-02-12 22:30:42.402962642 +0000 UTC
Policies:
   fed881c2-a9c1-b89d-3941-056fca77eb17 - nomad-server-token
   04a88c9a-bf4e-783d-a54e-844be7beb2ea - nomad-client-token
```
-->

In the next step, we will configure Nomad to use this token.
