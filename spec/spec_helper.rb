require 'rubygems'
require 'spork'
require 'mharris_ext'

class SpecGitDir
  include FromHash
  attr_accessor :dir

  def setup!
    `cp -r #{dir}/git_dir #{dir}/.git` unless FileTest.exist?("#{dir}/.git")
  end

  def teardown!
    `rm -rf #{dir}/.git` if FileTest.exist?("#{dir}/.git")
  end

  class << self
    def make(name)
      dir = File.dirname(__FILE__) + "/input/#{name}"
      new(:dir => dir)
    end
  end
end


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

    repo_dirs = %w(repo)

    config.before(:all) do
      repo_dirs.each do |dir|
        SpecGitDir.make(dir).setup!
      end
    end

    config.after(:all) do
      repo_dirs.each do |dir|
        SpecGitDir.make(dir).teardown!
      end
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
