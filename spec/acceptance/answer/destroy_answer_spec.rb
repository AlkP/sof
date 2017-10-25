require 'rails_helper'

feature 'Destroy answer', %q{
        As an authenticated user
        Be able to destroy an answer
} do

  given(:user) { create(:user) }
  given!(:answer) { create( :answer )}

  scenario 'Authenticated user destroy answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    expect(page).to have_link('Delete Answer', href: answer_path(answer))
    click_on 'Delete Answer'
    expect(page).to have_content 'Your answer successfully destroyed.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user destroy not self answer' do
    sign_in(user)
    visit question_path(answer.question)
    expect(page).to_not have_link('Delete Answer', href: answer_path(answer))
  end

  scenario 'Non-Authenticated user destroy answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link('Destroy Answer', href: answer_path(answer))
  end
end