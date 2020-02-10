The APIs needed to manage policies and tokens are not enabled until ACLs are
enabled. To begin, you need to enable the ACLs on the servers.

### Enable ACL subsystem in configuration

Enable the ACL subsystem requires a change to the Nomad configuration.

<pre class="file" data-target="clipboard">
acl {
  enabled = true
}
</pre>

The ACL stanza should be located at the top-level of the configuration.
Copy and paste this ACL stanza above the `client` stanza in the config.hcl file.
The environment will automatically save the file for you.

### Restart the nomad service

Now that you have modified the configuration, you will need to restart the Nomad
process to read the configuration changes.

Run the `systemctl restart nomad`{{execute}} command to restart Nomad now.
