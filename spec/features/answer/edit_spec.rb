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
        expect(page).not_to have_selector '#answer_body'
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

    scenario 'edits his answer with attached file' do
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "removes an answer's attached file" do
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      click_on 'Delete answer attachment'

      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario "tries to edit other user's answer" do
      visit question_path(another_question)

      expect(page).not_to have_link 'Edit answer'
    end

  end
end
