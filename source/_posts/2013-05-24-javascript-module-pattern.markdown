---
layout: post
title: "Understanding javascript module pattern"
date: 2013-05-26 22:10
comments: true
categories: Javascript
---

##什么是Module Pattern?

Javascript，是面向对象但并不是面向对象编程的一门语言。在Javascript的世界里，你遇到的所有东西都是对象(如Function, Number, String等)，但它本身的语法中却不提供类(class)的关键字或者访问符(private, public, protected)等的定义。

不过，通过使用Module Pattern，我们可以有效的筑起一道屏障，让私有状态的变量或者方法只能在module的内部被访问，从而达到面向对象封装的目的。

<!--More-->
下面，先让我们来看一段代码，看看Module Pattern是如何帮助我们完成面向对象的封装的：
    var Module = (function(){
      var myPrivateVar = 0;
      var myPrivateMethod = function(msg){
      	console.log(msg);
      }

      return {
      	myPublicVar: "publicFoo",
      	myPublicMethod: function(msg){
      		myPrivateVar++;
      		myPrivateMethod(msg);
      	}
      }; 
    })();

在这段代码中，我们首先定义了一个全局变量Module，然后将一个匿名函数的执行结果赋值给该变量(注意变量得到的不是匿名函数本身，而是匿名函数的执行结果。因为最后一行()的使用，表示定义完匿名函数后就立刻执行了该函数)。

然后，从上面的匿名函数的执行结果中，我们可以看出，该结果并不是返回函数中定义的所有变量或者方法，而是定义了一个return的代码块，然后仅将该代码块里面的内容暴露出去。

因此，对于匿名函数中的myPrivateMethod方法而言，它的scope就被限定在了匿名函数内部，任何匿名函数外部的代码都是访问不到myPrivateMethod的，这样我们便隔离了外界对该方法的访问，也就通过module实现了面向对象的封装。

这种实现封装的方式就是Module Pattern，它能够帮助我们有效的封装内部的状态、变量或者方法。

##Module Pattern的关键

了解完上面的代码，现在让我们可以回顾一下Module Pattern的几个关键点：

####1. Module是一个全局变量
####2. Module中封装了私有的状态(变量或者方法)。
####3. 通过“return { xxx }”代码块的定义，Module对外部暴露变量或者方法。
####4. Module是自包含的并且在定义完后就立刻执行。


## Argumentation Module Pattern
在上面的例子中，你会发现这是一个很简单、而且相对标准的模版，因为它包括了基本Module的定义:private方法、private变量，以及暴露出来的public方法或者变量。因此，你可以很容易的将它用在项目中。其实，这种使用方式最早是在<JavaScript: The Good Parts>一书中提到。后来在Yahoo YUI 的Library中，得到了广泛的应用，如果你熟悉YUI，一定清楚里面的很多的实现都是采用这种方式。

不过，对于上面这种方式的实现，存在一个较明显的弊端:整个Module的定义只能在一个文件里完成，对于一些大型的应用，codebase已经很复杂了，如果再定义某个数千行以上的JS Module，这无疑大大增加了维护的难度，因此我们这里衍生出一个Argumentation Module Pattern，帮助我们将一个复杂Module的实现，拆分到多个行数较少的小文件里实现，

譬如说，对于一个复杂的Module，可能会分出几个相对独立的功能，例如A,B等等。那么这个时候，我们可以将这相对独立的三部分放在3个文件里实现：
首先定义一个专门处理A的文件module_a.js
  var Module = (function (s) {
  	......
  	s.a=function(){//Implementation of A part}
  	......
  	return s;
  }(Module || {}));


然后，再定义一个Module_b.js，专门处理该Module中B的部分
  var Module = (function (s) {
  	......
  	s.b=function(){//Implementation of B part}
  	......
  	return s;
  }(Module || {}));

类似的，可以根据具体Module的需要决定如何划分不同的js文件。

接下来可以在html页面上引用这两个js，然后使用里面的方法,类似如下：
  <html>
    <header>
      <script type="text/javascript" src="module_a.js"></script>
      <script type="text/javascript" src="module_b.js"></script>
    </header>
    <script>
      module.a();
      module.b()
    </script>
    <body>
    </body>
  </html>


## Sub-Module
对于一个复杂的项目，也可能会存在不同级别的Module，而不仅仅是对Module内部功能的划分。这时候我们就可以引入sub module的概念，代码如下所示：

  MODULE = (function () {
  	var my = {};
  	// ...

  	return my;
  }());

  MODULE.subA = (function () {
  	// ...
  }());

  MODULE.subB = (function () {
  	// ...
  }());

从上面的代码中，我们可以看出，只是利用Module以及Sub-Module对变量名称的定义，将其作为不同的命名空间，从而在逻辑上将其划分成模块和子模块。这种方式其实也是Javascript中最简单，最有效的结构组织的方式。


