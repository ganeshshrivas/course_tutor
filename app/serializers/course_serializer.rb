class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :tutor_count
  has_many :tutors
  def tutor_count
    object.tutors.count
  end
end
