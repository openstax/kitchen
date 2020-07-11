require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex::V1 do

  before do
    stub_locales({
      'eob_index_title': "Index",
      'eob_index_symbols_group': "Symbols"
    })
  end

  let(:book_1) do
    book_containing(html:
      <<~HTML
        <div data-type="metadata" style="display: none;">
          <div class="authors" id="authors">Authors</div>
          <div class="publishers" id="publishers">Publishers</div>
          <div class="print-style" id="print-style">Print Style</div>
          <div class="permissions" id="permissions">Permissions</div>
          <div data-type="subject" id="subject">Subject</div>
        </div>
        <div data-type="page" id="p1">
          <div data-type="document-title">Preface</div>
          <span data-type="term">foo</span>
          <span data-type="term">Foo</span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
          </div>
        </div>
      HTML
    )
  end

  it "works" do
    described_class.new.bake(book: book_1)

    expect(book_1.first(".os-index-container").to_s).to match_normalized_html(
      <<~HTML
        <div class="os-eob os-index-container " data-type="composite-page" data-uuid-key="index">
          <h1 data-type="document-title">
            <span class="os-text">Index</span>
          </h1>
          <div data-type="metadata" style="display: none;">
            <h1 data-type="document-title" itemprop="name">Index</h1>
            <div class="authors" id="authors_copy_1">Authors</div>
            <div class="publishers" id="publishers_copy_1">Publishers</div>
            <div class="print-style" id="print-style_copy_1">Print Style</div>
            <div class="permissions" id="permissions_copy_1">Permissions</div>
            <div data-type="subject" id="subject_copy_1">Subject</div>
          </div>
          <div class="group-by">
            <span class="group-label">Symbols</span>
            <div class="os-index-item">
              <span class="os-term" group-by="Symbols">&#x394;E</span>
              <a class="os-term-section-link" href="#auto_p2_term4">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">F</span>
            <div class="os-index-item">
              <span class="os-term" group-by="F">Foo</span>
              <a class="os-term-section-link" href="#auto_p1_term2">
                <span class="os-term-section">Preface</span>
              </a>
            </div>
            <div class="os-index-item">
              <span class="os-term" group-by="f">foo</span>
              <a class="os-term-section-link" href="#auto_p1_term1">
                <span class="os-term-section">Preface</span>
              </a>
              <span class="os-index-link-separator">, </span>
              <a class="os-term-section-link" href="#auto_p2_term3">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
          <div class="group-by">
            <span class="group-label">S</span>
            <div class="os-index-item">
              <span class="os-term" group-by="s">sp3d2 orbitals</span>
              <a class="os-term-section-link" href="#auto_p2_term5">
                <span class="os-term-section">1.1 First Page</span>
              </a>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it "sorts terms with accent marks" do
    section = described_class::IndexSection.new(name: "whatever")
    section.add_term(text_only_term("Hu"))
    section.add_term(text_only_term("Hückel"))
    section.add_term(text_only_term("Héroult"))
    section.add_term(text_only_term("Hunk"))

    expect(section.items.map(&:term_text)).to eq %w(Héroult Hu Hückel Hunk)
  end

  it "sorts terms starting with symbols" do
    section = described_class::IndexSection.new(name: "whatever")
    section.add_term(text_only_term("Δoct"))
    section.add_term(text_only_term("π*"))
    expect(section.items.map(&:term_text)).to eq %w(Δoct π*)
  end

  it "sorts uppercase first for same term" do
    section = described_class::IndexSection.new(name: "whatever")
    section.add_term(text_only_term("hu"))
    section.add_term(text_only_term("Hu"))
    expect(section.items.map(&:term_text)).to eq %w(Hu hu)
  end

  it "sorts index items with superscript" do
    section = described_class::IndexSection.new(name: "whatever")
    section.add_term(text_only_term("sp hybrid"))
    section.add_term(text_only_term("sp2 hybrid"))    # sp^2 hybrid
    section.add_term(text_only_term("sp3 hybrid"))    # sp^3 hybrid
    section.add_term(text_only_term("sp3d hybrid"))   # (sp^3)(d) hybrid
    section.add_term(text_only_term("sp3d2 hybrid"))  # (sp^3)(d^2) hybrid
    expect(section.items.map(&:term_text)).to eq [
      "sp hybrid", "sp2 hybrid", "sp3 hybrid", "sp3d hybrid", "sp3d2 hybrid"
    ]
  end

  def text_only_term(text)
    described_class::Term.new(text: text, id: nil, group_by: nil, page_title: nil)
  end

end
