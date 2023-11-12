# == Schema Information
#
# Table name: schedules
#
#  id         :bigint           not null, primary key
#  day        :date
#  end_time   :time
#  start_time :time
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_schedules_on_course_id  (course_id)
#
require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'constants' do
    it 'has STATUS_COLLECTION constant' do
      expect(Schedule::STATUS_COLLECTION).to eq([:finished, :cancelled, :on_going])
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teacher).class_name('User').with_foreign_key('user_id') }
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many(:attendances).dependent(:destroy) }
    it { is_expected.to have_many(:attendance_requests).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:day) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:course).with_prefix(true) }
  end

  describe 'scopes' do
    let(:region) { create(:region) }
    let(:teacher) { create(:teacher) }
    let(:course) { create(:course) }
    let(:student) { create(:student) }

    let!(:schedule1) { create(:schedule, day: Date.current, start_time: Time.current, end_time: 1.hour.from_now, course:) }
    let!(:schedule2) { create(:schedule, day: Date.tomorrow, start_time: Time.current, end_time: 1.hour.from_now, user_id: teacher.id, course:) }

    describe 'where_students' do
      let!(:attendance1) { create(:attendance, user_id: student.id, schedule: schedule1) }
      let!(:attendance2) { create(:attendance, user_id: student.id, schedule: schedule2) }

      it 'returns schedules with the given student' do
        expect(described_class.where_students(student)).to include(schedule1)
      end
    end

    describe 'where_teacher' do
      it 'returns schedules with the given teacher' do
        expect(described_class.where_teacher(teacher)).to include(schedule2)
      end
    end

    describe 'where_course' do
      it 'returns schedules with the given course' do
        expect(described_class.where_course(course)).to include(schedule1)
      end
    end

    describe 'where_teacher_course' do
      it 'returns schedules with the given teacher and course' do
        expect(described_class.where_teacher_course(teacher, course)).to include(schedule1)
        expect(described_class.where_teacher_course(teacher, course)).to include(schedule2)
      end
    end

    describe 'in_range' do
      let(:range) do
        build(
          :schedule, day: Date.current + 20.days,
                     start_time: Time.current, end_time: 1.hour.from_now,
                     course_id: course.id, user_id: teacher.id
        )
      end

      it 'returns schedules within the given range' do
        schedule1 = create(:schedule, day: range.day, start_time: range.start_time, end_time: range.end_time, course:, teacher:)

        result = Schedule.in_range(range)

        expect(result).to contain_exactly(schedule1)
        expect(result).not_to include([schedule1])
      end
    end

    describe 'classes_today_region' do
      let!(:teacher_with_region) { create(:teacher, region_id: region.id) }
      let!(:schedule_with_region) { create(:schedule, day: Date.current, teacher: teacher_with_region) }

      it 'returns schedules with the given region for today' do
        expect(described_class.classes_today_region(region.id)).to eq([schedule_with_region])
      end
    end
  end

  describe 'methods' do
    let(:course) { create(:course) }
    let(:schedule) { create(:schedule, course:) }

    describe 'subject_name' do
      it 'returns the name of the associated course subject' do
        expect(schedule.subject_name).to eq(course.subject.name)
      end
    end
  end
end
