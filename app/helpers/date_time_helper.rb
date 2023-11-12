module DateTimeHelper
  def time_format(time)
    time&.strftime('%I:%M %p')
  end

  def time_format_24h(time)
    time&.strftime('%H:%M')
  end

  def date_format_ordinalize(day)
    day&.strftime("#{day&.day&.ordinalize} %B %Y")
  end

  def date_format_ordinalize_sort(day)
    day&.strftime("#{day&.day&.ordinalize} %b %Y")
  end

  def date_format_ordinalize_dmy(day)
    day&.strftime("%A, %B #{day.day.ordinalize} %Y")
  end

  def date_format_ordinalize_dmy_sort(day)
    day&.strftime("%a, %b #{day.day.ordinalize} %Y")
  end

  def date_time_ago_format(datetime)
    return '--' if datetime.nil?

    time = time_format(datetime)
    d = (DateTime.current - datetime.to_date).to_i

    case d
    when 0
      "Today - #{time}"
    when 1
      "Yesterday - #{time}"
    else
      "#{d} days ago - #{time}"
    end
  end

  def date_normal_format(day)
    day&.strftime('%d/%m/%Y')
  end

  def date_normal_format_ymd(day)
    day&.strftime('%Y-%m-%d')
  end

  def date_normal_format_y_m_d(day)
    day&.strftime('%Y/%m/%d')
  end

  def date_full_month_format(day)
    day&.strftime('%d %B %Y')
  end

  def from_time_to_time(from, to)
    "#{time_format_24h(from)} - #{time_format_24h(to)}"
  end

  def weekdays_date_ordinalize_format(day)
    day&.strftime("%a #{day.day.ordinalize}")
  end

  def month_year_format(day)
    day&.strftime('%b %Y')
  end

  def day_name(day)
    day&.strftime('%A')
  end

  def date_sort_month_format(day)
    day&.strftime('%d %b %Y')
  end

  def year_month_format(day)
    day&.strftime('%Y/%b')
  end

  def year_format(day)
    day&.strftime('%Y')
  end
end
