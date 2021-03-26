# frozen_string_literal: true

module Kitchen::Directions::BakeChapterAnswerKey
  class V1
    def bake(chapter:, metadata_source:, strategy:, append_to:)
      strategy =
        case strategy
        when :calculus
          Strategies::Calculus
        else
          raise 'No such strategy'
        end

      append_to.append(child:
        <<~HTML
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions#{chapter.count_in(:book)}">
            <h2 data-type="document-title">
              #{I18n.t(:chapter)} #{chapter.count_in(:book)}
            </h2>
            #{metadata_source.copy}
          </div>
        HTML
      )

      solutions_wrapper = append_to.first("[data-uuid-key='.solutions#{chapter.count_in(:book)}']")

      # puts solutions_wrapper
      # Add a new last_element method to Kitchen::ElementBase - should wrap
      # https://nokogiri.org/rdoc/Nokogiri/XML/Node.html#last_element_child-instance_method
      strategy.new.bake(chapter: chapter, append_to: solutions_wrapper)
    end
  end
end
