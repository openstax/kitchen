# frozen_string_literal: true

module Kitchen::Directions::BakeFurtherReading
  def self.v1(chapter:, metadata_source:, uuid_prefix: '.', klass: 'further-reading')

    further_reading = Kitchen::Clipboard.new

    chapter.search('section.further-reading').each do |section|
      section.search('h3').cut
      section.cut(to: further_reading)
    end

    Kitchen::Directions::EocCompositePageContainer.v1(
      container_key: klass,
      uuid_key: "#{uuid_prefix}#{klass}",
      metadata_source: metadata_source,
      content: further_reading.paste,
      append_to: chapter
    )
  end
end
