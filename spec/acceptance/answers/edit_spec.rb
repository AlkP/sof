require 'rails_helper'

feature 'User edit answer', js: true do
  given!(:answer) { create(:answer) }
  before { sign_in(answer.user) }
  before { visit question_path(answer.question) }
  before { click_on 'edit', edit_answer_path(answer) }

  scenario 'with valid attributes' do
    fill_in 'Your answer', with: 'It\'s my new body answer'
    click_on 'Update Answer'

    expect(current_path).to eq question_path(answer.question)
    within '.answers' do
      expect(page).to have_content 'It\'s my new body answer'
    end
  end

  scenario 'with invalid attributes' do
    fill_in 'Your answer', with: nil
    click_on 'Update Answer'

    expect(current_path).to eq question_path(answer.question)
    within '.new-answer' do
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

end