require 'rails_helper'

feature 'User can mark answer as best', %q(
  In order to choose the best answer
  As an author of question
  I'd ike to be able to mark answer as best
), js: true do

  given!(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:question_different_author) { create(:question, author: user_not_author) }
  given!(:answer) { create(:answer, author: user, question: question) }
  given!(:second_answer) { create(:answer, author: user, question: question) }

  describe 'Authenticated user' do
    context 'question author' do
      background do
        sign_in(user)
      end

      scenario 'can mark only one answer as best' do
        visit question_path(question)

        first('.mark-as-best').click
        sleep(5)
        first('.mark-as-best').click
        expect(page).to have_css('.best', count: 1)

      end
      scenario 'can mark another answer as best if question already has best answer' do
        answer.best = true
        visit question_path(question)

        first('.mark-as-best').click

        expect(page).to have_css('.best', count: 1)
      end
    end

    context 'question non-author' do
      background do
        sign_in(user_not_author)
      end

      scenario "can't mark answer as best" do
        visit question_path(question)

        expect(page).not_to have_content('Mark as best answer')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't mark answer as best" do
      visit question_path(question)

      expect(page).not_to have_content('Mark as best answer')
    end
  end
end
