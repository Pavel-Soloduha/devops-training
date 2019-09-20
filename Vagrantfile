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

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true

    (1..2).each do |i|
        config.vm.define "node-centos-#{i}" do |node|
        node.vm.box = "centos/7"
        node.vm.box_version = "1905.1"

        node.vm.hostname = "pavel-centos7-#{i}"
        node.vm.network "private_network", ip: "192.168.100.#{i+35}"

        node.vm.provision "shell", inline: $install_git
    end
  end
end
