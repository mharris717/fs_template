load "lib/overapp.rb"

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/output/**/*.*"].each do |f|
  `rm #{f}`
end

#Overapp::Files.write_combined "#{dir}/input/base","#{dir}/input/top","#{dir}/output"
Overapp.write_project "#{dir}/input/top","#{dir}/output"