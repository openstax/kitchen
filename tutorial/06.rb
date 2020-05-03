#!/usr/bin/env ruby

require "bundler/setup"
require "byebug"
require "kitchen"

recipe_06 = Kitchen::Recipe.new do |doc:|

  doc.each(".note") do |note|
    note.append child: <<~HTML
      <div>#{note.content(".title")}</div>
    HTML
  end

end

Kitchen::Oven.bake(
  input_file: File.expand_path("06-nesting-quirks.html", __dir__),
  recipes: recipe_06,
  output_file: File.expand_path("outputs/06-nesting-quirks-baked.html", __dir__)
)
