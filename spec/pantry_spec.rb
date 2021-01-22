require 'spec_helper'

RSpec.describe Kitchen::Pantry do
  let (:instance) {described_class.new}

  it 'creates a hash' do
      expect(described_class.new).to be_truthy
  end

  it 'adds an item to the Pantry with the provided label' do
    instance.store 'bar', label: 'foo'
    expect { instance }.not_to be_empty
  end

  it 'gets an item from the Pantry' do
    expect { instance.get('foo') }.to eq('bar')
  end

  it 'gets an item from the pantry, raising if not present' do
    expect { instance.get!('thud')}.to raise_error(Kitchen::RecipeError)
  end

  it 'iterate over the pantry items' do
    expect { instance.each(&block) }.to include(TK)
  end

  it 'returns the number of items in the pantry' do
    expect { instance.size }.to eq(1)
  end
end
