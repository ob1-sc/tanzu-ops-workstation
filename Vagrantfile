CPU=2
MEM=2048
DISK="30GB"
LOCAL_DNS=""

SYNC_HOST="~/Workspace"
SYNC_CLIENT="/home/vagrant/workspace"

GIT_USERNAME="Simon O'Brien"
GIT_EMAIL="simonobrien@vmware.com"

PIVNET_API_TOKEN=""

Vagrant.configure("2") do |config|

  config.vagrant.plugins = ["vagrant-disksize"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # forward ssh from host, ensure keys are added to ssh-agent via ssh-add
  config.ssh.forward_agent = true

  config.disksize.size = DISK

  config.vm.define "tanzu-ops-workstation" do |vagrant|
    vagrant.vm.box = "ubuntu/bionic64"
    vagrant.vm.provider :virtualbox do |v, override|
      v.memory = MEM
      v.cpus = CPU
    end

    # modify based on your host vm folders that you want to map
    vagrant.vm.synced_folder SYNC_HOST, SYNC_CLIENT

    if LOCAL_DNS != ""
      # ensure DNS is correctly set
      vagrant.vm.provision "shell" do |shell|
        shell.path = "vagrant-support/set-dns.sh"
        shell.args = [LOCAL_DNS]
      end
    end

    # install jmespath, needs to be in separate provisioned to ansible_local
    # to ensure it is available when the ansible_local provisioner runs
    vagrant.vm.provision "shell", inline: "sudo apt update; sudo apt install -y python-jmespath"

    # run the tanzu-ops-playbook
    vagrant.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "/vagrant/ansible-playbook/local.yml"
      ansible.verbose = false
      ansible.extra_vars = {
        local_user: "vagrant",
        pivnet_api_token: PIVNET_API_TOKEN,
        ansible_python_interpreter: "/usr/bin/python3"
      }
    end

    # set git username and email
    vagrant.vm.provision "shell" do |shell|
      shell.path = "vagrant-support/git-config.sh"
      shell.args = [GIT_USERNAME, GIT_EMAIL]
    end

  end

end
