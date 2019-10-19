# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_git = <<-SCRIPT
    yum install -y git nano
    git --version
    yum remove -y docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine
    yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum update -y
    yum install -y docker-ce docker-ce-cli containerd.io
    systemctl enable docker.service
    systemctl start docker.service
    docker version

    groupadd module3-group
    useradd module3-user
    usermod -aG module3-group module3-user
    groups module3-user
    groupdel module3-group
    groups module3-user

    yum install -y ntp
SCRIPT
# добавить в /etc/sudoers строчку
# module3-user ALL= NOPASSWD: /bin/systemctl restart docker.service

Vagrant.configure("2") do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true

    (1..1).each do |i|
        config.vm.define "node-centos-#{i}" do |node|
        node.vm.box = "centos/7"
        node.vm.box_version = "1905.1"

        node.vm.hostname = "pavel-centos7-#{i}"
        node.vm.network "private_network", ip: "192.168.100.#{i+35}"

        node.vm.provision "shell", inline: $install_git
    end
  end
end
