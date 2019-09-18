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


  (1..2).each do |i|
    config.vm.define "node-centos-#{i}" do |node|
      node.vm.box = "centos/7"
      node.vm.box_version = "1905.1"

      node.vm.network "public_network", bridge: "enp0s20f0u1"
      node.vm.hostname = "pavel-centos7-#{i}"
      # node.vm.network "private_network", ip: "192.168.100.35+#{i}"

      node.hostmanager.enabled = true
      node.hostmanager.manage_host = true
      node.hostmanager.manage_guest = true
      node.vm.provision "shell", inline: $install_git
    end
  end
end
