require 'rails_helper'

feature 'User can vote for question', %(
  In order to set the importance of question
  As an authenticated user
  I'd like to be able to vote for question
), js: true do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe "Authenticated user - not questions's author" do
    background do
      sign_in(another_user)
    end

    scenario "votes for other user's question" do
      visit question_path(question)
      click_on 'Vote up'

      expect(page).to have_content '1'
    end

    scenario 'discards his vote and revotes' do
      visit question_path(question)
      click_on 'Vote up'
      click_on 'Vote up'
      click_on 'Vote down'

      expect(page).to have_content '-1'
    end

    scenario "can't vote twice for other user's question" do
      visit question_path(question)
      click_on 'Vote up'
      sleep(5)
      click_on 'Vote up'

      question = find(:css, '.question')
      within '.score' do
        expect(page).not_to have_content '2'
      end
    end

  end

  describe "Authenticated user - questions's author" do
    background do
      sign_in(user)
    end

    scenario "can't vote for his own question" do
      visit question_path(question)

      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't vote for question" do
      visit question_path(question)

      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end
