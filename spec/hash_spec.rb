# Encoding: UTF-8
require 'spec_helper'


describe 'Hash enhancements' do
  before do
    @base_hash = {isdege: 'pugos', kariasi: 'zodziai', lyja: {pavasario: ['lietus', 'nuobodziai'], keliasi: 'dangus'}}
    @default_hash = {isdege: 'pugos', kariasi: 'zodziai', lyja: {pavasario: ['lietus', 'nuobodziai'], keliasi: 'dangus'}}
    @translated_hash = {isdege: 'pūgos', kariasi: 'žodžiai', lyja: {pavasario: ['lietūs', 'nuobodžiai'], keliasi: 'dangūs'}}
  end

  describe 'prune leafs' do
    describe 'not append' do
      it 'should set all leaf values to specified value' do
        @base_hash.prune_leafs('hey', false).should == {isdege: 'hey',
                                                        kariasi: 'hey',
                                                        lyja: {pavasario: ['hey', 'hey'], keliasi: 'hey'}}
      end

      it 'should not modify symbol values' do
        @base_hash[:aukstais] = :austa
        @base_hash.prune_leafs('hey', false).should == {isdege: 'hey',
                                                        kariasi: 'hey',
                                                        lyja: {pavasario: ['hey', 'hey'], keliasi: 'hey'}, aukstais: :austa}
      end

      it 'should not modify integer values' do
        @base_hash[:aukstais] = 2
        @base_hash.prune_leafs('hey', false).should == {isdege: 'hey',
                                                        kariasi: 'hey',
                                                        lyja: {pavasario: ['hey', 'hey'], keliasi: 'hey'}, aukstais: 2}
      end

      it 'should not modify boolean values' do
        @base_hash[:aukstais] = true
        @base_hash.prune_leafs('hey', false).should == {isdege: 'hey',
                                                        kariasi: 'hey',
                                                        lyja: {pavasario: ['hey', 'hey'], keliasi: 'hey'}, aukstais: true}
      end
    end

    describe 'append' do
      it 'should append to all leaf values a specified value' do
        @base_hash.prune_leafs('!', true).should == {isdege: 'pugos!',
                                                     kariasi: 'zodziai!',
                                                     lyja: {pavasario: ['lietus!', 'nuobodziai!'], keliasi: 'dangus!'}}
      end
    end
  end

  describe 'detect diff' do
    describe 'no changes' do
      it 'should not change translated hash' do
        @translated_hash.detect_diff(@base_hash, @default_hash).should == @translated_hash
      end
    end

    describe 'new key' do
      it 'should not change translated hash' do
        @default_hash[:aukstais] = 'ir austa'
        @translated_hash.detect_diff(@base_hash, @default_hash).should == @translated_hash
      end
    end

    describe 'updated key' do
      it 'should add updated tag' do
        @default_hash[:isdege] = 'Pugos'
        @translated_hash.detect_diff(@base_hash, @default_hash).should == { isdege: 'pūgos[Updated! TO (Pugos)]',
                                                               kariasi: 'žodžiai',
                                                               lyja: {pavasario: ['lietūs', 'nuobodžiai'], keliasi: 'dangūs'}}
      end
    end
  end

  describe 'deep subtract' do
    describe 'keep missing' do
      it 'should replace with values from hash' do
        @default_hash.deep_subtract(@translated_hash, true).should == @translated_hash
      end

      it 'should keep keys missing from hash' do
        @default_hash[:aukstais] = 'ir austa'
        @default_hash.deep_subtract(@translated_hash, true).should == {:isdege=>'pūgos',
                                                                       :kariasi=>'žodžiai',
                                                                       :lyja=>{:pavasario=>['lietūs', 'nuobodžiai'],
                                                                               :keliasi=>'dangūs'},
                                                                       :aukstais=>'ir austa'}
      end
    end

    describe 'delete missing' do
      it 'should not keep keys that are missing in subtracted hash' do
        @default_hash[:aukstais] = 'ir austa'
        @default_hash.deep_subtract(@translated_hash, false).should == @translated_hash
      end
    end
  end

  describe 'deep stringify keys' do
    it 'should replace hash symbol keys with strings' do
      @base_hash.deep_stringify_keys.should == {'isdege' => 'pugos', 'kariasi' => 'zodziai',
          'lyja' => {'pavasario' => ['lietus', 'nuobodziai'], 'keliasi' => 'dangus'}}
    end
  end
end