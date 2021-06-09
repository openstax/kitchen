# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BookAnswerKeyContainer do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BookAnswerKeyContainer::V1).to receive(:bake)
      .with(book: 'book')
    described_class.v1(book: 'book')
  end

  it 'calls v2' do
    expect_any_instance_of(Kitchen::Directions::BookAnswerKeyContainer::V2).to receive(:bake)
      .with(book: 'book')
    described_class.v2(book: 'book')
  end
end
