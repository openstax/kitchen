require 'spec_helper'

RSpec.describe Kitchen::Pantry do
  let(:instance) { described_class.new }

  it 'creates a hash' do
    expect(instance).to be_truthy
  end

  it 'adds an item to the pantry with the provided label' do
    instance.store 'bar', label: 'foo'
    expect(instance).to include(:foo)
  end

  it 'gets an item from the pantry' do
    instance.store 'bar', label: 'foo'
    expect(instance.get(:foo)).to eq('bar')
  end

  it 'raises if item is not in pantry' do
    expect{ instance.get!('thud') }.to raise_error(
      Kitchen::RecipeError, "There is no pantry item labeled 'thud'"
    )
  end

  it 'iterate over the pantry items' do
    expect(instance.each(&block)).to include(TK)
  end

  it 'returns the number of items in the pantry' do
    instance.store 'bar', label: 'foo'
    expect(instance.size).to eq(1)
  end
end
