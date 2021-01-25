require 'spec_helper'

RSpec.describe String do

  describe '#uncapitalize' do
    it 'downcases the first letter of self, returning a new string' do
      expect('Tomato'.uncapitalize).to eq('tomato')
    end
  end

end
