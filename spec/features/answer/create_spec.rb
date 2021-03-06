require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer
  As an authenticated user
  I'd like to be able to give the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'givs an answer' do
      within '.new-answer' do
        fill_in 'Body', with: 'text answer text'
        click_on 'Create answer'
      end

      expect(page).to have_content 'text answer text'
    end

    scenario 'givs an answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'givs an answer with attached file' do
      within '.new-answer' do
        fill_in 'Body', with: 'text answer text'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit(question_path(question))
      end

      Capybara.using_session('guest') do
        visit(question_path(question))
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'Body', with: 'text text text'
          click_on 'Create answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
