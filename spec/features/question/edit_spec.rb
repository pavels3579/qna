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

    scenario 'author edits a question with attached file' do
      click_on 'Edit question'

      within '.actions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "author removes a question's attached files" do
      click_on 'Edit question'

      within '.actions' do
        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      click_on 'Delete attachment'

      expect(page).not_to have_link 'spec_helper.rb'
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
