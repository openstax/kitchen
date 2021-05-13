# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIndex::V2 do

  before do
    stub_locales({
      'eob_index_term_title': 'Skorowidz rzeczowy',
      'eob_index_name_title': 'Skorowidz nazwisk',
      'eob_index_foreign_title': 'Skorowidz terminów obcojęzycznych',
      'eob_index_symbols_group': 'Symbole'
    })
  end

  let(:a_section) { described_class::IndexSection.new(name: 'whatever') }

  let(:book_with_regular_terms) do
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
          <span xmlns="http://www.w3.org/1999/xhtml" xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="foo">Foo</span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span data-type="term">foo</span>
            <span xmlns="http://www.w3.org/1999/xhtml" xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" data-type="term" cmlnle:reference="animag">animagiem</span>
            <span data-type="term">ΔE</span>
            <span data-type="term"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_name_terms) do
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
          <span xmlns="http://www.w3.org/1999/xhtml" xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noam Chomsky</span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span xmlns="http://www.w3.org/1999/xhtml" xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Wundt, Wilhelm (1832-1920)" cxlxt:index="name" cxlxt:name="Wundta, Wilhelma" cxlxt:born="1832" cxlxt:died="1920">Wilhelma Wundta</span>
            <span xmlns="http://www.w3.org/1999/xhtml" xmlns:cmlnle="http://katalysteducation.org/cmlnle/1.0" xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cmlnle:reference="Chomsky, Noam (ur. 1928)" cxlxt:index="name" cxlxt:name="Chomsky, Noam" cxlxt:born="1928">Noama Chomsky'ego</span>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_foreign_terms) do
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
          <span xmlns="http://www.w3.org/1999/xhtml" data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">ΔE</span>
          </span>
          <span xmlns="http://www.w3.org/1999/xhtml" data-type="foreign" xml:lang="en">
            <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
          </span>
        </div>
        <div data-type="chapter">
          <div data-type="page" id="p2">
            <div data-type="document-title"><span>1.1</span> First Page</div>
            <span xmlns="http://www.w3.org/1999/xhtml" data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign">introspection</span>
            </span>
            <span xmlns="http://www.w3.org/1999/xhtml" data-type="foreign" xml:lang="en">
              <span xmlns:cxlxt="http://katalysteducation.org/cxlxt/1.0" data-type="term" cxlxt:index="foreign"><em>sp</em><sup>3</sup><em>d</em><sup>2</sup> orbitals</span>
            </span>
          </div>
        </div>
      HTML
    )
  end

  context 'when book contains regular terms' do
    it 'works' do
      described_class.new.bake(book: book_with_regular_terms, type: term)

      expect(book1.first('.os-index-term-container').to_s).to match_normalized_html(
        <<~HTML
          <div class="os-eob os-index-term-container " data-type="composite-page" data-uuid-key=".index-term">
            <h1 data-type="document-title">
              <span class="os-text">Skorowidz rzeczowy</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Skorowidz rzeczowy</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="group-by">
              <span class="group-label">Symbole</span>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbole">&#x394;E</span>
                <a class="os-term-section-link" href="#auto_p2_term5">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">A</span>
              <div class="os-index-item">
                <span class="os-term" group-by="a">animag</span>
                <a class="os-term-section-link" href="#auto_p2_term4">
                  <span class="os-term-section">1.1 First Page</span>
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
                <a class="os-term-section-link" href="#auto_p2_term3">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">S</span>
              <div class="os-index-item">
                <span class="os-term" group-by="s">sp3d2 orbitals</span>
                <a class="os-term-section-link" href="#auto_p2_term6">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when book contains name terms' do
    it 'works' do
      described_class.new.bake(book: book_with_name_terms, type: name)

      expect(book1.first('.os-index-name-container').to_s).to match_normalized_html(
        <<~HTML
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
              <span class="group-label">W</span>
              <div class="os-index-item">
                <span class="os-term" group-by="W">Wundt, Wilhelm (1832-1920)</span>
                <a class="os-term-section-link" href="#auto_p2_term2">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
        HTML
      )
    end
  end

  context 'when book contains foreign terms' do
    it 'works' do
      described_class.new.bake(book: book_with_foreign_terms, type: foreign)

      expect(book1.first('.os-index-foreign-container').to_s).to match_normalized_html(
        <<~HTML
          <div class="os-eob os-index-foreign-container " data-type="composite-page" data-uuid-key=".index-foreign">
            <h1 data-type="document-title">
              <span class="os-text">Skorowidz terminów obcojęzycznych</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Skorowidz terminów obcojęzycznych</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <div class="group-by">
              <span class="group-label">Symbole</span>
              <div class="os-index-item">
                <span class="os-term" group-by="Symbole">&#x394;E</span>
                <a class="os-term-section-link" href="#auto_p1_term1">
                  <span class="os-term-section">Preface</span>
                </a>
              </div>
            </div>
            <div class="group-by">
              <span class="group-label">I</span>
              <div class="os-index-item">
                <span class="os-term" group-by="i">introspection</span>
                <a class="os-term-section-link" href="#auto_p1_term2">
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
                <a class="os-term-section-link" href="#auto_p2_term4">
                  <span class="os-term-section">1.1 First Page</span>
                </a>
              </div>
            </div>
          </div>
        HTML
      )
    end
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

  def text_only_term(text)
    described_class::Term.new(text: text, id: nil, group_by: nil, page_title: nil)
  end

end
