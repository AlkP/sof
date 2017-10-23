require 'rails_helper'

feature 'Destroy answer', %q{
        As an authenticated user
        Be able to destroy an answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  given(:answer) { create( :answer, body: 'Body', question_id: question.id, user_id: user.id )}

  scenario 'Authenticated user destroy answer' do
    sign_in(user)

    visit answer_path(answer)
    expect(page).to have_link('Destroy Answer', href: answer_path(answer))
    click_on 'Destroy Answer'
    expect(page).to have_content 'Your answer successfully destroyed.'
  end

  scenario 'Authenticated user destroy not self answer' do
    sign_in(user2)

    visit answer_path(answer)
    expect(page).to_not have_link('Destroy Answer', href: answer_path(question))
  end

  scenario 'Non-Authenticated user destroy answer' do
    visit answer_path(answer)
    expect(page).to_not have_link('Destroy Answer', href: answer_path(answer))
  end
end