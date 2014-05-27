---
layout: post
title: "Asgard: awesome tool for AWS deployment"
date: 2014-05-27 20:55
comments: true
categories: AWS
---

Asgard is named for the home of the Norse god of thunder and lightning. As the words described, it is closely relevant to the management and control in cloud.
Netflix build a tool named Asgard, who is using it to control and manage their AWS cloud.  In 2012, Netflix announced that Asgard was open-sourced.


##What is Asgard 

* Web-based cloud management and deployment tool, built on the top of [grails](https://grails.org/).
* By introducing `Application` and `Cluster` terminology, enable users understand their cloud objets clearly.
* Keep track cloud objects from the view of one application


##Why needs Asgard
The AWS Management Console has its uses for someone with your Amazon account password who needs to configure something Asgard does not provide. However, for everyday large-scale operations, the AWS Management Console has not yet met the needs of the Netflix cloud usage model, so we built Asgard instead. Here are some of the reasons.

* Hide the Amazon keys

  Asgard provides an internal console allows us to grant users access to our Amazon accounts without telling too many employees the shared cloud passwords. This strategy also saves us from needing to assign and revoke hundreds of Identity and Access Management (IAM) cloud accounts for employees.

* Auto Scaling Groups
		
	AWS Management Console lacks support for Auto Scaling Groups (ASGs). ASGs are good scaling features to provide reliability, redundancy, cost savings, clustering, discoverability, ease of deployment, and the ability to roll back a bad deployment quickly.
	
* Logging

	AWS console does not expose a log of recent user actions on an account. This makes it difficult to determine whom to call when a problem starts, and what recent changes might relate to the problem. Lack of logging is also a non-starter for any sensitive subsystems that legally require auditability.
	
* Simplify REST API
	
	For common operations that other systems need to perform, we can expose and publish our own REST API to do exactly what we want in a way that hides some of the complex steps from the user.

* Naming Conventions

	Like any growing collection of things users are allowed to create, the cloud can easily become a confusing place full of expensive, unlabeled clutter. Asgard is using registered services associated with cloud objects by naming convention. Asgard enforces these naming conventions in order to keep the cloud a saner place that is possible to audit and clean up regularly as things get stale, messy, or forgotten.

##What Asgard can do

<img src="http://2.bp.blogspot.com/-bn3mWGhb7Zo/T-S2bKpJZDI/AAAAAAAACnw/0xH5-M7oboc/s1600/cloud-model-diagram-625.png" />

Here’s a quick summary of the relationships of these cloud objects.

* An Auto Scaling Group (ASG) can attach zero or more Elastic Load Balancers (ELBs) to new instances.
* An ELB is used to send user traffic to instances.
* An ASG can launch and terminate instances.
* For each instance launch, an ASG uses a Launch Configuration.
* The Launch Configuration specifies which Amazon Machine Image (AMI) and which Security Groups to use when launching an instance.
* Security Groups can restrict the traffic sources and ports to the instances.

More functionality, please check the [documentation](https://github.com/Netflix/asgard/wiki/Quick-Start-Guide)


##Summary
As the AWS is becoming more common for deployment, as the infrasutre of web site is becoming more complex, Asgard would be star to make our life easier to manage and deploy our product.