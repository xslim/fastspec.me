set :user, "fastspec"
set :runner, user
set :use_sudo, false
set :deploy_to, "/home/fastspec/#{application}/staging"

set :application, "spec.theappfellas.com"

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server

set :rails_env, "staging"
set :deploy_env, 'staging'
ssh_options[:forward_agent] = true

set :branch, "develop"




