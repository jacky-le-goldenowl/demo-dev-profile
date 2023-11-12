require 'rails_helper'

RSpec.describe DateTimeHelper, type: :helper do
  let(:current_date) { Date.current }
  let(:time) { Time.zone.local(2023, 6, 11, 13, 30) }

  describe '#time_format' do
    it 'returns formatted time in AM/PM format' do
      formatted_time = helper.time_format(time)
      expect(formatted_time).to eq('01:30 PM')
    end

    it 'returns nil for nil time' do
      time = nil
      formatted_time = helper.time_format(time)
      expect(formatted_time).to be_nil
    end
  end

  describe '#time_format_24h' do
    it 'returns formatted time in 24-hour format' do
      formatted_time = helper.time_format_24h(time)
      expect(formatted_time).to eq('13:30')
    end

    it 'returns nil for nil time' do
      time = nil
      formatted_time = helper.time_format_24h(time)
      expect(formatted_time).to be_nil
    end
  end

  describe '#date_format_ordinalize' do
    it 'returns formatted date with ordinal day' do
      formatted_date = helper.date_format_ordinalize(current_date)
      expect(formatted_date).to eq(current_date&.strftime("#{current_date&.day&.ordinalize} %B %Y"))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_format_ordinalize(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_format_ordinalize_sort' do
    it 'returns formatted date with ordinal day for sorting' do
      formatted_date = helper.date_format_ordinalize_sort(current_date)
      expect(formatted_date).to eq(current_date&.strftime("#{current_date&.day&.ordinalize} %b %Y"))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_format_ordinalize_sort(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_format_ordinalize_dmy' do
    it 'returns formatted date with ordinal day, month, and year' do
      formatted_date = helper.date_format_ordinalize_dmy(current_date)
      expect(formatted_date).to eq(current_date&.strftime("%A, %B #{current_date.day.ordinalize} %Y"))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_format_ordinalize_dmy(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_format_ordinalize_dmy_sort' do
    it 'returns formatted date with ordinal day, month, and year for sorting' do
      formatted_date = helper.date_format_ordinalize_dmy_sort(current_date)
      expect(formatted_date).to eq(current_date&.strftime("%a, %b #{current_date.day.ordinalize} %Y"))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_format_ordinalize_dmy_sort(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_time_ago_format' do
    it 'returns formatted time ago for today' do
      datetime = DateTime.new(2023, 6, 11, 10, 30)
      formatted_datetime = helper.date_time_ago_format(datetime)
      expect(formatted_datetime).to include('- 10:30 AM')
    end

    it 'returns formatted time ago for yesterday' do
      datetime = DateTime.new(2023, 6, 10, 14, 45)
      formatted_datetime = helper.date_time_ago_format(datetime)
      expect(formatted_datetime).to include('- 02:45 PM')
    end

    it 'returns formatted time ago for other days' do
      datetime = DateTime.new(2023, 6, 9, 8, 0)
      formatted_datetime = helper.date_time_ago_format(datetime)
      expect(formatted_datetime).to include('- 08:00 AM')
    end

    it 'returns nil for nil datetime' do
      datetime = nil
      formatted_datetime = helper.date_time_ago_format(datetime)
      expect(formatted_datetime).to eq('--')
    end
  end

  describe '#date_normal_format' do
    it 'returns formatted date in dd/mm/yyyy format' do
      formatted_date = helper.date_normal_format(current_date)
      expect(formatted_date).to eq(current_date&.strftime('%d/%m/%Y'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_normal_format(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_normal_format_ymd' do
    it 'returns formatted date in yyyy-mm-dd format' do
      formatted_date = helper.date_normal_format_ymd(current_date)
      expect(formatted_date).to eq(current_date&.strftime('%Y-%m-%d'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_normal_format_ymd(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_normal_format_y_m_d' do
    it 'returns formatted date in yyyy/mm/dd format' do
      formatted_date = helper.date_normal_format_y_m_d(current_date)
      expect(formatted_date).to eq(current_date&.strftime('%Y/%m/%d'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_normal_format_y_m_d(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#date_full_month_format' do
    it 'returns formatted date with full month name' do
      formatted_date = helper.date_full_month_format(current_date)
      expect(formatted_date).to eq(current_date&.strftime('%d %B %Y'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_full_month_format(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#from_time_to_time' do
    it 'returns formatted time range from start to end time' do
      from = Time.zone.local(2023, 6, 11, 9, 0)
      to = Time.zone.local(2023, 6, 11, 12, 30)
      formatted_range = helper.from_time_to_time(from, to)
      expect(formatted_range).to eq('09:00 - 12:30')
    end

    it 'returns nil for nil start or end time' do
      from = nil
      to = Time.zone.local(2023, 6, 11, 12, 30)
      formatted_range = helper.from_time_to_time(from, to)
      expect(formatted_range).to eq(' - 12:30')

      from = Time.zone.local(2023, 6, 11, 9, 0)
      to = nil
      formatted_range = helper.from_time_to_time(from, to)
      expect(formatted_range).to eq('09:00 - ')
    end
  end

  describe '#weekdays_date_ordinalize_format' do
    it 'returns formatted weekday with ordinal day' do
      formatted_date = helper.weekdays_date_ordinalize_format(current_date)
      expect(formatted_date).to eq(current_date&.strftime("%a #{current_date.day.ordinalize}"))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.weekdays_date_ordinalize_format(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#month_year_format' do
    it 'returns formatted month and year' do
      formatted_date = helper.month_year_format(current_date)
      expect(formatted_date).to eq(current_date.strftime('%b %Y'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.month_year_format(day)
      expect(formatted_date).to be_nil
    end
  end

  describe '#day_name' do
    it 'returns formatted day name' do
      formatted_day = helper.day_name(current_date)
      expect(formatted_day).to eq(current_date.strftime('%A'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_day = helper.day_name(day)
      expect(formatted_day).to be_nil
    end
  end

  describe '#date_sort_month_format' do
    it 'returns formatted date with sorted month' do
      formatted_date = helper.date_sort_month_format(current_date)
      expect(formatted_date).to eq(current_date&.strftime('%d %b %Y'))
    end

    it 'returns nil for nil date' do
      day = nil
      formatted_date = helper.date_sort_month_format(day)
      expect(formatted_date).to be_nil
    end
  end
end
