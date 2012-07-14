set :user, "deployer"
set :runner, user
set :use_sudo, false
set :deploy_to, "/home/deployer/#{application}/dev"

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server

set :rails_env, "production"
set :deploy_env, 'production'