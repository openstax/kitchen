require 'spec_helper'
require 'ostruct'

RSpec.describe Kitchen::Ancestor do

  let(:element) { OpenStruct.new(short_type: 'page') }
  let(:ancestor) { described_class.new(element) }

  describe '#initalize' do
    it 'stores the element' do
      expect(ancestor.element).to eq element
    end
    it 'stores the element\'s type' do
      expect(ancestor.type).to eq element.short_type
    end
    it 'initalizes empty hash @descendant_counts' do
      expect(ancestor.descendant_counts).to eq {}
    end
  end

  describe '#increment_descendant_count' do
    it 'adds 1 to the descendant count for the given type' do
      # expect()
    end
  end

  describe '#decrement_descendant_count' do
    it 'decreases the descendant count for the given type by some amount' do
      # expect()
    end
  end

  describe '#get_descendant_count' do
    it 'returns the descendant count for the given type' do
      # expect()
    end
  end

  describe '#clone' do
    it 'makes a new ancestor around the same element with new counts' do
      # expect()
    end
  end
end
