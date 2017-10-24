require 'rails_helper'

feature 'Update answer', %q{
        As an authenticated user
        Be able to update a answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  given(:answer) { create( :answer, body: 'Body', question_id: question.id, user_id: user.id )}

  scenario 'Authenticated user update answer' do
    sign_in(user)

    answer
    visit question_path(question)
    expect(page).to have_link('Edit Answer', href: edit_answer_path(answer))
    click_on 'Edit Answer'
    fill_in 'Body', with: 'It\'s new body'
    click_on 'Update Answer'
    expect(page).to have_content "Question: '#{answer.question.title}'"
    expect(page).to have_content 'It\'s new body'
  end

  scenario 'Authenticated user update not self question' do
    sign_in(user2)

    answer
    visit question_path(question)
    expect(page).to_not have_link('Edit Answer', href: edit_answer_path(answer))
  end

  scenario 'Non-Authenticated user update question' do
    answer
    visit question_path(question)
    expect(page).to_not have_link('Edit Answer', href: edit_answer_path(answer))
  end
end