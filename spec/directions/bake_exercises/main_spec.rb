# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::V1).to receive(:bake).with(book: 'blah')
    described_class.v1(book: 'blah')
  end

  it 'calls bake eob exercises' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::EOB).to receive(:bake).with(book: 'blah', class_names: {})
    described_class.eob(book: 'blah', class_names: {})
  end

  it 'calls bake example exercises' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::InPlace).to receive(:example_exercises).with(exercise: 'blah')
    described_class.example_exercises(exercise: 'blah')
  end

  it 'calls bake note exercises' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::InPlace).to receive(:note_exercises).with(exercise: 'blah')
    described_class.note_exercises(exercise: 'blah')
  end

  it 'calls bake section exercises' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::InPlace).to receive(:section_exercises).with(exercise: 'blah', number: '123')
    described_class.section_exercises(exercise: 'blah', number: '123')
  end
end
