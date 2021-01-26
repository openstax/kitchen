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
    it 'returns the elements ID' do
      expect(element.id).to eq 'div1'
    end
  end

  describe '#id=' do
  end

  describe '#set' do
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
