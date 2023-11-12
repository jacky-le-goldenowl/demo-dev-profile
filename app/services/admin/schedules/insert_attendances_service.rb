module Admin
  module Schedules
    class InsertAttendancesService < ApplicationService
      attr_reader :schedule

      def initialize(schedule)
        @schedule = schedule
      end

      def call
        create_attendances
      end

      private ##

      def create_attendances
        students = schedule.course.students
        attendance_params = students.map do |student|
          { user_id: student.id, schedule_id: schedule.id }
        end

        Attendance.create!(attendance_params)
      end
    end
  end
end
