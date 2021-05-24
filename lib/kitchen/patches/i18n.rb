# frozen_string_literal: true

require 'twitter_cldr'

# rubocop:disable Style/Documentation
module I18n
  def self.sort_strings(first, second)
    # TwitterCldr does not know about our :test locale, so substitute the English one
    locale = I18n.locale == :test ? :en : I18n.locale
    @sorters ||= {}
    sorter = @sorters[locale] ||= TwitterCldr::Collation::Collator.new(locale)
    sorter.compare(first, second)
  end
end
# rubocop:enable Style/Documentation
