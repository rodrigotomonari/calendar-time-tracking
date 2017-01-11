# -*- mode: ruby -*-
## DOCUMENTATION => https://www.vagrantup.com/docs/multi-machine/

unless Vagrant.has_plugin?('vagrant-vbguest')
  system('vagrant plugin install vagrant-vbguest')
  puts 'Dependencies installed, please try the command again.'
  exit
end

unless Vagrant.has_plugin?('vagrant-librarian-chef-nochef')
  system('vagrant plugin install vagrant-librarian-chef-nochef')
  puts 'Dependencies installed, please try the command again.'
  exit
end

Vagrant.configure(2) do |config|
  config.vm.network :private_network, ip: '192.168.99.102'

  config.vm.define 'busycal', primary: true do |busycal|
    busycal.vm.box      = 'ubuntu/trusty64'
    busycal.vm.hostname = 'busycal'
    busycal.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name   = 'busycal'
      virtualbox.memory = '4096'
      virtualbox.cpus   = 2
      virtualbox.customize ['guestproperty', 'set', :id, '--timesync-threshold', 5000]

    end

    busycal.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ['cookbooks']
      chef.add_recipe 'apt'
      chef.add_recipe 'nodejs'
      chef.add_recipe 'vim'
      chef.add_recipe 'ruby_build'
      chef.add_recipe 'mysql::server'
      chef.add_recipe 'mysql::client'
      chef.add_recipe 'chef_rvm::default'


      chef.json = {
        chef_rvm: {
          users: {
            vagrant: {
              rubies: {
                '2.3.3' => 'install'
              }
            }
          }
        },
        mysql:    {
          server_root_password: ''
        },
        nodejs:   {
          npm_packages: [
                          {
                            name: 'phantomjs'
                          }
                        ]
        }
      }
    end
  end
end
