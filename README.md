![Vagrant Logo](logo_vagrant.png)
# Vagrant
Pre-Requisites

There are four software tools which you will need on your machine for this project:

* Vagrant
* VirtualBox
* Git
* SSH

### Setup

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
#### Source
[http://owencampbell.me.uk/pelican-starter](http://owencampbell.me.uk/pelican-starter).