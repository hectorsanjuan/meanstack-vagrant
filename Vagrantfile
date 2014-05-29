require 'yaml'

config_params = YAML.load(
  File.open(
    File.join(File.dirname(__FILE__), "config.yaml"),
    File::RDONLY
  ).read)

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"

  if config_params['vm']['hostname'].to_s != ''
    config.vm.hostname = "#{config_params['vm']['hostname']}"
  end

  if config_params['vm']['network']['private_network'].to_s != ''
    config.vm.network "private_network", ip: "#{config_params['vm']['network']['private_network']}"
  end

  config_params['vm']['network']['forwarded_ports'].each do |service, port|
    if port['guest'] != '' && port['host'] != ''
      config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
    end
  end


  config_params['vm']['synced_folders'].each do |key, folder|
    if folder['source'] != '' && folder['target'] != ''
      nfs = (folder['nfs'] && RUBY_PLATFORM =~ /darwin|linux/) ? "nfs" : nil
      if nfs == "nfs"
        config.vm.synced_folder "#{folder['source']}", "#{folder['target']}", type: nfs
      else
        config.vm.synced_folder "#{folder['source']}", "#{folder['target']}"
      end
    end
  end

  config.vm.usable_port_range = (10200..10500)

  if config_params['vm']['chosen_provider'].empty? || config_params['vm']['chosen_provider'] == "virtualbox"
    config.vm.provider :virtualbox do |virtualbox|
      config_params['vm']['provider']['virtualbox']['modifyvm'].each do |key, value|
        if key == "memory"
          next
        end

        if key == "natdnshostresolver1"
          value = value ? "on" : "off"
        end

        virtualbox.customize ["modifyvm", :id, "--#{key}", "#{value}"]
      end

      virtualbox.customize ["modifyvm", :id, "--memory", "#{config_params['vm']['memory']}"]
    end
  end

  if config_params['vm']['chosen_provider'] == "vmware_fusion" || config_params['vm']['chosen_provider'] == "vmware_workstation"
    config.vm.provider "vmware_fusion" do |vmware|
      config_params['vm']['provider']['vmware'].each do |key, value|
        if key == "memsize"
          next
        end

        vmware.vmx["#{key}"] = "#{value}"
      end

      vmware.vmx["memsize"] = "#{config_params['vm']['memory']}"
    end
  end

  if !config_params['ssh']['forward_agent'].nil?
    config.ssh.forward_agent = config_params['ssh']['forward_agent']
  end

  if config_params['vm']['chosen_provisioner'].empty? || config_params['vm']['chosen_provisioner'] == "salt"
    config.vm.provision :salt do |salt|
      salt.minion_config = config_params['vm']['provisioner']['salt']['minion_config']
      salt.run_highstate = config_params['vm']['provisioner']['salt']['run_highstate']
      salt.colorize = config_params['vm']['provisioner']['salt']['colorize']

      config_params['vm']['provisioner']['salt']['pillar'].each do |pillar, data|
        salt.pillar({pillar => data})
      end
    end
  end
end
