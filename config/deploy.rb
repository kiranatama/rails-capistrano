require 'bundler/capistrano'

set :user, "sysadmin"
set :domain, "foobar.stagingapps.net"
set :application, "rails-capistrano"
set :applicationdir, "/home/#{user}/foobar"

# Git
set :repository,  "git@github.com:kiranatama/rails-capistrano.git"
set :scm, :git

# Deploy from a tag
set :branch do
  default_tag = `git tag`.split("\n").last

  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end

# Servers
role :web, domain   
role :app, domain
role :db, domain, :primary => true

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

  # Assets precompile
  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end
end

# Integration via the rvm capistrano plugin
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3@rails-capistrano'
set :rvm_type, :user # Install gems in the deploying users home directory

# Additional settings
default_run_options[:pty] = true


# database.yml setup
namespace :deploy do
  namespace :db do
    desc <<-DESC
      Creates the database.yml configuration file in shared path.

      By default, this task uses a template unless a template \
      called database.yml.erb is found either is :template_dir \
      or /config/deploy folders. The default template matches \
      the template for config/database.yml file shipped with Rails.

      When this recipe is loaded, db:setup is automatically configured \
      to be invoked after deploy:setup. You can skip this task setting \
      the variable :skip_db_setup to true. This is especially useful \ 
      if you are using this recipe in combination with \
      capistrano-ext/multistaging to avoid multiple db:setup calls \ 
      when running deploy:setup for all stages one by one.
    DESC
    task :setup, :except => { :no_release => true } do
      default_template = <<-EOF
      base: &base
        adapter: sqlite3
        timeout: 5000
      development:
        database: #{shared_path}/db/development.sqlite3
        <<: *base
      test:
        database: #{shared_path}/db/test.sqlite3
        <<: *base
      production:
        database: #{shared_path}/db/production.sqlite3
        <<: *base
      EOF

      location = fetch(:template_dir, "config/deploy") + '/database.yml.erb'
      template = File.file?(location) ? File.read(location) : default_template

      config = ERB.new(template)

      run "mkdir -p #{shared_path}/db" 
      run "mkdir -p #{shared_path}/config" 
      put config.result(binding), "#{shared_path}/config/database.yml"
    end

    desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    end
  end

  after "deploy:setup",           "deploy:db:setup"   unless fetch(:skip_db_setup, false)
  after "deploy:finalize_update", "deploy:db:symlink"
end

