# Home Lab Boilerplate Deployment

Currently utilized for Reif.NET home lab datacenter usage. Encourage for others who want to deploy Kubernetes, as well as a myriad of other tools in a home lab.

License: 

![GitHub License](https://img.shields.io/github/license/reclaimergold/rnd-terraform)

This repository manages the infrastructure and applications for the Reif.NET home lab using FluxCD and Terraform. It employs GitOps principles to ensure that the cluster configurations are defined declaratively and managed efficiently on top of my Proxmox Virtual Environment (PVE).

![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/reclaimergold/rnd-terraform) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-closed/reclaimergold/rnd-terraform)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/reclaimergold/rnd-terraform) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr-closed/reclaimergold/rnd-terraform)

The goal is to create a robust repository that allows the user to drop into any 'point' in the process, whether it be starting with Proxmox Virtual Environment (PVE) or starting with Talos, and being able to specify the scope of deployment. I'm trying to be as active as possible on this repository, as it is what manages most of my infrastructure.

![GitHub commit activity](https://img.shields.io/github/commit-activity/y/reclaimergold/rnd-terraform)

Pull requests and issue reports are 100% welcome, if not aggressively encouraged. The only way we build better (l33t) code, is by collaboration. 

![GitHub contributors](https://img.shields.io/github/contributors-anon/reclaimergold/rnd-terraform)

## Overview

The home lab consists of various self-hosted applications, utilities, and services to support media streaming, automation, AI model management, and more. Each application is configured to run on a Kubernetes cluster managed with Talos and FluxCD.

## Repository Structure

> This section is not yet up to date, and is for my personal use. I will be moving my FluxCD deployment to this repository soon, check back later for the updated full filesystem.

- **flux-home/**: Contains FluxCD configurations for managing Kubernetes applications.
  - **apps/**: Application deployments configurations for my k8s cluster.
  - **clusters/**: FluxCD cluster configurations for applying infrastructure and application state.
  - **setup-scripts/**: Shell scripts to set up dependencies and prerequisites for Longhorn and other systems.

- **terraform/**: Terraform configurations to manage the infrastructure, including VMs on Proxmox and network configurations.
  - **home-lab/**: Specific configurations and terraform state for the home lab setup.

## Install CLI Prerequesites

To ensure that you can run all of the commands, you will need to ensure that you have all of the necessary command-line tools installed.

I utilize the following CLI tools to manage my datacenter:
- kubectl ([Install Instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/))
- talosctl ([Install Instructions](https://www.talos.dev/v1.9/talos-guides/install/talosctl/))
- flux ([Install Instructions](https://fluxcd.io/flux/installation/#install-the-flux-cli))

## Bootstrap The Datacenter

1. Copy the `terraform/home-lab/tfvars/example.tfvars.example` file to `terraform/home-lab/tfvars/prod.tfvars` (or `test.tfvars` depending on if you have a testing process). Be sure that you fill out all the settings in this file.
2. Navigate to the `terraform/home-lab/` directory, and execute the commands below. This command will deploy the datacenter based on the settings found in the 'prod.tfvars' file, or whichever file you specify in the commandline.

   > Note, do not be alarmed if this takes a while. Depending on how many nodes you are deploying, it may take a bit.
   ```bash
   terraform apply -var-file=tfvars/prod.tfvars
   ```
3. Retreive the Kubeconfig and Talosconfig files by printing them to the command line using the commands below. 
   ```bash
   terraform output o_kubeconfig
   terraform output o_talosconfig
   ```
4. Export the 'Kubeconfig' and 'Talosconfig' files to your system environment for your convenience. **Note: This will overwrite whatever file is in the destination location. Please be careful when running these scripts.**
    ```bash
    # Output Kubeconfig
    terraform output -raw o_kubeconfig > ~/.kube/config

    # Output Talosconfig
    terraform output -raw o_talosconfig > ~/.talos/config
    ```
5. Retrieve a [Personal Access Token from Github](https://github.com/settings/personal-access-tokens). Ensure it has ALL privileges for the flux repository. Export the credentials to your environment.
   ```bash
   export GITHUB_TOKEN=
   export GITHUB_USER=
   ```
6. Run Prechecks to validate that the cluster is ready:
   ```bash
   flux check --pre
   ```
   Precheck passes if you get the following message `✔ prerequisites checks passed
7. Bootstrap the Kubernetes configuration utilizing Flux by executing the following commands (obviously filling in the appropriate values):
   ```bash
   flux bootstrap github \
   --owner=$GITHUB_USER \
   --repository=flux-home \
   --branch=main \
   --path=./clusters/home-lab \
   --personal
   ```
8. Have a cup of coffee or something, idk. ☕ This will probably take a while.

## Contributing
Contributions to improve this home lab setup are welcome. Please fork the project, create a feature branch, and submit a pull request.
