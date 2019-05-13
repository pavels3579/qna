require 'rails_helper'

feature 'User can edit question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
}, js: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, author: another_user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'author edits a question' do
      click_on 'Edit question'

      within '.actions' do
        fill_in 'Your question', with: 'new question body'
        click_on 'Save'
      end

      expect(page).to have_content 'new question body'
    end

    scenario 'author edits a question with errors' do
      click_on 'Edit question'

      within '.actions' do
        fill_in 'Your question', with: ''
        click_on 'Save'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_selector '#edit-question textarea'
    end

    scenario 'non-author tries to edit a question' do
      visit question_path(another_question)

      expect(page).not_to have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated user tries to edit a question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit question'
  end

end
