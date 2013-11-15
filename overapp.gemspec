# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "overapp"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Harris"]
  s.date = "2013-11-15"
  s.description = "overapp"
  s.email = "mharris717@gmail.com"
  s.executables = ["overapp"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/overapp",
    "lib/overapp.rb",
    "lib/overapp/files.rb",
    "lib/overapp/from_command.rb",
    "lib/overapp/load/base.rb",
    "lib/overapp/load/factory.rb",
    "lib/overapp/load/instance.rb",
    "lib/overapp/load/types/command.rb",
    "lib/overapp/load/types/empty.rb",
    "lib/overapp/load/types/local_dir.rb",
    "lib/overapp/load/types/project.rb",
    "lib/overapp/load/types/raw_dir.rb",
    "lib/overapp/load/types/repo.rb",
    "lib/overapp/project.rb",
    "lib/overapp/project/config.rb",
    "lib/overapp/project/config_entry.rb",
    "lib/overapp/project/write.rb",
    "lib/overapp/template_file.rb",
    "lib/overapp/util/cmd.rb",
    "lib/overapp/util/dir.rb",
    "lib/overapp/util/git.rb",
    "lib/overapp/util/tmp_dir.rb",
    "lib/overapp/util/write.rb",
    "overapp.gemspec",
    "spec/from_command_spec.rb",
    "spec/input/rails_post_overlay/.overapp",
    "spec/input/rails_post_overlay/app/models/post.rb",
    "spec/input/rails_widget_overlay/.overapp",
    "spec/input/rails_widget_overlay/app/models/widget.rb",
    "spec/input/repo/.abc",
    "spec/input/repo/README.md",
    "spec/input/repo/b.txt",
    "spec/input/repo/git_dir/COMMIT_EDITMSG",
    "spec/input/repo/git_dir/HEAD",
    "spec/input/repo/git_dir/MERGE_RR",
    "spec/input/repo/git_dir/config",
    "spec/input/repo/git_dir/description",
    "spec/input/repo/git_dir/hooks/applypatch-msg.sample",
    "spec/input/repo/git_dir/hooks/commit-msg.sample",
    "spec/input/repo/git_dir/hooks/post-update.sample",
    "spec/input/repo/git_dir/hooks/pre-applypatch.sample",
    "spec/input/repo/git_dir/hooks/pre-commit.sample",
    "spec/input/repo/git_dir/hooks/pre-push.sample",
    "spec/input/repo/git_dir/hooks/pre-rebase.sample",
    "spec/input/repo/git_dir/hooks/prepare-commit-msg.sample",
    "spec/input/repo/git_dir/hooks/update.sample",
    "spec/input/repo/git_dir/index",
    "spec/input/repo/git_dir/info/exclude",
    "spec/input/repo/git_dir/logs/HEAD",
    "spec/input/repo/git_dir/logs/refs/heads/master",
    "spec/input/repo/git_dir/objects/0f/0920d9d41f24629586ec1c20d2283d7df3a950",
    "spec/input/repo/git_dir/objects/16/b5741fe01104ea0bdf50603b4c5d42ae5dcbc1",
    "spec/input/repo/git_dir/objects/20/508dfdb202a80e2c533f259a526205448b0152",
    "spec/input/repo/git_dir/objects/59/c5d2b4bc66e952a99b3b18a89cbc1e6704ffa0",
    "spec/input/repo/git_dir/objects/7b/1c8984cafd98a5b369ef325a85cb80e3985148",
    "spec/input/repo/git_dir/objects/bf/9307f21baa545173db65a417026088a033aa91",
    "spec/input/repo/git_dir/objects/d6/8dd4031d2ad5b7a3829ad7df6635e27a7daa22",
    "spec/input/repo/git_dir/objects/d6/cd9e553ef95332f3b77f70d11d0106ca06071c",
    "spec/input/repo/git_dir/objects/f8/4c814d15674489c0b41035eb4243ccce522511",
    "spec/input/repo/git_dir/refs/heads/master",
    "spec/input/top/.overlay",
    "spec/input/top/b.txt",
    "spec/input/top/c.txt",
    "spec/input/top/place/d.txt",
    "spec/nesting_spec.rb",
    "spec/overapp_spec.rb",
    "spec/project_note_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/output_dir.rb",
    "spec/support/setup.rb",
    "spec/support/tmp_dir.rb",
    "tmp/.gitkeep",
    "vol/input/base/a.txt",
    "vol/input/base/b.txt",
    "vol/input/top/.fstemplate",
    "vol/input/top/b.txt",
    "vol/input/top/c.txt",
    "vol/input/top/place/d.txt",
    "vol/test_write.rb"
  ]
  s.homepage = "http://github.com/mharris717/overapp"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.7"
  s.summary = "overapp"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mharris_ext>, [">= 1.7.1"])
      s.add_runtime_dependency(%q<andand>, [">= 0"])
      s.add_runtime_dependency(%q<ptools>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<guard-spork>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9"])
      s.add_development_dependency(%q<lre>, [">= 0"])
    else
      s.add_dependency(%q<mharris_ext>, [">= 1.7.1"])
      s.add_dependency(%q<andand>, [">= 0"])
      s.add_dependency(%q<ptools>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<guard-spork>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9"])
      s.add_dependency(%q<lre>, [">= 0"])
    end
  else
    s.add_dependency(%q<mharris_ext>, [">= 1.7.1"])
    s.add_dependency(%q<andand>, [">= 0"])
    s.add_dependency(%q<ptools>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<guard-spork>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9"])
    s.add_dependency(%q<lre>, [">= 0"])
  end
end

