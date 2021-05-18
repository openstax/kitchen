# frozen_string_literal: true

module Kitchen::Directions::BookAnswerKeyContainer
  class V1
    renderable
    def bake(book:, klass:)
      @klass = klass
      @metadata = book.metadata.children_to_keep.copy
      book.body.append(child: render(file: 'eob_answer_key_outer_container.xhtml.erb'))
      book.body.first(".os-eob.os-#{@klass}-container")
    end
  end
end
