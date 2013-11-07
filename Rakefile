# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "overlay"
  gem.homepage = "http://github.com/mharris717/overlay"
  gem.license = "MIT"
  gem.summary = %Q{overlay}
  gem.description = %Q{overlay}
  gem.email = "mharris717@gmail.com"
  gem.authors = ["Mike Harris"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "overlay #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :rename_to_overlay do
  require 'mharris_ext'
  names = {}
  names["FsTemplate"] = "Overlay"
  names["fs_template"] = "overlay"

  (Dir["**/*.rb"] + Dir["**/*.gemspec"]).each do |f|
    body = File.read(f)
    names.each do |k,v|
      body = body.gsub(k,v)
    end
    File.create f, body
  end

  Dir["**/*"].select { |x| FileTest.file?(x) }.each do |file|
    base = File.basename(file)
    if base =~ /fs_template/
      dest = File.dirname(file) + "/" + base.gsub("fs_template","overlay")
      ec "mv #{file} #{dest}"
    end
  end

  #ec "mv lib/fs_template lib/overlay"
end