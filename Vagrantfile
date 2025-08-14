Vagrant.configure("2") do |config|
  config.vm.hostname = "server"
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.network "forwarded_port", guest: 9000, host: 9000, host_ip: "127.0.0.1"

  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir -p ~/.ssh
    cat /vagrant/.ssh/*.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
  SHELL

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "file", source: ".env", destination: "/home/vagrant/.env"

  config.vm.provision "shell", path: "provision.sh"

  config.vbguest.auto_update = false
  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  config.vm.boot_timeout = 5000
end
