require 'mharris_ext'
require 'ptools'
require 'ostruct'
require 'andand'

class Object
  def klass
    self.class
  end
end

module Overapp
  def self.files
    h = {}
    h[nil] = %w(files template_file project var)
    h[:load] = %w(base instance factory)
    h["load/types"] = %w(command raw_dir local_dir repo project)
    h[:project] = %w(config write config_entry)
    h[:util] = %w(tmp_dir git dir cmd write file str)
    h[:template_file] = %w(params body_mod var_obj)

    res = []
    h.each do |k,v|
      k = "#{k}/" if k.present?
      res += v.map { |f| File.dirname(__FILE__) + "/overapp/#{k}#{f}.rb" }
    end
    res
  end

  def self.load_files!
    files.each { |x| load x }
  end
end

Overapp.load_files!

