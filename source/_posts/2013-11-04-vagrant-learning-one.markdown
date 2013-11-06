---
layout: post
title: "Vagrant Learning - 1 (basic concepts)"
date: 2013-11-04 20:02
comments: true
categories: Tools
---

###简介
经常会听到类似这样的对话:  
"在我这跑没问题，你那运行不起来肯定是环境有问题吧"  
"都是最新的代码，我这测试过了，你的测试怎么就挂了，该不是你的依赖有冲突吧"  
......

对于当今的屌丝程序猿而言，产品的开发/部署环境变得越来越复杂。无论你是开发人员、测试人员，还是系统维护人员，如何搭建一个干净的运行环境，快速、高效的部署以及配置软件应用，成了困扰我们的一个大问题。在这种情况下，无论对于个人，还是团队，高效的使用虚拟化技术，创建独立的产品运行环境也就变得越来越重要。

####对于个人  
- Ubuntu新的版本发布了，听说很cool，想试试但多操作系统麻烦啊
- NoSQL有这么多产品，装多了会不会影响本地的开发环境
- 当前产品的技术栈复杂啊，新人来了跑个应用，就得花上个2天，伤不起啊  
…….

####对于开发团队  
- Same dependencies
- Same versions
- Same configurations
- Same everything  

诚然,我们期望团队的开发/运行环境能够完全一样，但实际上这并不容易。  
这种不同来自很多方面，软件的版本、运行的配置或者版本之间的依赖等等。

<!--More-->

### 为什么选择Vagrant
- 能够构建可配置的、轻量级的、便携式的虚拟服务器
- 安装简单，提供不同平台的安装包
- 一条命令即可创建出虚拟机环境，而且官方提供各种虚拟机的模板。
- 能够最大化的帮助个人或者团队快速配置环境。譬如说，如果你是团队中的一员，通过Vagrant创建出一套独立的运行环境后，团队的其他成员能够使用该配置，创建完全一样地工作环境。所以无论你是工作在Linux，Mac OS X或Windows ，所有的团队成员都能在同一环境下运行代码，拥有相同的依赖。告别环境不一致带来的问题。
- 提供Shell、Chef或者Puppet的支持，能够利用这些工具(Infrastructure As Code的方式)配置环境。
- 从1.2的版本开始，不但支持VirtualBox,VmWare, 还开始支持Amazon EC2。


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