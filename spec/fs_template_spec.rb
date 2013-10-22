require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FsTemplate" do
  include_context "setup"

  it 'smoke' do
    2.should == 2
  end

  base_file "a.txt","stuff"
  on_top_file "b.txt","other"

  it 'base files' do
    base.files.size.should == 1
  end

  it 'top files' do
    on_top.files.size.should == 1
  end

  it 'combined' do
    combined.size.should == 2
  end
end

describe "combine" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","here"
  on_top_file "b.txt","other"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == 'other'
  end
end

describe "combine - append" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","here"
  on_top_file "b.txt","FSTMODE:append\nother"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == "here\nother"
  end
end

describe "combine - insert" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","a\nb\nc\nd"
  on_top_file "b.txt","FSTMODE:insert:line:2\nother\n"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == "a\nother\nb\nc\nd"
  end
end

describe "combine - top file in new dir" do
  include_context "setup"

  base_file "a.txt","stuff"
  on_top_file "place/b.txt","Hello"

  it 'combined size' do
    combined.size.should == 2
  end
end

#############

if false
describe "combine - append" do
  include_context "setup"
  let(:file_class) { FsTemplate::ThorFile }

  base_file "a.txt","stuff"
  base_file "b.txt","here"
  on_top_file "b.txt","<thor>append_to_file FILE, BODY</thor>\nother"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == "here\nother"
  end
end
end
