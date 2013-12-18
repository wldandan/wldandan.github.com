---
layout: post
title: "Vagrant Learning - 1 (Basic Concepts)"
date: 2013-11-04 20:02
comments: true
categories: Vagrant
---

### 为什么选择Vagrant
- 能够构建可配置的、轻量级的、便携式的虚拟服务器
- 安装简单，提供不同平台的安装包
- 一条命令即可创建出虚拟机环境，而且官方提供各种虚拟机的模板。
- 能够最大化的帮助个人或者团队快速配置环境。譬如说，如果你是团队中的一员，通过Vagrant创建出一套独立的运行环境后，团队的其他成员能够使用该配置，创建完全一样地工作环境。所以无论你是工作在Linux，Mac OS X或Windows ，所有的团队成员都能在同一环境下运行代码，拥有相同的依赖。告别环境不一致带来的问题。
- 提供Shell、Chef或者Puppet的支持，能够利用这些工具(Infrastructure As Code的方式)配置环境。
- 从1.2的版本开始，不但支持VirtualBox,VmWare, 还开始支持Amazon EC2。

<!--More-->
### 搭建环境  
- 安装[Virtual Box](http://virtualbox.org)
- 安装[Vagrant](http://downloads.vagrantup.com)
- 安装第一个虚拟机  
  ```vagrant init precise64 http://files.vagrantup.com/precise64.box```

- 启动虚拟机  
    ```vagrant up```

- 登录虚拟机  
   ```vagrang ssh```

- 删除虚拟机  
   ```vagrang destroy```


### 发生了什么

- 当执行```vagrant init precise64 http://files.vagrantup.com/precise64.box```时，Vagrant将先从官网上下载一个Box，然后新建一个配置文件Vagrantfile。

- 当执行
```vagrant up```
时，Vagrant将参照Vagrantfile的配置信息，初始化并被启动该虚拟机。

- 当执行```vagrant ssh```时，Vagrant将使用内建的SSHkey登陆。

- 当执行```vagrant destroy```时，Vagrant将删除该虚拟机，但并不会删除对应的Box。

- 执行```vagrant box list```, 便能看到刚刚创建的Box```precise64``` 