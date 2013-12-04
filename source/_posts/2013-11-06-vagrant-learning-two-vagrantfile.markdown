---
layout: post
title: Vagrant Learning - 2 (Configuration) 
date: 2013-11-06 17:26
comments: true
categories: Tools
---


###Vagrantfile

Vagrantfile是Vagrant启动并设置VM的配置文件，每个VM都必须有一个Vagrantfile。
当执行```Vagrant init```，Vagrant便会帮我们生成一个默认的Vagrantfile。
当然，不同的VM可以根据需求更改Vagrantfile的配置信息。  

对于开发团队，我们可以将Vagrant配置文件放入版本管理系统，从而整个团队能够共享并不断改进该文件，在团队内部提供一种方便快捷的方式，构建产品运行环境。

譬如，我们可以执行如下代码生成Vagrantfile

	mkdir vm && cd vm  
	vagrant init precise64 http://files.vagrantup.com/precise64.box

Vagrant会提示	  

	A Vagrantfile has been placed in this directory. You are now
	ready to 'vagrant up' your first virtual environment! Please read
	the comments in the Vagrantfile as well as documentation on
	'vagrantup.com' for more information on using Vagrant.
	
查看当前目录，会发现Vagrantfile已经生成。	

<!--More-->

###Ruby Style But Don't panic
你可能注意到该文件的格式不是简单的文本。实际上，Vagrantfile使用了ruby的语法来定义配置信息。不过别担心，即便不是Ruby开发者，通过后续的例子，也能随心所欲的配置你的VM。

对于上面的例子而言，

	Vagrant.configure(VAGRANTFILE_API_VERSION) do | config |
	config.vm.box = "precise64"
	config.vm.box_url="http://files.vagrantup.com/precise64.box"
	
其中，config是一个配置变量，我们可以通过它来配置VM的信息。```config.vm.box```表明创建VM时使用系统的名为precise64的Box。如果该Box不存在，则会使用```config.vm.box_url```从指定的地址重新下载该Box。


### Change VM Host Name
默认情况下,新建的VM的主机名(hostname)与它所使用的Box名称一样。
对于当前这个例子，如果执行

	vagrant ssh
将看到该VM的```hostname```为```precise64```

不过，我们可以使用如下代码修改主机名，

	config.vm.define "web" do |web|
       web.vm.hostname = "web-vm"
	end

### Share Host-Machine Directory
默认情况下,新建的VM的将会自动挂载执行"vagrant up"的主机文件夹到```/vagrant```目录。
也就是说, 主机上Vagrantfile所在的文件夹将被自动挂载到VM的/vagrant目录。

除此之外，我们也可以使用如下配置

	config.vm.synced_folder "/tmp", "/host_tmp"
第一个参数代表主机上的目录名称，第二个参数代表VM上的目录名称。

### Basic Networking
和文件共享同等重要的还有网络配置。通过更改网络配置信息，能帮助我们更有效的使用VM。
举例来说，如下的代码设置了端口映射(网络配置里的一部分)
	config.vm.network :forwarded_port, guest: 80, host: 9090

当访问主机端口9090时候，该请求会被转发到VM的80端口上。
譬如说，执行如下代码，在VM上启动一个Web Server
	vagrant ssh
	sudo python -m SimpleHTTPServer 80

然后在主机上访问localhost:9090, 将显示该目录下对应的文件。也就是说，访问主机的端口已经被转发到了VM上。

### Define Multimachine Clusters
其实，理论上每个VM都有一个对应的Vagrantfile。不过，Vagrant提供了创建集群的功能。
即使在一个Vagrantfile中，也是容许我们定义一个集群、即多台虚拟机的，如下所示：
一个Vagrant运行一次，会创建了2个虚拟机。

	Vagrant::Config.run do |config| 
	
    	config.vm.define :app do |app_config|
        	app_config.vm.customize ["modifyvm", :id, "--name", 
        							  "app", "--memory", "512"] 
    	    app_config.vm.box = "precise64"
        	app_config.vm.host_name = "app"
        	app_config.vm.network :hostonly, "33.33.13.37"
	    end 
	    
    	config.vm.define :db do |db_config|
	        db_config.vm.customize ["modifyvm", :id, "--name", 
	        						 "db", "--memory", "512"] 
     	    db_config.vm.box = "precise64"
        	db_config.vm.host_name = "db"
	        db_config.vm.network :hostonly, "33.33.13.38"
    	 end 
	end


### More …...
类似的，还有很多参数可以帮助我们定制VM，更多的细节这里就不一一列举了，请根据需要自行参考Vagrant的官方文档哦。
