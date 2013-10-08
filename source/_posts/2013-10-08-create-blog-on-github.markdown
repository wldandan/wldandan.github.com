---
layout: post
title: "How to use Octopress to set up blog"
date: 2013-10-08 14:20
comments: true
categories: tools
---

## Setup blog
##### Install RVM
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
rvm install 1.9.2 rvm use 1.9.2 --default

##### Clone repo
git clone git://github.com/imathis/octopress.git octopress

gem install bundler
bundle install
bundle update # 不执行，则下一步rake会报版本不匹配
rake install
rake setup_github_pages

## Publish new article
rake new_post["My first post"]
rake generate # 第一次使用，最好先编辑一下_config.yml

rake preview # 本地查看，地址是http://localhost:4000
rake deploy

## Update Source

git commit -m 'your message'

git push origin source
