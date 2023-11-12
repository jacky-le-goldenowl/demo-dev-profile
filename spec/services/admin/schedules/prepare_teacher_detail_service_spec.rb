require 'rails_helper'

RSpec.describe Admin::Schedules::PrepareTeacherDetailService, type: :service do
  let!(:teacher) { create(:teacher) }
  let!(:course) { create(:course, teacher:) }
  let!(:schedule1) { create(:schedule, teacher:, course:) }
  let!(:schedule2) { create(:schedule, teacher:, course:) }

  describe '#call' do
    shared_examples 'prepares and renders teacher info and schedules' do
      it 'returns the expected result' do
        result = described_class.call(params)
        expect(result.keys).to eq([:teacher_id, :html_teacher, :html_times])
        expect(result[:teacher_id]).to eq(teacher.id)
      end
    end

    context 'when teacher_id is provided' do
      let(:params) { { teacher_id: teacher.id, course_id: course.id, day: schedule1.day } }
      include_examples 'prepares and renders teacher info and schedules'
    end

    context 'when teacher_id is not provided' do
      let(:params) { { course_id: course.id, day: schedule1.day } }
      include_examples 'prepares and renders teacher info and schedules'
    end
  end
end
