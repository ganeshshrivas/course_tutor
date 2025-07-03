class Tutor < ApplicationRecord
  # Associations
  belongs_to :course

  # Validations
  validates :name, presence: true
end
