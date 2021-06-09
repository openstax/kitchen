# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V1
    renderable

    def bake(book:, solutions_plural: true)
      @metadata = book.metadata.children_to_keep.copy
      @solutions_plural = solutions_plural
      book.body.append(child: render(file: 'eob_solutions_container.xhtml.erb'))
      book.body.first("div.os-eob.os-solution#{'s' if solutions_plural}-container")
    end
  end
end
