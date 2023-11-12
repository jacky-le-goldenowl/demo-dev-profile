require 'rails_helper'

RSpec.describe Admin::Schedules::InsertAttendancesService, type: :service do
  let!(:course) { create(:course) }
  let!(:schedule) { create(:schedule, course:) }
  let!(:students) { create_list(:student, 5) }

  before { course.students = students }

  describe '#call' do
    it 'creates attendances for all students in the course' do
      expect { described_class.call(schedule) }.to change { Attendance.count }.by(5)

      students.each do |student|
        expect(Attendance.exists?(user_id: student.id, schedule_id: schedule.id)).to be_truthy
      end
    end

    context 'when an exception is raised during attendance creation' do
      before do
        allow(Attendance).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises an exception' do
        expect { described_class.call(schedule) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
