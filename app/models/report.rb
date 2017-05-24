class Report < ApplicationRecord
  has_many :comments
  belongs_to :user

  validates :user_id, :report_date, :title, :content, presence:true
end
