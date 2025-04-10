# Reif.NET Datacenter - Terraform Plan

This repository is used to manage the static infrastructure in the Reif.NET Datacenter utilizing GitOps principles. 

## Utilizing

To run this project, go to the 'home-lab' folder, and run the command
`terraform apply -var-file <your-tfvars-file>`

## Current Components

At the moment, only the following components of our datacenter are included:

- Kubernetes Cluster

## Known Limitations

Below are a list of all known limitations for the providers utilized in this repository.

### Telmate/proxmox

[Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)

- Cannot create/manage Software Defined Networks (SDNs) within the PVE
- Cannot create/manage Storage Pool Configurations within the PVE