# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::SearchQuery do
  let(:css_or_xpath) { nil }
  let(:only) { nil }
  let(:except) { nil }
  let(:instance) { described_class.new(css_or_xpath: css_or_xpath, only: only, except: except) }

  describe '#apply_default_css_or_xpath_and_normalize' do
    it 'arrayifies a string' do
      expect_normalization(css_or_xpath: 'foo', to: ['foo'])
    end

    it 'passes through an array' do
      expect_normalization(css_or_xpath: ['foo'], to: ['foo'])
    end

    it 'replaces $ with default css in a string' do
      expect_normalization(css_or_xpath: '$.hi', default_css_or_xpath: 'div', to: ['div.hi'])
    end

    it 'replaces $ with default css in an array' do
      expect_normalization(css_or_xpath: ['$.hi', '$#bar'], default_css_or_xpath: 'div', to: ['div.hi', 'div#bar'])
    end

    it 'clears $ when no default' do
      expect_normalization(css_or_xpath: '$.bar', to: ['.bar'])
    end

    it 'gives empty string when no css and no default' do
      expect_normalization(to: [''])
    end

    it 'adds a $ when css nil' do
      expect_normalization(default_css_or_xpath: 'div', to: ['div'])
    end
  end

  def expect_normalization(to:, css_or_xpath: nil, default_css_or_xpath: nil)
    instance = described_class.new(css_or_xpath: css_or_xpath)
    instance.apply_default_css_or_xpath_and_normalize(default_css_or_xpath)
    expect(instance.css_or_xpath).to eq to
  end

end
