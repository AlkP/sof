require 'rails_helper'

feature 'User create new answer for question:', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Registered user answer to the question' do
    before { sign_in(user) }
    before { visit question_path(question) }

    scenario 'with valid attributes' do
      fill_in 'Your answer', with: 'It\'s my answer'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'It\'s my answer'
      end
    end

    scenario 'with invalid attributes' do
      fill_in 'Your answer', with: nil
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to_not have_content 'It\'s my answer'
      end
      within '.new-answer' do
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  context 'Non-Registered user try answer to the question' do
    before { visit question_path(question) }

    #TODO
  end
end