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
* Forwarded port:
    * ```80 to 8080```
    * ```8000 to 8000```
    * ```3000 to 8000```

setup.sh will:

* Install:
    * apache2
    * git
    * python-pip
    * lftp
    * php5
    * libapache2-mod-php5
    * php5-mcrypt
    * php5-cli
    * php5-curl
    * python-pip
    * nodemon
    * bower
    * nodejs
    * rethinkdb
    * sass
* Setting a pre-chosen password for MySQL and PHPMyAdmin:
    * ```root```
* Activate:
    * ```mod_rewrite```

and add:
* ```AllowOverride All```

to the vhost settings.


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

The ```dev``` folder contains the source code for your project.

###

```setup.sh``` based on: [panique/vagrant-lamp-bootstrap](https://github.com/panique/vagrant-lamp-bootstrap).
