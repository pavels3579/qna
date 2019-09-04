require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:search_instance) { Services::Search.new }

    it 'calls search service with specified attributes' do
      allow(search_instance).to receive(:perform).with('question', user.email)
      get :index, params: { 'scope': 'question', 'search': user.email }
    end

    it 'returns bad request if attributes are anvalid' do
      get :index, params: { 'scope': 'error', 'search': user.email }
      expect(response.status).to eq(400)
    end
  end

end
