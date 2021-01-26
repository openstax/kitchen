require 'spec_helper'

RSpec.describe Utils do
  describe '.search_path_to_type(search_path' do
    it "converts a search path to an element type" do
      expect(described_class.search_path_to_type(["lol", "wow"])).to eq("lol wow")
    end
  end
end
