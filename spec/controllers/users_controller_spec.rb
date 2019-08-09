require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user, email: 'tempusermail@tempusermail.com') }

  describe 'PATCH #finish_signup' do
    before do
      login(user)
    end

    it 'updates user email' do
      patch :finish_signup, params: { id: user.id, user: { email: 'test@test.com' } }
      user.reload
      user.confirm
      user.reload
      expect(user.email).to eq 'test@test.com'
    end

    it 'returns 200 code' do
      patch :finish_signup, params: { id: user, user: { email: 'test@test.com'} }, format: :js
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #finish_signup' do
    before do
      user.confirm
      login(user)
    end

    it 'renders finish_signup template' do
      get :finish_signup, params: { id: user.id }
      expect(response).to render_template :finish_signup
    end
  end
end
