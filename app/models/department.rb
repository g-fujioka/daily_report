class Department < ApplicationRecord
  has_one :user

  validates :name, presence: true, uniqueness: true

  enum state: { invalidate: false, activate: true }
end
