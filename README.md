# Vagrant image to explore Juju charms

This repository provides a Vagrantfile to launch a vagrant that has
Juju/LXD/ZFS support, along with some instructions on how to get going.  This
repository was created by the  OpenStack charmers team at Canonical and used
for the Python Northeast Juju Charms talk on 2017-03-08.


# The Vagrant Base image

This repository contains

* A Vagrant file and associated provision file.
* Some nice configuration files for setting up tmux and a fancy shell prompt
* A custom.sh file that can be used to customise the provisioning further
* The juju/config.yaml file to configure Juju.

# Getting started

## Vagrant file

Just `git clone` the repository and then:

```shell
$ vagrant up
$ vagrant ssh

... wait for the shell from the Vagrant box ...

$ tmux-session
```

You'll now be in a handy tmux session.  Note that Ctrl-A is used as the tmux
meta key, as the author used GNE screen for years.

## Configuration Files

In the `provision` directory, there are various configuration files that are
used when building the Vagrant box.  These are:

* `dot.bashrc`: This becomes .bashrc in the `/home/vagrant` folder.  This is
  the standard Ubuntu 14.04 .bashrc with a few extra bits to work with
  Virtualenvs and the fancy prompt, and configures the `$PATH` variable to
  include `/home/vagrant/bin`.
* `dot.tmux.conf`: This becomes .tmux.conf in the `/home/vagrant` folder.
  * The tmux command is `Ctrl-A` rather than `Ctrl-B` because I've used `screen` for 15 years.
  * I've changed the split commands to work like Vi(m).
  * I've disabled logout, unless you hit `Ctrl-D` three times successively.
* `tmux-session`: This is copied to the `/home/vagrant/bin` folder. This
  configures tmux to create 3 windows.  Typing `tmux-session` at the command
  prompt configures the tmux session the first time it is run, and simply
  connects to a running server on subsequent invocations.
* `virtualenv-svn-git-path-prompt.bash`: This is a collection of functions and
  a 'fancy prompt' that puts the git repository (or SVN!) and active virtualenv
  onto the path.

## Configuring ZFS, LXD and Juju

In order to make the machines that Juju will launch as compact and fast as
possible, it's advisable to use ZFS as the file system and LXC/D as the
container service.  Then Juju can launch lightweight machines as quickly as
possible.

### ZFS

The `provision.sh` file creates a ZFS pool called `lxdpool` using a file that
is created, called `/lxdpool.file`.  Obviously, this isn't the *most* efficient
way to set up a filesystem as, if you destroy the vagrant image, the file goes
too.  But, the point was to enable the Juju machines to be a bit more
efficient.

### Initialise LXD to use the zfspool

At the prompt:

```bash
$ sudo lxd init
```

Call the pool `lxdpool` and be sure not to enable ipv6 networking.  Otherwise,
the other defaults are fine.

### Bootstrap a Juju controller

At the prompt:

```bash
$ juju bootstrap --config /vagrant/juju/config.yaml localhost lxd
```

This will configure the machine, and create the controller and a default model
for experimentation with Juju.
