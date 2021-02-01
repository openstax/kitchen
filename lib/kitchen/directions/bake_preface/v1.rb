module Kitchen::Directions::BakePreface
  class V1
    def book(book:)
      book.pages("$.preface").search("div[data-type='document-title']").each do |title| # TODO add title method
        title.replace_children(with:
          <<~HTML
            <span data-type="" itemprop="" class="os-text">#{title.text}</span>
          HTML
        )
        title.name = "h1"
      end
    end
  end
end
