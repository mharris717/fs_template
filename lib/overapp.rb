require 'mharris_ext'
require 'ptools'
require 'ostruct'

class Object
  def klass
    self.class
  end
end

module Overapp
  def self.load_files!
    %w(files template_file project from_command var).each do |f|
      load File.dirname(__FILE__) + "/overapp/#{f}.rb"
    end

    %w(base instance factory).each do |f|
      load File.dirname(__FILE__) + "/overapp/load/#{f}.rb"
    end

    %w(command raw_dir local_dir repo empty project).each do |f|
      load File.dirname(__FILE__) + "/overapp/load/types/#{f}.rb"
    end

    %w(config write config_entry).each do |f|
      load File.dirname(__FILE__) + "/overapp/project/#{f}.rb"
    end

    %w(tmp_dir git dir cmd write).each do |f|
      load File.dirname(__FILE__) + "/overapp/util/#{f}.rb"
    end

    %w(params body_mod var_obj).each do |f|
      load File.dirname(__FILE__) + "/overapp/template_file/#{f}.rb"
    end
  end
end

Overapp.load_files!

