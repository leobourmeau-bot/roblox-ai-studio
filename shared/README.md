# Shared contracts

This directory contains hand-authored Luau values and types that are stable across plugin modules.
It is mapped into the plugin model by Rojo as the `Shared` folder.

Shared code must remain independent of concrete UI instances and backend implementation details.
Any future wire contract belongs here only after both sides have an explicit versioning strategy.
