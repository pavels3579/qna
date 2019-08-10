require 'rails_helper'

feature 'User can sign in via social networks', %q{
   In order to log in without signin up
   As an unauthenticated user
  I'd like to be able to use oauth sign in
 } do

  context 'signup' do
    before { visit new_user_registration_path }

    scenario 'github', js: true do
      mock_auth_hash
      click_on "Sign in with GitHub"

      expect(page).to have_content'Successfully authenticated from Github account.'
    end

    scenario 'vk', js: true do
      mock_auth_hash
      click_on "Sign in with Vkontakte"

      expect(page).to have_content'Successfully authenticated from Vkontakte account.'
    end
  end

  context 'sign in' do
    let!(:user) { create(:user, email: 'mail@mail.net') }

    before do
      user.confirm
    end

    before { visit new_user_session_path }

    scenario 'github', js: true do
      mock_auth_hash
      click_on "Sign in with GitHub"
      expect(page).to have_content'Successfully authenticated from Github account.'
    end

    scenario 'vk', js: true do
      mock_auth_hash
      click_on "Sign in with Vkontakte"

      expect(page).to have_content'Successfully authenticated from Vkontakte account.'
    end
  end
end
