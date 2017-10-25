require 'rails_helper'

feature 'Update answer', %q{
        As an authenticated user
        Be able to update a answer
} do

  given(:user) { create(:user) }
  given(:answer) { create( :answer )}

  scenario 'Authenticated user update answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    expect(page).to have_link('Edit Answer', href: edit_answer_path(answer))
    click_on 'Edit Answer'
    fill_in 'Body', with: 'It\'s new body'
    click_on 'Update Answer'
    expect(page).to have_content "Question: '#{answer.question.title}'"
    expect(page).to have_content 'It\'s new body'
  end

  scenario 'Authenticated user update not self question' do
    sign_in(user)
    visit question_path(answer.question)
    expect(page).to_not have_link('Edit Answer', href: edit_answer_path(answer))
  end

  scenario 'Non-Authenticated user update question' do
    visit question_path(answer.question)
    expect(page).to_not have_link('Edit Answer', href: edit_answer_path(answer))
  end
end