In Nomad 0.10.4 we introduce task dependency declaration. This feature allows
job developers to declare what point in the lifetime an allocation that a task
should be run in.

Using the lifecycle stanza, you can express that a task should be run in the
"prestart" phase. Future versions of Nomad will express more of the lifecycle
phases, such as "poststart", "prestop", "prekill", "exited"

