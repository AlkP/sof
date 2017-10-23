require 'rails_helper'

feature 'Show answer', %q{
        Any user
        Be able to show an answer
} do

  given(:user) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  given(:answer) { create( :answer, body: 'Body', question_id: question.id, user_id: user.id )}

  scenario 'Authenticated user show answer' do
    sign_in(user)

    visit answer_path(answer)
    expect(page).to have_content "Answer: '#{answer.body}'"
  end

  scenario 'Non-Authenticated user show anser' do
    sign_in(user)

    visit answer_path(answer)
    expect(page).to have_content "Answer: '#{answer.body}'"
  end
end