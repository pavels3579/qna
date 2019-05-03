require 'rails_helper'

feature 'Authenticated user can destroy answer', %q{
  In order to destroy answer from a community
  As an authenticated user
  I'd like to be able to destroy the answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given(:question2) { create(:question, author: user) }
  given!(:another_answer) { create(:answer, question: question2, author: another_user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    scenario 'destroy his answer' do
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).not_to have_content answer.body
    end

    scenario 'tries to destroy not his answer' do
      visit question_path(question2)

      expect(page).not_to have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to destroy an answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end

end
