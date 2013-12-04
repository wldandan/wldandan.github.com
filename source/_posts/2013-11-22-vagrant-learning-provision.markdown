---
layout: post
title: "Vagrant Learning - 4 (Provision)"
date: 2013-11-22 23:02
comments: true
categories: Vagrant
---


###如何安装应用

当我们第一次使用Box创建VM时，它通常是个没有装太多应用的裸机。所以，就会面临一个问题：
如何快速并有效的安装工作需要的软件，如数据库、Web服务器等?

目前，基本上有两种方式：

####手动安装

<!--More-->

首次创建VM后，手动安装需要的软件，然后重新分发Box。这样，就拥有了一个包含所需软件的Box，以后再创建VM时，直接使用该Box即可。

譬如说，如果希望有一台VM作为Apache服务器，我们可以尝试使用以下方式：


	vagrant init precise64 http://files.vagrantup.com/precise64.box
	vagrant up
	........


####Provision安装

将安装软件作为构建VM流程的一部分，不依赖于Box。每次创建VM都会自动安装一遍所需要的软件，例如使用Shel脚本，使用Chef或者其他方式，我们将这种机制称之为“Provisioning”

实际上，Vagrant默认支持的Provisoining包括Shell、Chef以及Puppet。 
通过配置Provisioning，Vagrant会在```vagrant up```的阶段将其应用于VM。


#####Shell Provision

* 在Vagrantfile同级目录下 定义provison.sh并设置可执行权限
  
		#!/usr/bin/env bash
		echo "Installing Apache and setting it up..."
		apt-get update >/dev/null 2>&1
		apt-get install -y apache2 >/dev/null 2>&1
		rm -rf /var/www
		ln -fs /vagrant /var/www

* 在Vagrantfile中使用provision.sh
	config.vm.provision "shell", path: "provision.sh"

* 执行```vagrant up```	

#####[Chef](http://www.opscode.com) Provision
Vagrant对Chef支持的很好，包括chef-client和chef-solo两种模式。
这里，我们之讨论如何使用chef-solo来安装Apache。

* 在Vagrantfile同级目录下，创建如下目录及文件cookbooks/vagrant_book/recipes/default.rb, 并加入如下内容

		execute "apt-get update"
		package "apache2"
		execute "rm -rf /var/www" 
		link "/var/www" do
			to "/vagrant" 
		end

* 在Vagrantfile中定义如下配置	

		config.vm.define "web" do |web|
			web.vm.hostname = "web-vm-chef"
		end 
		config.vm.network :forwarded_port, guest: 80, host: 9090
		config.vm.provision "chef_solo", run_list: ["vagrant_book"]

* 执行```vagrant up```

##### Puppet Provision

Vagrant也同样支持Puppet，这里，我们看看如何使用Puppet安装Apache。

* 在Vagrantfile同级目录下，创建如下目录及文件manifests/default.pp, 并加入如下内容

		exec { "apt-get update":
			command => "/usr/bin/apt-get update",
		}

		package { "apache2":
			require => Exec["apt-get update"],
		}

		file { "/var/www": 
			ensure => link, 
			target => "/vagrant", 
			force => true,
		}

* 在Vagrantfile中定义如下配置	

  		config.vm.define "web" do |web|
    		web.vm.hostname = "web-vm-chef"
  		end 
  		config.vm.network :forwarded_port, guest: 80, host: 9090
  		config.vm.provision "puppet"

* 执行```vagrant up```  

##### 混搭

实际上，我们也可以同时使用多种Provision，让他们协同工作。
譬如，在下面的示例中，我们使用Shell以及Puppet一起完成Apache的安装

		config.vm.box = "precise64"
		config.vm.provision "shell", inline: "apt-get update" 
		config.vm.provision "puppet"


###总结
Vagrant提供了强大的Provision机制, 能方便的帮助我们更有效的安装以及部署应用。

