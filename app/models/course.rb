class Course < ApplicationRecord
  # Associations
  has_many :tutors, dependent: :destroy
  accepts_nested_attributes_for :tutors

  # Validations
  validates :name, presence: true
  validate :validate_name_uniqueness

  private
    def validate_name_uniqueness
      if Course.where(name: name).exists?
        errors.add(:base, "Course name is already taken")
      end
    end
end
