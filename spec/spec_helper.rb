require 'rubygems'
require 'spork'


Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start
  end
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require 'rspec'


  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    #config.filter_run :focus => true
    config.fail_fast = false

    config.before(:all) do
      repo = File.dirname(__FILE__) + "/input/repo"
      `cp -r #{repo}/git_dir #{repo}/.git` unless FileTest.exist?("#{repo}/.git")
    end
  end
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start
  end
  load File.dirname(__FILE__) + "/../lib/overapp.rb"
  #Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| load f}
end
