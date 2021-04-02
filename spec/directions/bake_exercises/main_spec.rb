# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeExercises do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::BakeExercises::V1).to receive(:bake)
      .with(
        book: 'blah',
        exercise_section_classname: 'classname',
        exercise_section_title: 'title'
    )
    described_class.v1(
      book: 'blah',
      exercise_section_classname: 'classname',
      exercise_section_title: 'title'
    )
  end
end
