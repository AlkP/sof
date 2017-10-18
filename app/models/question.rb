class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true

  paginates_per 15
end
