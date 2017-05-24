class Department < ApplicationRecord
  has_one :user

  validates :department_name, presence: true
end
