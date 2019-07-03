require 'rails_helper'

feature 'User can delete links of question', %q{
  In order to delete additional info to my question
  As an question's author
  I'd like to be able to delete links
}, js: true do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given(:another_question) { create(:question, author: another_user) }

  given(:link_url) { 'https://ya.ru' }
  given(:link_name) { 'ya.ru' }

  given!(:url) { create(:link, url: link_url, name: link_name, linkable: question) }
  given(:another_url) { create(:link, url: link_url, name: link_name, linkable: another_question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    scenario 'destroy his link' do

      visit question_path(question)

      within '.question' do
        click_on 'Delete link'
      end

      expect(page).not_to have_content link_name
    end

    scenario 'tries to destroy not his link' do

      visit question_path(another_question)

      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to destroy link', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end

end
