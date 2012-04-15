# Encoding: UTF-8
require 'spec_helper'

describe AwesomeLocaleSync do
  describe 'tag_updated' do
    it 'should add updated tag' do
      AwesomeLocaleSync::AwesomeLocaleSync.tag_updated('Some data', 'some tag').should == 'Some data[Updated! TO (some tag)]'
    end

    it 'should update tag' do
      AwesomeLocaleSync::AwesomeLocaleSync.tag_updated('Some data [Updated! TO (some_tag)]', 'new_tag').should == 'Some data [Updated! TO (new_tag)]'
    end
  end

  describe 'init base locale' do
    it 'should create base yaml file' do
      file = File.join(File.dirname(__FILE__),'spec/fixtures/base.yml')
      File.delete(file) if FileTest.exists?(file)

      AwesomeLocaleSync::AwesomeLocaleSync.any_instance.stub(:default_translations).and_return({:en => {:hello => :world}})
      expect {
        AwesomeLocaleSync::AwesomeLocaleSync.new.init_base_locale(:base_locale_file => file)
      }.to change { FileTest.exists?(file) }.from(false).to(true)

      File.delete(file) if FileTest.exists?(file)
    end
  end
end