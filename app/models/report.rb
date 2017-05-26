class Report < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user

  default_scope -> {order(created_at: :DESC)}

  validates :user_id, :report_date, :title, :content, presence: true
  validates :report_date, :uniqueness => {scope: :user_id}
end
