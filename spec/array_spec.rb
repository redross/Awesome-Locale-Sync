# Encoding: UTF-8

require 'spec_helper'

describe 'Array enhancements' do
    describe 'detect diff' do
      before do
        @base_array = ['ateik', 'mazyte', ['as', 'noriu Tave apkabint']]
        @default_array = ['ateik', 'mazyte', ['as', 'noriu Tave apkabint']]
        @generated_array = ['O ateik', 'mažyte', ['aš', 'Noriu Tave apkabint']]
      end

      describe 'no change' do
        it 'should not change anything' do
          @generated_array.detect_diff(@base_array, @default_array).should == @generated_array
        end
      end

      describe 'new value' do
        it 'should not change anything' do
          edited_array = @default_array + ['Smth']
          @generated_array.detect_diff(@base_array, edited_array).should == @generated_array
        end
      end

      describe 'updated key' do
        it 'should add add updated tag' do
          @default_array[0] = 'ATEIK!'
          @generated_array.detect_diff(@base_array, @default_array).should == ['O ateik[Updated! TO (ATEIK!)]',
                                                                               'mažyte', ['aš', 'Noriu Tave apkabint']]
        end
      end
    end

    describe 'prune_leafs' do
      before do
        @test_array = ['ratai', 'zoles', ['ziemos', 'dangus']]
      end

      it 'should not modify symbols' do
        @test_array << :test
        @test_array.prune_leafs('!', false).should == ['!', '!', ['!', '!'], :test]
        @test_array.prune_leafs('!', true).should == ['ratai!', 'zoles!', ['ziemos!', 'dangus!'], :test]
      end

      describe 'not appending' do
        it 'should replace elements with nils' do
          @test_array.prune_leafs('!', false).should == ['!', '!', ['!', '!']]
        end
      end

      describe 'appending' do
        it 'should add value to all array values' do
          @test_array.prune_leafs('!', true).should == ['ratai!', 'zoles!', ['ziemos!', 'dangus!']]
        end

        it 'should not modify source array' do
          expect {
            @test_array.prune_leafs('!', true)
          }.to_not change{ @test_array }
        end
      end
    end
  end