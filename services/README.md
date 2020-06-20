# Core services

This module is meant to provide the bare minimum to have a working LAN.

Right now, that's DNS services:
 * laptop localhost resolver (TLS forwarding to bastion)
 * three LAN nodes resolvers (idem)

These are not meant to be used by containers, but by other hosts on the network.

## Caveats

Since these nodes rely on their very own DNS containers to provide resolution...
This will fail if there is no local coredns image available and both containers are down.
