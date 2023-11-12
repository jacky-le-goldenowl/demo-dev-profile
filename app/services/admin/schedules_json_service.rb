class Admin::SchedulesJsonService < ApplicationService
  include DateTimeHelper

  def initialize(schedules, day)
    @schedules = schedules
    @day = day
  end

  def call
    set_results
  end

  private ##

  def set_results
    teachers = User.teachers.includes([avatar_attachment: :blob])
    schedules = @schedules.where(day: @day).includes([:teacher, { course: :subject }])

    render_events_json(schedules, teachers)
  end

  def resources_json(teachers)
    teachers.map do |teacher|
      {
        id: teacher.id,
        title: teacher.name,
        avatar: teacher.avatar.url || '/images/avatar-default.png'
      }
    end
  end

  def schedules_json(schedules)
    schedules.map do |schedule|
      {
        id: schedule.id,
        resource_id: schedule.teacher.id,
        title: schedule.subject_name,
        subtitle: "#{time_format_24h(schedule.start_time)} - #{time_format_24h(schedule.end_time)} | #{schedule.course.name}",
        start: "#{date_normal_format_ymd(schedule.day)} #{time_format_24h(schedule.start_time)}",
        end: "#{date_normal_format_ymd(schedule.day)} #{time_format_24h(schedule.end_time)}",
        class_name: 'events-container',
        color: schedule.course.subject.color,
        border_color: schedule.course.subject.border_color,
        text_color: 'black',
        course_id: schedule.course_id
      }
    end
  end

  def render_events_json(schedules, teachers)
    {
      events: schedules_json(schedules),
      resources: resources_json(teachers),
      day: @day.tr('/', '-'),
      day_string: date_format_ordinalize_dmy(@day.to_date)
    }
  end
end
