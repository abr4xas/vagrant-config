# encoding: utf-8
# This file originally created at http://rove.io/b12db7f9a4eea1c71e136e4ab8960440

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "opscode-ubuntu-12.04_chef-11.4.0"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.4.0.box"
  config.ssh.forward_agent = true
  config.vm.network :forwarded_port, guest: 8000, host: 1234
  config.vm.boot_timeout = 300    
    
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'php'
    chef.add_recipe 'python'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'vim'
    chef.add_recipe 'git'
    chef.json = {
      :git => {
        :prefix => "/usr/local"
      }
    }
  end
    
    # Install dependencies
    config.vm.provision :shell, :path => "dependencies.sh"
    
end
