require_relative '../index'

describe Enumerable do
  let(:arr) { [1, 4, 2, 5, 8, 6, 9, 3] }

  describe 'my_each' do
    it 'return the array unless block_given' do
      expect(arr.my_each(&:integer?)).to eql [1, 4, 2, 5, 8, 6, 9, 3]
    end
  end

  describe 'my_each_with_index' do
    it 'return array unless the value is to be indexed' do
      expect(arr.my_each_with_index { |a| a }).to eql([1, 4, 2, 5, 8, 6, 9, 3])
    end
  end

  describe 'my_select' do
    it 'should return the specific data type requested' do
      expect(arr.my_select(&:odd?)).to eql [1, 5, 9, 3]
    end
  end

  describe '#my_all?' do
    it 'should returns true if block is all integer' do
      expect(arr.my_all?(Integer)).to be true
    end
  end

  describe 'my_any?' do
    it 'should return false if the array has any integer' do
      expect(arr.my_any?(Integer)).to be false
    end
  end

  describe 'my_none?' do
    it 'should return true if it has no float numbers' do
      expect(arr.my_none?(Float)).to be true
    end
  end

  describe 'my_count' do
    it 'return the total count of the array' do
      expect(arr.count).to eql(8)
    end
  end

  describe 'my map' do
    it 'should return the square of each value ' do
      expect(arr.map { |i| i * i }).to eql([1, 16, 4, 25, 64, 36, 81, 9])
    end
  end

  describe 'my_inject' do
    it 'return the sum of all the array' do
      expect(arr.inject { |sum, n| sum + n }).to eql(38)
    end
  end
end
