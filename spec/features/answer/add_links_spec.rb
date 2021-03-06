require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:file_name) { 'sample.rb' }

  scenario 'User adds link when gives an answer', js: true do
    sign_in(user)

    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create answer'
    end

    sleep(5)

    within '.answers' do
      expect(page).to have_content file_name
    end
  end

end
