require 'rails_helper'

feature 'User can show questions list', %q{
  In order to find out questions
  As an unauthenticated user
  I'd like to be able to show questions list
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'Unauthenticated user tries to show questions list' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    questions.each do |_, index|
      expect(page).to have_content "MyString#{index}"
    end
  end

end
