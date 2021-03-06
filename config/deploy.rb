# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "daily_report"
set :repo_url, 'git@github.com:g-fujioka/daily_report.git'
set :rbenv_ruby, '2.3.4'
set :rbenv_type, :user
set :deploy_to, "/home/g-fujioka/#{fetch(:application)}"

shared_path = "#{fetch(:deploy_to)}/shared"
release_path = "#{fetch(:deploy_to)}/current"

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 10

# Unicorn
# unicorn.rb で指定した pid と一致するように。
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{release_path}/config/unicorn.rb"

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    on roles(:all) do
    invoke 'unicorn:restart'
    end
  end
end