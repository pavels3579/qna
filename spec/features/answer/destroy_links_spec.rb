require 'rails_helper'

feature 'User can delete links of answer', %q{
  In order to delete additional info to my answer
  As an answer's author
  I'd like to be able to delete links
}, js: true do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given(:link_url) { 'https://ya.ru' }
  given(:link_name) { 'ya.ru' }

  given!(:url) { create(:link, url: link_url, name: link_name, linkable: answer) }

  describe 'Authenticated user' do

    scenario 'destroy his link' do
      sign_in(user)

      visit question_path(question)

      within '.answers' do
        click_on 'Delete link'
      end

      expect(page).not_to have_content link_name
    end

    scenario 'tries to destroy not his link' do
      sign_in(another_user)

      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Delete link'
      end

    end
  end

  scenario 'Unauthenticated user tries to destroy link', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete link'
    end
  end

end
