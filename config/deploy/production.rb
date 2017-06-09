server '192.168.56.100', user: 'g-fujioka', roles: %w{app db web}
set :unicorn_pid, "/home/g-fujioka/#{fetch(:application)}/shared/tmp/pids/unicorn.pid"
set :unicorn_rack_env, 'production'
set :unicorn_config_path, "/home/g-fujioka/#{fetch(:application)}/current/config/unicorn.rb"
set :rails_env, 'production'
set :branch, 'master'
set :migration_role, 'db'
set :ssh_options, {
    keys: %w(~/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(publickey)
}

namespace :deploy do
  desc 'secrets.ymlをコピーします'
  task :copy_secrets_yml do
    on roles(:all) do
      execute "cp #{shared_path}/secrets.yml #{release_path}/config/secrets.yml"
    end
  end
end

before 'unicorn:start', 'deploy:copy_secrets_yml'