The ACL system is designed to be intuitive, high-performance, and to provide
administrative insight. At the highest level, there are four major components to
the ACL system: tokens, policies, and capabilities.

![Image showing that ACL Tokens refer to one or more associated policies and
that those policies encapsulate capabilities like "Allow Submit Job" or "Allow
Query Nodes"](https://deploy-preview-1072--hashicorp-learn.netlify.com/static/img/nomad/acls/acl.jpg)

This scenario will explore each of these objects as well as provide example
configurations that you can use to practice enabling and configuring ACL
enforcement in your own Nomad cluster. Next, you will learn how to bootstrap the
ACL system in a Nomad cluster