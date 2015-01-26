# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2" 

vagrant_root = File.dirname(File.expand_path(__FILE__))
vagrant_name = File.basename(vagrant_root)

layer_yml = "#{vagrant_root}/.layers.vagrant.yml"
config_yml = "#{vagrant_root}/.config.vagrant.yml"
raise "Can't find #{layer_yml}" unless File.exists?(layer_yml)
raise "Can't find #{config_yml}" unless File.exists?(config_yml)

#####
# Load Configs
#####

layers = Psych.load(File.read(layer_yml)).to_h
vagrant_cnf = Psych.load(File.read(config_yml)).to_h

os = vagrant_cnf['os']

#$scripts = ""
$scripts = vagrant_cnf['scripts'][os]

#####
# Vagrant
#####

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = vagrant_cnf['box'][os]
  #config.berkshelf.enabled = true
  #config.vm.synced_folder './', '/vagrant', type: 'nfs'

  layers.each do |layer, instances|
    instances.each do |i|
      config.vm.define i['name'] do |config|
        config.vm.hostname = "#{vagrant_name}-#{i['name'].to_s.gsub(/_/,"-")}"

	config.vm.network :public_network, :dev => "eth0", :mode => "bridge"
	config.vm.network :private_network, :ip => i['ip']

	case vagrant_cnf['provider']
        when "virtualbox"
            config.vm.provider "virtualbox" do |vm|
              vm.customize ["modifyvm", :id, "--cpus", i['cpus']]
              vm.customize ["modifyvm", :id, "--memory", i['mem']]
            end
	when "libvirt"
            config.vm.provider :libvirt do |vm|
              vm.cpus = i['cpus']
              vm.memory = i['mem']
              #vm.storage :file, :size => '1G'
            end
	end

        config.vm.provision "shell", inline: $scripts

        config.vm.provision "chef_solo" do |chef|
          chef.cookbooks_path = "./cookbooks"
          chef.roles_path = "./roles"
          chef.run_list = [ "role[#{layer}]" ]
        end

      end
    end
  end

end
