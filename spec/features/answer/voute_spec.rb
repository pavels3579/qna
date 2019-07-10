require 'rails_helper'

feature 'User can vote for answer', %(
  In order to set the importance of answer
  As an authenticated user
  I'd like to be able to vote for answer
), js: true do

  given(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe "Authenticated user - not answer's author" do
    background do
      sign_in(another_user)
    end

    scenario "votes for other user's answer" do
      visit question_path(question)
      within '.answers' do
        click_on 'Vote up'
      end
      expect(page).to have_content '1'
    end

    scenario 'discards his vote and revotes' do
      visit question_path(question)
      within '.answers' do
        click_on 'Vote up'
        click_on 'Vote up'
        click_on 'Vote down'
      end

      expect(page).to have_content '-1'
    end

    scenario "can't vote twice for other user's answer" do
      visit question_path(question)
      within '.answers' do
        click_on 'Vote up'
        click_on 'Vote up'
      end

      answers = find(:css, '.answers')
      expect(answers).not_to have_content '2'
    end

  end

  describe "Authenticated user - answer's author" do
    background do
      sign_in(user)
    end

    scenario "can't vote for his own answer" do
      visit question_path(question)
      answers = find(:css, '.answers')
      expect(answers).not_to have_content 'Vote up'
      expect(answers).not_to have_content 'Vote down'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't vote for answer" do
      visit question_path(question)

      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end
