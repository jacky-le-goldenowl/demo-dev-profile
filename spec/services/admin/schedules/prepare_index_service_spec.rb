require 'rails_helper'

RSpec.describe Admin::Schedules::PrepareIndexService, type: :service do
  let(:region) { create(:region) }
  let(:subject1) { create(:subject, region:) }
  let(:subject2) { create(:subject, region:) }
  let(:teacher1) { create(:teacher, region:) }
  let(:teacher2) { create(:teacher, region:) }
  let!(:course1) { create(:course, subject: subject1) }
  let!(:course2) { create(:course, subject: subject2) }
  let!(:schedule1) { create(:schedule, course: course1) }
  let!(:schedule2) { create(:schedule, course: course2, teacher: teacher1) }

  def call_service(params, region)
    described_class.call(params, region)
  end

  describe '#call' do
    context 'when subject_ids are not present in params' do
      let(:params) { {} }

      it 'prepares data without filtering by subject_ids' do
        result = call_service(params, region)
        expect(result[:subjects]).to match_array([subject1, subject2])
        expect(result[:schedules]).to match_array([schedule1, schedule2])
        expect(result[:teachers]).to match_array([teacher1, teacher2])
      end
    end

    context 'when subject_ids are present in params' do
      let(:params) { { subject_ids: "#{subject1.id},#{subject2.id}" } }
      it 'prepares data with filtering by subject_ids' do
        result = call_service(params, region)
        expect(result[:subjects]).to match_array([subject1, subject2])
        expect(result[:schedules]).to match_array([schedule1, schedule2])
        expect(result[:teachers]).to match_array([teacher1, teacher2])
      end
    end
  end
end
