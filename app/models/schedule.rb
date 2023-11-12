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
class Schedule < ApplicationRecord
  include PublicActivity::Model
  tracked

  extend Enumerize

  # constants
  STATUS_COLLECTION = %i[finished cancelled on_going].freeze

  # associations
  belongs_to :teacher, class_name: 'User', foreign_key: 'user_id'
  belongs_to :course, counter_cache: true
  has_many :attendances, dependent: :destroy
  has_many :attendance_requests, dependent: :destroy

  # enumerize
  enumerize :status, in: STATUS_COLLECTION, default: :on_going, predicates: true, scope: true

  # validations
  validates :day, :start_time, :end_time, presence: true
  validate :end_must_be_after_start
  validate :cannot_overlap_times

  delegate :name, to: :course, prefix: true

  # scopes
  scope :where_students, ->(student) {
    joins(:attendances).where(attendances: { user_id: student.id })
  }
  scope :where_teacher, ->(teacher) { where(user_id: teacher.id) }
  scope :where_course, ->(course) { where(course_id: course.id) }
  scope :classes_today_region, ->(region_id) { joins(:teacher).where(day: Date.current, users: { region_id: }) }
  scope :where_teacher_course, ->(teacher, course) do
    scopes = [where_teacher(teacher), where_course(course)]
    where(id: scopes.flatten.map(&:id))
  end

  scope :in_range, ->(range) {
    where(
      'day = :day AND (user_id = :user_id OR course_id = :course_id) AND
      (
        (start_time BETWEEN :start AND :end) OR
        (end_time BETWEEN :start AND :end) OR
        (start_time <= :start AND end_time >= :end)
      )',
      start: (range.start_time.presence || (range.start_time + 1.minute)),
      end: (range.end_time.presence || (range.end_time - 1.minute)),
      day: range.day,
      course_id: range.course_id,
      user_id: range.user_id
    )
  }

  # methods
  def subject_name
    course.subject.name
  end

  private ##

  def cannot_overlap_times
    return if start_time.blank? && end_time.blank?

    amount = Schedule.count
    records = Schedule.where.not(id: [id, nil]).in_range(self)
    overlap_error if amount.positive? && records.present?
  end

  def overlap_error
    errors.add(:overlap_error, 'There is already an daterange in this times')
  end

  def end_must_be_after_start
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:end_time, 'must be after start date')
    end
  end
end
