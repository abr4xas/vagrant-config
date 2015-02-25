![Vagrant Logo](logo_vagrant.png)
# Vagrant
Pre-Requisites

There are four software tools which you will need on your machine for this project:

* [Vagrant](http://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Setup

* Quick install

Simply run this: ```curl -L http://rove.io/install | bash```

* Install VirtualBox Guest Additions Plugin (This step is optional).

```bash
cd /path/to/your/repository
vagrant plugin install vagrant-vbguest
```

* Start the virtual machine for the first time:

```bash
cd /path/to/your/repository
vagrant up
```

This will take some time. It has to download the operating system and all the tools to install on your new virtual machine.

* Connect to your vm, exit and reload it:

```bash
vagrant ssh
# wait few seconds
exit
vagrant reload
```
## How to use

The ```development``` folder contains the source code for your project.

#### Source
Doc: [http://owencampbell.me.uk/pelican-starter](http://owencampbell.me.uk/pelican-starter).