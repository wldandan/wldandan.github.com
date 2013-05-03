---
layout: post
title: "Gradle Learning - 4 (files&amp;direcoties)"
date: 2013-01-25 06:20
comments: true
categories: [Gradle] 
---

在我们使用Gradle构建项目的过程中，免不了要经常和文件打交道，譬如文件拷贝、文件重命名、生成压缩包等。在这方面，Gradle已经提供了非常好的支持，下面我们就来尝试一下如何使用Gradle提供的方式，操作文件或者目录。

###1. 文件访问
####1). 访问单个文件或者目录

file()将帮助我们访问相对于当前project的文件或者目录，注意不是相对当前的工作目录。因为我们有可能通过参数-p指定运行Gradle脚本的目录，而并不一定非要进入到该目录后再运行gradle。譬如在下面的例子中，当前工作目录是home目录，而gradle当前project的目录则是~/work/project1/
	~> gradle -p ~/work/project1 tasks


<!--More-->
接下来，让我们看几个简单的例子.

	// Use String for file reference.
	File wsdl = file('src/wsdl/sample.wsdl')
	// Use File object for file reference.
	File xmlFile = new File('xml/input/sample.xml') 
	def inputXml = project.file(xmlFile)

	//check file exists
	def readme = project.file('README', PathValidation.EXISTS)

	//check file or directory
	def license = project.file('License.txt', PathValidation.FILE)
	def dir = project.file('config', PathValidation.DIRECTORY)

####2). 访问多文件或者目录
和file()类似，如果访问多个文件或者目录，则使用files()

	def combined = files('README', 'INSTALL')
 	// Use a Collection with file or directory names.
	def listOfFileNames = ['src', 'test']    def mainDirectories = files(listOfFileNames)

####3). 过滤文件或者目录

除此之外，我们可以使用fileTree()获取文件/目录列表，并使用include或者exclude过滤感兴趣的文件
	def srcDir = fileTree('src/main').include('**/*.java')

	// Use map with arguments to create a file tree.
	def resources = fileTree(dir: 'src/main', excludes: ['**/*.java,'**/*.groovy'])


	// Use closure to create file tree
	def javaFiles = fileTree {
	    from 'src/main/java'
	    exclude '*.properties' 
	}

###2. 文件拷贝
  Gradle内建了一个Copy task，而该task中使用了CopySpec接口（org.gradle.api.file.CopySpec）。通过配置这个task，实际上是调用了CopySpec接口提供的方法，来完成拷贝的工作。譬如如下所示的from(), into()等：
	
	task simpleCopy(type: Copy) {
	     from 'src/xml‘      into 'definitions'
	 }

   其中，from表示拷贝源目录，dist表示拷贝的目标目录，执行时将拷贝元目录下的文件但不包括目录本身。下面我们看一个复杂的例子：

	task copyTask(type: Copy) {
	    // Copy from directory
	    from 'src/webapp'
	    // Copy single file
	    from 'README.txt'
	    // Include files with html extension.
	    include '**/*.html', '**/*.htm'
	    // Use closure to resolve files.
	    include getTextFiles
	    exclude 'INSTALL.txt'
	    // Copy into directory dist
	    // resolved via closure.
	    into getDestinationDir

	}

###3. 文件重命名
实际上，CopySpec接口已经提供了rename()方法，因此我们可以类似上面的方式配置Copy Task，完成对文件的重命名。
	task copyAndRename(type: Copy) {
		from 'src'
		// Change extension .txt to .text.
		rename '(.*).txt', '$1.text'
		// Rename files that start with sample-
		// and remove the sample- part.
		rename ~/^sample-(.*)/, '$1'
		into 'dist'
	}

###4. 文件打包
和拷贝文件非常类似，Gradle内建了Zip, Tar, Jar, War, and Ear等task帮助我们实现文件的打包。不过，比拷贝文件稍微复杂一点的是，当生成压缩包的时候，Gradle会使用一些属性来决定压缩包的文件名：
	[baseName]-[appendix]-[version]-[classifier].[extension]	

如果没有设置其中的某个属性，也没有问题，只是该属性不会出现在压缩包的文件名上。下面例子将生成一个名为`dist-files-archive-1.0-sample.zip`的压缩包：
	task archiveDist(type: Zip) {
	   from 'dist'
	   
	   baseName = 'dist-files'
	   appendix = 'archive'
	   extension = 'zip'
	   version = '1.0'
	   classifier = 'sample'
	}

如果觉得设置这些属性比较麻烦，也可以直接设置`archiveName`。另外，还可以通过`destinationDir`来设置压缩包的输出目录，如下所示：

	task archiveFiles(type: Zip) {
	    from 'dist'
	    // Copy files to a directory inside the archive.
	    into 'files'
	    // Set destination directory.
	    destinationDir = file("$buildDir/zips")
	    // Set complete filename.
	    archiveName = 'dist-files.zip'
	}

###5. 总结
这些就是Gradle构建中常用的文件操作，可以看出，Gradle的DSL已经提供的非常完善了。通过几行代码，我们就可以随心所欲的操作文件了，Awesome!