module Admin
  module Schedules
    class Admin::Schedules::PrepareIndexService < ApplicationService
      attr_accessor :params, :region

      def initialize(params, region)
        @params = params
        @region = region
      end

      def call
        prepare_data
      end

      private ##

      def prepare_data
        subjects = Subject.with_region(region.id)
        schedules = Schedule.joins(:course).where(courses: { subject_id: subjects.pluck(:id) })
        teachers = User.teachers.includes([avatar_attachment: :blob])
                       .where(region_id: region.id)

        if params[:subject_ids].present?
          params[:subject_ids] = params[:subject_ids].split(',')
          schedules = schedules.joins(:course).where(courses: { subject_id: params[:subject_ids] })
        end

        json_result(subjects, schedules, teachers)
      end

      def json_result(subjects, schedules, teachers)
        { subjects:, schedules:, teachers: }
      end
    end
  end
end
