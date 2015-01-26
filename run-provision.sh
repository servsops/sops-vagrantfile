# vagrant rsync for libvirt provider (it seems don't sync as using virtualbox)
vagrant rsync $1
vagrant provision $1
