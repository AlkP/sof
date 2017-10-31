require 'rails_helper'

feature 'User edit answer' do
  given!(:answer) { create(:answer) }
  before { sign_in(answer.user) }
  before { visit edit_answer_path(answer) }

  scenario 'with valid attributes' do
    fill_in 'body', with: 'It\'s my new body answer'
    click_on 'Update Answer'

    expect(page).to have_content 'Answer was successfully updated.'
    expect(page).to have_content 'It\'s my new body answer'
    expect(current_path).to eq question_path(answer.question)
  end

  scenario 'with invalid attributes' do
    fill_in 'body', with: nil
    click_on 'Update Answer'

    expect(page).to have_content 'Answer was not updated.'
    expect(current_path).to eq answer_path(answer)
  end

end