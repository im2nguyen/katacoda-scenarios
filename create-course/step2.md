<style type="text/css">
.alert {
    position: relative;
    padding: .75rem 1.25rem;
    margin-bottom: 1rem;
    border: 1px solid transparent;
    border-radius: .25rem;
}

.alert-danger {
    color: #721c24;
    background-color: #f8d7da;
    border-color: #f5c6cb;

</style>

Once the ACL system is enabled, you need to generate the initial token. This
first management token is used to bootstrap the system. Care should be taken not
to lose all of your management tokens. If you do, you will need to re-bootstrap
the ACL subsystem.

<div class="alert alert-danger">
**Warning**: Bootstrapping the ACL subsystem will interrupt access to your cluster.
<br />
Once the nomad acl bootstrap command is run, Nomad's default-deny policy will
become enabled. You should have an acceptable anonymous policy prepared and
ready to submit immediately after bootstrapping.
</div>

