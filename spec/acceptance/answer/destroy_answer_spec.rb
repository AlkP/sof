require 'rails_helper'

feature 'Destroy answer', %q{
        As an authenticated user
        Be able to destroy an answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  given(:answer) { create( :answer, body: 'It\'s my Answer', question_id: question.id, user_id: user.id )}

  scenario 'Authenticated user destroy answer' do
    sign_in(user)
    answer
    visit question_path(question)
    expect(page).to have_link('Delete Answer', href: answer_path(answer))
    click_on 'Delete Answer'
    expect(page).to have_content 'Your answer successfully destroyed.'
    expect(page).to_not have_content 'It\'s my Answer'
  end

  scenario 'Authenticated user destroy not self answer' do
    sign_in(user2)
    answer
    visit question_path(question)
    expect(page).to_not have_link('Delete Answer', href: answer_path(answer))
  end

  scenario 'Non-Authenticated user destroy answer' do
    answer
    visit question_path(question)
    expect(page).to_not have_link('Destroy Answer', href: answer_path(answer))
  end
end