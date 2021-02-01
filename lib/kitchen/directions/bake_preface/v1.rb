module Kitchen::Directions::BakePreface
  class V1
    def book(book:)
        book.pages("$.preface").titles.each do |title| {
          title.replace_children(with:
            <<~HTML
              <span data-type="" itemprop="" class="os-text">#{title.text}</span>
            HTML
          )
          title.name = "h1"
        }
      end
    end
  end
end
