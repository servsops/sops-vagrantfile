Vagrantfile
-----------

### Q & A

* Why use libvirt ?

Support Dnsmasq. We can easily connect to vm using `ssh ubuntu@HOSTNAME`

* Why use chef-solo ?

I'm using vagrant for dev environment, and AWS Opsworks for prd environment. (Though AWS Opsworks actually using chef-zero, it's slow in local setup.)

### Get Start (Ubuntu + Virtualbox)

* add/check instances to/in layers `.layers.vagrant.yml`

```yml
bastion:
  -
    name: :bastion1
    ip: "192.168.90.21"
    cpus: 1
    mem: 800 
```

* start

```bash
# create vagrant folder, vagrant_name="dev-vagrant"
mkdir dev-vagrant

# clone files
cd dev-vagrant
git clone https://github.com/servsops/sops-vagrantfile .

cp .config.vagrant.yml.sample.virtualbox .config.vagrant.yml

vagrant up

# create instance: "#{vagrant_name}-#{name}"
# hostname: dev-vagrant-bastion1
vagrant ssh bastion1
```

### Get Start (Ubuntu + Libvirt)

* prepare vagrant libvirt box

```bash
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-libvirt
wget https://cloud-images.ubuntu.com/vagrant/trusty/20150123/trusty-server-cloudimg-amd64-vagrant-disk1.box -O ubuntu-trusty64.box
vagrant mutate ubuntu-trusty64.box libvirt
```

* start

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
mkdir dev-vagrant
cd dev-vagrant
git clone https://github.com/servsops/sops-vagrantfile .
cp .config.vagrant.yml.sample.libvirt .config.vagrant.yml
vagrant ssh bastion1
#or:
ssh ubuntu@dev-vagrant-bastion1
```

### Configs

* vagrant config at `.config.vagrant.yml`

```yml
os: "ubuntu"

# config.vm.provider: libvirt or virtualbox
provider: "libvirt"

# config.vm.box: ubuntu-trusty64 or centos-7
box:
  ubuntu: "ubuntu-trusty64"
  centos: "centos-7"

scripts:
  ubuntu: |
    apt-get install curl -y
  centos: |
    yum install curl -y
    which chef-solo || curl -L https://www.chef.io/chef/install.sh | sudo bash
    #yum install -y epel-release-7-2 curl
```
