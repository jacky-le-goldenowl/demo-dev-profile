module Admin
  module Schedules
    class PrepareTeacherDetailService < ApplicationService
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        prepare_data
      end

      private ##

      def prepare_data
        course = Course.find(params[:course_id])
        teacher = params[:teacher_id].present? ? User::Teacher.find(params[:teacher_id]) : course.teacher
        schedules = Schedule.where_teacher_course(teacher, course).where(day: params[:day])

        render_teacher_info(teacher, schedules)
      end

      def render_teacher_info(teacher, schedules)
        {
          teacher_id: teacher.id,
          html_teacher: render_to_string('teacher_info', { teacher:, active: true }),
          html_times: render_to_string('times_collection', { schedules:, active: true })
        }
      end

      def render_to_string(partial, locals = {})
        ApplicationController.new.render_to_string(
          partial: "admin/schedules/offcanvas/#{partial}",
          layout: false,
          locals:
        )
      end
    end
  end
end
