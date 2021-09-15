# frozen_string_literal: true

module Kitchen
  module Directions
    # Adds learning objectives header to abstracts
    module BakePageAbstracts
      def self.v1(chapter:)
        chapter.abstracts.each do |abstract|
          abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
        end
      end

      def self.v2(chapter:)
        chapter.abstracts.each do |abstract|
          abstract.prepend(child: "<h3 data-type='title'>#{I18n.t(:learning_objectives)}</h3>")
          modify_abstract_list(chapter: chapter, element: abstract)
        end
      end

      def self.v3(chapter:)
        chapter.search('section.learning-objectives').each do |learning_objective|
          modify_abstract_list(chapter: chapter, element: learning_objective)
        end
      end

      def self.modify_abstract_list(chapter:, element:)
        ul = element.first!('ul')
        ul.add_class('os-abstract')
        ul.search('li').each_with_index do |li, index|
          li.replace_children(with:
            <<~HTML
              <span class="os-abstract-token">#{chapter.count_in(:book)}.#{element.count_in(:chapter)}.#{index + 1}</span>
              <span class="os-abstract-content">#{li.children}</span>
            HTML
          )
        end
      end
    end
  end
end
