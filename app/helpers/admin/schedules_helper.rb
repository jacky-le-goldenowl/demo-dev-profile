module Admin::SchedulesHelper
  def hours_collection
    arr = (6..20)
    arr.step(0.5).map { |n| n.to_s.tr('.', ':').gsub(':5', ':30').gsub(':0', ':00') }
  end

  def check_hour_in_schedule(schedules, hour)
    schedules =
      schedules.pluck(:start_time, :end_time).map do |s|
        s.map { |a| a.strftime('%H.%M').to_f }
      end

    schedules.select { |s| hour.tr(':', '.').to_f.in?(s[0]..s[1]) }
  end

  def get_colour_from_find_subject(schedules, hour)
    color = ''

    schedules.map do |schedule|
      start_number = schedule.start_time.strftime('%H.%M').to_f
      end_number = schedule.end_time.strftime('%H.%M').to_f

      color = schedule.course.subject.color if hour.tr(':', '.').to_f.in?(start_number..end_number)
    end

    color
  end
end
