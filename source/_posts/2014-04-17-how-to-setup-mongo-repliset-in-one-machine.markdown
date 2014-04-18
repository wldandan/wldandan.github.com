---
layout: post
title: "How to setup mongo repliSet in one machine"
date: 2014-04-17 09:24
comments: true
categories: NoSQL
---
#### Create mongo repliSet instances

	mkdir -p /srv/mongodb/rs0-0 /srv/mongodb/rs0-1 /srv/mongodb/rs0-2

#### Run instances

	mongod --port 27017 --dbpath /srv/mongodb/rs0-0 --replSet rs0 --smallfiles --oplogSize 128
	mongod --port 27018 --dbpath /srv/mongodb/rs0-1 --replSet rs0 --smallfiles --oplogSize 128
	mongod --port 27019 --dbpath /srv/mongodb/rs0-2 --replSet rs0 --smallfiles --oplogSize 128


#### Enable replicaSet

	mongo --port 27017
	rs.initiate()
	rs.conf()
 	rs.status()

#### Add other instances as repliSet 

	* Login to 'primary' node by mongo client

	rs.add("<hostname>:27018")
	rs.add("<hostname>:27019")

#### Check ReplicatSet config
	* Login to any replicaSet instance

	rs.conf()
	rs.status()