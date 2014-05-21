---
layout: post
title: "How to setup mongo shard"
date: 2014-04-23 09:44
comments: true
categories: NoSQL
---
To simulate the process of production deployment of MongoDB, I used Vagrant to create a couples of VMs, and exprienced the journey of deployment mongo step by step as follow mentioned. 

### Mongo Shard Concepts

Before dived into the code, we can review the concepts related to Mongo Shard, it needs 3 components logically at least.

#### a) Config Server
 
The config server processes are mongod instances that 	store the cluster’s metadata. You designate a mongod as a config server using the --configsvr option. Each config server stores a complete copy of the cluster’s metadata.

#### b) Query Server
The query server are lightweight mongos instances and 	do not require data directories. You can run a mongos 	instance on a system that runs other cluster 	components, such as on an application server or a 	server running a mongod process. By default, a mongos 	instance runs on port 27017.

<!--More-->
#### c) Shard Server
The shard server is a component which can consist of 	a repicaSet(multiple machines).


### Mongo Shard Setup

#### a) Create mongo box
	vagrant box add precise64 http://files.vagrantup.com/precise64.box	
	setup mongo as [Mongo GUide](http://example.net/) mentioned
	vagrant package --base default --output mongo_vm.box

#### b) Create several VMs
Please check the vagrant config file from here
3 config servers
2 query servers
2 replicaSet and each replica has 2 instances.

#### c) Setup the shard
	1) start config servers
		(ssh to 192.168.2.21 config1): mongod --configsvr --dbpath /home/vagrant/mongo-config --port 27020
		(ssh to 192.168.2.22 config2): mongod --configsvr --dbpath /home/vagrant/mongo-config --port 27020
		(ssh to 192.168.2.23 config3): mongod --configsvr --dbpath /home/vagrant/mongo-config --port 27020

	2) start query servers
		(ssh to 192.168.2.31 router1): mongos --configdb 192.168.2.21:27020,192.168.2.22:27020,192.168.2.23:27020 --port 27017 --chunkSize 2
		(ssh to 192.168.2.32 router2): mongos --configdb 192.168.2.21:27020,192.168.2.22:27020,192.168.2.23:27020 --port 27017 --chunkSize 2

	3) start replicaSet1
		(ssh to 192.168.2.41 rep1a): mongod --dbpath /home/vagrant/mongo-data --port 27040 --replSet rep1 --oplogSize 200 --rest
		(ssh to 192.168.2.42 rep1b): mongod --dbpath /home/vagrant/mongo-data --port 27040 --replSet rep1 --oplogSize 200 --rest

	4) start replicaSet2
		(ssh to 192.168.2.51 rep2a): mongod --dbpath /home/vagrant/mongo-data --port 27040 --replSet rep2 --oplogSize 200 --rest
		(ssh to 192.168.2.52 rep2b): mongod --dbpath /home/vagrant/mongo-data --port 27040 --replSet rep2 --oplogSize 200 --rest

### Config the shard

	use mongo clien access any one of query server, and then execute 

		db.runCommand({addshard:'rep1/192.168.2.41:27040,192.168.2.42:27040'})
		db.runCommand({addshard:'rep2/192.168.2.51:27040,192.168.2.52:27040'})
		db.runCommand({listshards:1});

		You will see the shard server has been configured.








