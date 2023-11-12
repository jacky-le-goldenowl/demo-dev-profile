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
FactoryBot.define do
  factory :schedule do
    day         { Faker::Date.forward(days: 30) }
    start_time  { Faker::Time.forward(period: :morning) }
    end_time    { Faker::Time.forward(period: :afternoon) }
    association :course
    association :teacher
  end
end
