---
layout: post
title: "Mockito - Partial Mock"
date: 2013-12-09 17:09
comments: true
categories: Test
---


Mockito是一个方便的java测试Mock工具。  

当我们做TDD或者单元测试的时候，为了消除当前被测对象和其依赖之间的关系，经常使用Mockito。  

本篇文章只涉及如何使用Mockito的Partial Mock。关于Mockito的其他用法，请参照[Mockito](https://code.google.com/p/mockito/)

###1. 什么是Partial Mock
在单元测试的过程中，偶尔会出现这种情况。对于一个对象，某些方法需要被mock,而某些方法希望被直接调用，这时候，我们就需要借助Partial Mock。


###2. 使用Partial Mock的场景

在如下两种场景中，Partial Mock就显得相当犀利：
#### a) 测试存在具体方法的抽象类
```
public abstract class AbstractHandler {

    public String greet() {
        return "Hello " + fetchName() + "!";
    }
 
    protected abstract String fetchName();
}
```
如上代码所示，抽象类AbstractHandler中定义了方法greet()，并且该方法存在一定逻辑。
此时，如果希望测试greet()，可以选择两种方式：  

- 构建其派生非抽象类，如ConcertHandler，再进行测试。  
- 使用Partial Mock，它可以省去构建派生类的步骤，直接对该抽象类进行测试，代码如下所示:       

```
public class AbstractHandlerTest {
		
    @Test
    public void shouldCallRealMethodsAndFakeAbstractMethod() {
        AbstractHandler handler = mock(AbstractHandler.class);

        when(handler.greet()).thenCallRealMethod(); 
        when(handler.fetchName()).thenReturn("Geek");

        assertThat(handler.greet(), is("Hello Geek!"));
    }
}

```
如代码所示，对于抽象方法fechName()，直接mock其返回值
    when(handler.fetchName()).thenReturn("Geek");

对于被测方法greet()，则使用thenCallRealMethod()使Mock对象调用真实的实现方法。
    when(handler.greet()).thenCallRealMethod();


#### b)测试过分依赖于I/O操作的类


```

public class BooksController {

    protected Map<String, Date> fetchBooks(){
        //fetch the books from different publishing company.
        service1.retrieveBooks();
        service2.retrieveBooks();
        ......
        service10.retrieveBooks();

    }

    protected List<String> getPublishedBooks(){

        books = fetchBooks();
        //only pick up the books published.
    }
}
```

如上代码所示，类BooksController中定义了方法fetchBooks()，并且该方法严重依赖于I/O操作。因为fetchBooks()从不同的供应商那里获取最近的书籍信息。

对于这种测试，也有两种方案：

- Mock所有的service返回结果，然后测试getPublishedBooks()。

```
doReturn(xxxx).when(service1).retrieveBooks()
doReturn(xxxx).when(service2).retrieveBooks()
doReturn(xxxx).when(service3).retrieveBooks()
```

- 除此之外，也可以考虑在测试getPublishedBooks()的时候，对fetchBooks()方法进行mock。如下所示：

```
public class BooksControllerTest {

    @Test
    public void shouldReturnPublishedBooks(){
        BooksController controller = spy(new BooksController());

        Map<String, Date> books = new HashMap<String, Date>();
        books.put("XXX1", "2014-2-1");
        books.put("XXX2", "2014-3-1");

        doReturn(books).when(controller).fetchBooks();

        assertThat(controller.getPublishedBooks(), is(....));
    }

}
```

在如上的代码中，controller是BookController一个真实的实例，非mock对象。  原因是当前被测类为BooksController，因此不能将该类的实例定义成mock。  
另外，controller的fetchBooks()方法虽然被partial mock了，但其他的方法还是该实例真正的方法。  

因此，Spy的作用是将原本被实例化的对象，附上了Mock的功能。

#####注意，该场景完全是为了演示Partial mock。在实际情况中，如将books作为实例变量，并提供setBooks(List books)方法，根本不需要mock就能完成对getPublishedBooks的测试。另外，对于这种使用Spy的Partial Mock场景，大多数情况也是因为类的设计违背了SRP原则。


###3. 两种Partial Mock方式

让我们再回顾一下上面的例子，并总结一下Partial Mock的两种用法: 

- 使用Mock构建对象，再使用CallRealMethod指定某方法为真实调用。

- 实例化对象，定义Spy，再使用doReturn(xxx).when(xxx).method()


###4. 区别
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

在这个例子中，由于ArrayList是mock的，并不是实例化出来的，所以mock的ArrayList并没有初始化elementData对象。这就是为什么会出现NullPointerException的原因。

###5. 总结

- 当使用mockito mock对象时，它并不会mock该对象内部的其他依赖对象。
- 当使用mockito partial mock时，注意spy和CallRealMethod的区别。
