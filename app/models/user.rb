# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  access_token               :string
#  address                    :string
#  birthday                   :date
#  citizenship                :string
#  code                       :string
#  contact_email              :string
#  contact_number             :string
#  email                      :string           default(""), not null
#  emergency_contact_name     :string
#  emergency_contact_number   :string
#  emergency_contact_relation :string
#  encrypted_password         :string           default(""), not null
#  gender                     :string
#  guardian_name              :string
#  home_mobile                :string
#  identification_number      :string
#  marital_status             :string
#  medical_history            :text
#  name                       :string
#  phone_number               :string
#  qualification              :string
#  race                       :string
#  relation                   :string
#  religion                   :string
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  type                       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  region_id                  :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  extend Enumerize

  # constants
  TYPES = ['User::Student', 'User::Teacher'].freeze
  GENDERS = %w[male female other].freeze

  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # associations
  has_one_attached :avatar
  belongs_to :region
  has_many :schedules, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  # validations
  enumerize :type, in: TYPES, allow_nil: true

  # callbacks
  before_create :assign_default_role
  before_create :set_code
  after_create_commit :notify_welcome

  # scopes
  scope :students, -> { where(type: 'User::Student') }
  scope :teachers, -> { where(type: 'User::Teacher') }
  scope :search_by_name_code, ->(key) do
    where(
      'name ILIKE :key OR code = :code',
      key: "%#{key}%", code: key
    )
  end

  scope :with_region, ->(region) { where(region_id: region.id) }
  scope :role_with_region, ->(role, current_region) do
    includes(:roles).where(roles: { name: role }, region_id: current_region.id)
  end

  # methods

  def auth_token
    JsonWebToken.encode(user_id: id, user_email: email)
  end

  def student?
    roles.count == 1 && has_role?(:student)
  end

  def teacher?
    has_role?(:teacher)
  end

  def admin?
    has_role?(:admin)
  end

  def superadmin?
    has_role?(:superadmin)
  end

  def financial?
    has_role?(:financial)
  end

  def generate_password
    password_length = 8
    Devise.friendly_token.first(password_length)
  end

  def years_old
    return 'Unknown' if birthday.blank?

    Date.current.year - birthday&.year
  end

  private ##

  def notify_welcome
    User::NewUserNotification.with(user: self).deliver_later(self)
  end

  def assign_default_role
    add_role(:student) if roles.blank?
  end

  def password_changed?
    changed_attributes.include?('password')
  end

  def set_code
    self.code = generate_code if code.blank?
  end

  def generate_code
    loop do
      random_number = SecureRandom.random_number(10**4).to_s.rjust(4, '0')
      random_string = Array.new(4) { Array('A'..'Z').sample }.join
      token = "#{region.code}#{random_string}#{random_number}"
      break token unless User.exists?(code: token)
    end
  end
end
