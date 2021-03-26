# frozen_string_literal: true

module Kitchen::Directions::BakeBookAnswerKey
  class V1
    renderable

    def bake(book:)
      @metadata = book.metadata.children_to_keep.copy
      book.first('body').append(child: render(file: 'eob.xhtml.erb'))
      book.first('body').first('.os-eob.os-solutions-container')
    end
  end
end
