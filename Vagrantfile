# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/wily64"
    config.ssh.forward_agent = true
    # Create a private network, which allows host-only access to the machine using a specific IP.
    config.vm.network "private_network", ip: "192.168.30.10"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 8000, host: 8000
    config.vm.network :forwarded_port, guest: 3000, host: 3000
    config.vm.boot_timeout = 300
    config.vm.synced_folder "dev/", "/var/www/html"
    # Shell provisioning
    config.vm.provision "shell" do |s|
        s.path = "provision/setup.sh"
    end
    # VirtualBox GUI Name
    config.vm.provider "virtualbox" do |v|
        v.name = "Robbie"
        v.memory = 524
    end
    # VM Name
    # Bringing machine 'Robbie' up with 'virtualbox' provider...
    config.vm.define :Robbie do |t|
        config.vm.hostname = "Robbie"
    end
end
