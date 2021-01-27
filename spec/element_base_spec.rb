require 'spec_helper'

RSpec.describe Kitchen::ElementBase do

  let(:element) do
    book_containing(html:
      one_chapter_with_one_page_containing(
        <<~HTML
          <div data-type="example" class="class1" id="div1">
            <p>This is a paragraph.</p>
          </div>
        HTML
      )
    )
  end

  describe '#has_class?' do
    it 'returns true if element has given class' do
      div_element = element.search('div[data-type="example"]').first
      expect(div_element.has_class?('class1')).to eq true
    end

    it 'returns false if element does not have given class' do
      div_element = element.search('div[data-type="example"]').first
      expect(div_element.has_class?('class2')).to eq false
    end
  end

  describe '#id' do
    it 'returns the element\'s ID' do
      div_element = element.search('div[data-type="example"]').first
      expect(div_element.id).to eq 'div1'
    end
  end

  describe '#id=' do
    it 'sets the element\'s ID' do
      para = element.search('p').first
      para.id = 'para1'
      expect(para.id).to match('para1')
    end
  end

  describe '#set' do
    it 'changes the tag name of an element' do
      element.set(:name, 'section')
      expect(element.name).to match('section')
    end

    it 'sets the value of a element\'s property' do
      element.set(:id, 'newDivID')
      expect(element.id).to match('newDivID')
    end

    it 'changes the tag name of an element and gives it a property and value' do
      p_element = element.search('p').first
      p_matcher = /<p>This is a paragraph.<\/p>/
      span_matcher = /<span class="span1">This is a paragraph.<\/span>/
      expect {
        p_element.set(:name, 'span').set(:class, 'span1')
      }.to change {
        p_element.to_html
      }.from(p_matcher).to(span_matcher)
    end
  end

  describe '#ancestor' do
    it 'returns element\'s ancestor of the given type' do
      p_element = element.chapters.pages.examples.search('p').first
      expect(p_element.ancestor(:example).id).to eq 'div1'
    end

    it 'raises an error when there is no ancestor of the given type' do
      p_element = element.chapters.pages.examples.search('p').first
      type = :figure
      expect {
        p_element.ancestor(type).id
      }.to raise_error("No ancestor of type '#{type}'")
    end
  end

  describe '#has_ancestor?' do
    it 'returns true if element has ancestor of given type' do
      p_element = element.chapters.pages.examples.search('p').first
      expect(p_element.has_ancestor?(:chapter)).to eq true
    end

    it 'returns false if element does not have ancestor of given type' do
      p_element = element.chapters.pages.examples.search('p').first
      expect(p_element.has_ancestor?(:figure)).to eq false
    end
  end

end
