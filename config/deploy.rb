require 'bundler/capistrano'
require 'capistrano_colors'
load "deploy/assets"

# Add RVM's lib directory to the load path.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p194'
set :rvm_type, :system  # Don't use system-wide RVM


#set :bundle_flags,   "--deployment --quiet --disable_shared_gems"
#set :bundle_dir,          fetch(:shared_path)+"/bundle"
#set :bundle_dir,          "#{rvm_path}/gems/#{rvm_ruby_string}"

set :application, "fastspec.me"
set :repository,  "git@github.com:xslim/fastspec.me.git"

set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#default_run_options[:shell] = "/bin/bash"

set :user, "deployer"
set :use_sudo, false
set :deploy_to, "/home/deployer/#{application}/dev"
set :runner, user

set :rails_env, "development"

#set :gem_home, "/Users/slim/.rvm/gems/ruby-1.9.3-p194"


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:update', 'local:sshadd'
before 'deploy:finalize_update', 'local:copy_config'

namespace :local do
  desc "Localy run ssh-add"
  task :sshadd, :roles => :app do
    system "ssh-add"
  end
  desc "Copy local secret config to remote"
  task :copy_config, :hosts => "#{application}" do
    filename = "config.yml"
    upload "config/#{filename}", "#{current_release}/config/#{filename}"
  end
end

namespace :deploy do
  desc "set ENV['RAILS_ENV'] for mod_rails (phusion passenger)"
  task :set_rails_env do
    tmp = "#{current_release}/tmp/environment.rb"
    final = "#{current_release}/config/environment.rb"
    run <<-CMD
      echo 'ENV["RAILS_ENV"] = "#{rails_env}"' > #{tmp};
      cat #{final} >> #{tmp} && mv #{tmp} #{final};
    CMD
  end
end

after "deploy:finalize_update", "deploy:set_rails_env"

set :mongodbname_prod, 'fastspec_development'
set :mongodbname_dev, 'fastspec_development'

namespace :syncdb do
  
  desc 'Synchronize MongoDB local -> production.'
  task :dev2prod, :hosts => "#{application}" do
    database = mongodbname_dev
    dev_database = database
    filename = "database.#{database}.#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}.tar.bz2"
    system "/usr/local/bin/mongodump -db #{database}"
    system "tar -cjf #{filename} dump/#{database}"
    upload filename, "#{shared_path}/#{filename}"
    system "rm -rf #{filename} | rm -rf dump"
    
    database = mongodbname_prod
    run "tar -xjvf #{shared_path}/#{filename}"
    run "/usr/local/bin/mongorestore #{fetch(:db_drop, '')} -db #{database} dump/#{dev_database}"
    run "cd #{shared_path} && rm -rf #{filename} | rm -rf dump"
  end
  
  desc 'Synchronize MongoDB production -> local.'
  task :prod2dev, :hosts => "#{application}" do
    database = mongodbname_dev
    dev_database = database
    filename = "database.#{database}.#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}.tar.bz2"
    run "cd #{shared_path} && /usr/local/bin/mongodump -db #{database}"
    run "cd #{shared_path} && tar -cjf #{filename} dump/#{database}"
    download "#{shared_path}/#{filename}", "#{filename}"
    run "cd #{shared_path} && rm -rf #{filename} | rm -rf dump"
    
    database = mongodbname_prod
    system "tar -xjvf #{filename}"
    system "/usr/local/bin/mongorestore #{fetch(:db_drop, '')} -db #{database} dump/#{dev_database}"
    system "rm -rf #{filename}"
    system "rm -rf dump"
  end
  
  
  desc 'Generate indexes.'
  task :reindex, :host => "#{application}" do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:mongoid:create_indexes --trace"
  end
  
  after "deploy", "rvm:trust_rvmrc"
  

end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

