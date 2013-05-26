---
layout: post
title: "Understanding *nix bash profile"
date: 2013-05-23 22:10
comments: true
categories: Linux 
---

工作在*nix环境下的兄弟们，多多少少都应该见过这么几个文件:

	/etc/profile
	/etc/bashrc
	~/.bash_profile
	~/.bashrc
	~/.bash_login

说实话，我一直没搞清楚这些文件是干什么的，以及他们是什么联系。今天组里正好有人讲这个，就给自己长长见识吧。其实吧，最主要的区别就在于两个词: "Login shell" 和 "Non-login shell"。

<!--More-->
##什么是Login shell?
当进入shell(bash/csh/...)时，如果需要一个完整的登录过程（输入用户名和密码），我们就称获取的这个shell为login shell。譬如，如果你要是由 tty1 ~ tty6 登录，则*nix系统需要你提供用户名和密码，此时登录成功过后取得的bash就称为login shell.

##什么是 Non-login shell?
如果进入shell的过程不需要登录，则我们称获取的shell为Non-Login shell. 
譬如，使用X Window登录后，如果启动终端(Terminal)，则不需要登录即可进入shell
或者，如果在当前的bash环境中再输入命令bash，同样也没有提供用户名和密码便进入新的shell环境。

##它们究竟做了什么？
了解完Non-login shell和login shell，那让我们看看到底发生了什么？


当使用Login shell进入bash时，bash首先会读取/etc/profile，然后会依次读取下面的文件中的任意一个(注意是任意一个，也就是说bash会依次查找下面三个配置文件，且找到一个后，后续的文件便不再读取)。
	~/.bash_profile
	~/.bash_login
	~/.profile

当使用Non-login shell进入bash时，则只是读取
	~/.bashrc


综上所示，明白了Non-login shell以及Login shell后，让我们看看如何快速获取Login shell和Non-login shell:

#####1. 使用bash
在当前的bash环境下，输入bash, 则获取的为Non-login shell, ~/.bashrc会被执行
但如果执行bash -l, 则获取的shell为Login shell，并会执行/etc/profile以及~/.bash_profile。不过，不同的*nux发行版，可能执行的结果略有不同。

#####2. 使用su
 当使用su xxx时候，获取的是Non-login shell. 而当使用su - xxx时，获取的则是Login shell

##总结
了解了Login shell 和 Non-login shell，对于谁读取了哪些profile，我们就清楚了。

