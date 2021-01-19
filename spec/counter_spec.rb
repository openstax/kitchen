require 'spec_helper'

RSpec.describe Kitchen::Counter do
  describe ".initialize" do
    it 'creates a counter' do
      expect(Kitchen::Counter.new).to be_truthy
    end
  end
  describe ".increment" do
    counter = Kitchen::Counter.new
    it 'increments by 1 given no args' do
      val = counter.instance_variable_get(:@value)
      counter.increment
      expect(counter.instance_variable_get(:@value)).to eq(val + 1)
    end
    it 'increments by 2' do
      val = counter.instance_variable_get(:@value)
      counter.increment(by: 2)
      expect(counter.instance_variable_get(:@value)).to eq(val + 2)
    end
    it 'increments by -5' do
      val = counter.instance_variable_get(:@value)
      counter.increment(by: -5)
      expect(counter.instance_variable_get(:@value)).to eq(val -5)
    end
  end
  describe ".get" do
    it 'gets the counter value' do
      counter = Kitchen::Counter.new
      expect(counter.get).to eq(counter.instance_variable_get(:@value))
    end
  end
  describe ".reset" do
    counter = Kitchen::Counter.new
    counter.increment
    it 'resets to zero given no args' do
      counter.reset
      expect(counter.instance_variable_get(:@value)).to eq(0)
    end
    it 'resets to a given value' do
      counter.reset(to: 4)
      expect(counter.instance_variable_get(:@value)).to eq(4)
    end
  end
end
