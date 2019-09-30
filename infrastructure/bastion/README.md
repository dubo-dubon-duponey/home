# Digital Ocean droplet

This creates a droplet with a static ip and a firewall.

It also tighten-up security (ssh, unattended upgrades), and installs docker.

## Tl;DR

Ensure you have an ssh-agent up and running.

```
ssh-agent -s
```

Load the ssh private key you want to use with the new Droplet.

```
ssh-add ~/.ssh/id_ed25519
# Confirm
ssh-add -l
```

Create a terraform variable file (`host-vars.tfvars`):

```
token="Your digital ocean token"
public_key="/Users/dmp/.ssh/public_key.pub"
droplet_name="droplet-hostname.example.com"
```

Run terraform:

```
terraform apply -auto-approve -var-file="host-vars.tfvars" .
```
