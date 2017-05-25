class Comment < ApplicationRecord
  belongs_to :report
  belongs_to :user

  validates :content, presence: true
end
