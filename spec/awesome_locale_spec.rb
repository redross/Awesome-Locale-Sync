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
end