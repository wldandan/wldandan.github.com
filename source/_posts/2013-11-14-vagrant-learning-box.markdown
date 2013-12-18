---
layout: post
title: "Vagrant Learning - 3 (Box) "
date: 2013-11-14 17:02
comments: true
categories: Vagrant
---
###什么是Vagrant Box

谈论完了Vagrantfile，让我们看看Vagrant的另外一个重要概念Box。它是Vagrant运行VM的必要条件。
基本上，从头开始建立一个VM是相当耗时的工作，于是Vagrant使用一个基础映像(base image), 克隆它并快速创建一个可用的VM。  
在Vagrant的世界里，所有这些基础映像统称为Box。简单地说，Box可以理解为创建VM时需要的模板，通过这些模板，我们可以创建VM。
<!--More-->

如果将上面例子的
```config.vm.box = "precise64"```注释掉，并执行```vagrant up```,Vagrant将会提示

	There are errors in the configuration of this machine. Please fix
	the following errors and try again:

	vm:
	* A box must be specified.

但是，如果只是去掉```http://files.vagrantup.com/precise64.box```并执行```vagrant up```,则VM依然能够正常启动。

所以，可以理解为Vagrantfile是项目相关的(per-project basis)，不同的Vagrantfile之间并没有什么联系。而Box则是可以被共享的，当创建一个Box后，其他VM便可以将Box作为模板使用。这也就意味着，对于同一个Box，我们能通过不同的Vagrantfile配置文件，运行多个不同的VM。本质上，这也是Box和VM的区别。
举个例子，当构建一个复杂系统时，我们可以使用同一个Vagrant Box(比如Ubuntu 12), 定义不同的Vagarantfile，分别创建网站服务器，数据库服务器或者图片服务器等。

###启动Vagrant Box
理解了Vagrant Box，理解了Vagrantfile，现在我们来看看当第一次执行```vagrant up```时, Vagrant到底做了什么事情


	Bringing machine 'default' up with 'virtualbox' provider...
	[default] Importing base box 'precise64'... 
	//基于Box precise64创建VM
	[default] Matching MAC address for NAT networking... 
	//初始化网络配置
	[default] Setting the name of the VM... 
	//设置VM的名字(非hostname)。默认规则为当前```文件夹名称``` + ```随机数```, 可以通过	VirtualBox管理器查看到，如下所示

	[default] Clearing any previously set forwarded ports... 
	//清空端口转发的设置
	[default] Creating shared folders metadata...
	//初始化文件夹共享设置
	[default] Clearing any previously set network interfaces...
	//初始化文件夹共享设置
	[default] Preparing network interfaces based on configuration...
	//初始化网络配置
	[default] Forwarding ports...
	[default] -- 22 => 2222 (adapter 1)
	//设置SSH的端口转发
	[default] Booting VM...
	[default] Waiting for VM to boot. This can take a few minutes.
	[default] VM booted and ready for use!
	[default] Mounting shared folders...
	//挂载共享文件夹
	[default] -- /vagrant
	//默认的，主机上Vagrantfile所在的文件夹将被挂载到VM的/vagrant目录

另外有一点要注意的，当第一次执行```vagrant up```后，当前目录下会生成一个```.vagrant```的目录，里面记录了Vagrant对VM的配置信息，如ID,状态等。

###管理Vagrant Box
Vagrant 提供了方便的命令帮助我们管理Box. 

    add        //添加新的Box
    list       //显示当前Box 
    remove     //删除Box


类似的，对于VM，Vagrant也提供了不同的方式管理它:

	vagrant suspend //挂起当前VM
	vagrant halt    //关闭当前VM
	vagrant destroy //删除当前VM
	vagrant reload  //重新当前VM
	......
	
### 可用的Box
Vagrant官方已经提供了很多可用的Box，请看[这里](http://www.vagrantbox.es/)

###总结	
现在，我们已经了解了Vagrantfile, Vagrant Box, 以及Vagrant VM，通过上面的步骤，相信你已经可以轻松的创建虚拟机了。接下来，我们将看看如何使用Vagrant的一些高级功能，更方便的管理及定制虚拟机。