# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeNumberedExercise do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedExercise::V1).to receive(:bake)
      .with(exercise: 'exercise1', number: '1.1', suppress_solution: false, suppress_even_solution: false)
    described_class.v1(exercise: 'exercise1', number: '1.1', suppress_solution: false, suppress_even_solution: false)
  end

  it 'calls bake_solution_v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedExercise::V1).to receive(:bake_solution)
      .with(exercise: 'exercise1', number: '1.1', divider: 'abc')
    described_class.bake_solution_v1(exercise: 'exercise1', number: '1.1', divider: 'abc')
  end

  it 'calls bake_even_solution_v1' do
    expect_any_instance_of(Kitchen::Directions::BakeNumberedExercise::V1).to receive(:bake_even_solution)
      .with(exercise: 'exercise1', divider: 'abc')
    described_class.bake_even_solution_v1(exercise: 'exercise1', divider: 'abc')
  end
end
