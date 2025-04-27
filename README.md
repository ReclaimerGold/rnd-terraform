# 🧑‍💻 Reif.NET Home Lab
### A declarative home lab boilerplate using: 
#### 🌍 Terraforom | 🪨 Talos OS | ☸️ Kubernetes | ⬆️ Flux CD

![GitHub License](https://img.shields.io/github/license/reclaimergold/rnd-terraform)

## 🤷 Purpose

This repository manages the infrastructure and applications for the Reif.NET home lab using FluxCD and Terraform. It employs GitOps principles to ensure that the cluster configurations are defined declaratively and managed efficiently on top of my Proxmox Virtual Environment (PVE).

![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/reclaimergold/rnd-terraform) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-closed/reclaimergold/rnd-terraform)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/reclaimergold/rnd-terraform) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr-closed/reclaimergold/rnd-terraform)

## 🚀 Project Goals

The goal is to create a robust repository that allows the user to drop into any 'point' in the process, whether it be starting with Proxmox Virtual Environment (PVE) or starting with Talos, and being able to specify the scope of deployment. I'm trying to be as active as possible on this repository, as it is what manages most of my infrastructure.

![GitHub commit activity](https://img.shields.io/github/commit-activity/y/reclaimergold/rnd-terraform)

## 🤝 Contributions & Collaboration

Pull requests and issue reports are 100% welcome, if not ***aggressively*** encouraged. The only way we build better (l33t supa h4x0r) code, is by collaboration and constructive criticism. 

![GitHub contributors](https://img.shields.io/github/contributors-anon/reclaimergold/rnd-terraform)

## 🗄️ Repository Structure

> ⚠️ **WARNING:** This section is not yet up to date, and is for my personal use. I will be moving my FluxCD deployment to this repository soon, check back later for the updated full filesystem.

- **📂 flux-home/**: Contains FluxCD configurations for managing Kubernetes applications.
  - **📂 apps/**: Contains the application configurations for the Kubernetes cluster.
      - **📂 home-lab/**: Contains the folders specific to the 'home-lab' cluster.
      - **📂 staging/**: Contains the folders currently inactive for other clusters. Can be used for staged deployments on a separate cluster.
  - **📂 clusters/**: FluxCD cluster configurations for applying infrastructure and application state.
      - **📂 home-lab/**: Contains the folders specific to the 'home-lab' cluster.
      - **📂 staging/**: Contains the folders currently inactive for other clusters. Can be used for staged deployments on a separate cluster.
  - **📂 setup-scripts/**: Shell scripts to set up dependencies and prerequisites for Longhorn and other systems. These are not used by the bootstrapping process, and are only included for utilitarian purposes.
      - **📂 home-lab/**: Contains the folders specific to the 'home-lab' cluster.
      - **📂 staging/**: Contains the folders currently inactive for other clusters. Can be used for staged deployments on a separate cluster.

- **📂 terraform/**: Terraform configurations to manage the infrastructure.
  - **📂 home-lab/**: Contains the Terraform configurations specific to the 'home-lab' cluster.

## 💾 Install Prerequesites

**To ensure that you can run all of the commands, you will need to ensure that you have all of the necessary command-line tools installed.**

I utilize the following CLI tools to manage my datacenter. To be clear, ALL of these tools are REQUIRED for this repository. You will not have a good experience if you do not have these (at bare minimum) installed.

- **kubectl:** This is used to manage your Kubernetes cluster(s). If you're not familiar with this, it is highly suggested that you get familiar with Kubernetes and Kubectl before using this repository.

   - [To install this CLI tool, visit this link, and RTFM (Read The Manual).](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

- **talosctl:** This is used to manage your Talos operating systems, applying machine configurations, and accessing the dashboard components.  

   - [To install this CLI tool, visit this link, and RTFM (Read The Manual).](https://www.talos.dev/v1.9/talos-guides/install/talosctl/)

- **flux:** This is used to manage your Flux CI/CD configurations, from gathering statuses, to manually reconciling and applying configurations. 

   - [To install this CLI tool, visit this link, and RTFM (Read The Manual).](https://fluxcd.io/flux/installation/#install-the-flux-cli)

## 🥾 Bootstrap The Kubernetes Cluster

1. Copy the `terraform/home-lab/tfvars/example.tfvars.example` file to `terraform/home-lab/tfvars/prod.tfvars` (or `test.tfvars` depending on if you have a testing process). Be sure that you fill out all the settings in this file.

2. Navigate to the `terraform/home-lab/` directory, and execute the commands below. This command will deploy the datacenter based on the settings found in the 'prod.tfvars' file, or whichever file you specify in the commandline.

   >⚠️ **Note:** do not be alarmed if this takes a while. Depending on how many nodes you are deploying, it may take a bit.
   
   ```bash
   terraform apply -var-file=tfvars/prod.tfvars
   ```

3. Retreive the Kubeconfig and Talosconfig files by printing them to the command line using the commands below. 
   
   ```bash
   # Utlize this command if you wish to print the files to the command line for copy/pasting out of your console window. If you do not wish to expose raw credentials to your terminal, please skip this step, as it is only meant for easy visibility into your infrastructure.

   terraform output o_kubeconfig
   terraform output o_talosconfig
   ```

4. Export the 'Kubeconfig' and 'Talosconfig' files to your system environment for your convenience. **Note: This will overwrite whatever file is in the destination location. Please be careful when running these scripts.**

    ```bash
    # Outputs the 'kubeconfig' and 'talosconfig' files to the default configuration files utilized by the CLI tools. READ THIS FULL BLOCK BEFORE EXECUTING **ANY** COMMANDS BELOW.

    terraform output -raw o_kubeconfig > ~/.kube/config
    terraform output -raw o_talosconfig > ~/.talos/config

    # If you are connecting to multiple clusters THE ABOVE METHOD IS NOT RECOMMENDED AS IT WILL OVERWRITE YOUR  CONFIGURATION. 
    
    # Please instead use the commands below, and copy out the information you need for your multi-cluster configruation.

    terraform output -raw o_kubeconfig > ~/kubeconfig_export.yaml
    terraform output -raw o_talosconfig > ~/talosconfig_export.yaml
    ```

5. Retrieve a [Personal Access Token from Github](https://github.com/settings/personal-access-tokens). Ensure it has ALL privileges for the flux repository. Export the credentials to your environment. FluxCD will store this token as a secret in your Kubernetes cluster. **It is recommended to set a reasonable expiration for your token instead of setting it to indefinite expiration.**

   ```bash
   # Your Github Username should follow this
   #<YourGithubUsername>
   export GITHUB_USER=
   
   #<github_pat_...>
   export GITHUB_TOKEN=
   ```

   ---

   ♻️ **To rotate the bootstrap key be it a token or a deploy key:** ([Reference](https://github.com/fluxcd/flux2/discussions/2161))
   - Delete the auth secret from the cluster with:
   
   `kubectl -n flux-system delete secret flux-system`

   - Re-run flux bootstrap with the same args as before (Step 7 Below)

   ---

6. Run Prechecks to validate that the cluster is ready:

   ```bash
   # This step is optional, but highly recommeneded to ensure that your systems have the appropriate prerequesites for FluxCD.
   flux check --pre
   ```
   Precheck passes if you get the following message:

   `✔ prerequisites checks passed`

7. Bootstrap the Kubernetes configuration utilizing Flux by executing the following commands:

   ```bash
   # Note: You may need to adjust the './clusters/home-lab' path, or the 'main' branch depending on your own configuration, but if you are forking this repo for your own use, these default parameters should work just fine.

   flux bootstrap github \
   --owner=$GITHUB_USER \
   --repository=flux-home \
   --branch=main \
   --path=./clusters/home-lab \
   --personal
   ```

8. Have a cup of coffee or something. ☕ This will probably take a while. 

---

**A Quick Note for the Impatient Ones Out There**: My configuration takes about 30-35 minutes to fully bootstrap (3 Masters & 3 Workers), including Machine provisioning in PVE, Bootstrapping of the Talos cluster, and Bootstrapping of the FluxCD configuration on top of the cluster. Your configuration may vary, but unless you have some darn good hardware, this will take a while.

## 🚧 Development Roadmap Notes

This is the stuff that I want to add to this project. It may or may not get added - being listed below does not constitute a guarantee that the feature will be developed. Just doing what I can with the time I have.

> This will eventually be moved to the *Issues* tab of this project. Just haven't gotten to it yet.

### Planned

- ([@ReclaimerGold](https://github.com/reclaimergold)) High-Availability Control-Plane Proxy Installation (Via LXC or Docker) - `HAProxy` or `nginx` for control plane communications

- ([@ReclaimerGold](https://github.com/reclaimergold)) Adjustments to configuration for 'modularization' to allow for Talos deployment on environments other than PVE (Proxmox Virtual Environment), such as Xen or bare metal.

### Proposed

- ([@JacobBanghart](https://github.com/jacobbanghart)) Enable Talos & Kube configuration export 'merge' functionality to allow multi-cluster configurations instead of overwriting default config file entirely.

- ([@ReclaimerGold](https://github.com/reclaimergold)) Add script for prerequesite installation in one command
