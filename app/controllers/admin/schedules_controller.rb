class Admin::SchedulesController < Admin::BaseController
  include DateTimeHelper
  before_action :prepare_index, only: %i[index]

  def index
    respond_to do |format|
      format.html
      format.json { render json: call_schedules_json, status: :ok }
    end
  end

  def teacher_info
    json_result = Admin::Schedules::PrepareTeacherDetailService.call(params)
    render json: json_result, status: :ok
  end

  def create
    schedule = Schedule.new(schedule_params)

    if schedule.save
      Admin::Schedules::InsertAttendancesService.call(schedule)
      flash_notice('common.create.success', 'schedule')
    else
      flash[:alert] = schedule.errors.full_messages.to_sentence
    end

    redirect_to admin_schedules_path
  end

  private ##

  def schedule_params
    params.require(:schedule).permit(
      :day, :course_id, :user_id, :start_time, :end_time
    )
  end

  def prepare_index
    hash = Admin::Schedules::PrepareIndexService.call(params, @current_region)
    @subjects = hash[:subjects]
    @schedules = hash[:schedules]
    @teachers = hash[:teachers]
  end

  def call_schedules_json
    params[:day] = date_normal_format_ymd(Date.current) if params[:day].blank?
    Admin::SchedulesJsonService.call(@schedules, params[:day])
  end
end
