---
layout: post
title: "Arduino, Make Hardware development easy"
date: 2013-12-18 17:02
comments: true
categories: Hardware
---


顺应Open Hardware的潮流，Team里最近买了块 Arduino的板子。于是乎，偶也就有个机会，能倒腾倒腾了。

### 介绍 
Arduino 是一个开源、易于使用的硬件设备。其上的微控制器可以通过Arduino Style的编程语言来编写程序，编译成二进制文件，并烧录进微控制器。
Arduino 能通过各种各样的传感器来感知环境，通过控制灯光、马达和其他的装置来反馈、影响环境。和传统的单片机有点类似，但是更易于使用，对于开发者也更加友好。


### 环境搭建
- 当然，先买块Arduino的板子。国内的商家'奥松'还不错（非广告贴，只是个人经验），可以天猫之。:)

<img src="{{ root_url }}/images/arduino/arduino.png" />


- 下载[Arduino IDE](http://arduino.cc/en/Main/Software)， 开发更容易。

<!--More-->

### 跑起第一个程序

- 接上USB，为Arduino提供电源

<img src="{{ root_url }}/images/arduino/power.png" />

- 连上发光二极管
  将二极管的一根引脚接在Arduino的GND，另一根引脚接在Arduino的一个控制口，例如引脚13。
  我使用了面包板，连接后如图所示:
  
<img src="{{ root_url }}/images/arduino/diode.png" />


- 烧录程序到Arduino
  启动 Arduino IDE
  打开File->Exapmle->01.Basic->Blink，点击Upload，就能看到跑马灯的效果啦。
  
如图所示  

<img src="{{ root_url }}/images/arduino/blink.png" />

这里，我们使用的是Arduino IDE自带的例子，当然也可以自己编程，实现不同的效果。    

感兴趣的兄弟可以自行研究一下啦

### 总结

使用类似的方式，将Arduino的输出连接到其他设备上，然后再加上电源或者其他放大器，就能实现硬件开发了。  
  
接下来，我们的目标是使用Arduino实现一个四轮的小车，并能够远程控制它，前进、后退，加速等。

感兴趣的兄弟们不要忘了关注啊。:)





