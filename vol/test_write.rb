load "lib/fs_template.rb"

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/output/**/*.*"].each do |f|
  `rm #{f}`
end

#FsTemplate::Files.write_combined "#{dir}/input/base","#{dir}/input/top","#{dir}/output"
FsTemplate.write_project "#{dir}/input/top","#{dir}/output"