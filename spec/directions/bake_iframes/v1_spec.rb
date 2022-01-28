# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeIframes::V1 do
  let(:book_with_div_media) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-alt="atoms_isotopes" data-type="media" id="auto_78a58d46-6a29-4972-b848-385be0c8057f_11">
            <iframe height="371.4" src="url" width="660">
          <!-- no-selfclose -->
            </iframe>
          </div>
        HTML
      )
    )
  end

  let(:book_with_internal_resource) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-alt="atoms_isotopes" data-type="media" id="auto_78a58d46-6a29-4972-b848-385be0c8057f_11">
            <iframe height="371.4" src="../resources/Interactive/090221_opx_comp_ch04_1a_drag_and_drop_labeling/index.html" width="660">
          <!-- no-selfclose -->
            </iframe>
          </div>
        HTML
      )
    )
  end

  let(:book_with_note) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <div data-alt="atoms_isotopes" data-type="media">
              <iframe height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                </iframe>
            </div>
          </div>
          <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
            <div data-alt="atoms_isotopes" data-type="media">
              <iframe height="371.4" width="660"><!-- no-selfclose -->
              </iframe>
            </div>
          </div>
          <div class="interactive interactive-long" data-has-label="true" data-label="" data-type="note" id="iframenote3">
            <ul>
              <li>1: The evolution from fish to earliest tetrapod<span data-type="newline"><br /></span>
                <div data-alt="tetrapod_evol1" data-type="media"><iframe height="371.4" src="url1" width="660"><!-- no-selfclose --></iframe></div>
              </li>
              <li>2: The discovery of coelacanth and <em data-effect="italics">Acanthostega</em> fossils<span data-type="newline"><br /></span>
                <div data-alt="tetrapod_evol2" data-type="media"><iframe height="371.4" src="url2" width="660"><!-- no-selfclose --></iframe></div>
              </li>
            </ul>
          </div>
        HTML
      )
    )
  end

  let(:book_with_baked_iframes) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="abc" target="_window">Click to view content</a>
            <iframe height="371.4" src="abc" width="660" class="os-is-iframe">
          <!-- no-selfclose -->
            </iframe>
          </div>
        HTML
      )
    )
  end

  before do
    stub_locales({
      'iframe_link_text': 'Click to view content'
    })
  end

  it 'bakes iframe in div[data-type="media"] outer element' do
    described_class.new.bake(outer_element: book_with_div_media)
    expect(book_with_div_media.search('div[data-type="media"]').to_s).to match_normalized_html(
      <<~HTML
              <div data-alt="atoms_isotopes" data-type="media" id="auto_78a58d46-6a29-4972-b848-385be0c8057f_11">
                <div class="os-has-iframe os-has-link" data-type="alternatives">
                  <a class="os-is-link" href="url" target="_window">Click to view content (url)</a>
                  <iframe class="os-is-iframe" height="371.4" src="url" width="660">
        <!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
      HTML
    )
  end

  it 'bakes iframe in note outer element' do
    described_class.new.bake(outer_element: book_with_note)
    expect(book_with_note.search('div.interactive[data-type="note"]').to_s).to match_normalized_html(
      <<~HTML
            <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
                <div data-alt="atoms_isotopes" data-type="media">
                  <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="https://openstax.org/l/atoms_isotopes" target="_window">Click to view content (https://openstax.org/l/atoms_isotopes)</a>
                    <iframe class="os-is-iframe" height="371.4" src="https://openstax.org/l/atoms_isotopes" width="660"><!-- no-selfclose -->
                    </iframe>
                  </div>
                </div>
            </div>
            <div class="interactive" data-has-label="true" data-label="" data-type="note" id="iframenote">
                <div data-alt="atoms_isotopes" data-type="media">
                  <div class="os-has-iframe" data-type="alternatives">
                    <iframe class="os-is-iframe" height="371.4" width="660">
        <!-- no-selfclose -->
                    </iframe>
                  </div>
                </div>
            </div>
            <div class="interactive interactive-long" data-has-label="true" data-label="" data-type="note" id="iframenote3">
              <ul>
                <li>1: The evolution from fish to earliest tetrapod<span data-type="newline"><br /></span>
              <div data-alt="tetrapod_evol1" data-type="media">
                <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="url1" target="_window">Click to view content (url1)</a>
                  <iframe class="os-is-iframe" height="371.4" src="url1" width="660"><!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </li>
                <li>2: The discovery of coelacanth and <em data-effect="italics">Acanthostega</em> fossils<span data-type="newline"><br /></span>
              <div data-alt="tetrapod_evol2" data-type="media">
                <div class="os-has-iframe os-has-link" data-type="alternatives"><a class="os-is-link" href="url2" target="_window">Click to view content (url2)</a>
                  <iframe class="os-is-iframe" height="371.4" src="url2" width="660"><!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
            </li>
              </ul>
          </div>
      HTML
    )
  end

  it 'doesn\'t double-bake' do
    book_with_baked_iframes_snapshot = book_with_baked_iframes.copy
    described_class.new.bake(outer_element: book_with_baked_iframes)
    expect(book_with_baked_iframes).to match_normalized_html(book_with_baked_iframes_snapshot)
  end

  it 'bakes iframe with internal resource link' do
    described_class.new.bake(outer_element: book_with_internal_resource)
    expect(book_with_internal_resource.search('div[data-type="media"]').to_s).to match_normalized_html(
      <<~HTML
              <div data-alt="atoms_isotopes" data-type="media" id="auto_78a58d46-6a29-4972-b848-385be0c8057f_11">
                <div class="os-has-iframe os-has-link" data-type="alternatives">
                  <a class="os-is-link" data-rexify-href="true" href="rex#auto_78a58d46-6a29-4972-b848-385be0c8057f_11" target="_window">Click to view content (<span data-rexify-text="true">rex#auto_78a58d46-6a29-4972-b848-385be0c8057f_11</span>)</a>
                  <iframe class="os-is-iframe" height="371.4" src="../resources/Interactive/090221_opx_comp_ch04_1a_drag_and_drop_labeling/index.html" width="660">
        <!-- no-selfclose -->
                  </iframe>
                </div>
              </div>
      HTML
    )
  end
end
