# frozen_string_literal: true

module Kitchen::Directions::BakeBookAnswerKey
  class V1
    renderable

    def bake(book:)
      @metadata_elements = book.metadata.children_to_keep.copy
      book.first('body').append(child: render(file: 'eob.xhtml.erb'))
    end
  end
end
