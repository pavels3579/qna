require 'rails_helper'

feature 'User can show question and answers', %q{
  In order to find out answer
  As an unauthenticated user
  I'd like to be able to show question and question's answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario 'Unauthenticated user tries to show questions list' do
    visit question_path(question)

    answers.each do |_, index|
      expect(page).to have_content "MyAnswerText#{index}"
    end
  end

end
