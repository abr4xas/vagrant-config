![Vagrant Logo](logo_vagrant.png)

>Create and configure lightweight, reproducible, and portable development environments.

Pre-requisites:

There are 2 software tools which you will need on your machine for this project:

* [Vagrant](http://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Setup

* Quick install

Simply run this: ```curl -L http://rove.io/install | bash```

## Connect to the Virtual Machine

* Install VirtualBox Guest Additions Plugin (This step is optional).

```bash
$ vagrant plugin install vagrant-vbguest
```

* Start the virtual machine for the first time:

```bash
$ vagrant ssh
```

This will take some time. It has to download the operating system and all the tools to install on your new virtual machine.

* Connect to the virtual machine via ssh:

* To Stop the Virtual Machine:

```bash
$ vagrant halt
```
* To Suspend it:

```bash
$ vagrant suspend
```

* Back to init again:

```bash
vagrant up
```
* To reload (if it is running):

```bash
$ vagrant reload
```

* To remove completly:

```bash
$ vagrant destroy
```

The ```development``` folder contains the source code for your project.

### You own Cheffile?

[Rove.io](http://rove.io/) is a service that allows you to pregenerate typical Vagrant builds. ;)