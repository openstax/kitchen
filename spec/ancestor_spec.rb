require 'spec_helper'
require 'ostruct'

RSpec.describe Kitchen::Ancestor do

  let(:element) { OpenStruct.new(short_type: 'page') }
  let(:descendant) { OpenStruct.new(short_type: 'note')}
  let(:ancestor) { described_class.new(element) }

  it 'makes the type available' do
    expect(ancestor.type).to eq element.short_type
  end

  it 'makes the element available' do
    expect(ancestor.element).to eq element
  end

  describe '#increment_descendant_count' do
    it 'adds 1 to the descendant count for the given type' do
      expect { ancestor.increment_descendant_count(descendant.short_type) }.to change {ancestor.get_descendant_count(descendant.short_type)}.by(1)
    end
  end

  describe '#decrement_descendant_count' do
    it 'decreases the descendant count for the given type by 1' do
      ancestor.increment_descendant_count(descendant.short_type)
      expect { ancestor.decrement_descendant_count(descendant.short_type) }.to change {ancestor.get_descendant_count(descendant.short_type)}.by(-1)
    end
    it 'decreases the descendant count for the given type by -5' do
      expect { ancestor.decrement_descendant_count(descendant.short_type, by: -5) }.to raise_error("An element cannot have negative descendants")
    end
  end

  describe '#get_descendant_count' do
    it 'returns the descendant count for the given type' do
      ancestor.increment_descendant_count(descendant.short_type)
      expect(ancestor.get_descendant_count(descendant.short_type)).to eq 1
    end
  end

  describe '#clone' do
    it 'makes a new ancestor around the same element with new counts' do

    end
  end
end
