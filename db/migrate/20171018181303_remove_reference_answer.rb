class RemoveReferenceAnswer < ActiveRecord::Migration[5.1]
  def change
    remove_reference :questions, :answer, index: true, foreign_key: true
  end
end
