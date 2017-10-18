class AddQuestionAnswerAssociation < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :question, foreign_key: true
    add_reference :questions, :answer, foreign_key: true
  end
end
