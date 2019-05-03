require 'rails_helper'

feature 'Authenticated user can destroy question', %q{
  In order to destroy question from a community
  As an authenticated user
  I'd like to be able to delete the question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given(:another_question) { create(:question, author: another_user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    scenario 'destroy his question' do

      visit question_path(question)
      click_on 'Delete question'

      expect(page).not_to have_content question.body
    end

    scenario 'tries to destroy not his question' do

      visit question_path(another_question)

      expect(page).not_to have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to destroy a question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

end
