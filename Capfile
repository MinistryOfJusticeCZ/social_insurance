require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require 'capistrano/rails'
require 'capistrano3/unicorn'
require 'capistrano/sidekiq'

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
