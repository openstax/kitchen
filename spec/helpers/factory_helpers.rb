# frozen-string-literal: true

module FactoryHelpers
  def book_containing(html:, short_name: :not_set, add_math_namespace: true)
    Kitchen::BookDocument.new(short_name: short_name, document: Nokogiri::XML(
      <<~HTML
        <html #{'xmlns:m="http://www.w3.org/1998/Math/MathML"' if add_math_namespace}>
          <body>
            #{html}
          </body>
        </html>
      HTML
    )).book
  end

  def one_chapter_with_one_page_containing(html)
    <<~HTML
      <div data-type="chapter">
        <div data-type="page">
          #{html}
        </div>
      </div>
    HTML
  end

  def page_element(page_children_html)
    book_containing(html: "<div data-type='page'>#{page_children_html}</div>").pages.first
  end

  def new_element(html)
    nokogiri_document = Nokogiri::XML(
      <<~HTML
        <html>
          <body>
            #{html}
          </body>
        </html>
      HTML
    )

    children = nokogiri_document.search('body').first.element_children
    raise('new_element must only make one top-level element') if children.many?

    node = children.first

    Kitchen::Element.new(
      node: node,
      document: Kitchen::Document.new(nokogiri_document: nokogiri_document)
    )
  end
end

def chapter_element(chapter_children_html)
  book_containing(html: "<div data-type='chapter'>#{chapter_children_html}</div>").chapters.first
end

def note_element(note_html)
  book_containing(html: note_html).notes.first
end

def metadata_element
  book_containing(html:
    <<~HTML
      <div data-type="metadata" style="display: none;">
        <span data-type="revised" id="revised">Revised</span>
        <span data-type="slug" id="slug">Slug</span>
        <div class="authors" id="authors">Authors</div>
        <div class="publishers" id="publishers">Publishers</div>
        <div class="print-style" id="print-style">Print Style</div>
        <div class="permissions" id="permissions">Permissions</div>
        <div data-type="subject" id="subject">Subject</div>
      </div>
    HTML
  ).metadata
end
