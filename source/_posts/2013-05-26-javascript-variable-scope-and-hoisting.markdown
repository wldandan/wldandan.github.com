---
layout: post
title: "Understanding javascript variable scope &amp; hoisting"
date: 2013-05-26 22:10
comments: true
categories: Javascript
---
在这篇文章中，我将介绍Javascript中变量的作用域以及变量提升的一些相关知识。

##变量作用域
变量作用域是指变量存在的上下文环境，它表明了当定义一个变量后，代码如何能够访问该变量。基本上，Javascript的变量有两种：
局部变量和全局变量（废话，哪门语言没有这两种！）

<!--More-->
###局部变量
和其他的编程语言不太一样，Javascript并没有块作用域(使用{ xxx }定义的作用域)这个概念，取而代之的则是函数作用域的概念，而在函数作用域内使用var定义的变量就是局部变量。局部变量只能被所属函数作用域内的代码访问。譬如，如下代码的name是函数showName的局部变量，因此只能被showName函数内的代码访问到。

	function showName () {
		var name = "world"; 
		console.log (name); 
	}


###全局变量
全局变量区别与局部变量，这些变量的作用域是全局范围的，即程序中任何地方都能访问该变量。

#####1）任何定义在函数外的变量都是全局变量。
	var myName = "Hello";

	function showName(){
		console.log(window.myName); // Hello;
	}

	for (var i = 1; i <= 10; i++) {
		console.log (i); // i也是全局变量
	};

	console.log("myName" in window); // true

#####2）任何没有使用var关键字申明，就直接赋值的变量都是全局变量。
	function showName () {
		name = 'hello';
		console.log(name);
	}

	showName();
	console.log(name); 

#####3）减少全局变量的定义

如下的两个变量虽然都是全局变量，但实际上他们并不需要。

	var firstName, lastName;
	function fullName () {
		console.log ("Full Name: " + firstName + " " + lastName );
	}

重构后改成
	function fullName () {
		var firstName = "Hello", lastName = "World";
		console.log ("Full Name: " + firstName + " " + lastName );
	}


##变量提升

####所有在函数内部定义的变量，都会被执行‘变量提升’的过程。但是，只有变量的申明会被提升到顶部，变量的初始化或者赋值操作并不会。例如
	function showName () {
		console.log ("First Name: " + name); //undefined
		var name = "Hello";
		console.log ("Last Name: " + name);  //"Last Name: Hello"
	}
	showName (); 	

在如上的例子中，会先输出“undefined”，再输出“Last Name: Hello”，证明在执行第一句代码时，变量name实际上是已经存在的，只是undefine而已。
但是，如果执行如下代码，则JavaScript会报错:
	function showName () {
		console.log ("First Name: " + name); //undefined
	}
	showName (); 	

####函数申明的优先级会高于变量申明的优先级。
	var myName; 
	function myName () {
		console.log ("Hello");
	}
	console.log(typeof myName); // function

####但函数申明的优先级会低于于变量赋值的优先级。

	var myName = "Hello";
	function myName () {
		console.log ("World");
	}
	console.log(typeof myName); // string 	

##总结
变量的作用域和变量提升是Javascript比较基本，但是非常重要的两个特性。理解了这两部分，写代码的过程中应该就不会变量满天飞了吧。