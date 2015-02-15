# Setup guide for capistrano on rails

This is a procedure to setup deployment code for rails services.

## Production/staging server side
### Common setup ( should usually be done for AMI)
When you need to setup a new server from a blank AMI, you need to do the following.

When you setup a new server from a read-to-use AMI, you can skip here.
```
scp rails_initial_amazon_linux.sh nginx.conf rails.sh xxxxx@xxxxx.com:
chmod u+x rails_initial_amazon_linux.sh
./rails_initial_amazon_linux.sh
sudo cp nginx.conf /etc/nginx/
sudo service nginx start
sudo cp rails.sh /etc/profile.d/
mkdir /var/www/ec2-user/
chown ec2-user:ec2-user /var/www/ec2-user
```

#### Setup database (MySQL)
* modify /etc/my.cnf so that databases are created with utf-8
* set root password
* create database
* create user
* grant user on database


### Setup for each server
#### Register .ssh/id_rsa.pub as a deploy key for the target repository
```
ssh-keygen
```
open .ssh/id_rsa.pub and copy the content into your github deploy key.

#### Set SECRET_KEY_BASE
```
vim /etc/profile.d/rails.sh
```
update secret_key_base in rails.sh to any md5 hash.

#### Check if nginx is running correctly

allow http(tcp:80) access on aws console and access it.  
supposed to show an error "The page you are looking for is temporarily unavailable. Please try again later." as unicorn is not running yet






## Rails app side

### Add capistrano gems into Gemfile

comment-in therubytracer and unicorn.

add codes below to Gemfile.
```
group :deployment do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end
```
### Create initial settings for unicorn
```
bundle install --path vendor/bundle
cp unicorn.rb ${the root folder of your rails app}/config/
```
### Test unicorn locally
```
sudo nginx
bundle exec unicorn -c config/unicorn.rb
```
access http://localhost

### Setup capistrano

```
bundle exec cap install STAGES=staging,production
```
add the code below to deploy.rb (change "capstest2", "2.0.0-p598" depending on your environment)

```
set :application, 'capstest2'
set :repo_url, 'git@github.com:kakenman/capstest2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_to, '/var/www/ec2-user/capstest2'


set :rbenv_type, :user # :system or :user
set :rbenv_ruby, '2.0.0-p598'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
```

### Modify Capfile

add the code below
```
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano3/unicorn'
```

### Describe where to deploy
describe where to deploy in staging.rb on deploy/{staging,production}.rb.

sample code is:
```
role :app, %w{ec2-user@aws1.fgresearch.jp}
role :web, %w{ec2-user@aws1.fgresearch.jp}
role :db,  %w{ec2-user@aws1.fgresearch.jp}

server 'aws1.fgresearch.jp', user: 'ec2-user', roles: %w{web app}, my_property: :my_value

set :ssh_options, {
                    keys: [File.expand_path('~/.ssh/key1.pem')],
                    forward_agent: true,
                    auth_methods: %w(publickey)
                }
```

- (stab) add staging.rb to environments/?

### create config/unicorn/production.rb
copy prodcution.rb into config/unicorn/
modify appname in production.rb


### check deploy settings
```
bundle exec cap production deploy:check
```
or
```
bundle exec cap -S branch="xxxx" production deploy:check
```

### deploy

```
bundle exec cap staging deploy
bundle exec cap production deploy
```