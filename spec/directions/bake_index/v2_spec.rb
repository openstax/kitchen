# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex::V2 do

  before do
    stub_locales({
      'eob_index_symbols_group': 'Symbole',
      'index': {
        'name': 'Skorowidz nazwisk',
        'term': 'Skorowidz rzeczowy',
        'foreign': 'Skorowidz terminów obcojęzycznych'
      }
    })
  end

  let(:a_section) { described_class::IndexSection.new(name: 'whatever') }

  let(:book1) do
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
          <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="foo">Foo</span>
          <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noam Chomsky</span>
          <span data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">ΔE</span>
          </span>
          <span data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
          </span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="animag">animagiem</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Wundt, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Wundta, Wilhelma" cxlxt:born="1832" cxlxt:died="1920">Wilhelma Wundta</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noama Chomsky'ego</span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
            </span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            </span>
          </div>
          <div data-type="composite-chapter">
            <div data-type="document-title">Chapter Review</div>
            <div data-type="composite-page">
              <div data-type="title">EOC Section Title</div>
              <span data-type="term">composite page in a composite chapter</span>
            </div>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p4"/>
          <div data-type="composite-page">
            <div data-type="document-title">Another EOC Section</div>
            <span data-type="term">composite page at the top level</span>
          </div>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(book: book1, types: %w[name term foreign])
    expect(book1.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="metadata" style="display: none;">
            <div class="authors" id="authors">Authors</div>
            <div class="publishers" id="publishers">Publishers</div>
            <div class="print-style" id="print-style">Print Style</div>
            <div class="permissions" id="permissions">Permissions</div>
            <div data-type="subject" id="subject">Subject</div>
          </div>
          <div data-type="page" id="p1">
            <div data-type="document-title">Preface</div>
            <span data-type="term" group-by="f" id="auto_p1_term1">foo</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="foo" id="auto_p1_term2" group-by="f">Foo</span>
            <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928" id="auto_p1_term3" group-by="C">Noam Chomsky</span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign" id="auto_p1_term4" group-by="Symbole">ΔE</span>
            </span>
            <span data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign" id="auto_p1_term5" group-by="i">introspection</span>
            </span>
          </div>
          <div data-type="chapter">
            <div data-type="page" id="p2">
              <div data-type="document-title"><span>1.1</span> First Page</div>
              <span data-type="term" id="auto_p2_term6" group-by="f">foo</span>
              <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="animag" id="auto_p2_term7" group-by="a">animagiem</span>
              <span data-type="term" id="auto_p2_term8" group-by="Symbole">ΔE</span>
              <span data-type="term" id="auto_p2_term9" group-by="s"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
              <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Wundt, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Wundta, Wilhelma" cxlxt:born="1832" cxlxt:died="1920" id="auto_p2_term10" group-by="W">Wilhelma Wundta</span>
              <span xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928" id="auto_p2_term11" group-by="C">Noama Chomsky'ego</span>
              <span data-type="foreign" xml:lang="en">
                <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign" id="auto_p2_term12" group-by="i">introspection</span>
              </span>
              <span data-type="foreign" xml:lang="en">
                <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign" id="auto_p2_term13" group-by="s"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
              </span>
            </div>
            <div data-type="composite-chapter">
              <div data-type="document-title">Chapter Review</div>
              <div data-type="composite-page">
                <div data-type="title">EOC Section Title</div>
                <span data-type="term" id="auto_composite_page_term1" group-by="c">composite page in a composite chapter</span>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div data-type="page" id="p4"/>
            <div data-type="composite-page">
              <div data-type="document-title">Another EOC Section</div>
              <span data-type="term" id="auto_composite_page_term2" group-by="c">composite page at the top level</span>
            </div>
          </div>
          <div class="os-eob os-index-name-container " data-type="composite-page" data-uuid-key=".index-name">
            <h1 data-type="document-title">
              <span class="os-text">Skorowidz nazwisk</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Skorowidz nazwisk</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="group-by">
              <span class="group-label">C</span>
              <div class="os-index-item">
                <span class="os-term" group-by="C">Chomsky, Noam (ur. 1928)</span>
                <a class="os-term-section-link" href="#auto_p1_term3">
                  <span class="os-term-section">Preface</span>
                </a>
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p2_term11">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">W</span>
              <div class="os-index-item">
                <span class="os-term" group-by="W">Wundt, Wilhelm (1832-1920)</span>
                <a class="os-term-section-link" href="#auto_p2_term10">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
          <div class="os-eob os-index-term-container " data-type="composite-page" data-uuid-key=".index-term">
            <h1 data-type="document-title">
              <span class="os-text">Skorowidz rzeczowy</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Skorowidz rzeczowy</h1>
              <div class="authors" id="authors_copy_2">Authors</div>
              <div class="publishers" id="publishers_copy_2">Publishers</div>
              <div class="print-style" id="print-style_copy_2">Print Style</div>
              <div class="permissions" id="permissions_copy_2">Permissions</div>
              <div data-type="subject" id="subject_copy_2">Subject</div>
            </div>
            <div class="group-by">
              <span class="group-label">Symbole</span>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbole">&#x394;E</span>
                <a class="os-term-section-link" href="#auto_p2_term8">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">A</span>
              <div class="os-index-item">
                <span class="os-term" group-by="a">animag</span>
                <a class="os-term-section-link" href="#auto_p2_term7">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">C</span>
              <div class="os-index-item">
                <span class="os-term" group-by="c">composite page at the top level</span>
                <a class="os-term-section-link" href="#auto_composite_page_term2">
                  <span class="os-term-section">2 Another EOC Section</span>
                </a>
              </div>
              <div class="os-index-item">
                <span class="os-term" group-by="c">composite page in a composite chapter</span>
                <a class="os-term-section-link" href="#auto_composite_page_term1">
                  <span class="os-term-section">1 EOC Section Title</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">F</span>
              <div class="os-index-item">
                <span class="os-term" group-by="f">foo</span>
                <a class="os-term-section-link" href="#auto_p1_term1">
                  <span class="os-term-section">Preface</span>
                </a>
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p1_term2">
                  <span class="os-term-section">Preface</span>
                </a>
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p2_term6">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">S</span>
              <div class="os-index-item">
                <span class="os-term" group-by="s">sp3d2 orbitals</span>
                <a class="os-term-section-link" href="#auto_p2_term9">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
          <div class="os-eob os-index-foreign-container " data-type="composite-page" data-uuid-key=".index-foreign">
            <h1 data-type="document-title">
              <span class="os-text">Skorowidz terminów obcojęzycznych</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Skorowidz terminów obcojęzycznych</h1>
              <div class="authors" id="authors_copy_3">Authors</div>
              <div class="publishers" id="publishers_copy_3">Publishers</div>
              <div class="print-style" id="print-style_copy_3">Print Style</div>
              <div class="permissions" id="permissions_copy_3">Permissions</div>
              <div data-type="subject" id="subject_copy_3">Subject</div>
            </div>
            <div class="group-by">
              <span class="group-label">Symbole</span>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbole">&#x394;E</span>
                <a class="os-term-section-link" href="#auto_p1_term4">
                  <span class="os-term-section">Preface</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">I</span>
              <div class="os-index-item">
                <span class="os-term" group-by="i">introspection</span>
                <a class="os-term-section-link" href="#auto_p1_term5">
                  <span class="os-term-section">Preface</span>
                </a>
                <span class="os-index-link-separator">, </span>
                <a class="os-term-section-link" href="#auto_p2_term12">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">S</span>
              <div class="os-index-item">
                <span class="os-term" group-by="s">sp3d2 orbitals</span>
                <a class="os-term-section-link" href="#auto_p2_term13">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  it 'sorts terms with accent marks' do
    a_section.add_term(text_only_term('Hu'))
    a_section.add_term(text_only_term('Hückel'))
    a_section.add_term(text_only_term('Héroult'))
    a_section.add_term(text_only_term('Hunk'))

    expect(a_section.items.map(&:term_text)).to eq %w[Héroult Hu Hückel Hunk]
  end

  it 'sorts terms starting with symbols' do
    a_section.add_term(text_only_term('Δoct'))
    a_section.add_term(text_only_term('π*'))
    expect(a_section.items.map(&:term_text)).to eq %w[Δoct π*]
  end

  it 'sorts index items with superscript' do
    a_section.add_term(text_only_term('sp hybrid'))
    a_section.add_term(text_only_term('sp2 hybrid'))    # sp^2 hybrid
    a_section.add_term(text_only_term('sp3 hybrid'))    # sp^3 hybrid
    a_section.add_term(text_only_term('sp3d hybrid'))   # (sp^3)(d) hybrid
    a_section.add_term(text_only_term('sp3d2 hybrid'))  # (sp^3)(d^2) hybrid
    expect(a_section.items.map(&:term_text)).to eq [
      'sp hybrid', 'sp2 hybrid', 'sp3 hybrid', 'sp3d hybrid', 'sp3d2 hybrid'
    ]
  end

  it 'collapses the same term with different capitalization into one item with lowercase' do
    a_section.add_term(text_only_term('temperature'))
    a_section.add_term(text_only_term('Temperature'))
    expect(a_section.items.count).to eq 1
    expect(a_section.items.first.term_text).to eq 'temperature'
  end

  it 'sorts terms with polish diacritics' do
    with_locale(:pl) do
      a_section.add_term(text_only_term('Sąd'))
      a_section.add_term(text_only_term('Sen'))
      a_section.add_term(text_only_term('Sad'))
      a_section.add_term(text_only_term('Sędziwy'))

      expect(a_section.items.map(&:term_text)).to eq %w[Sad Sąd Sen Sędziwy]
    end
  end

  def text_only_term(text)
    described_class::Term.new(text: text, id: nil, group_by: nil, page_title: nil)
  end

end
