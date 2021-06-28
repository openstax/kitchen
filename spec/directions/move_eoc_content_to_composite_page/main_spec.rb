# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::MoveEocContentToCompositePage do
  it 'calls v1' do
    expect_any_instance_of(Kitchen::Directions::MoveEocContentToCompositePage::V1).to receive(:bake)
      .with(metadata_source: 'metadata', content: 'content', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
    described_class.v1(metadata_source: 'metadata', content: 'content', append_to: 'element', klass: 'class', uuid_prefix: 'uuid')
  end
end
