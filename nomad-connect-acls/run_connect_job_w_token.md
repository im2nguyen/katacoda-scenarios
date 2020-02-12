Unset the Consul token in your shell session.

`unset CONSUL_HTTP_TOKEN`

Now, try running countdash.nomad again. This time, you will receive an error.

`nomad run countdash.nomad`{{execute}}

**Example**

```shell
$ nomad run countdash.nomad
Error submitting job: Unexpected response code: 500 (operator token denied: missing consul token)
```

Nomad will not allow you to submit a job to the cluster without providing a
Consul token that has write access to the Consul service that the job defines.

You can supply the token in a few ways:

- the CONSUL_HTTP_TOKEN environment variable
- the `-consul-token` flag on the command line
- the `-X-Consul-Token` header on API calls