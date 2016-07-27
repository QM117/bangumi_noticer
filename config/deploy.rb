require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :user, 'deploy'
set :domain, '45.32.28.139'
set :deploy_to, '/var/www/bgm-noti'
set :repository, 'https://github.com/Tsumugi52961/bangumi_noticer.git'
set :branch, ENV['at']  if ENV['at']
set :forward_agent, true
set :current_path, "current"
set :releases_path, 'releases'
set :shared_path, 'shared'
set :app_path, lambda { "#{deploy_to}/#{current_path}" }
set :stage, 'production'
set :rvm_path, '/home/deploy/.rvm/scripts/rvm'

set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml']

task :environment do
  invoke :'rvm:use[ruby-2.3.0@default]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"] 

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/log"] 

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    queue! "cd #{app_path} & RAILS_ENV=#{stage} bundle exec rake db:create"
    invoke :'rails:db_migrate'
    # queue! "cd #{app_path} & RAILS_ENV=#{stage} bundle exec rake db:seed"
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'puma:restart'

    to :launch do      
    end
  end
end
