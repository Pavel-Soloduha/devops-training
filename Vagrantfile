# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_git = <<-SCRIPT
  sudo yum install git -y
  git --version
  git clone https://github.com/Pavel-Soloduha/devops-training.git
  cd devops-training
  git checkout module2
  cat hometask.txt
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "centos/7"
    vm1.vm.box_version = "1905.1"

    vm1.vm.network "public_network", bridge: "enp0s20f0u1"
    vm1.vm.hostname = "pavel-centos7-vm1"
    vm1.vm.network "private_network", ip: "192.168.100.35"

    vm1.hostsupdater.aliases = {
      '192.168.100.36' => 'pavel-centos7-vm2'
    }

    vm1.hostmanager.enabled = true
    vm1.hostmanager.manage_host = true
    vm1.hostmanager.manage_guest = true
    vm1.vm.provision "shell", inline: $install_git
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "centos/7"
    vm2.vm.box_version = "1905.1"

    vm2.vm.network "public_network", bridge: "enp0s20f0u1"
    vm2.vm.hostname = "pavel-centos7-vm2"
    vm2.vm.network "private_network", ip: "192.168.100.36"
    
    vm2.hostsupdater.aliases = {
      '192.168.100.35' => 'pavel-centos7-vm1'
    }

    vm2.hostmanager.enabled = true
    vm2.hostmanager.manage_host = true
    vm2.hostmanager.manage_guest = true
    vm2.vm.provision "shell", inline: $install_git
  end

end
