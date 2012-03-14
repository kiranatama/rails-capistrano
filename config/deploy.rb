require 'bundler/capistrano'

set :user, "sysadmin"
set :domain, "foobar.stagingapps.net"
set :application, "rails-capistrano"
set :applicationdir, "/home/#{user}/foobar"

# Git
set :repository,  "git@github.com:kiranatama/rails-capistrano.git"
set :scm, :git

# Servers
role :web, domain   
role :app, domain

# Deploy
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Integration via the rvm capistrano plugin
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3@rails-capistrano'
set :rvm_type, :user # Install gems in the deploying users home directory

# Additional settings
default_run_options[:pty] = true
