module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def list_of_answers_is_available(answers)
    answers.each do |a|
      expect(page).to have_content a.body
    end
  end

  def list_of_my_answers_is_available(answers)
    answers.each do |a|
      expect(page).to have_content a.body
      expect(page).to have_link('edit', href: edit_answer_path(a))
      expect(page).to have_link('del', href: answer_path(a))
    end
  end

  def answers_list_is_not_available(answers)
    answers.each do |a|
      expect(page).to_not have_content a.body
    end
  end

end