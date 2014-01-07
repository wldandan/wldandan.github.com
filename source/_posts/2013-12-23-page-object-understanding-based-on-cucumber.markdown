---
layout: post
title: "Page Object Understanding"
date: 2013-12-23 11:39
comments: true
categories: Test
---

##什么是Page Object
Page Object是[Selenium](http://www.seleniumhq.org/)中提出的一种测试设计模式。在Web前端自动化测试的过程中，Page Object可以称得上是居家必备的良品之一。PageObject将与Web测试页面交互的行为封装在其内部，旨在将每个页面或者相似页面的功能封装，例如页面中需要测试的元素（按钮，输入框，标题等），这样，通过在测试中访问Page类的相应方法来获取页面相应的元素，从而巧妙的避免了当页面元素id或者位置变化时，需要修改测试代码的情况。

言而总之，总而言之，PageObject就是将Web页面元素的变化封装起来，提供API供外部测试代码调用，从而达到将测试代码于Web页面元素的变化解耦。

<!--More-->

##Page Object的优点

- 将测试代码与页面元素的操作解耦
- 将Web页面元素的访问统一化、规范化、结构化
- 封装不同浏览器对元素访问的差异
- 易于实现Web元素访问的DSL


对于小规模站点的Web自动化测试，直接使用Capybara之类的框架并不会出现问题。但对于业务复杂，功能完备的大规模Web站点自动化测试而言，如果不使用PageObject将测试代码于Web页面元素的访问解耦，而在测试代码中直接访问Web页面元素，不仅易造成冗余代码，还会导致测试集结构混乱，后期难于理解和维护。

##Gizmo

在最近的一个项目中，我们使用[Capybara](https://github.com/jnicklas/capybara)进行Web自动化测试，同时使用[Gizmo](https://github.com/icaruswings/gizmo)来完成PageObject的定义。
Gizmo出自[REA Group](www.realestat.com.au)之手，使用Nokogiri对Selenimu的Driver进行轻量级的封装，并定义自己的Page对象。


####使用Gizmo时注意的要点：

- PageObject可以是整个页面，也可是页面的某一小块。但都统称为Page Module。  
- PageObject被定义成module,而非class
- PageObject的命名为page_with_<module_name>, 而调用者则遵循on_page_with :<module_name>的模式进行调用
- PageObject使用define_action作为行为的定义，例如 点击button，填充form，输入文本等。
- PageObject使用def selectors作为获取属性的定义，例如获取页面对象，获取文本等。


####不过，Gizmo中也存在一些问题：
###### a) Page对象只对生成时的DOM元素有效。  
如果DOM元素随后发生变化(例如Javascript操作DOM), 则无法捕获到。需要显示的重新更新PageObject对DOM元素的引用。

    def refresh
      @document = Nokogiri::HTML(body)
    end


另外，作者貌似已经不再维护Gizmo了，上次的更新要追溯到3年前了。所以如果有不爽的地方，要做好fork&customize的打算。 :(


##Capybara-Page-Object(CPO)
了解完Gizmo，让我们来认识下Capybara-Page-Object。  
除了包含Gizmo现有的大部分优点之外，CPO对开发者更加友好：

#### Page与Component共同使用
在CPO中，Page的定义通常是指整个页面。而对于页面的某一块功能或者布局，通常被定义为Component。  
譬如，首页作为一个Page对象，可能会包含Login，BasicSearchForm，SearchResult等Component。  
而搜索页面，作为Page对象，可能包含Login，BasicSearchForm以及AdvancedSearchForm等Component。
换句话说，一个Page是由多个Component组成，而Component(如果Element类似)则又可以被不同的Page重用。


#### 对HTML元素的封装
在CPO中，实现了对HTML不同元素的分装。如Form，Image，List，ListItem, Select, Input等。

通过使用CPO封装后的HTML元素类，开发者可以更轻松的访问不同类型的HTML元素，而不必为每个心仪元素定义CSS或者Xpath查找策略。  
如下是CapybaraPageObject::Form的定义，其中已经提供了对Form内buttons，inputs，selects等内元素的访问接口。


    class Form < CapybaraPageObject::Element
        def fields
          r = ActiveSupport::OrderedHash.new
          r.merge! inputs
          r.merge! selects
          r.merge! textareas
        end
        
        def buttons
          r = []
          all('input').each do |element|
            input = Input.new(element)
            next unless input.button?
            r << element
          end
          all('button').each do |button|
            r << button
          end
          r
        end

        def inputs
          all('input').each_with_object(ActiveSupport::OrderedHash.new) do |input_tag, hash|
            input = Input.new(input_tag)
            next if input.button?
            if input.checkable?
              hash[input.key] = !! input.checked?
            else
              hash[input.key] = input_tag.value
            end
          end
        end

    	  def textareas
        		all('textarea').inject(ActiveSupport::OrderedHash.new) do |result, element|
            	textarea = Textarea.new(element)
    	        result.merge textarea.key => textarea.value
          	end
        end

        def selects
          	all('select').inject(ActiveSupport::OrderedHash.new) do |result, element|
    	        select = Select.new(element)
        	    result.merge select.key => select.value
          	end
       	end
    end

有了这些封装类，在定义Component时需要做的逻辑就很简单了

    module Pages
      module Components
        class SearchForm < CapybaraPageObject::Form

          def search(query)
            source.fill_in 'as_q',    :with => query
            source.click_button 'Search'
          end

        end
      end
    end

然后再Page中使用Component时，只需传入Form对应的Selector即可。

    module Pages
      module Search
        class Index < Pages::Base

          component(:search_form) do
            Components::SearchForm.new find('.advsearch')
          end

          def search(*args)
            search_form.search(*args)
          end
        end
      end
    end

关于本篇提到的代码，如有兴趣，请参考[我的cucumber-capybara示例](https://github.com/wldandan/cucumber-capybara)


