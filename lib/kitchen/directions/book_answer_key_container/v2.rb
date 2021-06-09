# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V2
    # Difference from v1: singular append_solution_area
    def bake(book:)
      metadata = book.metadata.children_to_keep.copy
      book.body.append(child:
        <<~HTML
          <div class="os-eob os-solution-container" data-type="composite-chapter" data-uuid-key=".solution">
            <h1 data-type="document-title">
              <span class="os-text">#{I18n.t(:answer_key_title)}</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:answer_key_title)}</h1>
              #{metadata.paste}
            </div>
          </div>
        HTML
      )
      book.body.first('div.os-eob.os-solution-container')
    end
  end
end
