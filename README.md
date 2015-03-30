![Vagrant Logo](logo_vagrant.png)

>Create and configure lightweight, reproducible, and portable development environments.

Pre-requisites:

There are 2 software tools which you will need on your machine for this project:

* [Vagrant](http://www.vagrantup.com/downloads.html).
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

___

A super-simple Vagrantfile to setup a LAMP stack inside Vagrant 100% automatically.

* Setup a Ubuntu 14.04 LTS "Trustry Thar" 64bit box
* Private network, which allows host-only access to the machine using a specific IP: ```192.168.30.10```
* Forwarded port: ```80 to 8080```, ```8000 to 1234```, ```3000 to 1235```.

setup.sh will:

* Install apache 2.4, php 5.5, MySQL, PHPMyAdmin, git and Composer.
* Setting a pre-chosen password for MySQL and PHPMyAdmin ```root```.
* Activate mod_rewrite and add AllowOverride All to the vhost settings.
* Install: Composer, nodejs, npm, bower, git, python-pip and lftp.


## Connect to the Virtual Machine

* Install VirtualBox Guest Additions Plugin (This step is optional).

```bash
$ vagrant plugin install vagrant-vbguest
```

* Start the virtual machine for the first time:

```bash
$ vagrant up
``` 

This will take some time. It has to download the operating system and all the tools to install on your new virtual machine.

* Connect to the virtual machine via ssh:

```bash
$ vagrant ssh
```

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