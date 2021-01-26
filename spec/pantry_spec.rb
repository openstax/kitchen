require 'spec_helper'

RSpec.describe Kitchen::Pantry do
  let(:instance) { described_class.new }

  it 'creates a hash' do
    expect(instance).to be_truthy
  end

  context 'when the pantry has contents' do
    before { instance.store 'bar', label: 'foo' }

    it 'adds an item to the pantry with the provided label' do
      expect(instance).to include(:foo)
    end

    it 'gets an item from the pantry' do
      expect(instance.get(:foo)).to eq('bar')
    end

    it 'raises if requested item is not in pantry' do
      expect{ instance.get!('thud') }.to raise_error(
        Kitchen::RecipeError, "There is no pantry item labeled 'thud'"
      )
    end

    it 'iterates over the pantry items' do
      instance.store 'baz', label: 'qux'
      expect { |block| instance.each(&block) }.to yield_successive_args([:foo, 'bar'], [:qux, 'baz'])
    end

    it 'returns the number of items in the pantry' do
      expect(instance.size).to eq(1)
    end
  end
end
