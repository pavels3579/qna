require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
}, js: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, author: another_user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit answer'
  end

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    scenario 'edits his answer' do
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content answer.body
      expect(page).to have_selector 'textarea'
    end

    scenario "tries to edit other user's question" do
      visit question_path(another_question)

      expect(page).not_to have_link 'Edit answer'
    end

  end
end
