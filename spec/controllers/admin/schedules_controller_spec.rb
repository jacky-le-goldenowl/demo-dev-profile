require 'rails_helper'

RSpec.describe Admin::SchedulesController, type: :controller do
  let!(:region) { create(:region) }
  let!(:admin) { create(:admin, region:) }
  let!(:teacher) { create(:teacher, region:) }
  let!(:student) { create(:student, region:) }
  let!(:term) { create(:term, region:) }
  let!(:level) { create(:level) }
  let!(:subject) { create(:subject, region:) }
  let(:course) { create(:course, subject:) }
  let!(:schedule) { create(:schedule, course:) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @subjects, @schedules, and @teachers' do
      get :index

      expect(assigns(:subjects)).to include(subject)
      expect(assigns(:schedules)).to include(schedule)
      expect(assigns(:teachers)).to include(teacher)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'with JSON format' do
      it 'renders schedules JSON' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #teacher_info' do
    it 'renders teacher info JSON' do
      get :teacher_info, params: { course_id: course.id, user_id: teacher.id, day: 'Monday' }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.keys).to eq(['teacher_id', 'html_teacher', 'html_times'])
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { course_id: course.id, user_id: teacher.id, day: 'Monday', start_time: '10:00', end_time: '11:00' } }
    let(:invalid_params) { { day: '', course_id: course.id } }

    context 'with valid params' do
      it 'redirects to the index page' do
        post :create, params: { schedule: valid_params }
        expect(response).to redirect_to(admin_schedules_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new schedule' do
        expect do
          post :create, params: { schedule: invalid_params }
        end.not_to change(Schedule, :count)
      end

      it 'sets a flash alert message' do
        post :create, params: { schedule: invalid_params }
        expect(flash[:alert]).to eq(
          "Teacher must exist, Day can't be blank, Start time can't be blank, and End time can't be blank"
        )
      end

      it 'redirects to the index page' do
        post :create, params: { schedule: invalid_params }
        expect(response).to redirect_to(admin_schedules_path)
      end
    end
  end
end
