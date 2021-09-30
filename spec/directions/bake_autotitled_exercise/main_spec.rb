# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAutotitledExercise do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeAutotitledExercise::V1).to receive(:bake)
      .with(exercise: 'exercise1', number: nil)
    described_class.v1(exercise: 'exercise1')
  end
end
