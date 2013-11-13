if false
  require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_context "tmp dir" do
  let(:tmp_dir) do
    Overapp.with_tmp_dir
  end
  before do
    tmp_dir
  end
  after do
    #puts "rm -rf #{tmp_dir}"
  end
end

describe 'Nesting' do
  include_context "tmp dir"

  let(:widget_overlay_dir) do
    File.expand_path(File.dirname(__FILE__) + "/input/rails_widget_overlay")
  end

  let(:widget_post_dir) do
    File.expand_path(File.dirname(__FILE__) + "/input/rails_post_overlay")
  end

  describe 'basic' do
    before do
      Overapp.write_project widget_overlay_dir,tmp_dir
    end

    it 'wrote' do
      File.read("#{tmp_dir}/app/models/widget.rb").should == "class Widget < ActiveRecord::Base\nend"
      File.read("#{tmp_dir}/config/routes.rb").should == "route stuff\n"
    end
  end

  describe 'runs base overlay commands' do
    before do
      Overapp.write_project widget_post_dir,tmp_dir
    end

    it 'has post model' do
      FileTest.should be_exist("#{tmp_dir}/app/models/post.rb")
    end

    it 'has widget model' do
      FileTest.should be_exist("#{tmp_dir}/app/models/widget.rb")
    end

    it 'has routes file' do
      FileTest.should be_exist("#{tmp_dir}/config/routes.rb")
    end
  end
end
end