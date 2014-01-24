---
layout: post
title: "WebRTC - Understand the MediaStream"
date: 2014-01-06 23:59
comments: true
categories: WebRTC
---

WebRTC从设计之初，目的就是为开发人员提供更加简便的方式构建基于Web的视频、音频应用。对于任何的WebRTC应用程序，只需要做如下几件事情：

- 1）获取本地媒体流(音频、视频)。
- 2）与对端建立连接(包括防火墙和NAT的穿透)。
- 3）初始化双方通信信道。
- 4）交换通信元数据信息，比如分辨率、编解码方案、网络地址等。
- 5）开始音频，视频或数据的通信。

<!--More-->

为了完成这个过程，WebRTC提供了三个主要的对象接口：

- MediaStream
- RTCPeerConnection
- RTCDataChannel

在这篇文章里，我们先来看看如何使用MediaStream。

MediaStream代表一个抽象的流媒体对象，通常是音频或视频的内容。每个媒体流对象中，包含零个或多个轨道（MediaStreamTrack)，用来显示并控制该流媒体对象的输入源名称，如音频还是视频，特征或者状态，同时也能控制如静音、开始或者结束等。

每个MediaStream都有输入和输出，输入一般由navigator.getUserMedia()（下面会详细介绍）生成，而输出则可以控制该流媒体对象如何被使用，例如存储到文件，显示在在video元素中，或者绑定到RTCPeerConnection的连接上。

<img src="{{ root_url }}/images/webrtc/media-stream.png" />

getUserMedia()是浏览器提供的获取音频和视频媒体流的API。对于捕获到的流媒体，其和信号源是紧密相关的，如麦克风只能发出音频流，摄像头只能发出视频流。对于某些高清摄像头，可以产生高清的视频流。

当使用getUserMedia() 获取视频或音频的媒体流时，需要指定三个参数：

* 设置流媒体的配置参数
* 获取视频成功的回调函数
* 获取视频失败的回调函数

		
        <video autoplay></video>
	    <script>
		    var constraints = {
				audio: true,
				video: { 
		    	  	mandatory: {  
		        		width: { min: 320 },
		        		height: { min: 180 }},	        
		      		optional: [{	        	 
			          	width: { max: 1280 }, 
			          	height: { max: 720 }},	        
		        	    { frameRate: 30 }]
		        }
		    }
		 
		    function successCallback(stream) {
			    window.stream = stream; 
			    var video = document.querySelector("video");
			    video.src = window.URL.createObjectURL(stream);
			    video.play();
			}

			function errorCallback(error){
			    console.log("navigator.getUserMedia error: ", error);
			}

			navigator.getUserMedia(constraints, gotStream, logError);  
		</script>


在如上所示的Javascript代码中，
首先定义了对象constraints，包括容许获取视频、音频，以及获取视频时，可接受的最小分辨率以及可选最大分辨率。  
然后定义了获取媒体流成功时的处理函数successCallback和失败的处理函数errorCallback。  
最后，使用navigator.getUserMedia()获取视频和音频的媒体流。  


