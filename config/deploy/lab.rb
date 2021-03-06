after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
server "labcssz.lab.justice.cz", user: ENV['DEPLOY_USER_NAME'], roles: %w{app db web}

set :rails_env, 'staging'
set :unicorn_config_path, File.join(current_path, "config", "unicorn.rb")

set :ssh_options, {
  keys: %w(~/.ssh/id_rsa),
  forward_agent: false,
  auth_methods: %w(publickey)
}
