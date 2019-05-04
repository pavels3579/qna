require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer
  As an authenticated user
  I'd like to be able to give the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'givs an answer' do
      fill_in 'Body', with: 'text answer text'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'givs an answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
