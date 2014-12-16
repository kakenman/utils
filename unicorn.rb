rails_root = File.expand_path('../../', __FILE__)
worker_processes 2
listen '/tmp/unicorn.sock'
#stderr_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
#stdout_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
stderr_path "#{rails_root}/log/unicorn_error.log"
stdout_path "#{rails_root}/log/unicorn.log"
preload_app true