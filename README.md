# Description

The goal of this repository is to provide some quick and easy options for setting an a Workstation/Dev environment with all of the tooling required for performing Tanzu Operations and Engineering work.

The content of this repository is not a supported product, rather an opinionated template for setting up a Workstation/Dev environment that Tanzu operators and engineers can use to build out their own environment. Feel free to modify with your own packages/dotfile/configs/etc and if you feel anything is generically reusable then please don't hesitate to make a pull request back to this repo. 

Currently the repository provides the following options:

1. Setup tooling on any Ubuntu based distro
1. Setup a local Ubuntu based Vagrant box with tooling

# Setup Tooling on any Ubuntu based distro

## Dependencies

1. Ensure Ansible is installed, see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
2. Ensure python jmespath is installed
```bash
$ sudo apt update
$ sudo apt install python3-jmespath # Ubuntu 20.04
$ sudo apt install python-jmespath # Ubuntu 18.04
```
3. Ensure git is installed
```bash
$ sudo apt update
$ sudo apt install git
```

## Getting Started

1. Clone this repo onto the server
1. Run Ansible locally ensuring you update the `pivnet_api_token` var otherwise the playbook will not be able to connect to Pivnet:
```bash
$ sudo ansible-playbook --extra-vars "user=$(whoami) pivnet_api_token=<insert your pivnet token> ansible_python_interpreter=/usr/bin/python3" --connection=local --inventory 127.0.0.1, ./ansible-playbook/local.yml
```

## Specifying cli versions

By default the playbook will install cli's based on the settings defined under `./ansible-playbook/roles/tanzu/defaults`, if you want to override these settings (such as the version or the install location) you can do this by adding an override into the `./ansible-playbook/vars.yml`, for example you could add the following into `./ansible-playbook/vars.yml` to install version 0.11.14 of Terraform instead of the latest version:
```yaml
---
terraform_cli:
  install_location: /usr/local/bin
  version: 0.11.14
```

# Setup a local Ubuntu based Vagrant box with tooling

## Dependencies

1. Ensure Vagrant is installed, see https://learn.hashicorp.com/tutorials/vagrant/getting-started-install
1. Ensure a [supported version](https://www.vagrantup.com/docs/providers/virtualbox) of [Oracle Virtual box](https://www.virtualbox.org/wiki/Downloads) is installed
2. Ensure relevent ssh keys are added via ssh-agent on host so that they can be forward to the Vagrant box (for example if you have keys for accessing a git repo)

## Getting Started

1. Update the following variables in the Vagrantfile to suit your setup:
    1. CPU (cpu to assign to Vagrant box)
    1. MEM (memory to assign to Vagrant box)
    1. DISK (disk to assign to Vagrant box)
    1. LOCAL_DNS (if you want to use a specfic DNS server then set it here, otherwise leave blank)
    1. SYNC_HOST (directory on your host that should be synced into the Vagrant box)
    1. SYNC_CLIENT (directory on the Vagrant box where synced directories are mounted)
    1. PIVENT_API_TOKEN (your PIVNET api token to ensure the Ansible provisioner is able to download Pivnet dependencies)

1. At the command line, change into the repository root directory and run `vagrant up`, if prompted to install plugins then select `y` and then when prompted re-run the `vagrant up` command. This will provision an Ubuntu based Vagrant box and deploy Tanzu tooling using the Ansible playbook located in the `ansible-playbook` directory

1. Once started, all standard Vagrant commands can be used (halt/reload/suspend/resume) to control the Vagrant box (see https://www.vagrantup.com/docs/cli for more details)

## Working with the Vagrant box

### Connect via SSH

1. At the command line, change into the repository root directory and run `vagrant ssh` 

### Connect via Visual Studio Code remote ssh

1. Get the Vagrant box ssh config by running the following command in the repository root directory:
```
$ vagrant ssh-config
```
2. Copy the output of this into an SSH config file, for example my default SSH config is at `~/.ssh/config`. In VScode you can easily open this file, or generate a custom config file for VScode to use, by pressing opening the command pallette and selecting Remote-SSH: Open Configuration File

3. Once setup you can then select to connect to the Vagrant box via ssh

NOTE: if you have added your ssh key(s) to your host ssh-agent these will automatically be forwarded via the remote ssh connection.

### Make changes to the Tanzu Ops ansible playbook

1. If you make any changes/additions to the Tanzu Ops ansible playbook, you **do not** need to recrete the Vagrant box to have these changes realised. You simply need to browse to the repository root director and run `vagrant provision`, this will then re-run the Ansible playbook against the running Vagrant box with any changes you have made 