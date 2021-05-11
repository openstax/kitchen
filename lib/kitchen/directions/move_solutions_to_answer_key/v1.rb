# frozen_string_literal: true

module Kitchen::Directions::MoveSolutionsToAnswerKey
  class V1
    def bake(chapter:, metadata_source:, strategy:, append_to:)
      strategy =
        case strategy
        when :calculus
          Strategies::Calculus
        when :uphysics
          Strategies::UPhysics
        when :american_government
          Strategies::AmericanGovernment
        when :sociology
          Strategies::Sociology
        else
          raise 'No such strategy'
        end

      append_to.append(child:
        <<~HTML
          <div class="os-eob os-solutions-container" data-type="composite-page" data-uuid-key=".solutions#{chapter.count_in(:book)}">
            <h2 data-type="document-title">
              <span class="os-text">#{I18n.t(:chapter)} #{chapter.count_in(:book)}</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:chapter)} #{chapter.count_in(:book)}</h1>
              #{metadata_source.children_to_keep.copy.paste}
            </div>
          </div>
        HTML
      )
      strategy.new.bake(chapter: chapter, append_to: append_to.last_element)
    end
  end
end
