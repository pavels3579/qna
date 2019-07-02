require 'rails_helper'

feature 'User can see the list of best answer awards', %q(
  In order to see the list of best answer awards
  As an author of best answer
  I'd ike to be able to see the award
), js: true do

  describe 'Authenticated user', js: true do

    given!(:user) { create(:user) }
    given!(:user_not_author) { create(:user) }

    context 'author' do
      background do
        sign_in(user)
      end

      scenario 'can see the award in the list' do
        visit new_question_path
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        fill_in 'Award title', with: 'text text text'
        attach_file 'Award picture', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Ask'
        sleep(5)
        click_on 'Edit question'
        within '.new-answer' do
          fill_in 'Body', with: 'text text text'
          click_on 'Create answer'
        end
        click_on 'Mark as best answer'
        visit best_answer_awards_path
        expect(page).to have_content 'text text text'
        expect(page).to have_content 'Test question'
      end
    end

    context 'non-author' do
      background do
        sign_in(user)
      end

      scenario "can't see the award in the list" do
        visit new_question_path
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        fill_in 'Award title', with: 'text text text'
        attach_file 'Award picture', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Ask'
        within '.new-answer' do
          fill_in 'Body', with: 'text text text'
          click_on 'Create answer'
        end
        click_on 'Mark as best answer'
        visit root_path
        click_on 'Sign out'
        sign_in(user_not_author)
        visit best_answer_awards_path
        expect(page).not_to have_content 'text text text'
        expect(page).not_to have_content 'Test question'
      end
    end
  end
end
