# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V1
    renderable

    def bake(book:, solutions_plural:)
      @composite_element = 'composite-chapter'
      @metadata = book.metadata.children_to_keep.copy
      @answer_key_class = case solutions_plural
                          when true
                            'solutions'
                          when :prefix
                            'end-of-book-solutions'
                          else
                            'solution'
                          end
      @title = I18n.t(:answer_key_title)
      @main_title_tag = 'h1'
      @uuid_key = @answer_key_class
      book.body.append(child: render(file: 'eob_answer_key_container.xhtml.erb'))
      book.body.first("div.os-eob.os-#{@answer_key_class}-container")
    end
  end
end
