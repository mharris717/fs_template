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

describe "dotfile" do
  include_context "setup"

  base_file ".abc","stuff"
  base_file "b.txt","here"
  on_top_file "c.txt","other"

  it 'combined size' do
    combined.size.should == 3
  end

  it 'dotfile there' do
    f = combined.files.find { |x| x.path == ".abc" }
    f.body.should == 'stuff'
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

describe "combine - append format2" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","here"
  on_top_file "b.txt","<overlay>append</overlay>\nother"

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

describe "combine - insert after" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","123\n456\n789"
  on_top_file "b.txt","<overlay>action: insert\nafter: 456</overlay>\nabc"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == "123\n456\nabc\n789"
  end
end

describe "combine - replace" do
  include_context "setup"

  base_file "a.txt","stuff"
  base_file "b.txt","123\n456\n789"
  on_top_file "b.txt","<overlay>action: replace\nbase: 456</overlay>abc"

  it 'combined size' do
    combined.size.should == 2
  end

  it 'combined file should overwrite' do
    f = combined.files.find { |x| x.path == "b.txt" }
    f.body.should == "123\nabc\n789"
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

describe "combine - error" do
  include_context "setup"

  base_file "a.txt","stuff"
  on_top_file "a.txt","FSTMODE:fgdfgdfg\nstuff"

  it 'combined size' do
    lambda { combined.size }.should raise_error
  end
end
