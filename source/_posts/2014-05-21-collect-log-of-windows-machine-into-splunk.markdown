---
layout: post
title: "Splunk - Receive logs from distributed Windows machine"
date: 2014-05-21 20:56
comments: true
categories: [Splunk] 
---

### Why do I need Splunk
Recently, our team is moving several legacy components running in Windows server from data-center to AWS. The transformation itself is not hard, but the eco-system like monitoring, alerting, troubleshooting is most important before getting started the transofrmation.
 
The article would talk about how to setup and config Splunk Universal Forwarder in Windows machine where the component is running. 

Bying using SUF, Splunk central server can easily collect logs from different distributed machines, so that the OPS guy can query and analyze the logs from one portal rather than login on different distributed machines.

<!--More-->

### Terminology
**SCS** (Splunk Central Server)

	It is the splunk server that OPS can access this machine and query or analyze the logs from distributed nodes.

**SUF **(Splunk Universal Forwarder)
	
	It is the component running in application server, which can forward log to Splunk Central Server.


### How to install SUF

1. Download [Universal Forwarder](http://download.splunk.com/products/splunk/releases/6.1.1/universalforwarder/windows/splunkforwarder-6.1.1-207789-x64-release.msi)

2. Run Universal Forwarder Wizard, following the [guide](http://docs.splunk.com/Documentation/WindowsApp/5.0.2/User/InstallauniversalforwarderonaWindowsserver)
	* Click 'Next' until "Receiving Indexer" dialog appears
	* In["Receiving Indexer" dialog] page, enter hostname with splunk central server and port with "9997".
	* Click 'Next' and finish the installation.			
3. Config Universal Forwarder
	* Open file "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf"
	* Append the following content into the file
	<pre>
		[monitor://C:\inetpub\logs\OnlinePayment*.log]
		ignoreOlderThan = 10d
		disabled = 0
		followTail = 0
		//logs will be grouped by index in splunk central server
		index = "listing"  
		//[Pre-defined source type](http://docs.splunk.com/Documentation/Storm/Storm/User/Sourcesandsourcetypes), or you can specify any value as you like
		sourcetype = "YOUR-SOURCE-TYPE"
	</pre>
	
	
	Please check the [doc](http://docs.splunk.com/Documentation/Splunk/6.1/admin/Inputsconf) to understand the meaning of each item above.
	
	
4. Restart Universal Forwarder	
	* Execute `cd "C:\Program Files\SplunkUniversalForwarder\bin"` in command line.
	* Execute `splunk restart` in command line.

#### Create new index in SCS

Right now, there is no index named 'listing', so we need to create a new index in splunk central server.

The step is as below:

  1. Login Splunk central server
  2. Click "Manager" menu at top right navigator and go to "Manager" page.
  3. Click "Indexes" and go to "Indexes" page.
  4. Click "New" and input "bs" as 'index name'
  5. Keep others blank and Click "Save"

### Summary 

It is time to cheer!
Your log should appear in Splunk Central Server, and you can enjoy it now.
