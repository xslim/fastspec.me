set :user, "fastspec"
set :runner, user
set :use_sudo, false
set :deploy_to, "/home/fastspec/#{application}/staging"

role :web, "dev1.rabat.me"                          # Your HTTP server, Apache/etc
role :app, "dev1.rabat.me"                          # This may be the same as your `Web` server

set :rails_env, "staging"
set :deploy_env, 'staging'
ssh_options[:forward_agent] = false

set :repository,  "git@github.com:xslim/fastspec.me.git", :branch => 'develop'


