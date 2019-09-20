require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe 'collection_cache_key_for' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3, author: user) }
    it 'returns key' do
      expect(collection_cache_key_for(:question)).to match("questions/collection-#{questions.count}-#{Question.maximum(:updated_at).utc.to_s(:number)}")
    end
  end

end
