---
layout: post
title: "Dora诞生记"
date: 2014-02-14 23:32
comments: true
categories: Hardware
---
趁着在墨尔本和西安Office上Hackday获奖的喜悦劲，赶紧来一篇Dora诞生记。    
提醒偶记住这个特殊的日子，同时也感谢在过去两个月，牺牲个人时间，奋斗在Dora(X-Robot)上的Casa的兄弟姐妹们。

#####-2013年10月20
和Charley午餐的时候，无意间谈论起了各自想做但没时间做的idea。  

幸运乎，找到一个我俩都认为不错但又没被完全实现的一个想法<<公交来了>>(**旨在帮助等车族们准确的掌握公交将来的时间，为既不想迟到又想多赖几分钟在床上的兄弟提供福音**)。

<!--More-->
#####-2013年10月25
借着Team Retro, 抛出了这个话题，“**是不是应该每周抽出点业余时间，让大家坐在一起，实现自己想实现但却一直没时间实现的Idea**”。  

为了保证大家能够集中火力在一个项目上，于是每个人都做了自己Idea的present，然后团队集体投票选出一个可以一起做的idea，并开工。  

为这个活动起了个洋气的名字**LBS** (Let's Build Something)，并且暂定为每周一晚6:00~8:00是我们的官方活动时间。

#####-2013年11月18
LBS有条不紊的进行着，<<公交来了>>也有了点小眉目。   

客户Enrico来访，茶余饭后闲聊之际，他提到了构建可远端操控的小车的想法，目的让更多的Casa guy们知道西安的团队如何工作，例如站会，Rero，Piar，以及如何敏捷的交付等等。    

我自然也聊到了我们的LBS以及正在做的 <<公交来了>>。 

#####-2013年11月24
邀请Enrico参加了我们的LBS，X-Robot的火花被果断擦出，旨在构建一个能控制其移动并回传视频的机器人，方便Italia和Xi'an Office更加随意的沟通。   
  
#####-2013年12月10
经过几天的探索，技术选型基本确定:    
* 使用**NodeJS**构建服务器端应用。   
* 使用**WebRTC**处理视频部分。   
* 使用**Arduino**作为X-Robot的控制芯片。    
* 构建**Android Native App**控制Arduino。    
* 使用**WebSocket**为用户提供UI的控制接口。    
   
#####-2013年12月22
淘宝上买的Arduino到货。在Team掀起了一阵研究Arduino的热潮。    
同时，被告知卖家发的小车出了点问题，需要再等，捉急。
   
#####-2014年1月7
超级无敌高大上的小车到了，立马组装之。    
Android的Native APP有了雏形，使用USB将手机连接到Arduino，能够发出控制信号了。    
使用Arduino可以控制X-Robot的**前进**，**后退**了。
   
#####-2014年1月20
集成WebRTC，WebSocket到Android Native APP。    
**前进、后退、优雅的转弯、视频传输**都没问题啦。
   
#####-2014年2月7
小伙伴卿带着X-Robot踏上了去Melboune的HackDay之路。

#####-2014年2月14
X-Robot有了一双迷人的大眼睛并正式命名为"**Dora**"。    
小家伙不负众望，为我们赢得了“**The ‘Marvin‘ Winners for innovation**”奖项。
   
至此，Dora诞生了。接下来，我们会为Dora提供更多有意思的功能，敬请期待 :)   