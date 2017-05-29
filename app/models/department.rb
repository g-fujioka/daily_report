class Department < ApplicationRecord
  has_one :user

  validates :department_name, presence: true

  enum status: { invalidate: 0, activate: 1 }
end
