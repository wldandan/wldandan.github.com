---
layout: post
title: "Gradle Learning - 1 (basic concepts)"
date: 2013-01-23 10:58
comments: true
categories: [Gradle] 
---

###前提： 安装Gradle
安装过程非常简单: 

(1)下载Gradle (2)设置GRADLE_HOME  (3)将GRADLE_HOME/bin/gradle加入$PATH


###1.基本概念(Project 和 Task)

Gradle中有两个基本的概念：project和task。每个Gradle的构建由一个或者多个project构成(有且仅有一个root-project以及多个可能存在的sub-project)，代表着需要被构建的根项目以及可能包括的多个子项目。每个project由一个或者多个task组成,而task则是Gradle构建过程中可执行的最小单元。譬如，当构建一个Java项目时，可能需要先编译、打包、然后再发布，这其中的每一个动作，都可以定义成一个task。



###2.构建第一个Task
和Ant运行时读取build.xml类似，Gradle运行时默认会读取build.gradle这个文件, 当然你也可以使用参数"-b"来指定其他的gradle文件。

下面，让我们新建一个build.gradle文件，然后输入如下内容:

	task hello {
		doLast{
			println "hello world"
		}
	}

<!--more-->
这个构建的脚本很简单，只是简单的打印出hello world。为了执行这个构建，我们应该在当前目录下执行"gradle hello"，即gradle {TaskName}。其中，doLast意思是定义一段code(映射Gradle中的Action类)，并将其放在task的最后执行。类似的，还有doFirst，表示将定义的code放在当前task的最前面执行，例如

	task hello {
		doLast{
			println "Hello world"
		}   
		doFirst{
			println "I am twer"
		}   
	}

执行gradle hello, 将输出
	"I am twer"
	"Hello world"

另外，你也可以使用如下更简洁的方式来定义task：
	task hello <<  {
		println "hello world"
	}

这里也许大家可能会觉得很奇怪，为什么可以用"<<"来定义Task的执行内容呢，还是让我们看看Gradle的代码是怎么实现的吧:
	public abstract class AbstractTask implements TaskInternal, DynamicObjectAware {
		private List<Action<? super Task>> actions = new ArrayList<Action<?   super Task>>();
 
 		public Task doFirst(Action<superTask> action) {
			if (action == null) {
				throw new InvalidUserDataException("Action must not be null!");
			}
			actions.add(0, wrap(action));
			return this;
		}
 
		public Task doLast(Action<superTask> action) {
			if (action == null) {
				throw new InvalidUserDataException("Action must not be null!");
			}
			actions.add(wrap(action));
			return this;
		}

从上面的代码可以看出，Task类里有个Action的集合actions，当使用doFirst或者
doLast时，实际上是将定义的执行代码部分实例化成Action的对象，然后添加到
actions集合里。

明白了这一点，接下来让我们看看为什么可以使用`<<`定义Task:
##### 其实，作为JVM上的一门动态语言，Groovy早已经帮我们重载了 << 操作符，使得我们可以方便的使用 << 向集合添加元素。

说道这，相信真相已经大白了：原来就是使用Groovy的<<操作符，向集合actions里添加Action的实例而已。对，这就是Gradle的语法，利用Groovy的DSL，帮助我们更容易的定义构建脚本。不过也许大家会觉得，这个例子实在是没有什么代表性，只是一个简单的 hello world，说明不了什么问题。好吧，别着急，下次我们会继续研究Gradle的其他部分，不过先记住：

#####作为一个Java构建工具，这是历史的转变，因为程序猿已经可以随心所欲的使用代码，而不是XML配置的方式实现构建了。
