class Question < ActiveRecord::Base

  belongs_to :user
  has_many :votes, as: :voteable
  has_many :comments, as: :commentable
  has_many :answers
  belongs_to :best_answer, { class_name: "Answer", foreign_key: "best_answer_id" }

  validates :content, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false

end
