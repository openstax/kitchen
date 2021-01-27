require 'spec_helper'

RSpec.describe Kitchen::ElementBase do

  let(:element) do
    new_element(
      <<~HTML
        <div class="class1" id="div1">
          <p>This is a paragraph.</p>
        </div>
      HTML
    )
  end

  describe '#has_class?' do
    it 'returns true if element has given class' do
      expect(element.has_class?('class1')).to eq true
    end

    it 'returns false if element does not have given class' do
      expect(element.has_class?('class2')).to eq false
    end
  end

  describe '#id' do
    it 'returns the element\'s ID' do
      expect(element.id).to eq 'div1'
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
  end

  describe '#has_ancestor?' do
  end

  context 'add_ancestors' do
  end

  describe '#add_ancestor' do
  end

  describe '#ancestor_elements' do
  end

  describe '#count_as_descendant' do
  end

  describe '#count_in' do
  end

  describe '#remember_that_sub_elements_are_already_counted' do
  end

  describe '#have_sub_elements_already_been_counted?' do
  end

  describe '#number_of_sub_elements_already_counted' do
  end

  describe '#search_history' do
  end

  describe '#search' do
  end

  describe '#first' do
  end

  describe '#first!' do
  end



end
