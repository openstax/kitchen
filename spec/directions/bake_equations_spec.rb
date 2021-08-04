# frozen_string_literal: true

RSpec.describe Kitchen::Directions::BakeEquations do

  before do
    stub_locales({
      'equation': 'Equation'
    })
  end

  let(:book_with_equations) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="equation" class="unnumbered" id="aaa">
            <p>do nothing</p>
          </div>
          <div data-type="equation" id="123">
            <p>equation 1</p>
          </div>
        </div>
        <div data-type="chapter">
          <div data-type="equation" id="456">
            <p>4+4=8</p>
          </div>
          <div data-type="equation" id="789">
            <p>e=mc^2</p>
          </div>
        </div>
      HTML
    )
  end

  let(:book_with_one_equation) do
    book_containing(html:
      <<~HTML
        <div data-type="chapter">
          <div data-type="equation" id="123">
            <p>equation 1</p>
          </div>
        </div>
      HTML
    )
  end

  it 'bakes' do
    described_class.v1(book: book_with_equations)
    expect(book_with_equations.body).to match_normalized_html(
      <<~HTML
        <body>
          <div data-type="chapter">
            <div data-type="equation" class="unnumbered" id="aaa">
              <p>do nothing</p>
            </div>
            <div data-type="equation" id="123">
              <p>equation 1</p>
              <div class="os-equation-number">
                <span class="os-number">1.1</span>
              </div>
            </div>
          </div>
          <div data-type="chapter">
            <div data-type="equation" id="456">
              <p>4+4=8</p>
              <div class="os-equation-number">
                <span class="os-number">2.1</span>
              </div>
            </div>
            <div data-type="equation" id="789">
              <p>e=mc^2</p>
              <div class="os-equation-number">
                <span class="os-number">2.2</span>
              </div>
            </div>
          </div>
        </body>
      HTML
    )
  end

  it 'decorates number with parenthesis' do
    described_class.v1(book: book_with_one_equation, number_decorator: :parentheses)
    expect(book_with_one_equation.chapters.first).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type="equation" id="123">
            <p>equation 1</p>
            <div class="os-equation-number">
              <span class="os-number">(1.1)</span>
            </div>
          </div>
        </div>
      HTML
    )
  end

  it 'raises if decorator is not supported' do
    expect {
      described_class.v1(book: book_with_one_equation, number_decorator: :dots)
    }.to raise_error("Unsupported number_decorator 'dots'")
  end

  context 'when book does not use grammatical cases' do
    it 'stores link text' do
      pantry = book_with_one_equation.pantry(name: :link_text)
      expect(pantry).to receive(:store).with('Equation 1.1', { label: '123' })
      described_class.v1(book: book_with_one_equation)
    end
  end

  context 'when book uses grammatical cases' do
    it 'stores link text' do
      with_locale(:pl) do
        stub_locales({
          'equation': {
            'nominative': 'Równanie',
            'genitive': 'Równania'
          }
        })

        pantry = book_with_one_equation.pantry(name: :nominative_link_text)
        expect(pantry).to receive(:store).with('Równanie 1.1', { label: '123' })

        pantry = book_with_one_equation.pantry(name: :genitive_link_text)
        expect(pantry).to receive(:store).with('Równania 1.1', { label: '123' })
        described_class.v1(book: book_with_one_equation, cases: true)
      end
    end
  end

end
