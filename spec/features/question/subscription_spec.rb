require 'rails_helper'

feature 'User can subscribe for a question', %(
  In order to get answer faster
  As an authenticated user
  I'd like to be able to subscribe for new answers
), js: true do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated user' do

    scenario 'subscribes for new answers' do
      sign_in(user)
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'unsubscribes from new answers' do
      sign_in(author)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'Unauthenticated user tries to subscribe' do
    visit questions_path
    expect(page).not_to have_link'Subscribe'
  end
end
