# frozen_string_literal: true

module Kitchen::Directions::EocContentTransform
  def self.v1(section:, strategy:)
    send(strategy, section: section)
  end

  def self.remove_title(section:)
    section.first('h3').trash
  end
end
