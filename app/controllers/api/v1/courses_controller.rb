# app/controllers/api/v1/courses_controller.rb
module Api
  module V1
    class CoursesController < ApplicationController
      def index
        courses = Course.includes(:tutors)
        render json: courses
      end

      def create
        course = Course.new(course_params)
        if course.save
          render json: course, status: :created
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def course_params
        params.require(:course).permit(:name, tutors_attributes: [ :name ])
      end
    end
  end
end
