# frozen-string-literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::EocSectionTitleLinkSnippet do
  before do
    stub_locales({
      'eoc': {
        'top-level': 'Top Level Container',
        'some-eoc-section': 'Some Eoc Section'
      }
    })
  end
end
