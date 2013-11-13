require 'mharris_ext'

class Object
  def klass
    self.class
  end
end

module Overapp
  def self.load_files!
    %w(files template_file project from_command).each do |f|
      load File.dirname(__FILE__) + "/overapp/#{f}.rb"
    end

    %w(base instance factory).each do |f|
      load File.dirname(__FILE__) + "/overapp/load/#{f}.rb"
    end

    %w(command raw_dir local_dir repo empty projects).each do |f|
      load File.dirname(__FILE__) + "/overapp/load/types/#{f}.rb"
    end

    %w(config write).each do |f|
      load File.dirname(__FILE__) + "/overapp/project/#{f}.rb"
    end

    %w(tmp_dir git dir cmd write).each do |f|
      load File.dirname(__FILE__) + "/overapp/util/#{f}.rb"
    end
  end
end

Overapp.load_files!

