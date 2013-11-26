require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "projects" do
  include_context "projects"
  include_context "output dir"

  describe "basic file loading" do
    project do |p|
      p.file "abc.txt","hello"
    end

    has_files 1
    has_file "abc.txt","hello"
  end

  describe "multiple projects" do
    project "main" do |p|
      p.config :overlay, :widget
      p.file "README","hello"
    end

    project "widget" do |p|
      p.file "widget.rb","class Widget; end"
    end

    has_files 2
  end

  describe "multiple projects" do
    project "auth" do |p|
      p.config "c.overlay 'base'"
      p.file "README","\nauth stuff", :action => :append
    end

    project "base" do |p|
      p.file "README","hello"
    end

    has_files 1
    has_file "README","hello\nauth stuff"
  end

  describe "project nesting" do
    project "auth" do |p|
      p.config "c.overlay 'widget'"
      p.file "auth.coffee","auth setup"
      p.file "app.js","\nauth = true", :action => :append
    end

    project "widget" do |p|
      p.config "c.overlay 'base'"
      p.file "widget.coffee","Widget = Em.Object.extend()"
    end

    project "base" do |p|
      p.file "app.js","App = Em.Application.create()"
      p.file "README","Hello"
    end

    has_files 4
    has_file "README"
    has_file "app.js","App = Em.Application.create()\nauth = true"
  end

  describe "missing base file" do
    project do |p|
      p.file "README","Hello",action: :append
    end

    it 'errors' do
      lambda { combined.size }.should raise_error(Overapp::MissingBaseFileError,/./)
    end
  end

  describe "template file with project var" do
    project do |p|
      p.file "README","Hello <%= foo %>", :template => "erb"
      p.var "foo","bar"
    end

    has_files 1
    has_file "README","Hello bar"
  end

  describe "template file with global var" do
    project do |p|
      p.file "README","Hello <%= foo %>", :template => "erb"
    end

    var "foo","bar"

    has_files 1
    has_file "README","Hello bar"
  end

  describe "template file with global var in config" do
    project do |p|
      p.file "README","Hello <%= foo %>", :template => "erb"
      p.config "c.var 'foo','bar'"
    end

    has_files 1
    has_file "README","Hello bar"
  end

  describe "template file with global var and local var" do
    project do |p|
      p.file "README","Hello <%= foo %>", :template => "erb"
      p.var "foo","baz"
    end

    var "foo","bar"

    has_files 1
    has_file "README","Hello baz"
  end

  describe "refs self", :pending => false do
    project "base" do |p|
      p.config :overlay, "."
      p.config :overlay,:auth
      p.file "README","hello"
    end

    project "auth" do |p|
      p.file "README"," auth stuff", :action => :append
    end

    has_files 1
    has_file "README","hello auth stuff"
  end

  
end




