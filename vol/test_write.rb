load "lib/overlay.rb"

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/output/**/*.*"].each do |f|
  `rm #{f}`
end

#Overlay::Files.write_combined "#{dir}/input/base","#{dir}/input/top","#{dir}/output"
Overlay.write_project "#{dir}/input/top","#{dir}/output"