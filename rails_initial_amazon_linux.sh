#!/bin/bash
# initial commands for amazon linux to launch rails on nginx
# created and test for Amazon Linux AMI 2014.09.1 (HVM) - ami-4985b048
# last updated on Dec 16, 2014 by kakenman
# this may take 15 min.

echo "installing initial environment for rails on nginx."
echo "ruby version: 2.1.5"
date

LANG=C
sudo yum -y update
sudo yum install -y git vim sudo tar wget emacs
sudo yum install -y gcc make gcc-c++ zlib-devel httpd-devel openssl-devel curl-devel sqlite-devel
sudo yum install -y nginx
sudo yum install -y ruby-devel

# installed for nokogiri
sudo yum install -y patch

sudo yum install -y mysql-devel mysql-server

sudo yum install -y ImageMagick-devel
sudo chkconfig mysqld on


cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.1.5
rbenv global 2.1.5


rbenv exec gem install bundler
rbenv exec gem install rb-readline
rbenv exec gem install rails 
rbenv rehash

sudo service mysqld start

date
echo "installation finished"