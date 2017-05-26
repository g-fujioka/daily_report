class Report < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :user_id, :report_date, :title, :content, presence: true
  validates :report_date, :uniqueness => {scope: :user_id}
end
