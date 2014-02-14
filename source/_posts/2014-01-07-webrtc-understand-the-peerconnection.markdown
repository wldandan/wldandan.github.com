---
layout: post
title: "WebRTC - Understand the PeerConnection"
date: 2014-01-07 18:55
comments: true
categories: WebRTC
---

在上篇文章里，我们已经了解了MediaStream。那么这篇文章里，我们就来重点了解RTCPeerConnection。

RTCPeerConnection表示浏览器之间点对点的连接。只有当连接建立后，浏览器的两端才能真正完成流媒体数据的传输。

还记得之前讨论过的WebRTC架构图吗？
实际上，虽然RTCPeerConnection是一个暴露的连接接口，
但其内部封装了大量WebRTC编解码和协议处理的工作，因此使浏览器之间点到点的即时通讯变得简单。

<!--More-->
#### 什么是信令处理(Signaling)

WebRTC使得浏览器之间能够点对点通信，但是作为浏览器的一端，茫茫大海，如何知道另一端在哪里？怎么能通过网络连接到对端？如何知道是否能够连接成功？

所以，即便是点对点通信，依然需要服务器协助双方建立连接。不过此时的服务器，其职责更多的是 交换元数据，如编解码机制、数据加密、流量控制等信息。

对于这些看似不重要但却必要的信息交换过程，我们称之为信令处理。

<img src="{{ root_url }}/images/webrtc/webrtc-signaling.png" />

#### NAT、防火墙和现实的网络世界

NAT(Net Address Translation)是负责网络地址转换的一个协议。通俗的说，它负责把私网内的的IP和端口转换成公网的IP和端口，也即使我们所说的IP地址映射。

由于IPv4地址的数量有限，大多数企业或者团体通常都使用局域网地址，并通过NAT转换，连接到互联网上。另外，
许多企业内部网络都存在防火墙，因此这就为点对点通信带来寻址问题。

<img src="{{ root_url }}/images/webrtc/nat.png" />

[STUN](http://en.wikipedia.org/wiki/STUN),TURN,ICE是由IETF提出的处理网络中NAT穿越问题的协议族。
STUN能够为NAT后的终端定位公网地址，因此它可以被用来在两个同时处于NAT之后的终端建立UDP通信。
TURN是STUN协议的一个增强版，能够通过中继的方式帮助处于NAT之后的终端建立TCP连接。ICE则是综合STUN及TURN的产物，是一个框架。

使用STUN服务器后，通信双方能够完成NAT穿透，从而建立连接，如下图所示：

<img src="{{ root_url }}/images/webrtc/stun.png" />

使用TURN服务器后，通信双方需要通过中继完成NAT穿透，从而建立连接，如下图所示。从某种角度而言，这种方式已经不是传统意义上的点对点连接了，因为它依赖于中继服务器完成数据的传输。

<img src="{{ root_url }}/images/webrtc/turn.png" />


#### 建立RTCPeerConnection

了解了STUN，TURN的相关概念后，是深入了解PeerConnection的时候了。

当创建RTCPeerConnection时，需要指定两个参数：

- 包括STUN或者TURN服务器的列表。
- 对于协议元数据的参数设置。

```
  var SERVER = {
    iceServers: [
        {url: "stun:23.21.150.121"},
        {url: "stun:stun.l.google.com:19302"},
        {url: "turn:numb.viagenie.ca", credential: "xxxx", username: "xxx"}
    ]
  };


  var OPTIONS = {
        optional: [
          {DtlsSrtpKeyAgreement: true},
          {RtpDataChannels: true}
        ]
  };
  peerConnection = new RTCPeerConnection(SERVER, OPTIONS);

```

  

注意，当RTCPeerConnection执行连接时，首先会尝试使用STUN服务器来协助完成，如果失败，则使用TURN中继服务器完成通信。	


#### 开始通信

通信的过程如下如所示:
<img src="{{ root_url }}/images/webrtc/peerconnection-process.png" />

##### 主动发起者将使用createOffer发起连接，并设置SDP(Session Description Protocol)相关信息.

```
  navigator.getUserMedia({video: true}, function(stream) {
    var video = document.getElementById("video");
    video.srcObject = stream;
    video.play();
    pc.addStream(stream);

    pc.createOffer(function(offer) {
      pc.setLocalDescription(new RTCSessionDescription(offer), function() {
        // send the offer to a server to be forwarded the friend you're calling.
      }, error);
    }, error);
  }
```

##### 对端接受者，收到setRemoteDescription并使用createAnswer回复连接请求。

```
  navigator.getUserMedia({video: true}, function(stream) {
    var video = document.getElementById("video");
    video.srcObject = stream;
    video.play();
    pc.addStream(stream);

    pc.setRemoteDescription(offer, function() {
      pc.createAnswer(function(answer) {
        pc.setLocalDescription(new RTCSessionDescription(answer), function() {
          // send the offer to a server to be forwarded to the caller
        }, error);
      }, error);
    }, error);
  }
```

##### 主动发起者，处理对端发回的响应，并设置setRemoteDescription信息。

```
  var offer = getResponseFromFriend();
  pc.setRemoteDescription(new RTCSessionDescription(offer), function() { }, error);
```

#####总结: 

* 创建RTCPeerConnection对象, 指定相关的STUN、TURN服务器。
* 每个RTCPeerConnection对象都关联一个ICE agent。当创建该对象时，ICE agent的相关状态会被初始化。
* 每个RTCPeerConnection对象关联两个流媒体集合。
- 本地流媒体集合(Local stream set), 本地流媒体集合代表当前发送的数据流，
- 远程流集合(Remote stream set), 远程流媒体集合代表RTCPeerConnection对象接收到的流