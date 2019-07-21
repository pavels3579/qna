require 'rails_helper'

feature 'User can create comment', %q{
  In order to give a comment
  As an authenticated user
  I'd like to be able to create a comment
}, :js do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  context 'multiple sessions' do
    context 'question' do
      scenario "comment appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit(question_path(question))
        end

        Capybara.using_session('guest') do
          visit(question_path(question))
        end

        Capybara.using_session('user') do
          within '.question-comments' do
            fill_in 'Body', with: 'text text text'
            click_on 'Create comment'
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'text text text'
        end
      end
    end
    context 'answer' do
      scenario "comment appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit(question_path(question))
        end

        Capybara.using_session('guest') do
          visit(question_path(question))
        end

        Capybara.using_session('user') do
          within '.answer-comments' do
            fill_in 'Body', with: 'text text text'
            click_on 'Create comment'
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'text text text'
        end
      end
    end
  end
end
