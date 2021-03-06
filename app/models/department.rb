class Department < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true

  enum state: { invalidate: false, activate: true }
end
