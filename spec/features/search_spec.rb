require 'sphinx_helper'

feature 'User can perform a search', %q{
   In order to find needed information
   As an unauthenticated user
  I'd like to be able to search fo the information
 }, js: true, sphinx: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:comment) { create(:question_comment, commentable: question, user: user) }

  context 'Authenicated user' do

    background do
      sign_in(user)
      visit root_path
    end

    scenario 'searches for a question by title' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: question.title
        select 'Question', from: 'scope'
        click_on 'Search'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end

    scenario 'user searches for a question by body' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: question.body
        select 'Question', from: 'scope'
        click_on 'Search'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end

    scenario 'searches for a question by title within all scope' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: question.title
        select 'All', from: 'scope'
        click_on 'Search'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end

    scenario 'searches for a answer by body' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: answer.body
        select 'Answer', from: 'scope'
        click_on 'Search'
        expect(page).to have_content answer.body
      end
    end
    scenario 'searches for a comment by body' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: comment.body
        select 'Comment', from: 'scope'
        click_on 'Search'
        expect(page).to have_content comment.body
      end
    end

    scenario 'searches for a user by email' do
      ThinkingSphinx::Test.run do
        fill_in 'search', with: user.email
        select 'User', from: 'scope'
        click_on 'Search'
        expect(page).to have_content user.email
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'can\'t search for anything' do
      expect(page).not_to have_content 'Search'
    end
  end
end
