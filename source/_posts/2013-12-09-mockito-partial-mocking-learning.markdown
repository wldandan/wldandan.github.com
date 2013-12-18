---
layout: post
title: "Mockito - Partial Mock"
date: 2013-12-09 17:09
comments: true
categories: Test
---


Mockito是一个方便的java测试Mock工具。  

当我们做TDD或者单元测试的时候，为了消除当前被测对象和其依赖之间的关系，经常使用Mockito。  

关于Mockito的一般用法，请参照[Mockito](https://code.google.com/p/mockito/)。这里，只想提一下关于如何使用Mockito的Partial Mock。

###1. 什么是Partial Mock
在单元测试的过程中，偶尔会出现这种情况。对于一个对象,某些方法需要被mock,而某些方法希望直接调用，这时候，我们就需要使用Partial Mock。

###2. 两种Partial Mock方式

<!--More-->

##### a) 先Mock，然后CallRealMethod

    public class VersionInfoCheck {

        public String displayLatestVersion(){
            return "1.1.1";
        }

        public String displayCurrentVersion(){
            return "0.9.1";
        }

        public Boolean isUpgradable(){
            //Check Current Version
            //Check Latest Version
            //Compare
        }
    }

我们使用如下方式实现Partial Mock:

    @Test
    public void testPartialMockByCallRealMethod(){
        VersionInfoCheck check = mock(VersionInfoCheck.class);

        when(check.displayLatestVersion()).thenCallRealMethod();
        when(check.displayCurrentVersion()).thenReturn("current version");

        System.out.println(check.displayLatestVersion());
        System.out.println(check.displayCurrentVersion());
    }


在这个例子中，注意thenCallRealMethod的使用。   
当我们调用displayLatestVersion时,使用的是原始的实现。  
而使用displayCurrentVersion()时,使用的则是Mock结果"current version";


##### b) 先实例化，然后Spy

    @Test
    public void testPartialMockBySpy(){
        VersionInfoCheck check = spy(new VersionInfoCheck()); 
        when(check.displayCurrentVersion()).thenReturn("current version");

        System.out.println(check.displayLatestVersion());
        System.out.println(check.displayCurrentVersion());
    }

在这个例子中，先使用了spy(), 接着使用了when().thenReturn()来mock方法displayCurrentVersion。  
于是，当我们调用displayCurrentVersion时,使用的是mock的结果。  
而对于没有mock的方法displayCurrentVersion，使用的则是原来对象的真实方法。
因此，Spy的作用是将原本实例化的对象，加上Mock的功能。


###3. 区别
起初，偶比较倾向于使用CallRealMethod。因为该方法名足够表意，很容易就能理解其带来的用途。
不过，使用CallRealMethod却不是推荐的方式，为什么呢，请看如下代码：

    @Test
    public void testListPartialMockByCallRealMethod(){
        List<Integer> list = mock(ArrayList.class);
        when(list.add(100)).thenCallRealMethod();

        list.add(100);
        verify(list).add(100);
    }

代码没问题吧，不过运行后，却得到如下错误：

    java.lang.NullPointerException
        at java.util.ArrayList.add(ArrayList.java:352)
        at com.wl.tw.VersionInfoCheckTest.testListByCallRealMethod(VersionInfoCheckTest.java:59)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)


如果查看ArrayList.java:352的代码，就会发现

    350    public boolean add(E e) {
    351        ensureCapacity(size + 1);  // Increments modCount!!
    352        elementData[size++] = e;
    353        return true;
    354    }

在第352行，ArrayList实际上使用了另外一个对象elementData来存放新加入的元素。  

但是，请注意，在这个例子中，ArrayList是mock出来的，并不是真实创建出来的，所以mock的ArrayList并没有初始化这个elementData对象。这就是为什么会出现NullPointerException的原因。

###4. 总结

- 当使用mockito mock对象时，它并不会mock该对象内部的其他依赖对象。
- 当使用mockito partial mock时，注意spy和CallRealMethod的区别。
