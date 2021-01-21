require 'spec_helper'

RSpec.describe Kitchen::Clipboard do
  let(:my_clipboard) { described_class.new }
  let(:element_1) do
    new_element(
      <<~HTML
        <div id='e1'>
          <span>Element 1</span>
          <span>ABC</span>
          <span>Zebra</span>
          <span>B</span>
        </div>
      HTML
    )
  end

  let(:element_2) do
    new_element(
      <<~HTML
        <h1 id='e2'>Title</h1>
      HTML
    )
  end

  context '#add' do
    it 'throws error when no item was given' do
      expect{my_clipboard.add}.to raise_error(ArgumentError)
    end

    it 'returns array with added item' do
      my_clipboard.add(1)
      expect(my_clipboard.add(2)).to eq([1, 2])
    end
  end

  context '#clear' do
    it 'clears clipboard contents' do
      expect(my_clipboard.add(1)).to eq([1])
      expect(my_clipboard.clear).to be {}
    end
  end

  context '#paste' do
    it 'returns a concatenation of the pasting' do
      element_2.cut(to: my_clipboard)
      element_1.cut(to: my_clipboard)
      expect(my_clipboard.paste).to match(/[e1][e2]/)
    end

    it 'returns empty object when theres nothing to paste' do
      expect(my_clipboard.paste).to be {}
    end
  end

  context '#each' do
    it 'returns self when the clipboard has contents' do
      element_1.cut(to: my_clipboard)
      expect(my_clipboard.each{}).to be my_clipboard
    end

    it 'returns self when the clipboard is empty' do
      expect(my_clipboard.each).to be my_clipboard
    end

    it 'handles clipboard not empty and no block given' do
      element_1.cut(to: my_clipboard)
      expect{my_clipboard.each}.to raise_error(NoMethodError)
    end
  end

  context '#sort_by' do
    it 'returns empty object when no block given' do
      element_1.cut(to: my_clipboard)
      expect(my_clipboard.sort_by!).to be {}
    end

    it 'returns sorted object when block given' do
      element_1.search('span').cut(to: my_clipboard)
      expect(
        my_clipboard.sort_by!{|element| element.text}.to_s
      ).to eq("[<span>ABC</span>, <span>B</span>, <span>Element 1</span>, <span>Zebra</span>]")
    end
  end
end
