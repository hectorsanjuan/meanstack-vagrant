# meanstack-vagrant

Simple vagrant box configuration for virtualbox provider and with salt
provisioner.

Vagrant >= 1.5.1 is required.

## Vagrant configuration

To simple manage vagrant box copy and modify config.yaml.dist to config.yaml
file and configure base options like forwarded ports, private ip, synced folders
or salt pillar data.

To use clone repo on project folder, create config based on config.yaml.dist and
start box:

```Shell
cd /path/to/project
git clone https://github.com/hectorsanjuan/meanstack-vagrant.git vagrant
echo "vagrant/" >> .gitignore
cd vagrant
cp config.yaml.dist config.yaml
vi config.yaml
vagrant up
```

## Virtualbox provider

Simple config based on ubuntu precise pangolin official vagrant box with private
network configuration and simple port options.

## Salt provisioner

Vagrant box configured using saltstack masterless option with simple minion.

The following formulas have been used from the github repositories of saltstack
formulas (https://github.com/saltstack-formulas/):

* ruby
* tmux
* vim
* git
* node
* mongodb

Added new state to install from source heroku toolbelt.
