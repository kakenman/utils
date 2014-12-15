#!/bin/bash
# initial commands for amazon linux to launch rails on nginx
# created and test for Amazon Linux AMI 2014.09.1 (HVM) - ami-4985b048
# last updated on Dec 16, 2014 by kakenman

LANG=C
sudo yum -y update
sudo yum install -y git vim sudo tar wget
sudo yum install -y gcc make gcc-c++ zlib-devel httpd-devel openssl-devel curl-devel sqlite-devel
sudo yum install -y nginx
sudo yum install -y ruby-devel

cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.0.0-p598

gem install bundler
gem install rb-readline
gem install rails 

