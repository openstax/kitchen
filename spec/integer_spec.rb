# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Integer do
  describe '#to_format' do
    it 'returns self if format is arabic' do
      expect(3.to_format(:arabic)).to eq(3)
      expect(11.to_format(:arabic)).to eq(11)
    end

    it 'converts to roman numerals' do
      expect(3.to_format(:roman)).to eq('iii')
      expect(10.to_format(:roman)).to eq('x')
      expect {
        11.to_format(:roman)
      }.to raise_error('Unknown conversion to Roman numerals')
    end
  end
end
