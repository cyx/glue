# This file contains the bootstraping code for a Monk application.
RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
ROOT_DIR = $0 unless defined? ROOT_DIR

# Helper method for file references.
#
# @param args [Array] Path components relative to ROOT_DIR.
# @example Referencing a file in config called settings.yml:
#   root_path("config", "settings.yml")
def root_path(*args)
  File.join(ROOT_DIR, *args)
end

require "sinatra/base"
require "haml"
require "sass"

require "monk/glue/reloader"
require "monk/glue/logger"
require "monk/glue/settings"

Monk = Module.new unless defined? Monk

class Monk::Glue < Sinatra::Base
  set :dump_errors, true
  set :logging, true
  set :methodoverride, true
  set :raise_errors, Proc.new { test? }
  set :root, root_path
  set :run, Proc.new { $0 == app_file }
  set :show_exceptions, Proc.new { development? }
  set :static, true
  set :views, root_path("app", "views")

  use Rack::Session::Cookie

  configure :development do
    use Monk::Glue::Reloader
  end

  configure :development, :test do
    begin
      require "ruby-debug"
    rescue LoadError
    end
  end

  helpers do
    # TODO Add documentation.
    def haml(template, options = {}, locals = {})
      options[:escape_html] = true unless options.include?(:escape_html)
      super(template, options, locals)
    end

    # TODO Add documentation.
    def partial(template, locals = {})
      haml(template, {:layout => false}, locals)
    end
  end
end
