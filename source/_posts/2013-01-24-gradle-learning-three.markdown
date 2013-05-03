---
layout: post
title: "Gradle Learning - 3 (multiple projects)"
date: 2013-01-24 18:20
comments: true
categories: [Gradle]
---

 随着信息化的快速发展，IT项目变得越来越复杂，通常都是由多个子系统共同协作完成。对于这种多系统、多项目的情况，很多构建工具都已经提供了不错的支持，像maven、ant。Gradle除了借鉴了ant或者maven的继承的方式定义子项目，也提供了一种更为方便的集中配置的方式，大大减少了构建带来的复杂度。除此之外，Gradle还提供了清晰的Project树模型来映射多项目的组织结构。下面，让我们了解一下如何使用Gradle构建多项目。
 

###1. 多项目定义及结构

 在Gradle中，使用文件settings.gradle定义当前项目的子项目，格式如下所示： 

include 'sub-project1', 'sub-project2', 'sub-project3'，
它表示在当前的项目下建立三个子项目，分别为'sub-project1', 'sub-project2', 'sub-project3'。默认情况下，每个子项目的名称对应着当前操作系统目录下的一个子目录。

<!--More-->

当Gradle运行时，会根据settings.gradle的配置情况，构建一个单根节点的项目树。其中的每个子节点代表一个项目(Project)，每个项目都有一个唯一的路径表示它在当前树中的位置，路径的定义方式类似:

Root:<Level1-子节点>:<Level2-子节点>:<Level3-子节点>
也可以简写成“:<Level1-子节点>:<Level2-子节点>:<Level3-子节点>”。借助这种路径的定义方式，我们可以在build.gradle去访问不同的子项目。另外，对于单项目，实际上是一种特殊的、只存在根节点，没有子节点的项目树。

例如，我们有个产品A，包括以下几个组件core，web，mobile。分别代表"核心逻辑"、"网站"、“手机客户端”。 因为每个组件是独立的部分，这个时候最好我们能定义多个子项目，让每个子项目分别管理自己的构建。于是我们可以这样定义A/settings.gradle

include 'core', 'web', 'mobile'
按照之前描述的，core组件对应A/core目录，web组件对应A/web目录，mobile组件对应A/mobile目录。接下来，我们就可以在每个组件内部，定义build.gradle负责管理当前组件的构建。

Gradle提供了一个内建的task 'gradle projects'，可以 帮助我们查看当前项目所包含的子项目，下面让我们看看gradle projects的输出结果：

	$ gradle projects
	:projects
	------------------------------------------------------------
	Root project
	------------------------------------------------------------
	Root project 'A'
	+--- Project ':core'
	+--- Project ':mobile'
	\--- Project ':web
结果一目了然，首先是Root级别的项目A，然后是A下面的子项目'core', 'mobile', 'mobile'

最终的文件以及目录结构如下所示：

	A
	   --settings.gradle
	   --build.gradle
	   --core
	     --build.gradle
	   --web
	      --build.gradle
	   --mobile
	      --build.gradle
如果你不喜欢这种默认的结构，也可以按照如下方式定义子项目的名称和物理目录结构：

	include(':core)
	project(':core').projectDir = new File(settingsDir, 'core-xxx') 

	include(':web)
	project(':web').projectDir = new File(settingsDir, 'web-xxx') 

	include(':mobile)
	project(':mobile').projectDir = new File(settingsDir, 'mobile-xxx') 
在这个例子中，子项目core实际上对应的物理目录为A/core-xxx，web实际上对应的是A/web-xxx，mobile也类似。

虽然我们更改了子项目的物理目录结构，不过由于我们在build.gradle中使用的是类似 “ :<SubProject>”的方式访问对应的子项目，所以目录结构的改变，对我们Gradle的构建脚本并不会产生影响。

接下来，考虑一个更复杂的情况，随着产品的发展，mobile这个组件慢慢的划分成了Android和IOS两个部分，这时我们只需要在目录A/mobile下定义新的settings.gradle，并加入如下部分：

	include 'android', 'ios'
现在，mobile组件下将存在两个新的子项目 "android"和"ios"

于是，这时候'gradle projects'的目录结构就变成

	A
	   --settings.gradle
	   --core
	      --build.gradle
	   --web
	      --build.gradle
	   --mobile
	      --settings.gradle
	      --ios
	        --build.gradle
	      --android
	        --build.gradle

###2. 多项目的集中配置

对于大多数构建工具，对于子项目的配置，都是基于继承的方式。Gradle除了提供继承的方式来设置子项目，还提供了另外一种集中的配置方式，方便我们统一管理子项目的信息。下面看一个例子，打开A/build.gradle，输入如下部分：

	allprojects {
	    task hello << {task -> println "I'm $task.project.name" }
	}
	subprojects {
	    hello << {println "- I am the sub project of A"}
	}
	project(':core').hello << {
	      println "- I'm the core component and provide service for other parts."
	}
对于上面所示的代码，已经很表意了：

allprojects{xxx}  这段代码表示，对于所有的project，Gradle都将定义一个名称是hello的Task { println "I'm $task.project.name"} 。

subprojects{xxxx}的这段代码表示，对于所有的子project，将在名称为hello的Task上追加Action {println "- I am the sub project of A"}

注意：关于Task和Action的关系，请看我之前写的本系列的第一部分。

project(':core')的这段代码表示，对于名称为core的project，将在名称为hello的Task上追加Action { println "- I'm the core component and provide service for other parts." }


###3. 多项目的Task执行

之前我们已经了解了多项目的结构以及如何通过路径去访问子项目。现在让我们看看如何使用Gradle来执行多项目。

在Gradle中，当在当前项目上执行gradle <Task>时，gradle会遍历当前项目以及其所有的子项目，依次执行所有的同名Task，注意：子项目的遍历顺序并不是按照setting.gradle中的定义顺序，而是按照子项目的首字母排列顺序。

基于刚才的例子，如果我们在根目录下，执行gradle hello，那么所有子项目的“hello” Task都会被执行。如果我们在mobile目录下执行gradle hello,那么mobile、android以及IOS的“hello” Task都会被执行。关于该例子的运行结果，这里就不贴出来了。大家如果有兴趣的话可以试试。


###4. 总结
这篇文章主要描述了使用Gradle管理多项目的知识。相比Ant或者Maven，Gradle提供了更灵活的配置方式。更重要的是，Gradle还提供了很多内建的Task帮助我们查看或者管理项目。这次就先聊到这里，下次我们来看看Gradle的生命周期。
