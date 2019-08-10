require 'rails_helper'

feature 'User can sign out', %q{
  In order to sign out
  As an Authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  before do
    user.confirm
  end

  background { visit root_path }

  scenario 'Registered user tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
